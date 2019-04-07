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
package org.scribble.core.lang.global;

import java.io.File;
import java.io.IOException;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.antlr.runtime.tree.CommonTree;
import org.scribble.core.job.Job;
import org.scribble.core.job.JobArgs;
import org.scribble.core.job.JobContext;
import org.scribble.core.lang.Protocol;
import org.scribble.core.lang.ProtocolMod;
import org.scribble.core.lang.SubprotoSig;
import org.scribble.core.lang.local.LProjection;
import org.scribble.core.model.MState;
import org.scribble.core.model.endpoint.EGraph;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.global.SGraph;
import org.scribble.core.type.kind.Global;
import org.scribble.core.type.kind.NonRoleParamKind;
import org.scribble.core.type.name.GProtocolName;
import org.scribble.core.type.name.LProtocolName;
import org.scribble.core.type.name.MemberName;
import org.scribble.core.type.name.MessageId;
import org.scribble.core.type.name.RecVar;
import org.scribble.core.type.name.Role;
import org.scribble.core.type.name.Substitutions;
import org.scribble.core.type.session.global.GRecursion;
import org.scribble.core.type.session.global.GSeq;
import org.scribble.core.type.session.local.LSeq;
import org.scribble.core.visit.STypeInliner;
import org.scribble.core.visit.STypeUnfolder;
import org.scribble.core.visit.global.Projector2;
import org.scribble.util.ScribException;
import org.scribble.util.ScribUtil;

public class GProtocol extends Protocol<Global, GProtocolName, GSeq>
		implements GNode  // Mainly for GDel.translate return (to include GProtocol)
{
	public GProtocol(CommonTree source, List<ProtocolMod> mods,
			GProtocolName fullname, List<Role> roles,
			List<MemberName<? extends NonRoleParamKind>> params, GSeq def)
	{
		super(source, mods, fullname, roles, params, def);
	}

	public GProtocol reconstruct(CommonTree source,
			List<ProtocolMod> mods, GProtocolName fullname, List<Role> roles,
			List<MemberName<? extends NonRoleParamKind>> params, GSeq def)
	{
		return new GProtocol(source, mods, fullname, roles, params, def);
	}
	
	// CHECKME: drop from Protocol (after removing Protocol from SType?)
	// Pre: stack.peek is the sig for the calling Do (or top-level entry)
	// i.e., it gives the roles/args at the call-site
	@Override
	public GProtocol getInlined(STypeInliner v)
	{
		SubprotoSig sig = v.peek();
		Substitutions subs = new Substitutions(this.roles, sig.roles, this.params,
				sig.args);
		GSeq body = this.def.substitute(subs).getInlined(v).pruneRecs();
		RecVar rv = v.getInlinedRecVar(sig);
		GRecursion rec = new GRecursion(null, rv, body);  // CHECKME: or protodecl source?
		CommonTree source = getSource();
		GSeq def = new GSeq(null, Stream.of(rec).collect(Collectors.toList()));
		Set<Role> used = def.getRoles();
		List<Role> rs = this.roles.stream().filter(x -> used.contains(x))  // Prune role decls
				.collect(Collectors.toList());
		return new GProtocol(source, this.mods, this.fullname, rs,
				this.params, def);
	}
	
	@Override
	public GProtocol unfoldAllOnce(STypeUnfolder<Global> u)
	{
		GSeq unf = (GSeq) this.def.unfoldAllOnce(u);
		return reconstruct(getSource(), this.mods, this.fullname, this.roles,
				this.params, unf);
	}

	// Following are some top-level entry to GType methods
	public Set<Role> checkRoleEnabling() throws ScribException
	{
		Set<Role> tmp = this.roles.stream().collect(Collectors.toSet());
		return this.def.checkRoleEnabling(tmp);
	}

	public Map<Role, Role> checkExtChoiceConsistency() throws ScribException
	{
		Map<Role, Role> tmp = this.roles.stream()
				.collect(Collectors.toMap(x -> x, x -> x));
		return this.def.checkExtChoiceConsistency(tmp);
	}
	
	// Currently assuming inlining (or at least "disjoint" protodecl projection, without role fixing)
	public LProjection projectInlined(Role self)
	{
		LSeq body = (LSeq) this.def.projectInlined(self);
		return projectAux(self, this.roles, body);
	}
	
	private LProjection projectAux(Role self, List<Role> decls, LSeq body)
	{
		LProtocolName fullname = Projector2
				.projectFullProtocolName(this.fullname, self);
		Set<Role> tmp = body.getRoles();
		List<Role> roles = decls.stream()
				.filter(x -> x.equals(self) || tmp.contains(x))  // Implicitly filters Role.SELF
				.collect(Collectors.toList());
		List<MemberName<? extends NonRoleParamKind>> params =
				new LinkedList<>(this.params);  // CHECKME: filter params by usage?
		return new LProjection(this.mods, fullname, roles, self, params, this.fullname,
				body);
	}

	public LProjection project(Projector2 v)
	{
		LSeq body = (LSeq) this.def.project(v).pruneRecs();
		return projectAux(v.self,
				v.job.getContext().getInlined(this.fullname).roles,  // Used inlined decls, already pruned
				body);
	}
	
	@Override
	public String toString()
	{
		return this.mods.stream().map(x -> x.toString() + " ")
				.collect(Collectors.joining()) + "global " + super.toString();
	}

	@Override
	public int hashCode()
	{
		int hash = 11;
		hash = 31 * hash + super.hashCode();
		return hash;
	}

	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof GProtocol))
		{
			return false;
		}
		return super.equals(o);  // Does canEquals
	}

	@Override
	public boolean canEquals(Object o)
	{
		return o instanceof GProtocol;
	}

	
	
	// TODO FIXME: refactor following methods (e.g., make non-static?)
	
	public static void validateByScribble(Job job2, GProtocolName fullname,
			boolean fair) throws ScribException
	{
		JobContext jc = job2.getContext();
		SGraph graph = (fair) 
				? jc.getSGraph(fullname)
				: jc.getUnfairSGraph(fullname);
		//graph.toModel().validate(job);
		job2.config.sf.newSModel(graph).validate(job2);
	}

	public static void validateBySpin(Job job2, GProtocolName fullname)
			throws ScribException
	{
		JobContext jobc2 = job2.getContext();
		/*Module mod = jc.getModule(fullname.getPrefix());
		GProtocolDecl gpd = (GProtocolDecl) mod
				.getProtocolDeclChild(fullname.getSimpleName());*/
		GProtocol gpd = jobc2.getInlined(fullname);
		
		List<Role> rs = //gpd.getHeaderChild().getRoleDeclListChild().getRoles()
				gpd.roles
				.stream().sorted(Comparator.comparing(Role::toString))
				.collect(Collectors.toList());
	
		/*MessageIdCollector coll = new MessageIdCollector(job,
				((ModuleDel) mod.del()).getModuleContext());  // TODO: get ModuleContext from Job(Context)
		gpd.accept(coll);
		Set<MessageId<?>> mids = coll.getNames();*/
		Set<MessageId<?>> mids = gpd.def.getMessageIds();
		
		//..........FIXME: get mids from SType, instead of old AST Collector
		
		String pml = "";
		pml += "mtype {" + mids.stream().map(mid -> mid.toString())
				.collect(Collectors.joining(", ")) + "};\n";
	
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
			pml += "chan s_" + p[0] + "_" + p[1] + " = [1] of { mtype };\n"
					+ "chan r_" + p[0] + "_" + p[1] + " = [1] of { mtype };\n"
					+ "bool empty_" + p[0] + "_" + p[1] + " = true;\n"
					+ "active proctype chan_" + p[0] + "_" + p[1] + "() {\n"
					+ "mtype m;\n"
					+ "end_chan_" + p[0] + "_" + p[1] + ":\n"
					+ "do\n"
					+ "::\n"
					+ "atomic { s_" + p[0] + "_" + p[1] + "?m; empty_" + p[0] + "_" + p[1]
							+ " = false }\n"
					+ "atomic { r_" + p[0] + "_" + p[1] + "!m; empty_" + p[0] + "_" + p[1]
							+ " = true }\n"
					+ "od\n"
					+ "}\n";
		}
		
		for (Role r : rs)
		{
			pml += "\n\n" + jobc2.getEGraph(fullname, r).toPml(r);
		}
		if (job2.config.args.get(JobArgs.debug))
		{
			System.out.println("[-spin]: Promela processes\n" + pml + "\n");
		}
		
		List<String> clauses = new LinkedList<>();
		for (Role r : rs)
		{
			Set<EState> tmp = new HashSet<>();
			EGraph g = jobc2.getEGraph(fullname, r);
			tmp.add(g.init);
			tmp.addAll(MState.getReachableStates(g.init));
			if (g.term != null)
			{
				tmp.remove(g.term);
			}
			tmp.forEach(  // Throws exception, cannot use flatMap
					s -> clauses.add("!<>[]" + r + "@label" + r + s.id)  // FIXME: factor out
			);
		}
		//*/
		/*String roleProgress = "";  // This way is not faster
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
			roleProgress += (((roleProgress.isEmpty()) ? "" : " || ")
					+ tmp.stream().map(s -> r + "@label" + r + s.id).collect(Collectors.joining(" || ")));
		}
		roleProgress = "!<>[](" + roleProgress + ")";
		clauses.add(roleProgress);*/
		/*for (Role[] p : pairs)
		{
			clauses.add("[]<>(empty_" + p[0] + "_" + p[1] + ")");
		}*/
		String eventualStability = "";
		for (Role[] p : pairs)
		{
			//eventualStability += (((eventualStability.isEmpty()) ? "" : " && ") + "empty_" + p[0] + "_" + p[1]);
			eventualStability += (((eventualStability.isEmpty()) ? "" : " && ") + "<>empty_" + p[0] + "_" + p[1]);
		}
		//eventualStability = "[]<>(" + eventualStability + ")";
		eventualStability = "[](" + eventualStability + ")";  // FIXME: current "eventual reception", not eventual stability
		clauses.add(eventualStability);
	
		//int batchSize = 10;  // FIXME: factor out
		int batchSize = 6;  // FIXME: factor out  // FIXME: dynamic batch sizing based on previous batch duration?
		for (int i = 0; i < clauses.size(); )
		{
			int j = (i+batchSize < clauses.size()) ? i+batchSize : clauses.size();
			String batch = clauses.subList(i, j).stream().collect(Collectors.joining(" && "));
			String ltl = "ltl {\n" + batch + "\n" + "}";
			if (job2.config.args.get(JobArgs.debug))
			{
				System.out.println("[-spin] Batched ltl:\n" + ltl + "\n");
			}
			if (!GProtocol.runSpin(fullname.toString(), pml + "\n\n" + ltl))
			{
				throw new ScribException("Protocol not valid:\n" + gpd);
			}
			i += batchSize;
		}
	}

	// FIXME: relocate
	public static boolean runSpin(String prefix, String pml) //throws ScribbleException
	{
		File tmp;
		try
		{
			tmp = File.createTempFile(prefix, ".pml.tmp");
			try
			{
				String tmpName = tmp.getAbsolutePath();				
				ScribUtil.writeToFile(tmpName, pml);
				String[] res = ScribUtil.runProcess("spin", "-a", tmpName);
				res[0] = res[0].replaceAll("(?m)^ltl.*$", "");
				res[1] = res[1].replace(
						"'gcc-4' is not recognized as an internal or external command,\noperable program or batch file.",
						"");
				res[1] = res[1].replace(
						"'gcc-3' is not recognized as an internal or external command,\noperable program or batch file.",
						"");
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (!res[0].trim().isEmpty() || !res[1].trim().isEmpty())
				{
					//throw new RuntimeException("[scrib] : " + Arrays.toString(res[0].getBytes()) + "\n" + Arrays.toString(res[1].getBytes()));
					throw new RuntimeException("[-spin] [spin]: " + res[0] + "\n" + res[1]);
				}
				int procs = 0;
				for (int i = 0; i < pml.length(); procs++)
				{
					i = pml.indexOf("proctype", i);
					if (i == -1)
					{
						break;
					}
					i++;
				}
				int dnfair = (procs <= 6) ? 2 : 3;  // FIXME
				res = ScribUtil.runProcess("gcc", "-o", "pan", "pan.c", "-DNFAIR=" + dnfair);
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (!res[0].isEmpty() || !res[1].isEmpty())
				{
					throw new RuntimeException("[-spin] [gcc]: " + res[0] + "\n" + res[1]);
				}
				res = ScribUtil.runProcess("pan", "-a", "-f");
				res[1] = res[1].replace("warning: no accept labels are defined, so option -a has no effect (ignored)", "");
				res[0] = res[0].trim();
				res[1] = res[1].trim();
				if (res[0].contains("error,") || !res[1].isEmpty())
				{
					throw new RuntimeException("[-spin] [pan]: " + res[0] + "\n" + res[1]);
				}
				int err = res[0].indexOf("errors: ");
				boolean valid = (res[0].charAt(err + 8) == '0');
				if (!valid)
				{
					System.err.println("[-spin] [pan] " + res[0] + "\n" + res[1]);
				}
				return valid;
			}
			catch (ScribException e)
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
