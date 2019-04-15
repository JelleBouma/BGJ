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
import org.scribble.ast.global.GRecursion;
import org.scribble.core.type.name.RecVar;
import org.scribble.core.type.session.global.GSeq;
import org.scribble.del.RecursionDel;
import org.scribble.util.ScribException;
import org.scribble.visit.GTypeTranslator;

public class GRecursionDel extends RecursionDel
		implements GCompoundSessionNodeDel
{
	
	@Override
	public org.scribble.core.type.session.global.GRecursion translate(ScribNode n,
			GTypeTranslator t) throws ScribException
	{
		GRecursion source = (GRecursion) n;
		RecVar recvar = source.getRecVarChild().toName();
		GSeq block = (GSeq) source.getBlockChild().visitWith(t);
		return new org.scribble.core.type.session.global.GRecursion(source, recvar, block);
	}
}
