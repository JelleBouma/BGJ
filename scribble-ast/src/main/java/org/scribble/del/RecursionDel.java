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
package org.scribble.del;

import org.scribble.ast.Recursion;
import org.scribble.ast.ScribNode;
import org.scribble.core.type.name.RecVar;
import org.scribble.util.ScribException;
import org.scribble.visit.InlinedProtocolUnfolder;
import org.scribble.visit.ProtocolDefInliner;
import org.scribble.visit.env.UnfoldingEnv;
import org.scribble.visit.util.RecVarCollector;
import org.scribble.visit.wf.NameDisambiguator;

public abstract class RecursionDel extends CompoundInteractionDel
{
	public RecursionDel()
	{

	}

	@Override
	public void enterDisambiguation(ScribNode parent, ScribNode child,
			NameDisambiguator disamb) throws ScribException
	{
		Recursion<?> rec = (Recursion<?>) child;
		RecVar rv = rec.getRecVarChild().toName();
		/*if (disamb.isBoundRecVar(rv))
		{
			throw new ScribbleException("Rec variable shadowing not currently allowed: " + rv); 
					// Inconsistent to disallow due to subprotocols and that NameDisambiguator is not an inlined or subprotocol visitor
		}*/
		//disamb.addRecVar(rv);
		disamb.pushRecVar(rv);
	}

	@Override
	public ScribNode leaveDisambiguation(ScribNode parent, ScribNode child,
			NameDisambiguator disamb, ScribNode visited) throws ScribException
	{
		Recursion<?> rec = (Recursion<?>) visited;
		/*RecVar rv = rec.recvar.toName();
		disamb.popRecVar(rv);*/
		RecVar rv = ((Recursion<?>) child).getRecVarChild().toName();  // visited may be already name mangled  // Not any more (refactored to inlining)
		disamb.popRecVar(rv);
		return rec;
	}

	@Override
	public void enterProtocolInlining(ScribNode parent, ScribNode child,
			ProtocolDefInliner inliner) throws ScribException
	{
		super.enterProtocolInlining(parent, child, inliner);
		Recursion<?> rec = (Recursion<?>) child;
		inliner.pushRecVar(rec.getRecVarChild().toName());
	}

	@Override
	public ScribNode leaveProtocolInlining(ScribNode parent, ScribNode child,
			ProtocolDefInliner inliner, ScribNode visited) throws ScribException
	{
		//Recursion<?> rec = (Recursion<?>) visited;
		RecVar origRV = ((Recursion<?>) child).getRecVarChild().toName();  // visited may be already name mangled
		inliner.popRecVar(origRV);
		return super.leaveProtocolInlining(parent, child, inliner, visited);
	}

	@Override
	public void enterInlinedProtocolUnfolding(ScribNode parent, ScribNode child,
			InlinedProtocolUnfolder unf) throws ScribException
	{
		super.enterInlinedProtocolUnfolding(parent, child, unf);
		Recursion<?> lr = (Recursion<?>) child;
		RecVar recvar = lr.getRecVarChild().toName();
		unf.setRecVar(unf.job.config.af, recvar, lr);  // Cloned on use (on continue)
	}

	@Override
	public Recursion<?> leaveInlinedProtocolUnfolding(ScribNode parent,
			ScribNode child, InlinedProtocolUnfolder unf, ScribNode visited)
			throws ScribException
	{
		Recursion<?> rec = (Recursion<?>) visited;
		RecVar recvar = rec.getRecVarChild().toName();
		unf.removeRecVar(recvar);
		UnfoldingEnv merged = unf.popEnv().mergeContext((UnfoldingEnv) rec.getBlockChild().del().env());
		unf.pushEnv(merged);
		return (Recursion<?>) super.leaveInlinedProtocolUnfolding(parent, child, unf, rec);
	}

	/*@Override
	public void enterChoiceUnguardedSubprotocolCheck(ScribNode parent, ScribNode child, ChoiceUnguardedSubprotocolChecker checker) throws ScribbleException
	{
		ScribDelBase.pushVisitorEnv(this, checker);
	}*/

	@Override
	public void enterRecVarCollection(ScribNode parent, ScribNode child,
			RecVarCollector coll)
	{
		coll.addName(((Recursion<?>) child).getRecVarChild().toName());
	}
}
