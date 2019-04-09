package org.scribble.core.visit;

import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.antlr.runtime.tree.CommonTree;
import org.scribble.core.job.Job;
import org.scribble.core.lang.SubprotoSig;
import org.scribble.core.type.kind.ProtocolKind;
import org.scribble.core.type.name.RecVar;
import org.scribble.core.type.session.Continue;
import org.scribble.core.type.session.Recursion;
import org.scribble.core.type.session.SType;
import org.scribble.core.type.session.Seq;

public abstract class STypeInliner<K extends ProtocolKind, B extends Seq<K, B>>
		extends STypeVisitor<K, B>
{
	public final Job job;
	
	// Basically, "SubprotocolVisitor" -- factor out?
	private final Deque<SubprotoSig> stack = new LinkedList<>();

  // To handle recvar shadowing in nested recs
	private Map<RecVar, Deque<RecVar>> recvars = new HashMap<>();
	private Map<RecVar, Integer> counter = new HashMap<>();

	private final Map<RecVar, Seq<K, ?>> recs = new HashMap<>(); 

	public STypeInliner(Job job)
	{
		this.job = job;
	}

	@Override
	public SType<K, B> visitContinue(Continue<K, B> n)
	{
		RecVar rv = getInlinedRecVar(n.recvar);
		return n.reconstruct(n.getSource(), rv);
	}

	@Override
	public SType<K, B> visitRecursion(Recursion<K, B> n)
	{
		CommonTree source = n.getSource();  // CHECKME: or empty source?
		RecVar rv = enterRec(n.recvar);  // FIXME: make GTypeInliner, and record recvars to check freshness (e.g., rec X in two choice cases)
		B body = n.body.visitWith(this);//, stack);
		Recursion<K, B> res = n.reconstruct(source, rv, body);
		exitRec(n.recvar);
		return res;
	}

	@Override
	public B visitSeq(B n)
	{
		List<SType<K, B>> elems = new LinkedList<>();
		for (SType<K, B> e : n.elems)
		{
			SType<K, B> e1 = e.visitWith(this);
			if (e1 instanceof Seq<?, ?>)
			{
				elems.addAll(((Seq<K, B>) e1).elems);
			}
			else
			{
				elems.add(e1);
			}
		}
		return n.reconstruct(n.getSource(), elems);
	}

	public void pushRec(RecVar rv, Seq<K, ?> body)
	{
		if (this.recs.containsKey(rv))
		{
			throw new RuntimeException("Shouldn't get here: " + rv);
		}
		this.recs.put(rv, body);
	}

	public boolean hasRec(RecVar rv)
	{
		return this.recs.containsKey(rv);
	}
	
	public Seq<K, ?> getRec(RecVar rv)
	{
		return this.recs.get(rv);
	}
	
	public void popRec(RecVar rv)
	{
		this.recs.remove(rv);
	}

	public void pushSig(SubprotoSig sig)
	{
		if (this.stack.contains(sig))
		{
			throw new RuntimeException("Shouldn't get here: " + sig);
		}
		this.stack.push(sig);
	}

	public SubprotoSig peek()
	{
		return this.stack.peek();
	}

	public boolean hasSig(SubprotoSig sig)
	{
		return this.stack.contains(sig);
	}
	
	public void popSig()
	{
		this.stack.pop();
	}
	
	// For Protocol/Do -- sig is for the current innermost proto (but not implicitly peek() for G/LDo convenience)
	public RecVar getInlinedRecVar(SubprotoSig sig)
	{
		String lab = "__" + sig.fullname.toString().replaceAll("\\.", "_") + "__"
				+ sig.roles.stream().map(x -> x.toString())
						.collect(Collectors.joining("_"))
				+ "__" + sig.args.stream().map(x -> x.toString())
						.collect(Collectors.joining("_"));
		return new RecVar(lab);
	}
	
	public RecVar enterRec(//SubprotoSig sig, 
			RecVar rv)
	{
		String text = getInlinedRecVar(this.stack.peek()) + "__" + rv;
		if (this.counter.containsKey(rv))
		{
			int i = this.counter.get(rv) + 1;
			text += "_" + i;
			this.counter.put(rv, i);
		}
		else
		{
			this.counter.put(rv, 0);
		}
		RecVar res = new RecVar(text);
		Deque<RecVar> tmp = this.recvars.get(rv);
		if (tmp == null)
		{
			tmp = new LinkedList<>();
			this.recvars.put(rv, tmp);
		}
		tmp.push(res);
		return res;
	}
	
	// For Continue
	public RecVar getInlinedRecVar(RecVar rv)
	{
		return this.recvars.get(rv).peek();
	}
	
	public void exitRec(RecVar rv)
	{
		this.recvars.get(rv).pop();
	}
}
