package org.scribble.lang.global;

import org.scribble.ast.ScribNode;
import org.scribble.del.global.GDel;
import org.scribble.job.Job;
import org.scribble.job.ScribbleException;
import org.scribble.type.name.ModuleName;
import org.scribble.visit.SimpleVisitor;

// CHECKME: move to visit package?
public class GTypeTranslator extends SimpleVisitor<GType>
{
	public GTypeTranslator(Job job, ModuleName mod)
	{
		super(job, mod);
	}

	@Override
	public GType visit(ScribNode n) throws ScribbleException
	{
		return ((GDel) n.del()).translate(n, this);
	}
}
