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
package org.scribble.model.endpoint;

import org.scribble.model.endpoint.actions.EAction;
import org.scribble.model.global.SModelFactory;
import org.scribble.model.global.actions.SAction;
import org.scribble.type.name.Op;
import org.scribble.type.name.RecVar;
import org.scribble.type.name.Role;
import org.scribble.type.session.Payload;

// FIXME rename better (it's an "external rec" continue edge)
@Deprecated
class IntermediateRecEdge extends EAction
{
	public final EAction action;
	
	public IntermediateRecEdge(EModelFactory ef, EAction a, RecVar rv)
	{
		super(ef, Role.EMPTY_ROLE, new Op(rv.toString()), Payload.EMPTY_PAYLOAD);  // HACK
		this.action = a;
	}
	
	@Override
	public EAction toDual(Role self)
	{
		throw new RuntimeException("Shouldn't get in here: " + this);
	}

	@Override
	public SAction toGlobal(SModelFactory sf, Role self)
	{
		throw new RuntimeException("Shouldn't get in here: " + this);
	}

	@Override
	protected String getCommSymbol()
	{
		return "&";
	}
	
	@Override
	public int hashCode()
	{
		int hash = 6037;
		hash = 31 * hash + super.hashCode();
		return hash;
	}

	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof IntermediateRecEdge))
		{
			return false;
		}
		return ((IntermediateRecEdge) o).canEqual(this) && super.equals(o);
	}

	@Override
	public boolean canEqual(Object o)
	{
		return o instanceof IntermediateRecEdge;
	}
}
