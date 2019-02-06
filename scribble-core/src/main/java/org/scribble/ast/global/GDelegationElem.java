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
import org.scribble.ast.PayloadElem;
import org.scribble.ast.ScribNodeBase;
import org.scribble.ast.local.LDelegationElem;
import org.scribble.ast.name.qualified.GProtocolNameNode;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.del.ScribDel;
import org.scribble.job.ScribbleException;
import org.scribble.type.kind.Local;
import org.scribble.type.name.GDelegationType;
import org.scribble.type.name.PayloadElemType;
import org.scribble.visit.AstVisitor;
import org.scribble.visit.context.Projector;

// A "name pair" payload elem (current AST hierarchy induces this pattern), cf. UnaryPayloadElem (also differs in no parsing ambig against parameters)
// The this.name will be global kind, but overall this node is local kind
//public class DelegationElem extends PayloadElem<Local>
public class GDelegationElem extends ScribNodeBase implements PayloadElem<Local>
{
	// ScribTreeAdaptor#create constructor
	public GDelegationElem(Token t)
	{
		super(t);
		this.proto = null;
		this.role = null;
	}

	// Tree#dupNode constructor
	public GDelegationElem(GDelegationElem node)
	{
		super(node);
		this.proto = null;
		this.role = null;
	}

  // Becomes full name after disambiguation
	public GProtocolNameNode getProtocolChild()
	{
		return (GProtocolNameNode) getChild(0);
	}
	
	public RoleNode getRoleChild()
	{
		return (RoleNode) getChild(1);
	}
	
	@Override
	public GDelegationElem dupNode()
	{
		return new GDelegationElem(this);
	}
	
	@Override
	public LDelegationElem project(AstFactory af)
	{
		return af.LDelegationElem(this.source, Projector.makeProjectedFullNameNode(
				af, this.source, getProtocolChild().toName(), getRoleChild().toName()));
	}

	@Override
	public boolean isGlobalDelegationElem()
	{
		return true;
	}

	public GDelegationElem reconstruct(GProtocolNameNode proto, RoleNode role)
	{
		ScribDel del = del();
		GDelegationElem elem = new GDelegationElem(this.source, proto, role);
		elem = (GDelegationElem) elem.del(del);
		return elem;
	}

	@Override
	public GDelegationElem visitChildren(AstVisitor nv) throws ScribbleException
	{
		GProtocolNameNode name = (GProtocolNameNode) 
				visitChild(getProtocolChild(), nv);
		RoleNode role = (RoleNode) visitChild(getRoleChild(), nv);
		return reconstruct(name, role);
	}

	@Override
	public PayloadElemType<Local> toPayloadType()
	{
		return new GDelegationType(getProtocolChild().toName(),
				getRoleChild().toName());
	}
	
	@Override
	public String toString()
	{
		return getProtocolChild() + "@" + getRoleChild();
	}

	














  // Currently no potential for ambiguity, cf. UnaryPayloadElem (DataTypeNameNode or ParameterNode)
	private final GProtocolNameNode proto;  // Becomes full name after disambiguation
	private final RoleNode role;
	
	public GDelegationElem(CommonTree source, GProtocolNameNode proto, RoleNode role)
	{
		//super(proto);
		super(source);
		this.proto = proto;
		this.role = role;
	}

	/*@Override
	protected GDelegationElem copy()
	{
		return new GDelegationElem(this.source, this.proto, this.role);
	}
	
	@Override
	public GDelegationElem clone(AstFactory af)
	{
		GProtocolNameNode name = (GProtocolNameNode) this.proto.clone(af);
		RoleNode role = (RoleNode) this.role.clone(af);
		return af.GDelegationElem(this.source, name, role);
	}*/
}
