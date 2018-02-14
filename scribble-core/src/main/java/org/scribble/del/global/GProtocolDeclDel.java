/**
 * Copyright 2008 The Scribble Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package org.scribble.del.global;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.scribble.ast.AstFactory;
import org.scribble.ast.Module;
import org.scribble.ast.NonRoleParamDeclList;
import org.scribble.ast.RoleDeclList;
import org.scribble.ast.ScribNode;
import org.scribble.ast.context.DependencyMap;
import org.scribble.ast.context.global.GProtocolDeclContext;
import org.scribble.ast.global.GProtocolDecl;
import org.scribble.ast.global.GProtocolHeader;
import org.scribble.ast.local.LProtocolDecl;
import org.scribble.ast.local.LProtocolDef;
import org.scribble.ast.local.LProtocolHeader;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.del.ModuleDel;
import org.scribble.del.ProtocolDeclDel;
import org.scribble.main.Job;
import org.scribble.main.JobContext;
import org.scribble.main.ScribbleException;
import org.scribble.model.MState;
import org.scribble.model.endpoint.EGraph;
import org.scribble.model.endpoint.EState;
import org.scribble.model.global.SGraph;
import org.scribble.type.kind.Global;
import org.scribble.type.name.GProtocolName;
import org.scribble.type.name.MessageId;
import org.scribble.type.name.ProtocolName;
import org.scribble.type.name.Role;
import org.scribble.util.ScribUtil;
import org.scribble.visit.context.Projector;
import org.scribble.visit.context.ProtocolDeclContextBuilder;
import org.scribble.visit.context.env.ProjectionEnv;
import org.scribble.visit.util.MessageIdCollector;
import org.scribble.visit.util.RoleCollector;
import org.scribble.visit.validation.GProtocolValidator;

public class GProtocolDeclDel extends ProtocolDeclDel<Global>
{
	public GProtocolDeclDel()
	{

	}
	
	@Override
	public GProtocolDeclContext getProtocolDeclContext()
	{
		return (GProtocolDeclContext) super.getProtocolDeclContext();
	}

	@Override
	protected GProtocolDeclDel copy()
	{
		return new GProtocolDeclDel();
	}

	@Override
	protected void addSelfDependency(ProtocolDeclContextBuilder builder, ProtocolName<?> proto, Role role)
	{
		builder.addGlobalProtocolDependency(role, (GProtocolName) proto, role);
	}
	
	@Override
	public GProtocolDecl
			leaveProtocolDeclContextBuilding(ScribNode parent, ScribNode child, ProtocolDeclContextBuilder builder, ScribNode visited) throws ScribbleException
	{
		GProtocolDecl gpd = (GProtocolDecl) visited;
		GProtocolDeclContext gcontext = new GProtocolDeclContext(builder.getGlobalProtocolDependencyMap());
		GProtocolDeclDel del = (GProtocolDeclDel) setProtocolDeclContext(gcontext);
		return (GProtocolDecl) gpd.del(del);
	}

	@Override
	public ScribNode leaveRoleCollection(ScribNode parent, ScribNode child, RoleCollector coll, ScribNode visited) throws ScribbleException
	{
		GProtocolDecl gpd = (GProtocolDecl) visited;

		// Need to do here (e.g. RoleDeclList too early, def not visited yet)
		// Currently only done for global, local does roledecl fixing after role collection -- should separate this check to a later pass after context building
		// Maybe relax to check only occs.size() > 1
		List<Role> decls = gpd.header.roledecls.getRoles();
		Set<Role> occs = coll.getNames();
		if (occs.size() != decls.size()) 
		{
			decls.removeAll(occs);
			throw new ScribbleException(gpd.header.roledecls.getSource(), "Unused role decl(s) in " + gpd.header.name + ": " + decls);
		}

		return super.leaveRoleCollection(parent, child, coll, gpd);
	}

	@Override
	public GProtocolDecl
			leaveProjection(ScribNode parent, ScribNode child, Projector proj, ScribNode visited) throws ScribbleException
	{
		AstFactory af = proj.job.af;

		Module root = proj.job.getContext().getModule(proj.getModuleContext().root);
		GProtocolDecl gpd = (GProtocolDecl) visited;
		GProtocolHeader gph = gpd.getHeader();
		Role self = proj.peekSelf();

		LProtocolNameNode pn = Projector.makeProjectedSimpleNameNode(af, gph.getSource(), gph.getDeclName(), self);
		RoleDeclList roledecls = gph.roledecls.project(af, self);
		NonRoleParamDeclList paramdecls = gph.paramdecls.project(af, self);
		//LProtocolHeader hdr = af.LProtocolHeader(gpd.header.getSource(), pn, roledecls, paramdecls);  // FIXME: make a header del and move there?
		LProtocolHeader hdr = gph.project(af, self, pn, roledecls, paramdecls);
		LProtocolDef def = (LProtocolDef) ((ProjectionEnv) gpd.def.del().env()).getProjection();
		LProtocolDecl lpd = gpd.project(af, root, self, hdr, def);  // FIXME: is root (always) the correct module? (wrt. LProjectionDeclDel?)
		
		Map<GProtocolName, Set<Role>> deps = ((GProtocolDeclDel) gpd.del()).getGlobalProtocolDependencies(self);
		Module projected = ((ModuleDel) root.del()).createModuleForProjection(proj, root, gpd, lpd, deps);
		proj.addProjection(gpd.getFullMemberName(root), self, projected);
		return gpd;
	}

	protected Map<GProtocolName, Set<Role>> getGlobalProtocolDependencies(Role self)
	{
		DependencyMap<GProtocolName> deps = getProtocolDeclContext().getDependencyMap();
		return deps.getDependencies().get(self);
	}
	
	@Override
	public void enterValidation(ScribNode parent, ScribNode child, GProtocolValidator checker) throws ScribbleException
	{
		GProtocolDecl gpd = (GProtocolDecl) child;
		if (gpd.isAuxModifier())
		{
			return;
		}

		GProtocolName fullname = gpd.getFullMemberName((Module) parent);
		if (checker.job.spin)
		{
			if (checker.job.fair)
			{
				throw new RuntimeException("TODO");
			}
			validateBySpin(checker.job, fullname);
		}
		else
		{
			validateByScribble(checker.job, fullname, true);
			if (!checker.job.fair)
			{
				checker.job.debugPrintln("(" + fullname + ") Validating with \"unfair\" output choices.. ");
				validateByScribble(checker.job, fullname, false);  // FIXME: only need to check progress, not full validation
			}
		}
	}

	private static void validateByScribble(Job job, GProtocolName fullname, boolean fair) throws ScribbleException
	{
		JobContext jc = job.getContext();
		SGraph graph = (fair) ? jc.getSGraph(fullname) : jc.getUnfairSGraph(fullname);
		//graph.toModel().validate(job);
		job.sf.newSModel(graph).validate(job);
	}
		
	private static void validateBySpin(Job job, GProtocolName fullname) throws ScribbleException
	{
		JobContext jc = job.getContext();
		Module mod = jc.getModule(fullname.getPrefix());
		GProtocolDecl gpd = (GProtocolDecl) mod.getProtocolDecl(fullname.getSimpleName());
		
		List<Role> rs = gpd.header.roledecls.getRoles().stream()
				.sorted(Comparator.comparing(Role::toString)).collect(Collectors.toList());

		MessageIdCollector coll = new MessageIdCollector(job, ((ModuleDel) mod.del()).getModuleContext());
		gpd.accept(coll);
		Set<MessageId<?>> mids = coll.getNames();
		
		String pml = "";
		pml += "mtype {" + mids.stream().map(mid -> mid.toString()).collect(Collectors.joining(", ")) + "};\n";

		// FIXME: explicit

		pml += "\n";
		List<Role[]> pairs = new LinkedList<>();
		for (Role r1 : rs)
		{
			for (Role r2 : rs)
			{
				if (!r1.equals(r2))
				{
					pairs.add(new Role[] {r1, r2});
				}
			}
		}
		//for (Role[] p : (Iterable<Role[]>) () -> pairs.stream().sorted().iterator())
		for (Role[] p : pairs)
		{
			pml += "chan s_" + p[0] + "_" + p[1] + " = [1] of { mtype };\n";
		}
		
		for (Role r : rs)
		{
			pml += "\n\n" + jc.getEGraph(fullname, r).toPml(r);
		}
		
		List<String> labs = new LinkedList<>();
		for (Role r : rs)
		{
			Set<EState> tmp = new HashSet<>();
			EGraph g = jc.getEGraph(fullname, r);
			tmp.add(g.init);
			tmp.addAll(MState.getReachableStates(g.init));
			if (g.term != null)
			{
				tmp.remove(g.term);
			}
			tmp.forEach(  // Throws exception, cannot use flatMap
					s -> labs.add("!<>[]" + r + "@" + (s.isTerminal() ? "end" : "label") + r + s.id)  // FIXME: factor out
			);
		}
		/*pml += "\n\nltl {\n" + labs.stream().collect(Collectors.joining(" && ")) + "\n" + "}";
		
		System.out.println("aaa: " + pml + "\n");
		if (!runSpin(pml))
		{
			throw new ScribbleException("Protocol not valid:\n" + gpd);
		}*/
		System.out.println("aaa: " + pml + "\n");
		/*for (String lab : labs)
		{
			System.out.println("bbb: " + lab);
			String run = pml + "\n\nltl {\n" + lab + "\n" + "}";
			if (!runSpin(run))
			{
				throw new ScribbleException("Protocol not valid:\n" + gpd);
			}
		}*/
		int batch = 10;
		for (int i = 0; i < labs.size(); )
		{
			int j = (i+batch < labs.size()) ? i+batch : labs.size();
			String foo = labs.subList(i, j).stream().collect(Collectors.joining(" && "));
			System.out.println("bbb: " + foo);
			String run = pml + "\n\nltl {\n" + foo + "\n" + "}";
			if (!runSpin(run))
			{
				throw new ScribbleException("Protocol not valid:\n" + gpd);
			}
			i += batch;
		}
	}

	// FIXME: move
	private static boolean runSpin(String pml) //throws ScribbleException
	{
		File tmp;
		try
		{
			tmp = File.createTempFile("gpd.header.name", ".pml.tmp");
			try
			{
				String tmpName = tmp.getAbsolutePath();				
				ScribUtil.writeToFile(tmpName, pml);
				String[] res = ScribUtil.runProcess("spin", "-a", tmpName);
				res[0] = res[0].replaceAll("(?m)^ltl.*$", "");
				res[1] = res[1].replace("'gcc-4' is not recognized as an internal or external command,\noperable program or batch file.", "");
				res[1] = res[1].replace("'gcc-3' is not recognized as an internal or external command,\noperable program or batch file.", "");
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (!res[0].trim().isEmpty() || !res[1].trim().isEmpty())
				{
					//throw new RuntimeException("[scrib] : " + Arrays.toString(res[0].getBytes()) + "\n" + Arrays.toString(res[1].getBytes()));
					throw new RuntimeException("[scrib-Spin] [spin]: " + res[0] + "\n" + res[1]);
				}
				res = ScribUtil.runProcess("gcc", "-o", "pan", "pan.c");
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (!res[0].isEmpty() || !res[1].isEmpty())
				{
					throw new RuntimeException("[scrib-Spin] [gcc]: " + res[0] + "\n" + res[1]);
				}
				res = ScribUtil.runProcess("pan", "-a", "-f");
				res[1] = res[1].replace("warning: no accept labels are defined, so option -a has no effect (ignored)", "");
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (res[0].contains("error,") || !res[1].isEmpty())
				{
					throw new RuntimeException("[scrib-Spin] [pan]: " + res[0] + "\n" + res[1]);
				}
				int err = res[0].indexOf("errors: ");
				return (res[0].charAt(err + 8) == '0');
			}
			catch (ScribbleException e)
			{
				throw new RuntimeException(e);
			}
			finally
			{
				tmp.delete();
			}
		}
		catch (IOException e)
		{
			throw new RuntimeException(e);
		}
	}
}

