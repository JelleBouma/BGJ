package org.scribble.visit.env;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.scribble.sesstype.name.RecVar;

public class ReachabilityEnv extends Env
{
	private boolean seqable; 
			// For checking bad sequencing of unreachable code: false after a continue; true if choice has an exit (false inherited for all other constructs)
	private final Set<RecVar> contlabs;  // For checking "reachable code" satisfies tail recursion (in the presence of sequencing)
	
	public ReachabilityEnv()
	{
		this(true, Collections.emptySet());
	}
	
	protected ReachabilityEnv(boolean seqable, Set<RecVar> contlabs)
	{
		this.contlabs = new HashSet<RecVar>(contlabs);
		this.seqable = seqable;
	}

	@Override
	public ReachabilityEnv copy()
	{
		return new ReachabilityEnv(this.seqable, this.contlabs);
	}

	@Override
	public ReachabilityEnv enterContext()
	{
		return copy();
	}

  // Should not be used for single block choice 
	@Override
	public ReachabilityEnv mergeContext(Env child)
	{
		return mergeContexts(Arrays.asList((ReachabilityEnv) child));
	}

	// Should not be used for Choice
	@Override
	public ReachabilityEnv mergeContexts(List<? extends Env> children)
	{
		return merge(false, castList(children));
	}

	public ReachabilityEnv mergeForChoice(List<ReachabilityEnv> children)
	{
		return merge(true, children);
	}

	// Does merge depend on choice/par etc?
	private ReachabilityEnv merge(boolean isChoice, List<ReachabilityEnv> children)
	{
		ReachabilityEnv copy = copy();
		copy.seqable =
				(isChoice)
					? children.stream().filter((e) -> e.seqable).count() > 0
					: children.stream().filter((e) -> !e.seqable).count() == 0;
		children.stream().forEach((e) -> copy.contlabs.addAll(e.contlabs));
		return copy;
	}
	
	// i.e. control flow has the potential to exit from this context
	public boolean isSequenceable()
	{
		return this.seqable && this.contlabs.isEmpty();
	}
	
	public ReachabilityEnv addContinueLabel(RecVar recvar)
	{
		ReachabilityEnv copy = copy();
		copy.seqable = false;
		copy.contlabs.add(recvar);
		return copy;
	}
	
	public ReachabilityEnv removeContinueLabel(RecVar recvar)
	{
		ReachabilityEnv copy = copy();
		copy.contlabs.remove(recvar);
		return copy;
	}
	
	private static List<ReachabilityEnv> castList(List<? extends Env> envs)
	{
		return envs.stream().map((e) -> (ReachabilityEnv) e).collect(Collectors.toList());
	}
}
