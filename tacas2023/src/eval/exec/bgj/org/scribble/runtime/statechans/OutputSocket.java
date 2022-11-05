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
package eval.exec.bgj.org.scribble.runtime.statechans;

import eval.exec.bgj.org.scribble.main.ScribRuntimeException;
import eval.exec.bgj.org.scribble.runtime.message.ScribMessage;
import eval.exec.bgj.org.scribble.runtime.net.BinaryChannelEndpoint;
import eval.exec.bgj.org.scribble.runtime.session.MPSTEndpoint;
import eval.exec.bgj.org.scribble.runtime.session.Session;
import eval.exec.bgj.org.scribble.runtime.session.SessionEndpoint;
import org.scribble.core.type.name.Op;
import org.scribble.core.type.name.Role;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.concurrent.Callable;

public class OutputSocket<S extends Session, R extends Role> extends LinearSocket<S, R>
{
	//protected OutputSocket(MPSTEndpoint<S, R> ep)
	public OutputSocket(SessionEndpoint<S, R> ep)
	{
		super(ep);
	}

	public void writeScribMessage(Role peer, Op op, Object... payload) throws IOException, ScribRuntimeException
	{
		writeScribMessage(peer, new ScribMessage(op, payload));
	}

	protected void writeScribMessage(Role peer, ScribMessage msg) throws IOException, ScribRuntimeException
	{
		use();
		/*SocketEndpoint se = this.ep.getSocketEndpoint(peer);
		se.writeMessageAndFlush(msg);*/
		this.se.getChannelEndpoint(peer).write(msg);
	}

	// FIXME: check if MPST/ExplicitEndpoint
	protected void connect(Role role, Callable<? extends BinaryChannelEndpoint> cons, String host, int port) throws ScribRuntimeException, UnknownHostException, IOException
	{
		use();
		//this.se.connect(role, cons, host, port);
		MPSTEndpoint.request(this.se, role, cons, host, port);
	}

	// FIXME: check if MPST/ExplicitEndpoint
	protected void disconnect(Role role) throws ScribRuntimeException, UnknownHostException, IOException
	{
		use();
		//this.se.disconnect(role);
		MPSTEndpoint.disconnect(this.se, role);
	}
	
	//public void wrap(Callable<? extends BinaryChannelEndpoint> cons, Role role, String host, int port) throws ScribbleRuntimeException, UnknownHostException, IOException

	/*// Right to limit reconnect to send state? Or generalise and manually handle pending incoming messages on old connection? 
	public void reconnect(Callable<? extends BinaryChannelEndpoint> cons, Role role, String host, int port) throws ScribbleRuntimeException, UnknownHostException, IOException
	{
		// Following InitSocket.connect
		use();
		
		...FIXME: close old and make new
		
		try
		{
			BinaryChannelEndpoint c = cons.call();
			c.initClient(se, host, port);
			this.se.reregister(role, c);
		}
		catch (Exception e)
		{
			if (e instanceof IOException)
			{
				throw (IOException) e;
			}
			throw new IOException(e);
		}
	}*/
}
