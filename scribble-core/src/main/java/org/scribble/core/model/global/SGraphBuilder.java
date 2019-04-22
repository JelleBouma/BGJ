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
package org.scribble.core.model.global;

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.stream.Collectors;

import org.scribble.core.job.Core;
import org.scribble.core.job.CoreArgs;
import org.scribble.core.model.endpoint.EFsm;
import org.scribble.core.model.endpoint.EGraph;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.model.global.actions.SAction;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.util.ScribException;

public class SGraphBuilder
{
	public final Core core;
	
	private final SGraphBuilderUtil util;
	
	public SGraphBuilder(Core core)
	{
		this.core = core;
		this.util = this.core.config.mf.newSGraphBuilderUtil();
	}

	// Do as an initial state rather than config?
	protected SConfig createInitConfig(Map<Role, EGraph> egraphs,
			boolean explicit)
	{
		Map<Role, EFsm> efsms = egraphs.entrySet().stream()
				.collect(Collectors.toMap(Entry::getKey, e -> e.getValue().toFsm()));
		SQueues b0 = new SQueues(efsms.keySet(), !explicit);
		return this.core.config.mf.newSConfig(efsms, b0);
	}
	
	// Factory method: not fully integrated with SGraph constructor because of Job arg (debug printing)
	// Also checks for non-deterministic payloads
	// Maybe refactor into an SGraph builder util; cf., EGraphBuilderUtil -- but not Visitor-based building (cf. EndpointGraphBuilder), this isn't an AST algorithm
	//public SGraph buildSGraph(Job job, GProtocolName fullname, SConfig c0) throws ScribbleException
	public SGraph build(GProtoName fullname, Map<Role, EGraph> egraphs,
			boolean explicit) throws ScribException
	{
		this.util.reset();
		
		SConfig c0 = createInitConfig(egraphs, explicit);
		SState init = this.util.newState(c0);
		Set<SState> todo = new LinkedHashSet<>();
		todo.add(init);
		for (int debugCount = 1; !todo.isEmpty(); ) // Compute configs and use util to construct graph, until no more new configs
		{
			Iterator<SState> i = todo.iterator();
			SState curr = i.next();
			i.remove();
			/*if (this.core.config.args.get(CoreArgs.VERBOSE))
			{
				if (debugCount++ % 50 == 0)
				{
					this.core.verbosePrintln(
							"(" + fullname + ") Building global states: " + debugCount);
				}
			}*/

			// Based on config semantics, not "static" graph edges (cf., super.getActions) -- used to build global model graph
			Map<Role, List<EAction>> fireable = curr.config.getFireable();
			for (Role r : fireable.keySet())
			{
				for (EAction a : fireable.get(r))
				{
					// Asynchronous (input/output) actions
					if (a.isSend() || a.isReceive() || a.isDisconnect())
					{
						List<SConfig> next = curr.config.async(r, a);
						Set<SState> succs = this.util.getSuccs(curr, a.toGlobal(r), next);  // util.getSuccs constructs the edges
						todo.addAll(succs);
					}
					// Synchronous (client/server) actions
					else if (a.isAccept() || a.isRequest() || a.isClientWrap()
							|| a.isServerWrap())
					{	
						List<EAction> as = fireable.get(a.peer);
						EAction abar = a.toDual(r);
						if (as != null && as.contains(abar))
						{
							as.remove(abar);  // Removes one occurrence
							SAction aglobal = (a.isRequest() || a.isClientWrap()) // "client" side action
									? a.toGlobal(r)
									: abar.toGlobal(a.peer);
									// CHECKME: edge will be drawn as the connect, but should be read as the sync. of both -- something like "r1, r2: sync" may be more consistent (or take a set of actions as the edge label?)
							List<SConfig> next = curr.config.sync(r, a, a.peer, abar);
							Set<SState> succs = this.util.getSuccs(curr, aglobal, next);  // util.getSuccs constructs the edges
							todo.addAll(succs);
						}
					}
					else
					{
						throw new RuntimeException("Unknown action kind: " + a);
					}
				}
			}
		}

		return this.core.config.mf.newSGraph(fullname, this.util.getStates(), init);
	}
}
