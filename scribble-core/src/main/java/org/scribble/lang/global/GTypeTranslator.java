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
package org.scribble.lang.global;

import org.scribble.ast.ScribNode;
import org.scribble.del.global.GDel;
import org.scribble.job.Job;
import org.scribble.job.ScribbleException;
import org.scribble.type.name.ModuleName;
import org.scribble.type.session.global.GType;
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
	
	/*// sig is the for the current innermost proto
	public RecVar makeRecVar(SubprotoSig sig)
	{
		String lab = "__" + sig.fullname + "__"
				+ sig.roles.stream().map(x -> x.toString())
						.collect(Collectors.joining("_"))
				+ "__" + sig.args.stream().map(x -> x.toString())
						.collect(Collectors.joining("_"));
		return new RecVar(lab);
	}

	public RecVar makeRecVar(SubprotoSig sig, RecVar rv)
	{
		return new RecVar(makeRecVar(sig).toString() + "__" + rv);
	}*/
}
