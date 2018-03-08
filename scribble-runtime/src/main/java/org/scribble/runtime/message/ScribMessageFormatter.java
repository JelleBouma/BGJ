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
package org.scribble.runtime.message;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;

public interface ScribMessageFormatter
{
	//byte[] toBytes(ScribMessage m) throws IOException;
	@Deprecated
	void writeMessage(DataOutputStream dos, ScribMessage m) throws IOException;
	@Deprecated
	ScribMessage readMessage(DataInputStream dis) throws IOException;
	
	byte[] toBytes(ScribMessage m) throws IOException;

  // Pre and post: bb:put (maybe get would be more intuitive, but Buffers work better with put as default)
	// Returns null if not enough data (FIXME?)
	ScribMessage fromBytes(ByteBuffer bb) throws IOException, ClassNotFoundException;
}
