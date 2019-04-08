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
package org.scribble.visit;

import java.util.Map;

import org.scribble.ast.NonRoleArgNode;
import org.scribble.ast.ScribNode;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.core.type.kind.NonRoleArgKind;
import org.scribble.core.type.name.Role;
import org.scribble.core.type.session.Arg;
import org.scribble.lang.Lang;
import org.scribble.util.ScribException;

public class Substitutor extends AstVisitor
{
	// name in the current protocoldecl scope -> the original name node in the root protocol decl
	// Applications of the maps (i.e. substitution) should reconstruct/clone the original nodes
	private final Map<Role, RoleNode> rolemap;
	private final Map<Arg<? extends NonRoleArgKind>, NonRoleArgNode> argmap;

	public Substitutor(Lang job, Map<Role, RoleNode> rolemap,
			Map<Arg<? extends NonRoleArgKind>, NonRoleArgNode> argmap)
	{
		super(job);
		this.rolemap = rolemap;
		this.argmap = argmap;
	}
	
	@Override
	public ScribNode leave(ScribNode child, ScribNode visited)
			throws ScribException
	{
		return visited.substituteNames(this);
	}

	public RoleNode getRoleSubstitution(Role role)
	{
		return this.rolemap.get(role).clone();//this.job.af);
	}

	public NonRoleArgNode getArgumentSubstitution(
			Arg<? extends NonRoleArgKind> arg)
	{
		return (NonRoleArgNode) this.argmap.get(arg).clone();//this.job.af);  
				// Makes new dels that will be discarded in NonRoleParamNode (just as calling the factory manually would)
	}
}
