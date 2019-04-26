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
package org.scribble.core.type.name;

import org.scribble.core.type.kind.RoleKind;


public class Role extends AbstractName<RoleKind>  // CHECKME: type.name package has no SimpleName
{
	public static final Role EMPTY_ROLE = new Role();
	public static final Role SELF = new Role("self");  // TODO Factor out constant

	private static final long serialVersionUID = 1L;

	protected Role()
	{
		super(RoleKind.KIND);
	}

	public Role(String text)
	{
		super(RoleKind.KIND, text);
	}

	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof Role))
		{
			return false;
		}
		Role n = (Role) o;
		return n.canEquals(this) && super.equals(o);
	}
	
	public boolean canEquals(Object o)
	{
		return o instanceof Role;
	}

	@Override
	public int hashCode()
	{
		int hash = 2741;
		hash = 31 * super.hashCode();
		return hash;
	}
}
