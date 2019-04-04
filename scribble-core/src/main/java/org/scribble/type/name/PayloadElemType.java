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
package org.scribble.type.name;

import org.scribble.type.kind.PayloadTypeKind;
import org.scribble.type.session.Arg;


public interface PayloadElemType<K extends PayloadTypeKind> extends Arg<K>
{
	default boolean isDataType()
	{
		return false;
	}

	default boolean isGDelegationType()
	{
		return false;
	}
	
	/*public boolean isLDelegationType()  // Not currently used
	{
		return true;
	}*/
}
