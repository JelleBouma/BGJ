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
import org.scribble.ast.Do;
import org.scribble.ast.NonRoleArgList;
import org.scribble.ast.RoleArgList;
import org.scribble.ast.local.LDo;
import org.scribble.ast.name.qualified.GProtocolNameNode;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.job.JobContext;
import org.scribble.lang.context.ModuleContext;
import org.scribble.type.kind.Global;
import org.scribble.type.name.GProtocolName;
import org.scribble.type.name.Role;

public class GDo extends Do<Global> implements GSimpleSessionNode
{
	// ScribTreeAdaptor#create constructor
	public GDo(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	public GDo(GDo node)
	{
		super(node);
	}

	@Override
	public GProtocolNameNode getProtocolNameNode()
	{
		return (GProtocolNameNode) getChild(0);
	}
	
	@Override
	public GDo dupNode()
	{
		return new GDo(this);
	}

	public LDo project(AstFactory af, Role self, LProtocolNameNode fullname)
	{
		RoleArgList roles = this.getRoleListChild().project(af, self);
		NonRoleArgList args = this.getNonRoleListChild().project(af, self);
		LDo projection = af.LDo(this.source, roles, args, fullname);
		return projection;
	}

	@Override
	public GProtocolName getTargetProtocolDeclFullName(ModuleContext mcontext)
	{
		return (GProtocolName) super.getTargetProtocolDeclFullName(mcontext);
	}

	@Override
	public GProtocolDecl getTargetProtocolDecl(JobContext jcontext,
			ModuleContext mcontext)
	{
		return (GProtocolDecl) super.getTargetProtocolDecl(jcontext, mcontext);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public GDo(CommonTree source, RoleArgList roles, NonRoleArgList args, GProtocolNameNode proto)
	{
		super(source, roles, args, proto);
	}

	/*@Override
	protected ScribNodeBase copy()
	{
		return new GDo(this.source, this.roles, this.args, getProtocolNameNode());
	}
	
	@Override
	public GDo clone(AstFactory af)
	{
		RoleArgList roles = this.roles.clone(af);
		NonRoleArgList args = this.args.clone(af);
		GProtocolNameNode proto = this.getProtocolNameNode().clone(af);
		return af.GDo(this.source, roles, args, proto);
	}

	@Override
	public GDo reconstruct(RoleArgList roles, NonRoleArgList args, ProtocolNameNode<Global> proto)
	{
		ScribDel del = del();
		GDo gd = new GDo(this.source, roles, args, (GProtocolNameNode) proto);
		gd = (GDo) gd.del(del);
		return gd;
	}*/
}
