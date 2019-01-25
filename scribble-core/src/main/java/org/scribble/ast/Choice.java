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
package org.scribble.ast;

import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.del.ScribDel;
import org.scribble.main.ScribbleException;
import org.scribble.type.kind.ProtocolKind;
import org.scribble.visit.AstVisitor;

public abstract class Choice<K extends ProtocolKind> extends CompoundInteractionNode<K>
{
	// ScribTreeAdaptor#create constructor
	public Choice(Token t)
	{
		super(t);
		this.subj = null;
		this.blocks = null;
	}

	// Tree#dupNode constructor
	protected Choice(Choice<K> node)
	{
		super(node);
		this.subj = null;
		this.blocks = null;
	}
	
	public abstract Choice<K> dupNode();
	
	public RoleNode getSubjectChild()
	{
		return (RoleNode) getChild(0);
	}

	// Override in concrete sub for cast
	public abstract List<? extends ProtocolBlock<K>> getBlockChildren();
	
	public Choice<K> reconstruct(RoleNode subj, List<? extends ProtocolBlock<K>> blocks)
	{
		Choice<K> c = dupNode();
		ScribDel del = del();
		c.addChild(subj);
		c.addChildren(blocks);
		c.setDel(del);  // No copy
		return c;
	}
	
	@Override
	public Choice<K> visitChildren(AstVisitor nv) throws ScribbleException
	{
		RoleNode subj = (RoleNode) visitChild(getSubjectChild(), nv);
		List<? extends ProtocolBlock<K>> blocks = 
				visitChildListWithClassEqualityCheck(this, getBlockChildren(), nv);
		return reconstruct(subj, blocks);
	}
	
	@Override
	public String toString()
	{
		String sep = " " + Constants.OR_KW + " ";
		return Constants.CHOICE_KW + " "
				+ Constants.AT_KW + " " + getSubjectChild() + " "
				+ getBlockChildren().stream().map(b -> b.toString())
						.collect(Collectors.joining(sep));
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	private final RoleNode subj;
	private final List<? extends ProtocolBlock<K>> blocks;  
			// Factor up? And specialise to singleton for Recursion/Interruptible? Maybe too artificial -- could separate unaryblocked and multiblocked compound ops?

	protected Choice(CommonTree source, RoleNode subj, List<? extends ProtocolBlock<K>> blocks)
	{
		super(source);
		this.subj = subj;
		this.blocks = new LinkedList<>(blocks);
	}
}
