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
package eval.sj.Adder.Adder;

import eval.sj.Adder.Adder.roles.C;
import eval.sj.Adder.Adder.statechans.C.Adder_C_1;
import eval.sj.Adder.Adder.statechans.C.Adder_C_2;
import eval.sj.Adder.Adder.statechans.C.EndSocket;
import eval.sj.org.scribble.runtime.message.ObjectStreamFormatter;
import eval.sj.org.scribble.runtime.session.MPSTEndpoint;
import eval.sj.org.scribble.runtime.util.Buf;

public class AdderCMain {

	public static void main(String[] args) throws Exception {
		long duration = args.length == 1 ? Long.parseLong(args[0]) : 0;
		Adder adder = new Adder();
		try (MPSTEndpoint<Adder, C> client =
					new MPSTEndpoint<>(adder, Adder.C, new ObjectStreamFormatter())) {
			client(new Adder_C_1(client), duration);
		}
	}

	private static EndSocket client(Adder_C_1 c1, long duration) throws Exception {
//		long n = 0;
//		long deadline = Long.MAX_VALUE;
//		while (System.currentTimeMillis() < deadline) {
//			Adder_C_2 c2 = c1.send(S, Add, 5, 6);
//			Buf<Integer> buf = new Buf<>();
//			c1 = c2.receive(S, Res, buf);
//			n++;
//			deadline = deadline == Long.MAX_VALUE ? System.currentTimeMillis() + duration : deadline;
//		}
//		System.err.println(n);

		duration = duration == 0 ? Integer.MAX_VALUE : duration;
		long start = -1;
		for (long i = 0; i < duration; i++) {
			Adder_C_2 c2 = c1.send(Adder.S, Adder.Add, 5, 6);
			Buf<Integer> buf = new Buf<>();
			c1 = c2.receive(Adder.S, Adder.Res, buf);
			start = start == -1 ? System.currentTimeMillis() : start;
		}
		System.out.println(System.currentTimeMillis() - start);

		EndSocket c3 = c1.send(Adder.S, Adder.Bye);
		return c3;
	}
}
