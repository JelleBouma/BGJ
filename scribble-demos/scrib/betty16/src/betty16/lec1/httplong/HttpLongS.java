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
package betty16.lec1.httplong;

import static betty16.lec1.httplong.HttpLong.Http.Http.ACCEPT;
import static betty16.lec1.httplong.HttpLong.Http.Http.ACCEPTE;
import static betty16.lec1.httplong.HttpLong.Http.Http.ACCEPTL;
import static betty16.lec1.httplong.HttpLong.Http.Http.BODY;
import static betty16.lec1.httplong.HttpLong.Http.Http.C;
import static betty16.lec1.httplong.HttpLong.Http.Http.CONNECTION;
import static betty16.lec1.httplong.HttpLong.Http.Http.COOKIE;
import static betty16.lec1.httplong.HttpLong.Http.Http.DNT;
import static betty16.lec1.httplong.HttpLong.Http.Http.HOST;
import static betty16.lec1.httplong.HttpLong.Http.Http.REQUESTL;
import static betty16.lec1.httplong.HttpLong.Http.Http.S;
import static betty16.lec1.httplong.HttpLong.Http.Http.UPGRADEIR;
import static betty16.lec1.httplong.HttpLong.Http.Http.USERA;

import java.io.IOException;

import org.scribble.main.ScribRuntimeException;
import org.scribble.runtime.net.ScribServerSocket;
import org.scribble.runtime.net.SocketChannelServer;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.util.Buf;

import betty16.lec1.httplong.HttpLong.Http.Http;
import betty16.lec1.httplong.HttpLong.Http.roles.S;
import betty16.lec1.httplong.HttpLong.Http.statechans.S.EndSocket;
import betty16.lec1.httplong.HttpLong.Http.statechans.S.Http_S_1;
import betty16.lec1.httplong.HttpLong.Http.statechans.S.Http_S_2;
import betty16.lec1.httplong.HttpLong.Http.statechans.S.Http_S_2_Cases;
import betty16.lec1.httplong.message.Body;
import betty16.lec1.httplong.message.HttpLongMessageFormatter;
import betty16.lec1.httplong.message.server.ContentLength;
import betty16.lec1.httplong.message.server.HttpVersion;
import betty16.lec1.httplong.message.server._200;


/** TODO:
 * Cannot parse header field: Pragma: no-cache
 *         at betty16.lec1.httplong.message.HttpLongMessageFormatter.fromBytes(HttpLongMessageFormatter.java:197)
 *
 * java.lang.RuntimeException: Cannot parse header field: Cache-Control: max-age=0
 *         at betty16.lec1.httplong.message.HttpLongMessageFormatter.fromBytes(HttpLongMessageFormatter.java:197) 
 */

public class HttpLongS
{
	public static void main(String[] args) throws Exception
	{
		try (ScribServerSocket ss = new SocketChannelServer(8080)) {
			while (true)	{
				Http http = new Http();
				try (MPSTEndpoint<Http, S> server = new MPSTEndpoint<>(http, S,
						new HttpLongMessageFormatter())) {
					server.accept(ss, C);
				
					run(new Http_S_1(server));
				}
				catch (IOException | ClassNotFoundException
						| ScribRuntimeException e)
				{
					e.printStackTrace();
				}
			}
		}
	}
	
	private static EndSocket run(Http_S_1 s1)
			throws ClassNotFoundException, ScribRuntimeException, IOException {
		Buf<Object> buf = new Buf<>();
		
		Http_S_2 s2 = s1.receive(C, REQUESTL, buf);
		System.out.println("Requested: " + buf.val);
		
		while (true) {
			Http_S_2_Cases cases = s2.branch(C);
			switch (cases.op) {
				case ACCEPT:  s2 = cases.receive(ACCEPT, buf); break;
				case ACCEPTE: s2 = cases.receive(ACCEPTE, buf); break;
				case ACCEPTL: s2 = cases.receive(ACCEPTL, buf); break;
				case BODY:
				{
					String body = "<html><body>Hello, World!</body></html>";
					return
						cases.receive(BODY, buf)
							.send(C, new HttpVersion("1.1"))
							.send(C, new _200("OK"))
							.send(C, new ContentLength(body.length()))
							.send(C, new Body(body));
				}
				case CONNECTION: s2 = cases.receive(CONNECTION, buf); break;
				case DNT:        s2 = cases.receive(DNT, buf); break;
				case UPGRADEIR:  s2 = cases.receive(UPGRADEIR, buf); break;
				case COOKIE:     s2 = cases.receive(COOKIE, buf); break;
				case HOST:       s2 = cases.receive(HOST, buf); break;
				case USERA:      s2 = cases.receive(USERA, buf); break;
			}
		}
	}
}
