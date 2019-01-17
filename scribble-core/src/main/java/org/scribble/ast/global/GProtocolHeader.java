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
import org.scribble.ast.Constants;
import org.scribble.ast.NonRoleParamDeclList;
import org.scribble.ast.ProtocolHeader;
import org.scribble.ast.RoleDeclList;
import org.scribble.ast.ScribNodeBase;
import org.scribble.ast.local.LProtocolHeader;
import org.scribble.ast.name.qualified.GProtocolNameNode;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.ast.name.qualified.ProtocolNameNode;
import org.scribble.del.ScribDel;
import org.scribble.type.kind.Global;
import org.scribble.type.name.GProtocolName;
import org.scribble.type.name.Role;

public class GProtocolHeader extends ProtocolHeader<Global> implements GNode
{
	public GProtocolHeader(Token t)
	{
		super(t);
	}

	public GProtocolHeader(CommonTree source, GProtocolNameNode name, RoleDeclList roledecls, NonRoleParamDeclList paramdecls)
	{
		super(source, name, roledecls, paramdecls);
	}

	@Override
	protected ScribNodeBase copy()
	{
		return new GProtocolHeader(this.source, getNameNode(), this.roledecls, this.paramdecls);
	}
	
	@Override
	public GProtocolHeader clone(AstFactory af)
	{
		GProtocolNameNode name = getNameNode().clone(af);
		RoleDeclList roledecls = this.roledecls.clone(af);
		NonRoleParamDeclList paramdecls = this.paramdecls.clone(af);
		return af.GProtocolHeader(this.source, name, roledecls, paramdecls);
	}

	@Override
	public GProtocolHeader reconstruct(ProtocolNameNode<Global> name, RoleDeclList rdl, NonRoleParamDeclList pdl)
	{
		ScribDel del = del();
		GProtocolHeader gph = new GProtocolHeader(this.source, (GProtocolNameNode) name, rdl, pdl);
		gph = (GProtocolHeader) gph.del(del);
		return gph;
	}

	@Override
	public GProtocolNameNode getNameNode()
	{
		return (GProtocolNameNode) this.name;
	}
	
	@Override
	public GProtocolName getDeclName()
	{
		return (GProtocolName) super.getDeclName();
	}

	// FIXME: make a delegate and move there?
	public LProtocolHeader project(AstFactory af, Role self, LProtocolNameNode name, RoleDeclList roledecls, NonRoleParamDeclList paramdecls)
	{
		return af.LProtocolHeader(this.source, name, roledecls, paramdecls);
	}
	
	@Override
	public String toString()
	{
		return Constants.GLOBAL_KW + " " + super.toString();
	}
}
