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
package org.scribble.codegen.java.statechanapi.ioifaces;

import org.scribble.codegen.java.statechanapi.StateChanTypeGen;
import org.scribble.codegen.java.statechanapi.StateChannelApiGenerator;
import org.scribble.core.model.endpoint.EState;

public abstract class IOIfaceGen extends StateChanTypeGen
{
	protected final EState curr;

	public IOIfaceGen(StateChannelApiGenerator apigen, EState curr)
	{
		super(apigen);
		this.curr = curr;
	}
}
