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
package org.scribble.ast.local;

import java.util.Collections;
import java.util.Set;

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.Continue;
import org.scribble.ast.name.simple.RecVarNode;
import org.scribble.core.type.kind.Local;
import org.scribble.core.type.name.Role;
import org.scribble.core.type.session.Message;
import org.scribble.util.ScribException;
import org.scribble.visit.context.ProjectedChoiceSubjectFixer;

public class LContinue extends Continue<Local> implements LSimpleSessionNode
{
	// ScribTreeAdaptor#create constructor
	public LContinue(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	protected LContinue(LContinue node)
	{
		super(node);
	}
	
	@Override
	public LContinue dupNode()
	{
		return new LContinue(this);
	}

	@Override
	public LContinue clone()
	{
		return (LContinue) super.clone();
	}

	@Override
	public Role inferLocalChoiceSubject(ProjectedChoiceSubjectFixer fixer)
	{
		//return new DummyProjectionRoleNode().toName();  // For e.g. rec X { 1() from A to B; choice at A { continue X; } or { 2() from A to B; } }
		return fixer.createRecVarRole(getRecVarChild().toName());  // Never used?
		//return null;
	}

	@Override
	public LSessionNode merge(AstFactory af, LSessionNode ln)
			throws ScribException
	{
		if (!(ln instanceof LContinue) || !this.canMerge(ln))
		{
			throw new ScribException("Cannot merge " + this.getClass() + " and "
					+ ln.getClass() + ": " + this + ", " + ln);
		}
		LContinue them = ((LContinue) ln);
		if (!getRecVarChild().equals(them.getRecVarChild()))
		{
			throw new ScribException("Cannot merge choices for " + getRecVarChild()
					+ " and " + them.getRecVarChild() + ": " + this + ", " + ln);
		}
		return clone();
	}

	@Override
	public boolean canMerge(LSessionNode ln)
	{
		return ln instanceof LContinue;
	}

	@Override
	public Set<Message> getEnabling()
	{
		return Collections.emptySet();
	}

	
	
	
	
	
	
	
	
	
	public LContinue(CommonTree source, RecVarNode recvar)
	{
		super(source, recvar);
	}

	/*@Override
	protected LContinue copy()
	{
		return new LContinue(this.source, this.recvar);
	}
	
	@Override
	public LContinue clone(AstFactory af)
	{
		RecVarNode rv = this.recvar.clone(af);
		return af.LContinue(this.source, rv);
	}

	@Override
	public LContinue reconstruct(RecVarNode recvar)
	{
		ScribDel del = del();
		LContinue lc = new LContinue(this.source, recvar);
		lc = (LContinue) lc.del(del);
		return lc;
	}*/
}
