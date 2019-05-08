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
package http.shortvers;

import static http.shortvers.HttpShort.Http.Http.C;
import static http.shortvers.HttpShort.Http.Http.RESPONSE;
import static http.shortvers.HttpShort.Http.Http.S;

import org.scribble.runtime.util.Buf;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.net.SocketChannelEndpoint;

import http.shortvers.HttpShort.Http.Http;
import http.shortvers.HttpShort.Http.statechans.C.Http_C_1;
import http.shortvers.HttpShort.Http.roles.C;
import http.shortvers.message.HttpShortMessageFormatter;
import http.shortvers.message.client.Request;
import http.shortvers.message.server.Response;

public class HttpShortC
{
	public HttpShortC() throws Exception
	{
		run();
	}

	public static void main(String[] args) throws Exception
	{
		new HttpShortC();
	}

	public void run() throws Exception
	{
		Http http = new Http();
		try (MPSTEndpoint<Http, C> client = new MPSTEndpoint<>(http, C, new HttpShortMessageFormatter()))
		{
			//String host = "www.doc.ic.ac.uk";  int port = 80;  String file = "/~rhu/";
			//String host = "example.com";  int port = 80;  String file = "/";
			String host = "localhost"; int port = 8080;  String file = "/";
		
			client.request(S, SocketChannelEndpoint::new, host, port);
			
			Buf<Response> buf = new Buf<>();
			new Http_C_1(client)
				.send(S, new Request(file, "1.1", host))
				.receive(S, RESPONSE, buf);
			
			System.out.println("Response:\n" + buf.val);
		}
	}
}
