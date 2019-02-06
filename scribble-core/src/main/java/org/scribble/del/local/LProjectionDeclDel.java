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
package org.scribble.del.local;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.scribble.ast.RoleDecl;
import org.scribble.ast.RoleDeclList;
import org.scribble.ast.ScribNode;
import org.scribble.ast.local.LProtocolDecl;
import org.scribble.ast.local.LProtocolHeader;
import org.scribble.job.ScribbleException;
import org.scribble.type.name.GProtocolName;
import org.scribble.type.name.Role;
import org.scribble.visit.context.ProjectedRoleDeclFixer;

public class LProjectionDeclDel extends LProtocolDeclDel
{
	// Maybe better to store in context, but more convenient to pass to here via factory (than infer in context building) -- could alternatively store in projected module
	protected final GProtocolName fullname;
	protected final Role self;  // Can be obtained from LProtocolHeader?

	public LProjectionDeclDel(GProtocolName fullname, Role self)
	{
		this.fullname = fullname;
		this.self = self;
	}
	
	@Override
	protected LProtocolDeclDel copy()
	{
		return new LProjectionDeclDel(this.fullname, this.self);
	}

	@Override
	public ScribNode leaveProjectedRoleDeclFixing(ScribNode parent,
			ScribNode child, ProjectedRoleDeclFixer fixer, ScribNode visited)
			throws ScribbleException
	{
		LProtocolDecl lpd = (LProtocolDecl) visited;
		// TODO: ensure all role params are used, to avoid empty roledecllist
		Set<Role> occs = ((LProtocolDeclDel) lpd.del()).getProtocolDeclContext()
				.getRoleOccurrences();
		List<RoleDecl> rds = lpd.getHeaderChild().getRoleDeclListChild()
				.getParamDeclChildren().stream()
				.filter(rd -> occs.contains(rd.getDeclName()))
				.collect(Collectors.toList());
		LProtocolHeader tmp = lpd.getHeaderChild();
		RoleDeclList rdl = fixer.job.config.af
				.RoleDeclList(tmp.getRoleDeclListChild().getSource(), rds);
		LProtocolHeader hdr = tmp.reconstruct(tmp.getNameNodeChild(), rdl,
				tmp.getParamDeclListChild());
		LProtocolDecl fixed = lpd.reconstruct(hdr, lpd.getDefChild());
		
		fixer.job.debugPrintln("\n[DEBUG] Projected " + getSourceProtocol()
				+ " for " + getSelfRole() + ":\n" + fixed);
		
		return super.leaveProjectedRoleDeclFixing(parent, child, fixer, fixed);
	}
	
	public GProtocolName getSourceProtocol()
	{
		return this.fullname;
	}
	
	// Redundant with SelfRoleDecl in header
	public Role getSelfRole()
	{
		return this.self;
	}
}
