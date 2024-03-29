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
package eval.exec.scribble.org.scribble.runtime.handlers.states;

import org.scribble.core.type.name.Op;

import java.util.HashMap;
import java.util.Map;

abstract public class ScribState
{
	public final String name;

	//public final Map<Op, ScribState> succs = new HashMap<>(); // FIXME
	public final Map<Op, String> succs = new HashMap<>();

	public ScribState(String name)
	{
		this.name = name;
	}
	
	@Override
	public String toString()
	{
		return this.name;
	}
	
	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof ScribState))
		{
			return false;
		}
		ScribState n = (ScribState) o;
		return n.canEqual(this) && this.name.equals(n.name);
	}
	
	protected abstract boolean canEqual(Object o);

	@Override
	public int hashCode()
	{
		int hash = 7907;
		hash = 31 * hash + this.name.hashCode();
		return hash;
	}
}
