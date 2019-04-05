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

import org.scribble.ast.ScribNode;
import org.scribble.ast.global.GWrap;
import org.scribble.ast.local.LScribNode;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.core.type.name.Role;
import org.scribble.del.ConnectionActionDel;
import org.scribble.util.ScribException;
import org.scribble.visit.context.Projector;
import org.scribble.visit.wf.NameDisambiguator;
import org.scribble.visit.wf.WFChoiceChecker;
import org.scribble.visit.wf.env.WFChoiceEnv;

// TODO: make WrapDel (cf., G/LMessageTransferDel)
public class GWrapDel extends ConnectionActionDel
		implements GSimpleInteractionNodeDel
{
	public GWrapDel()
	{
		
	}

	@Override
	public ScribNode leaveDisambiguation(ScribNode parent, ScribNode child,
			NameDisambiguator disamb, ScribNode visited) throws ScribException
	{
		GWrap gw = (GWrap) visited;
		return gw;
	}

	@Override
	public GWrap leaveInlinedWFChoiceCheck(ScribNode parent, ScribNode child,
			WFChoiceChecker checker, ScribNode visited) throws ScribException
	{
		GWrap gw = (GWrap) visited;
		
		RoleNode srcNode = gw.getSourceChild();
		RoleNode destNode = gw.getDestinationChild();
		Role src = srcNode.toName();
		Role dest = destNode.toName();
		if (!checker.peekEnv().isEnabled(src))
		{
			throw new ScribException(srcNode.getSource(),
					"Role not enabled: " + src);
		}
		if (!checker.peekEnv().isEnabled(dest))
		{
			throw new ScribException(destNode.getSource(),
					"Role not enabled: " + dest);
		}
		//Message msg = gw.msg.toMessage();  //  Unit message 
		if (src.equals(dest))
		{
			throw new ScribException(gw.getSource(),
					"[TODO] Self connections not supported: " + gw);
		}
		WFChoiceEnv env = checker.popEnv();
		if (!env.isConnected(src, dest))
		{
			throw new ScribException(gw.getSource(),
					"Roles not (necessarily) connected: " + src + ", " + dest);
		}

		//env = env.addMessage(src, dest, msg);
		/*env = env
				.connect(src, dest)
				.addMessage(src, dest, new MessageSig(Op.EMPTY_OPERATOR, Payload.EMPTY_PAYLOAD));*/
		checker.pushEnv(env);
		return gw;
	}

	@Override
	public ScribNode leaveProjection(ScribNode parent, ScribNode child,
			Projector proj, ScribNode visited) throws ScribException 
			// throwsScribbleException
	{
		GWrap gw = (GWrap) visited;
		Role self = proj.peekSelf();
		LScribNode projection = gw.project(proj.lang.config.af, self);
		proj.pushEnv(proj.popEnv().setProjection(projection));
		return (GWrap) GSimpleInteractionNodeDel.super.leaveProjection(parent,
				child, proj, gw);
	}
}
