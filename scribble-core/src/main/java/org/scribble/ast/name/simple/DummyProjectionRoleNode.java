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
package org.scribble.ast.name.simple;

import org.antlr.runtime.Token;
import org.scribble.type.name.Role;
import org.scribble.visit.Substitutor;

// For local choice subjects
public class DummyProjectionRoleNode extends RoleNode
{
	public static final String DUMMY_PROJECTION_ROLE = "__DUMMY_ROLE";

	// ScribTreeAdaptor#create constructor
	public DummyProjectionRoleNode(Token t)
	{
		super(t);
	}

	// Tree#dupNode constructor
	protected DummyProjectionRoleNode(DummyProjectionRoleNode node, String id)
	{
		super(node, id);
	}
	
	@Override
	public RoleNode dupNode()
	{
		return new RoleNode(this, getIdentifier());
	}

	@Override
	protected DummyProjectionRoleNode reconstruct(String id)
	{
		return (DummyProjectionRoleNode) super.reconstruct(id);
	}
	
	@Override
	public DummyProjectionRoleNode substituteNames(Substitutor subs)
	{
		//throw new RuntimeException("Shouldn't get in here: " + this);
		return reconstruct(null);  // HACK: for ProjectedSubprotocolPruner, but maybe useful for others
	}
	
	@Override
	public Role toName()
	{
		return new Role(getIdentifier());
	}

	@Override
	public boolean equals(Object o)
	{
		if (this == o)
		{
			return true;
		}
		if (!(o instanceof DummyProjectionRoleNode))
		{
			return false;
		}
		return ((DummyProjectionRoleNode) o).canEqual(this) && super.equals(o);
	}
	
	@Override
	public boolean canEqual(Object o)
	{
		return o instanceof DummyProjectionRoleNode;
	}
	
	@Override
	public int hashCode()
	{
		int hash = 359;
		hash = 31 * super.hashCode();
		return hash;
	}
	
	
	
	
	
	
	
	
	
	
	public DummyProjectionRoleNode()
	{
		super(null, DUMMY_PROJECTION_ROLE);
	}

	/*@Override
	protected DummyProjectionRoleNode copy()
	{
		return new DummyProjectionRoleNode();
	}
	
	@Override
	public DummyProjectionRoleNode clone(AstFactory af)
	{
		return af.DummyProjectionRoleNode();
	}*/

	/*@Override
	protected DummyProjectionRoleNode reconstruct(String id)
	{
		ScribDel del = del();
		DummyProjectionRoleNode rn = new DummyProjectionRoleNode();
		rn = (DummyProjectionRoleNode) rn.del(del);
		return rn;
	}*/
}
