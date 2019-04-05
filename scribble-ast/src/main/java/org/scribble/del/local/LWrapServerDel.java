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

import org.scribble.ast.ScribNode;
import org.scribble.ast.local.LWrapServer;
import org.scribble.core.type.name.Role;
import org.scribble.del.ConnectionActionDel;
import org.scribble.util.ScribException;
import org.scribble.visit.context.EGraphBuilder;
import org.scribble.visit.context.ProjectedChoiceSubjectFixer;
import org.scribble.visit.context.UnguardedChoiceDoProjectionChecker;
import org.scribble.visit.context.env.UnguardedChoiceDoEnv;

public class LWrapServerDel extends ConnectionActionDel
		implements LSimpleInteractionNodeDel
{
	@Override
	public LWrapServer leaveEGraphBuilding(ScribNode parent, ScribNode child,
			EGraphBuilder builder, ScribNode visited) throws ScribException
	{
		LWrapServer la = (LWrapServer) visited;
		Role peer = la.getSourceChild().toName();
		builder.util.addEdge(builder.util.getEntry(),
				builder.job.config.ef.newEWrapServer(peer), builder.util.getExit());
		return (LWrapServer) super.leaveEGraphBuilding(parent, child, builder, la);
	}

	@Override
	public void enterProjectedChoiceSubjectFixing(ScribNode parent,
			ScribNode child, ProjectedChoiceSubjectFixer fixer)
	{
		fixer.setChoiceSubject(((LWrapServer) child).getSourceChild().toName());
	}

	@Override
	public void enterUnguardedChoiceDoProjectionCheck(ScribNode parent,
			ScribNode child, UnguardedChoiceDoProjectionChecker checker)
			throws ScribException
	{
		super.enterUnguardedChoiceDoProjectionCheck(parent, child, checker);
		LWrapServer la = (LWrapServer) child;
		UnguardedChoiceDoEnv env = checker.popEnv();
		env = env.setChoiceSubject(la.getSourceChild().toName());
		checker.pushEnv(env);
	}
}
