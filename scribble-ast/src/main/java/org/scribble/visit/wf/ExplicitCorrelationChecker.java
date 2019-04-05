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
package org.scribble.visit.wf;

import org.scribble.ast.Module;
import org.scribble.ast.ProtocolDecl;
import org.scribble.ast.ScribNode;
import org.scribble.ast.global.GProtocolDecl;
import org.scribble.core.job.ScribbleException;
import org.scribble.core.type.kind.ProtocolKind;
import org.scribble.core.type.name.GProtocolName;
import org.scribble.core.type.name.Role;
import org.scribble.lang.Lang;
import org.scribble.visit.SubprotocolVisitor;
import org.scribble.visit.wf.env.ExplicitCorrelationEnv;

public class ExplicitCorrelationChecker
		extends SubprotocolVisitor<ExplicitCorrelationEnv>
		// Need to follow /unfolded/ subprotos (inlined is already unfolded by context building when this pass is run)
{
	public ExplicitCorrelationChecker(Lang job)
	{
		super(job);
	}
	
	
	@Override
	public ScribNode visit(ScribNode parent, ScribNode child)
			throws ScribbleException
	{
		if (child instanceof GProtocolDecl)
		{
			GProtocolDecl gpd = (GProtocolDecl) child;
			if (!gpd.isAux() && gpd.isExplicit())
			{
				Module mod = (Module) parent;
				GProtocolName gpn = gpd.getFullMemberName(mod);
				for (Role r : gpd.getHeaderChild().getRoleDeclListChild().getRoles())
				{
					/*Module proj = this.job.getJobContext().getProjection(gpn, r);
					proj.accept(this);*/
					throw new RuntimeException("[TODO]: " + gpn + "@" + r);
				}
			}
			return gpd;
		}
		return super.visit(parent, child);
	}

	@Override
	public void subprotocolEnter(ScribNode parent, ScribNode child)
			throws ScribbleException
	{
		super.subprotocolEnter(parent, child);
		child.del().enterExplicitCorrelationCheck(parent, child, this);
	}
	
	@Override
	public ScribNode subprotocolLeave(ScribNode parent, ScribNode child,
			ScribNode visited) throws ScribbleException
	{
		visited = visited.del().leaveExplicitCorrelationCheck(parent, child, this, visited);
		return super.subprotocolLeave(parent, child, visited);
	}

	@Override
	protected ExplicitCorrelationEnv makeRootProtocolDeclEnv(
			ProtocolDecl<? extends ProtocolKind> pd)
	{
		return new ExplicitCorrelationEnv();
	}
}
