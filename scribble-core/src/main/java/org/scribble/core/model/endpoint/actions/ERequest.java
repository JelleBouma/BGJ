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

import org.scribble.core.model.endpoint.EModelFactory;
import org.scribble.core.model.global.SModelFactory;
import org.scribble.core.model.global.actions.SRequest;
import org.scribble.core.type.name.MessageId;
import org.scribble.core.type.name.Role;
import org.scribble.core.type.session.Payload;

public class ERequest extends EAction
{
	public ERequest(EModelFactory ef, Role peer, MessageId<?> mid, Payload payload)
	//public Connect(Role peer)
	{
		super(ef, peer, mid, payload);
		//super(peer, Op.EMPTY_OPERATOR, Payload.EMPTY_PAYLOAD);
	}
	
	@Override
	public EAccept toDual(Role self)
	{
		//return new Accept(self);
		return this.ef.newEAccept(self, this.mid, this.payload);
	}

	@Override
	public SRequest toGlobal(SModelFactory sf, Role self)
	{
		//return new GConnect(self, this.peer);
		return sf.newSConnect(self, this.peer, this.mid, this.payload);
	}
	
	@Override
	public int hashCode()
	{
		int hash = 929;
		hash = 31 * hash + super.hashCode();
		return hash;
	}
	
	@Override
	public boolean isRequest()
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
		if (!(o instanceof ERequest))
		{
			return false;
		}
		return ((ERequest) o).canEqual(this) && super.equals(o);
	}

	@Override
	public boolean canEqual(Object o)
	{
		return o instanceof ERequest;
	}

	@Override
	protected String getCommSymbol()
	{
		return "!!";
	}
}
