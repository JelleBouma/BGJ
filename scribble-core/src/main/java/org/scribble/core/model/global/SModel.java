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

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.scribble.core.job.Core;
import org.scribble.core.job.CoreArgs;
import org.scribble.core.model.endpoint.EFsm;
import org.scribble.core.model.endpoint.actions.ESend;
import org.scribble.core.model.global.actions.SAction;
import org.scribble.core.type.name.Role;
import org.scribble.util.ScribException;

public class SModel
{
	public final SGraph graph;

	public SModel(SGraph graph)
	{
		this.graph = graph;
	}

	public void validate(Core core) throws ScribException
	{
		SState init = this.graph.init;
		Map<Integer, SState> states = this.graph.states;

		String errorMsg = "";

		int count = 0;
		for (SState s : states.values())
		{
			if (core.config.args.get(CoreArgs.VERBOSE))
			{
				count++;
				if (count % 50 == 0)
				{
					//job.debugPrintln("(" + this.graph.proto + ") Checking safety: " + count + " states");
					core.verbosePrintln(
							"(" + this.graph.proto + ") Checking states: " + count);
				}
			}
			SStateErrors errors = s.getErrors();
			if (!errors.isEmpty())
			{
				// FIXME: getTrace can get stuck when local choice subjects are disabled
				List<SAction> trace = this.graph.getTrace(init, s);  // FIXME: getTrace broken on non-det self loops?
				//errorMsg += "\nSafety violation(s) at " + s.toString() + ":\n    Trace=" + trace;
				errorMsg += "\nSafety violation(s) at session state " + s.id
						+ ":\n    Trace=" + trace;
			}
			errorMsg = appendSafetyErrorMessages(errorMsg, errors);
		}
		core.verbosePrintln("(" + this.graph.proto + ") Checked all states: " + count);  // May include unsafe states
		//*/
		
		if (!core.config.args.get(CoreArgs.NO_PROGRESS))
		{
			//job.debugPrintln("(" + this.graph.proto + ") Checking progress: ");  // Incompatible with current errorMsg approach*/

			Set<Set<Integer>> termsets = this.graph.getTerminalSets();
			for (Set<Integer> termset : termsets)
			{
				/*job.debugPrintln("(" + this.graph.proto + ") Checking terminal set: "
							+ termset.stream().map((i) -> new Integer(all.get(i).id).toString()).collect(Collectors.joining(",")));  // Incompatible with current errorMsg approach*/

				Set<Role> starved = checkRoleProgress(states, init, termset);
				Map<Role, Set<ESend>> ignored = 
						checkEventualReception(states, init, termset);
				errorMsg = appendProgressErrorMessages(errorMsg, starved, ignored, core,
						states, termset);
			}
		}

		if (!errorMsg.equals(""))
		{
			//throw new ScribbleException("\n" + init.toDot() + errorMsg);
			throw new ScribException(errorMsg);
		}
		//job.debugPrintln("(" + this.graph.proto + ") Progress satisfied.");  // Also safety... current errorMsg approach
	}

	protected String appendSafetyErrorMessages(String errorMsg,
			SStateErrors errors)
	{
		if (!errors.stuck.isEmpty())
		{
			errorMsg += "\n    Stuck messages: " + errors.stuck;  // Deadlock from reception error
		}
		if (!errors.waitFor.isEmpty())
		{
			errorMsg += "\n    Wait-for errors: " + errors.waitFor;  // Deadlock from input-blocked cycles, terminated dependencies, etc
		}
		if (!errors.orphans.isEmpty())
		{
			errorMsg += "\n    Orphan messages: " + errors.orphans;  // FIXME: add sender of orphan to error message 
		}
		if (!errors.unfinished.isEmpty())
		{
			errorMsg += "\n    Unfinished roles: " + errors.unfinished;
		}
		return errorMsg;
	}

	protected String appendProgressErrorMessages(String errorMsg,
			Set<Role> starved, Map<Role, Set<ESend>> ignored, Core core,
			Map<Integer, SState> states, Set<Integer> termset)
	{
		if (!starved.isEmpty())
		{
			errorMsg += "\nRole progress violation for " + starved
					+ " in session state terminal set:\n    "
					+ termSetToString(core, termset, states);
		}
		if (!ignored.isEmpty())
		{
			errorMsg += "\nEventual reception violation for " + ignored
					+ " in session state terminal set:\n    "
					+ termSetToString(core, termset, states);
		}
		return errorMsg;
	}
	
	protected String termSetToString(Core core, Set<Integer> termset,
			Map<Integer, SState> all)
	{
		return core.config.args.get(CoreArgs.VERBOSE)
				? termset.stream().map((i) -> all.get(i).toString())
						.collect(Collectors.joining(","))
				: termset.stream().map((i) -> new Integer(all.get(i).id).toString())
						.collect(Collectors.joining(","));
	}

	// ** Could subsume terminal state check, if terminal sets included size 1 with reflexive reachability (but not a good approach)
	protected static Set<Role> checkRoleProgress(Map<Integer, SState> states,
			SState init, Set<Integer> termset) throws ScribException
	{
		Set<Role> starved = new HashSet<>();
		Iterator<Integer> i = termset.iterator();
		SState s = states.get(i.next());
		Map<Role, SState> ss = new HashMap<>();
		s.config.efsms.keySet().forEach(r -> ss.put(r, s));
		while (i.hasNext())
		{
			SState next = states.get(i.next());
			Map<Role, EFsm> tmp = next.config.efsms;
			for (Role r : tmp.keySet())
			{
				if (ss.get(r) != null)
				{
					/*if (!ss.get(r).equals(tmp.get(r)))
					{	
						ss.put(r, null);
					}
					else*/
					{
						for (SAction a : next.getActions())
						{
							if (a.containsRole(r))
							{
								ss.put(r, null);
								break;
							}
						}
					}
				}
			}
		}
		for (Role r : ss.keySet())
		{
			SState foo = ss.get(r);
			if (foo != null)
			{
				EFsm tmp = foo.config.efsms.get(r);
				if (tmp != null)
				{
					if (!foo.config.canSafelyTerminate(r))
					{
						if (s.config.queues.getQueue(r).values().stream()
								.allMatch((v) -> v == null))
						{
							starved.add(r);
						}
						/*
						// Should be redundant given explicit reception error etc checking
						else
						{
							safety.add(r);
						}*/
					}
				}
			}
		}
		return starved;
	}

	// (eventual reception)
	protected static Map<Role, Set<ESend>> checkEventualReception(
			Map<Integer, SState> states, SState init, Set<Integer> termset)
			throws ScribException
	{
		Set<Role> roles = states.get(termset.iterator().next()).config.efsms
				.keySet();

		Iterator<Integer> i = termset.iterator();
		Map<Role, Map<Role, ESend>> b0 = states.get(i.next()).config.queues
				.getQueues();
		while (i.hasNext())
		{
			SState s = states.get(i.next());
			SQueues b = s.config.queues;
			for (Role r1 : roles)
			{
				for (Role r2 : roles)
				{
					ESend s0 = b0.get(r1).get(r2);
					if (s0 != null)
					{
						ESend tmp = b.getQueue(r1).get(r2);
						if (tmp == null)
						{
							b0.get(r1).put(r2, null);
						}
					}
				}
			}
		}
	
		Map<Role, Set<ESend>> ignored = new HashMap<>();
		for (Role r1 : roles)
		{
			for (Role r2 : roles)
			{
				ESend m = b0.get(r1).get(r2);
				if (m != null)
				{
					Set<ESend> tmp = ignored.get(r2);
					if (tmp == null)
					{
						tmp = new HashSet<>();
						ignored.put(r2, tmp);
					}
					tmp.add(m);
				}
			}
		}
		return ignored;
	}
	
	@Override
	public String toString()
	{
		return this.graph.toString();
	}
}
