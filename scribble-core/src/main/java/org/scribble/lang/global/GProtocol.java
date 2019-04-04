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
package org.scribble.lang.global;

import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.scribble.ast.ProtocolDecl;
import org.scribble.ast.global.GProtocolDecl;
import org.scribble.job.ScribbleException;
import org.scribble.lang.Projector;
import org.scribble.lang.Protocol;
import org.scribble.lang.ProtocolMod;
import org.scribble.lang.STypeInliner;
import org.scribble.lang.STypeUnfolder;
import org.scribble.lang.SubprotoSig;
import org.scribble.lang.Substitutions;
import org.scribble.lang.local.LProjection;
import org.scribble.type.kind.Global;
import org.scribble.type.kind.NonRoleParamKind;
import org.scribble.type.name.GProtocolName;
import org.scribble.type.name.LProtocolName;
import org.scribble.type.name.MemberName;
import org.scribble.type.name.RecVar;
import org.scribble.type.name.Role;
import org.scribble.type.session.global.GRecursion;
import org.scribble.type.session.global.GSeq;
import org.scribble.type.session.global.GType;
import org.scribble.type.session.local.LSeq;

public class GProtocol extends
		Protocol<Global, GProtocolName, GSeq> implements GType
{
	public GProtocol(ProtocolDecl<Global> source, List<ProtocolMod> mods,
			GProtocolName fullname, List<Role> roles,
			List<MemberName<? extends NonRoleParamKind>> params, GSeq def)
	{
		super(source, mods, fullname, roles, params, def);
	}

	public GProtocol reconstruct(ProtocolDecl<Global> source,
			List<ProtocolMod> mods, GProtocolName fullname, List<Role> roles,
			List<MemberName<? extends NonRoleParamKind>> params, GSeq def)
	{
		return new GProtocol(source, mods, fullname, roles, params, def);
	}
	
	// CHECKME: drop from Protocol (after removing Protocol from SType?)
	// Pre: stack.peek is the sig for the calling Do (or top-level entry)
	// i.e., it gives the roles/args at the call-site
	@Override
	public GProtocol getInlined(STypeInliner i)//, Deque<SubprotoSig> stack)
	{
		SubprotoSig sig = i.peek();
		Substitutions subs = new Substitutions(this.roles, sig.roles, this.params,
				sig.args);
		GSeq body = this.def.substitute(subs).getInlined(i).pruneRecs();
		RecVar rv = i.getInlinedRecVar(sig);
		GRecursion rec = new GRecursion(null, rv, body);  // CHECKME: or protodecl source?
		GProtocolDecl source = getSource();
		GSeq def = new GSeq(null, Stream.of(rec).collect(Collectors.toList()));
		return new GProtocol(source, this.mods, this.fullname, this.roles,
				this.params, def);
	}
	
	@Override
	public GProtocol unfoldAllOnce(STypeUnfolder<Global> u)
	{
		GSeq unf = (GSeq) this.def.unfoldAllOnce(u);
		return reconstruct(getSource(), this.mods, this.fullname, this.roles,
				this.params, unf);
	}
	
	// Currently assuming inlining (or at least "disjoint" protodecl projection, without role fixing)
	@Override
	public LProjection projectInlined(Role self)
	{
		LSeq body = (LSeq) this.def.projectInlined(self);
		return projectAux(self, body);
	}
	
	private LProjection projectAux(Role self, LSeq body)
	{
		LProtocolName fullname = org.scribble.visit.context.Projector
				.projectFullProtocolName(this.fullname, self);
		Set<Role> tmp = body.getRoles();
		List<Role> roles = this.roles.stream()
				.filter(x -> x.equals(self) || tmp.contains(x))  // Implicitly filters Role.SELF
				.collect(Collectors.toList());
		List<MemberName<? extends NonRoleParamKind>> params =
				new LinkedList<>(this.params);  // CHECKME: filter params by usage?
		return new LProjection(this.mods, fullname, roles, self, params, this.fullname,
				body);
	}

	@Override
	public LProjection project(Projector v)
	{
		LSeq body = (LSeq) this.def.project(v).pruneRecs();
		return projectAux(v.self, body);
	}

	@Override
	public Set<Role> checkRoleEnabling(Set<Role> enabled) throws ScribbleException
	{
		throw new RuntimeException("Unsupported for Protocol: " + this);
	}

	// FIXME: top-level overriding pattern inconsistent with, e.g., getInlined -- though maybe should be fixing the latter
	// CHECKME: refactor Protocol out of SType?  Also Do -- but harder because Do needs to be in Seq
	public Set<Role> checkRoleEnabling() throws ScribbleException
	{
		Set<Role> tmp = //Collections.unmodifiableSet(
				new HashSet<>(this.roles);
		return this.def.checkRoleEnabling(tmp);
	}

	@Override
	public Map<Role, Role> checkExtChoiceConsistency(Map<Role, Role> enablers)
			throws ScribbleException
	{
		throw new RuntimeException("Unsupported for Protocol: " + this);
	}

	public Map<Role, Role> checkExtChoiceConsistency() throws ScribbleException
	{
		Map<Role, Role> tmp = this.roles.stream()
				.collect(Collectors.toMap(x -> x, x -> x));
		return this.def.checkExtChoiceConsistency(tmp);
	}
	
	@Override
	public GProtocolDecl getSource()
	{
		return (GProtocolDecl) super.getSource();
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
}
