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
package org.scribble.del.local;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.scribble.ast.InteractionNode;
import org.scribble.ast.ScribNode;
import org.scribble.ast.local.LInteractionNode;
import org.scribble.ast.local.LInteractionSeq;
import org.scribble.ast.local.LRecursion;
import org.scribble.del.InteractionSeqDel;
import org.scribble.del.ScribDelBase;
import org.scribble.job.ScribbleException;
import org.scribble.model.endpoint.EState;
import org.scribble.type.kind.Local;
import org.scribble.visit.ProtocolDefInliner;
import org.scribble.visit.context.EGraphBuilder;
import org.scribble.visit.context.ProjectedChoiceDoPruner;
import org.scribble.visit.context.RecRemover;
import org.scribble.visit.env.InlineProtocolEnv;
import org.scribble.visit.wf.ReachabilityChecker;
import org.scribble.visit.wf.env.ReachabilityEnv;

public class LInteractionSeqDel extends InteractionSeqDel
{
	@Override
	public ScribNode leaveProjectedChoiceDoPruning(ScribNode parent,
			ScribNode child, ProjectedChoiceDoPruner pruner, ScribNode visited)
			throws ScribbleException
	{
		LInteractionSeq lc = (LInteractionSeq) visited;
		List<LInteractionNode> actions = lc.getInteractNodeChildren().stream()
				.filter(li -> li != null).collect(Collectors.toList());
		return lc.reconstruct(actions);
	}

	// enter in super
	@Override
	public ScribNode leaveProtocolInlining(ScribNode parent, ScribNode child,
			ProtocolDefInliner inl, ScribNode visited) throws ScribbleException
	{
		LInteractionSeq lis = (LInteractionSeq) visited;
		List<LInteractionNode> lins = new LinkedList<LInteractionNode>();
		for (LInteractionNode li : lis.getInteractNodeChildren())
		{
			ScribNode inlined = ((InlineProtocolEnv) li.del().env()).getTranslation();
			if (inlined instanceof LInteractionSeq)
			{
				lins.addAll(((LInteractionSeq) inlined).getInteractNodeChildren());
			}
			else
			{
				lins.add((LInteractionNode) inlined);
			}
		}
		LInteractionSeq inlined = 
				inl.job.config.af.LInteractionSeq(lis.getSource(), lins);
		inl.pushEnv(inl.popEnv().setTranslation(inlined));
		return (LInteractionSeq) ScribDelBase.popAndSetVisitorEnv(this, inl, lis);
	}

	// Replaces visitChildrenInSubprotocols for LocalInteractionSequence 
	public LInteractionSeq visitForReachabilityChecking(
			ReachabilityChecker checker, LInteractionSeq child)
			throws ScribbleException
	{
		List<LInteractionNode> visited = new LinkedList<>();
		for (InteractionNode<Local> li : child.getInteractNodeChildren())
		{
			ReachabilityEnv re = checker.peekEnv();
			if (!re.isSequenceable())
			{
				throw new ScribbleException(li.getSource(),
						"Invalid/unreachable sequence to: " + li);
			}
			visited.add((LInteractionNode) li.accept(checker));
		}
		return child;
	}

	public LInteractionSeq visitForFsmConversion(EGraphBuilder gb,
			LInteractionSeq child) throws ScribbleException
	{
		EState entry = gb.util.getEntry();
		EState exit = gb.util.getExit();
		//try
		{
			/*for (int i = child.getInteractions().size() - 1; i >= 0; i--)  // Backwards for "tau-less" continue
			{
				if (i > 0)
				{
					EndpointState tmp = conv.builder.newState(Collections.emptySet());
					conv.builder.setEntry(tmp);
					child.getInteractions().get(i).accept(conv);
					conv.builder.setExit(conv.builder.getEntry());  // entry may not be tmp, entry/exit can be modified, e.g. continue
				}
				else
				{
					conv.builder.setEntry(entry);
					child.getInteractions().get(i).accept(conv);
				}
			}*/
			for (int i = 0; i < child.getInteractNodeChildren().size(); i++)
			{
				if (i == child.getInteractNodeChildren().size() - 1)
				{
					gb.util.setExit(exit);
					child.getInteractNodeChildren().get(i).accept(gb);
				}
				else
				{
					EState tmp = // conv.util.newState(Collections.emptySet());
							gb.util.ef.newEState(Collections.emptySet());
					gb.util.setExit(tmp);
					child.getInteractNodeChildren().get(i).accept(gb);
					gb.util.setEntry(gb.util.getExit());
							// exit may not be tmp, entry/exit can be modified, e.g. continue
				}
			}
		}
		/*catch (ScribbleException e)  // Hack: EFSM building now done before reachability check, removeEdge can fail
		{
			throw new RuntimeException("Shouldn't get in here: " + e);
		}*/
		//conv.builder.setExit(exit);
		gb.util.setEntry(entry);
		return child;	
	}
	
	// Duplicated from GInteractionSeq
	@Override
	public LInteractionSeq leaveRecRemoval(ScribNode parent, ScribNode child,
			RecRemover rem, ScribNode visited) throws ScribbleException
	{
		LInteractionSeq lis = (LInteractionSeq) visited;
		List<LInteractionNode> lins = lis.getInteractNodeChildren().stream()
				.flatMap((li) -> (li instanceof LRecursion
						&& rem.toRemove(((LRecursion) li).getRecVarChild().toName()))
								? ((LRecursion) li).getBlockChild().getInteractSeqChild()
										.getInteractNodeChildren().stream()
								: Stream.of(li))
				.collect(Collectors.toList());
		return rem.job.config.af.LInteractionSeq(lis.getSource(), lins);
	}
}
