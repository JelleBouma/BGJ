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
package eval.exec.bgj.org.scribble.runtime.handlers;

import org.scribble.core.type.name.Op;
import org.scribble.core.type.name.Role;

// FIXME: make interface and add to bounds of output icallback -- cf. CBEndpointApiGenerator
// FIXME: not serializable due to RoleKind (in Role)
public interface ScribOutputEvent
{
	Role getPeer();
	Op getOp();
	Object[] getPayload();
}
