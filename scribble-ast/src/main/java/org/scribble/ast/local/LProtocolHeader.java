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
import org.scribble.ast.NameDeclNode;
import org.scribble.ast.NonRoleParamDeclList;
import org.scribble.ast.ProtocolHeader;
import org.scribble.ast.RoleDecl;
import org.scribble.ast.RoleDeclList;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.ast.name.qualified.ProtocolNameNode;
import org.scribble.core.type.kind.Local;
import org.scribble.core.type.kind.RoleKind;
import org.scribble.core.type.name.LProtocolName;
import org.scribble.core.type.name.Role;
import org.scribble.util.Constants;

public class LProtocolHeader extends ProtocolHeader<Local> implements LScribNode
{
	// ScribTreeAdaptor#create constructor
	public LProtocolHeader(Token t)
	{
		super(t);
	}
	
	// Tree#dupNode constructor
	protected LProtocolHeader(LProtocolHeader node)
	{
		super(node);
	}
		
	@Override
	public LProtocolNameNode getNameNodeChild()
	{
		return (LProtocolNameNode) getNameNodeChild();
	}
	
	@Override
	public LProtocolHeader dupNode()
	{
		return new LProtocolHeader(this);
	}

	@Override
	public LProtocolHeader reconstruct(ProtocolNameNode<Local> name,
			RoleDeclList rdl, NonRoleParamDeclList pdl)
	{
		return (LProtocolHeader) super.reconstruct(name, rdl, pdl);
	}

	public Role getSelfRole()
	{
		RoleDeclList rdl = getRoleDeclListChild();
		for (NameDeclNode<RoleKind> rd : rdl.getParamDeclChildren())
		{
			RoleDecl tmp = (RoleDecl) rd;
			if (tmp.isSelfRoleDecl())
			{
				return tmp.getDeclName();
			}
		}
		throw new RuntimeException("Shouldn't get here: " + rdl);
	}

	@Override
	public LProtocolName getDeclName()
	{
		return getNameNodeChild().toName();
	}
	
	@Override
	public String toString()
	{
		return Constants.LOCAL_KW + " " + super.toString();
	}
	
	
	
	
	
	
	
	
	
	
	
	
	public LProtocolHeader(CommonTree source, LProtocolNameNode name, RoleDeclList roledecls, NonRoleParamDeclList paramdecls)
	{
		super(source, name, roledecls, paramdecls);
	}

	/*@Override
	protected ScribNodeBase copy()
	{
		return new LProtocolHeader(this.source, getNameNodeChild(), this.roledecls, this.paramdecls);
	}
	
	@Override
	public LProtocolHeader clone(AstFactory af)
	{
		LProtocolNameNode name = getNameNodeChild().clone(af);
		RoleDeclList roledecls = this.roledecls.clone(af);
		NonRoleParamDeclList paramdecls = this.paramdecls.clone(af);
		return af.LProtocolHeader(this.source, name, roledecls, paramdecls);
	}

	@Override
	public LProtocolHeader reconstruct(ProtocolNameNode<Local> name, RoleDeclList rdl, NonRoleParamDeclList pdl)
	{
		ScribDel del = del();
		LProtocolHeader gph = new LProtocolHeader(this.source, (LProtocolNameNode) name, rdl, pdl);
		gph = (LProtocolHeader) gph.del(del);
		return gph;
	}*/
}
