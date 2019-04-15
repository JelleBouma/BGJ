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
package org.scribble.core.model.endpoint.actions;

import org.scribble.core.model.ModelFactory;
import org.scribble.core.model.global.actions.SAccept;
import org.scribble.core.type.name.MsgId;
import org.scribble.core.type.name.Role;
import org.scribble.core.type.session.Payload;

public class EAccept extends EAction
{
	public EAccept(ModelFactory ef, Role peer, MsgId<?> mid, Payload payload)
	//public Accept(Role peer)
	{
		super(ef, peer, mid, payload);
		//super(peer, Op.EMPTY_OPERATOR, Payload.EMPTY_PAYLOAD);
	}
	
	@Override
	public ERequest toDual(Role self)
	{
		//return new Connect(self);
		return this.ef.newERequest(self, this.mid, this.payload);
	}

	@Override
	public SAccept toGlobal(ModelFactory sf, Role self)
	{
		return sf.newSAccept(self, this.peer, this.mid, this.payload);
		//return new GAccept(self, this.peer);
	}
	
	@Override
	public int hashCode()
	{
		int hash = 937;
		hash = 31 * hash + super.hashCode();
		return hash;
	}
	
	@Override
	public boolean isAccept()
	{
		return true;
	}

	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof EAccept))
		{
			return false;
		}
		return ((EAccept) o).canEqual(this) && super.equals(o);
	}

	public boolean canEqual(Object o)
	{
		return o instanceof EAccept;
	}

	@Override
	protected String getCommSymbol()
	{
		return "??";
	}
}
