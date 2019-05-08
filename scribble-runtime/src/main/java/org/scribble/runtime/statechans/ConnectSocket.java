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
package org.scribble.runtime.statechans;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.concurrent.Callable;

import org.scribble.core.type.name.Role;
import org.scribble.main.ScribRuntimeException;
import org.scribble.runtime.net.BinaryChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.session.Session;

@Deprecated
public abstract class ConnectSocket<S extends Session, R extends Role> extends LinearSocket<S, R>
{
	protected ConnectSocket(MPSTEndpoint<S, R> ep)
	{
		super(ep);
	}

	/*public void connect(Role role, String host, int port) throws ScribbleRuntimeException, UnknownHostException, IOException
	{
		use();
		Socket s = new Socket(host, port);
		this.ep.register(role, new SocketWrapper(s));
	}*/

	protected void connect(Role role, Callable<? extends BinaryChannelEndpoint> cons, String host, int port) throws ScribRuntimeException, UnknownHostException, IOException
	{
		use();
		//this.se.connect(role, cons, host, port);
	}
}
