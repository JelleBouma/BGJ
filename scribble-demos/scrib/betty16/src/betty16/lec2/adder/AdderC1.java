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
package betty16.lec2.adder;

import static betty16.lec2.adder.Adder.Adder.Adder.Add;
import static betty16.lec2.adder.Adder.Adder.Adder.Bye;
import static betty16.lec2.adder.Adder.Adder.Adder.C;
import static betty16.lec2.adder.Adder.Adder.Adder.Res;
import static betty16.lec2.adder.Adder.Adder.Adder.S;

import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.util.Buf;

import betty16.lec2.adder.Adder.Adder.Adder;
import betty16.lec2.adder.Adder.Adder.roles.C;
import betty16.lec2.adder.Adder.Adder.statechans.C.Adder_C_1;

public class AdderC1 {

	public static void main(String[] args) throws Exception {
		Adder adder = new Adder();
		try (MPSTEndpoint<Adder, C> client = new MPSTEndpoint<>(adder, C,
				new ObjectStreamFormatter())) {
			client.request(S, SocketChannelEndpoint::new, "localhost", 8888);
			System.out.println("C: " + new AdderC1().run(client));
		}
	}
	
	private int run(MPSTEndpoint<Adder, C> client) throws Exception {
		Buf<Integer> i = new Buf<>(1);

		new Adder_C_1(client)
			.send(S, Add, i.val, i.val)
			.receive(S, Res, i)
			.send(S, Add, i.val, i.val)
			.receive(S, Res, i)
			.send(S, Bye).receive(S, Bye);

		return i.val;
	}
}
