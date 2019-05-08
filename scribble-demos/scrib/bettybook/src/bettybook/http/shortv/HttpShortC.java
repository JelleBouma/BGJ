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
package bettybook.http.shortv;

import static bettybook.http.shortv.HttpShort.Http.Http.C;
import static bettybook.http.shortv.HttpShort.Http.Http.Resp;
import static bettybook.http.shortv.HttpShort.Http.Http.S;

import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.util.Buf;

import bettybook.http.shortv.HttpShort.Http.Http;
import bettybook.http.shortv.HttpShort.Http.roles.C;
import bettybook.http.shortv.HttpShort.Http.statechans.C.Http_C_1;
import bettybook.http.shortv.message.HttpShortMessageFormatter;
import bettybook.http.shortv.message.client.Req;
import bettybook.http.shortv.message.server.Resp;

public class HttpShortC {

	public static void main(String[] args) throws Exception
	{
		Http http = new Http();
		try (MPSTEndpoint<Http, C> client = new MPSTEndpoint<>(http, C,
				new HttpShortMessageFormatter()))
		{
			String host = "www.doc.ic.ac.uk";  int port = 80;  String file = "/~rhu/";
			//String host = "example.com";  int port = 80;  String file = "/";
			//String host = "localhost"; int port = 8080;  String file = "/";

			client.request(S, SocketChannelEndpoint::new, host, port);
			new HttpShortC().run(client, host, file);
		}
	}

	private void run(MPSTEndpoint<Http, C> client, String host, String file) throws Exception
	{
		Buf<Resp> buf = new Buf<>();
		Http_C_1 c = new Http_C_1(client);


		c.send(S, new Req(file, "1.1", host))
		 .receive(S, Resp, buf);
		

		System.out.println("Response:\n" + buf.val);
	}
}

