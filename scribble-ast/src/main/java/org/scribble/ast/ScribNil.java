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
package org.scribble.ast;

import org.antlr.runtime.Token;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.del.DelFactory;

public class ScribNil extends ScribNodeBase
{
	// Used by (Scrib)TreeAdapator
	public ScribNil()
	{
		super((Token) null);  // CHECKME: null Token
	}

	// Copy constructor
	protected ScribNil(CommonTree node)
	{
		super((ScribNodeBase) node);
	}

	@Override
	public ScribNodeBase dupNode()
	{
		return new ScribNil(this);  // CHECKME: nil can have children(?), so may need to actually copy
	}

	@Override
	public void decorateDel(DelFactory df)
	{
		throw new RuntimeException("Shouldn't get in here: ");
	}
}
