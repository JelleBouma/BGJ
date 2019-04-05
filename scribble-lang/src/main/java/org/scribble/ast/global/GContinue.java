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
package org.scribble.ast.global;

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.Continue;
import org.scribble.ast.local.LContinue;
import org.scribble.ast.name.simple.RecVarNode;
import org.scribble.type.kind.Global;
import org.scribble.type.kind.RecVarKind;
import org.scribble.type.name.Role;

public class GContinue extends Continue<Global> implements GSimpleSessionNode
{
	// ScribTreeAdaptor#create constructor
	public GContinue(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	protected GContinue(GContinue node)
	{
		super(node);
	}
	
	@Override
	public GContinue dupNode()
	{
		return new GContinue(this);
	}

	public LContinue project(AstFactory af, Role self)
	{
		RecVarNode recvar = getRecVarChild();
		RecVarNode recvar1 = (RecVarNode) af.SimpleNameNode(recvar.getSource(),
				RecVarKind.KIND, recvar.toName().toString()); // clone?
		LContinue projection = af.LContinue(this.source, recvar1);
		return projection;
	}
	
	
	
	
	
	
	
	
	

	public GContinue(CommonTree source, RecVarNode recvar)
	{
		super(source, recvar);
	}

	/*@Override
	protected GContinue copy()
	{
		return new GContinue(this.source, this.recvar);
	}
	
	@Override
	public GContinue clone(AstFactory af)
	{
		RecVarNode rv = this.recvar.clone(af);
		return af.GContinue(this.source, rv);
	}

	@Override
	public GContinue reconstruct(RecVarNode recvar)
	{
		ScribDel del = del();
		GContinue gc = new GContinue(this.source, recvar);
		gc = (GContinue) gc.del(del);
		return gc;
	}*/
}
