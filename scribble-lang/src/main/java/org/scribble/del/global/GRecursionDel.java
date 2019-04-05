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
package org.scribble.del.global;

import org.scribble.ast.ScribNode;
import org.scribble.ast.global.GProtocolBlock;
import org.scribble.ast.global.GRecursion;
import org.scribble.ast.local.LProtocolBlock;
import org.scribble.ast.local.LRecursion;
import org.scribble.ast.name.simple.RecVarNode;
import org.scribble.del.RecursionDel;
import org.scribble.job.ScribbleException;
import org.scribble.type.name.RecVar;
import org.scribble.type.session.global.GSeq;
import org.scribble.visit.GTypeTranslator;
import org.scribble.visit.ProtocolDefInliner;
import org.scribble.visit.context.Projector;
import org.scribble.visit.context.env.ProjectionEnv;
import org.scribble.visit.env.InlineProtocolEnv;
import org.scribble.visit.wf.WFChoiceChecker;
import org.scribble.visit.wf.env.WFChoiceEnv;

public class GRecursionDel extends RecursionDel implements GCompoundInteractionNodeDel
{
	
	@Override
	public org.scribble.type.session.global.GRecursion translate(ScribNode n,
			GTypeTranslator t) throws ScribbleException
	{
		GRecursion source = (GRecursion) n;
		RecVar recvar = source.getRecVarChild().toName();
		GSeq block = (GSeq) source.getBlockChild().visitWith(t);
		return new org.scribble.type.session.global.GRecursion(source, recvar, block);
	}

	@Override
	public ScribNode leaveProtocolInlining(ScribNode parent, ScribNode child,
			ProtocolDefInliner inl, ScribNode visited) throws ScribbleException
	{
		GRecursion gr = (GRecursion) visited;
		//RecVarNode recvar = gr.recvar.clone();
		RecVarNode recvar = (RecVarNode) ((InlineProtocolEnv) gr.getRecVarChild()
				.del().env()).getTranslation();
		GProtocolBlock block = (GProtocolBlock) ((InlineProtocolEnv) gr
				.getBlockChild().del().env()).getTranslation();
		GRecursion inlined = 
				inl.job.config.af.GRecursion(gr.getSource(), recvar, block);
		inl.pushEnv(inl.popEnv().setTranslation(inlined));
		return (GRecursion) super.leaveProtocolInlining(parent, child, inl, gr);
	}

	@Override
	public GRecursion leaveInlinedWFChoiceCheck(ScribNode parent, ScribNode child,
			WFChoiceChecker checker, ScribNode visited) throws ScribbleException
	{
		GRecursion rec = (GRecursion) visited;
		WFChoiceEnv merged = checker.popEnv()
				.mergeContext((WFChoiceEnv) rec.getBlockChild().del().env());
				// Merge block child env into current rec env
		checker.pushEnv(merged);
		return (GRecursion) super.leaveInlinedWFChoiceCheck(parent, child, checker,
				rec);
				// Will merge current rec env into parent (and set env on del)
	}

	@Override
	public GRecursion leaveProjection(ScribNode parent, ScribNode child,
			Projector proj, ScribNode visited) throws ScribbleException
	{
		GRecursion gr = (GRecursion) visited;
		LProtocolBlock block =
				(LProtocolBlock) ((ProjectionEnv) gr.getBlockChild().del().env())
						.getProjection();
				//((GProtocolBlockDel) gr.block.del()).project(gr.getBlock(), self);
		LRecursion projection = 
				gr.project(proj.job.config.af, proj.peekSelf(), block);
		proj.pushEnv(proj.popEnv().setProjection(projection));
		return (GRecursion) GCompoundInteractionNodeDel.super.leaveProjection(
				parent, child, proj, gr);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/*@Override
	public void enterAnnotCheck(ScribNode parent, ScribNode child, AnnotationChecker checker) throws ScribbleException
	{
		ScribDelBase.pushVisitorEnv(this, checker);
	}
	
	@Override
	public GRecursion leaveAnnotCheck(ScribNode parent, ScribNode child, AnnotationChecker checker, ScribNode visited) throws ScribbleException
	{
		return (GRecursion) ScribDelBase.popAndSetVisitorEnv(this, checker, visited);
	}*/
}
