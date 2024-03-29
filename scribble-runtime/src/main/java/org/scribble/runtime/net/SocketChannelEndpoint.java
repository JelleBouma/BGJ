/**
 * Copyright 2008 The Scribble Authors
 * This file has been modified by Jelle Bouma
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
package org.scribble.runtime.net;

import java.io.IOException;
import java.net.ConnectException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.util.concurrent.TimeUnit;

import org.scribble.runtime.session.SessionEndpoint;

public class SocketChannelEndpoint extends BinaryChannelEndpoint
{
	//private final SocketChannel s;
	
	//private final ByteBuffer bb = ByteBuffer.allocate(16921);  // FIXME: size
	
	// Server side
	//public SocketChannelEndpoint(MPSTEndpoint<?, ?> se, SocketChannel s) throws IOException
	public SocketChannelEndpoint(SessionEndpoint<?, ?> se, SocketChannel s) throws IOException
	{
		super(se, s);
	}

	// Client side
	public SocketChannelEndpoint()
	{
		
	}
	
	@Override
	//public void initClient(MPSTEndpoint<?, ?> se, String host, int port) throws IOException
	public void initClient(SessionEndpoint<?, ?> se, String host, int port) throws IOException {
		try {
			SocketChannel s = SocketChannel.open(new InetSocketAddress(host, port));
			super.init(se, s);
		}
		catch (ConnectException e) {
			System.out.println("Could not connect to " + host + ":" + port + ", most likely because the receiving endpoint is not running.");
			System.out.println("Retrying in one second.");
			try {
				TimeUnit.SECONDS.sleep(1);
				initClient(se, host, port);
			}
			catch(InterruptedException ex) {
				Thread.currentThread().interrupt();
			}
		}
	}

	@Override
	public SocketChannel getSelectableChannel()
	{
		return (SocketChannel) super.getSelectableChannel();
	}
	
	public void writeBytes(byte[] bs) throws IOException
	{
		getSelectableChannel().write(ByteBuffer.wrap(bs));  // Currently does not depend on SocketChannel
		// flush not supported -- async: manually check if written yet if needed
	}

	@Override
	public synchronized void readBytesIntoBuffer() throws IOException
	{
		/*getSelectableChannel().read(this.bb);  // Pre: bb:put
				// FIXME: what if bb is full?
		ScribMessage m = this.se.smf.fromBytes(this.bb);  // Post: bb:put
		if (m != null)
		{
			enqueue(m);
		}*/
		ByteBuffer bb = (ByteBuffer) getBuffer();
		getSelectableChannel().read(bb);  // Currently does not depend on SocketChannel
		//bb.compact();  // Post: bb:put
	}
	
	@Override
	public void close()
	{
		try
		{
			super.close();
			getSelectableChannel().close();
		}
		catch (IOException e)
		{
			// FIXME: (BinaryChannelEndpoint read will throw exception)
			e.printStackTrace();
		}
	}
}
