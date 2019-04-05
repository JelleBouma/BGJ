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
import java.util.Iterator;
import java.util.Set;

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.Do;
import org.scribble.ast.NonRoleArgList;
import org.scribble.ast.RoleArgList;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.job.JobContext;
import org.scribble.job.RuntimeScribbleException;
import org.scribble.job.ScribbleException;
import org.scribble.lang.context.ModuleContext;
import org.scribble.type.kind.Local;
import org.scribble.type.name.LProtocolName;
import org.scribble.type.name.Role;
import org.scribble.type.session.Message;
import org.scribble.visit.context.ProjectedChoiceSubjectFixer;

public class LDo extends Do<Local> implements LSimpleSessionNode
{
	// ScribTreeAdaptor#create constructor
	public LDo(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	public LDo(LDo node)
	{
		super(node);
	}

	@Override
	public LProtocolNameNode getProtocolNameNode()
	{
		return (LProtocolNameNode) getChild(2);
	}
	
	@Override
	public LDo dupNode()
	{
		return new LDo(this);
	}

	@Override
	public Role inferLocalChoiceSubject(ProjectedChoiceSubjectFixer fixer)
	{
		ModuleContext mc = fixer.getModuleContext();
		JobContext jc = fixer.job.getContext();
		Role subj = getTargetProtocolDecl(jc, mc).getDefChild().getBlockChild()
				.getInteractSeqChild().getInteractionChildren().get(0)
				.inferLocalChoiceSubject(fixer);
		// FIXME: need equivalent of (e.g) rec X { continue X; } pruning (cf GRecursion.prune) for irrelevant recursive-do (e.g. proto(A, B, C) { choice at A {A->B.do Proto(A,B,C)} or {A->B.B->C} }))
		Iterator<Role> roleargs = getRoleListChild().getRoles().iterator();
		for (Role decl : getTargetProtocolDecl(jc, mc).getHeaderChild()
				.getRoleDeclListChild().getRoles())
		{
			Role arg = roleargs.next();
			if (decl.equals(subj))
			{
				return arg;
			}
		}
		throw new RuntimeException("Shouldn't get here: " + this);
	}

	@Override
	public LSessionNode merge(AstFactory af, LSessionNode ln)
			throws ScribbleException
	{
		throw new RuntimeScribbleException("Invalid merge on LDo: " + this);
	}

	@Override
	public boolean canMerge(LSessionNode ln)
	{
		return false;
	}

	@Override
	public Set<Message> getEnabling()
	{
		return Collections.emptySet();
	}

	@Override
	public LProtocolName getTargetProtocolDeclFullName(ModuleContext mcontext)
	{
		return (LProtocolName) super.getTargetProtocolDeclFullName(mcontext);
	}

	@Override
	public LProtocolDecl getTargetProtocolDecl(JobContext jcontext,
			ModuleContext mcontext)
	{
		return (LProtocolDecl) super.getTargetProtocolDecl(jcontext, mcontext);
	}
	
	
	
	
	
	
	

	
	
	
	
	
	public LDo(CommonTree source, RoleArgList roleinstans, NonRoleArgList arginstans, LProtocolNameNode proto)
	{
		super(source, roleinstans, arginstans, proto);
	}

	/*@Override
	protected LDo copy()
	{
		return new LDo(this.source, this.roles, this.args, getProtocolNameNode());
	}
	
	@Override
	public LDo clone(AstFactory af)
	{
		RoleArgList roles = this.roles.clone(af);
		NonRoleArgList args = this.args.clone(af);
		LProtocolNameNode proto = this.getProtocolNameNode().clone(af);
		return af.LDo(this.source, roles, args, proto);
	}
	
	@Override
	public LDo reconstruct(RoleArgList roles, NonRoleArgList args, ProtocolNameNode<Local> proto)
	{
		ScribDel del = del();
		LDo ld = new LDo(this.source, roles, args, (LProtocolNameNode) proto);
		ld = (LDo) ld.del(del);
		return ld;
	}*/
}
