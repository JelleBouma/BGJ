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

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.MessageSigNode;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.util.Constants;

public class LWrapServer extends LConnectionAction implements LSimpleSessionNode
{
	// ScribTreeAdaptor#create constructor
	public LWrapServer(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	public LWrapServer(LWrapServer node)
	{
		super(node);
	}
	
	@Override
	public LWrapServer dupNode()
	{
		return new LWrapServer(this);
	}

	@Override
	public String toString()
	{
		return Constants.WRAP_KW + " " + Constants.FROM_KW + " "
				+ this.getSourceChild() + ";";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public LWrapServer(CommonTree source, MessageSigNode unit, RoleNode src, RoleNode dest)
	{
		super(source, src, unit, dest);
	}

	/*@Override
	protected ScribNodeBase copy()
	{
		return new LWrapServer(this.source, (MessageSigNode) this.msg, this.src, this.dest);
	}
	
	@Override
	public LWrapServer clone(AstFactory af)
	{
		RoleNode src = this.src.clone(af);
		RoleNode dest = this.dest.clone(af);
		return af.LWrapServer(this.source, src, dest);
	}

	@Override
	public LWrapServer reconstruct(RoleNode src, MessageNode msg, RoleNode dest)
	//public LWrapServer reconstruct(RoleNode src, RoleNode dest)
	{
		ScribDel del = del();
		LWrapServer lr = new LWrapServer(this.source, (MessageSigNode) this.msg, src, dest);
		lr = (LWrapServer) lr.del(del);
		return lr;
	}*/
}
