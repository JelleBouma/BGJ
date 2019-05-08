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
//$ java -cp modules/cli/target/classes/';'modules/core/target/classes';'modules/trace/target/classes';'modules/parser/target/classes';c:\Users\Raymond\.m2\repository\org\antlr\antlr-runtime\3.2\antlr-runtime-3.2.jar;'modules/validation/target/classes/';'modules/projection/target/classes/';C:\Users\Raymond\.m2\repository\org\codehaus\jackson\jackson-mapper-asl\1.9.9\jackson-mapper-asl-1.9.9.jar;C:\Users\Raymond\.m2\repository\org\codehaus\jackson\jackson-core-asl\1.9.9\jackson-core-asl-1.9.9.jar' org.scribble2.cli.CommandLine -path modules/validation/src/test/scrib/src modules/validation/src/test/scrib/src/Test.scr -session Foo -d modules/validation/src/main/java
//$ java -cp modules/cli/target/classes/';'modules/core/target/classes';'modules/trace/target/classes';'modules/parser/target/classes';c:\Users\Raymond\.m2\repository\org\antlr\antlr-runtime\3.2\antlr-runtime-3.2.jar;'modules/validation/target/classes/';'modules/projection/target/classes/';C:\Users\Raymond\.m2\repository\org\codehaus\jackson\jackson-mapper-asl\1.9.9\jackson-mapper-asl-1.9.9.jar;C:\Users\Raymond\.m2\repository\org\codehaus\jackson\jackson-core-asl\1.9.9\jackson-core-asl-1.9.9.jar' org.scribble2.cli.CommandLine -path modules/validation/src/test/scrib/src modules/validation/src/test/scrib/src/Test.scr -api Foo A -d modules/validation/src/main/java

package fib;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.concurrent.ExecutionException;

import org.scribble.main.ScribRuntimeException;
import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.util.Buf;

import fib.Fib.Adder.Adder;
import fib.Fib.Adder.roles.C;
import fib.Fib.Adder.statechans.C.Adder_C_1;
import fib.Fib.Adder.statechans.C.ioifaces.Receive_C_S_BYE;
import fib.Fib.Adder.statechans.C.ioifaces.Receive_C_S_RES_Int;
import fib.Fib.Adder.statechans.C.ioifaces.Select_C_S_ADD_Int_Int__S_BYE;
import fib.Fib.Adder.statechans.C.ioifaces.Succ_Out_S_BYE;


public class AdderClient
{
	public static void main(String[] args)
			throws UnknownHostException, ScribRuntimeException, IOException,
			ClassNotFoundException, ExecutionException, InterruptedException
	{
		Buf<Integer> i1 = new Buf<>(1);
		//Buf<Integer> i2 = new Buf<>(2);

		Adder adder = new Adder();
		try (MPSTEndpoint<Adder, C> se = new MPSTEndpoint<>(adder, Adder.C,
				new ObjectStreamFormatter()))
		{	
			se.request(Adder.S, SocketChannelEndpoint::new, "localhost", 8888);

			Adder_C_1 s1 = new Adder_C_1(se);

			/*s1.send(Adder.S, Adder.ADD, i1.val, i1.val)
				.receive(Adder.S, Adder.RES, i1)
				.send(Adder.S, Adder.ADD, i1.val, i1.val)
				.receive(Adder.S, Adder.RES, i1)
				.send(Adder.S, Adder.BYE)
				.receive(Adder.S, Adder.BYE);*/
			
			/*while (i1.val < 100)
			{
				s1 = s1.send(Adder.S, Adder.ADD, i1.val, i1.val).receive(Adder.S, Adder.RES, i1);
			}
			s1.send(Adder.S, Adder.BYE).receive(Adder.S, Adder.BYE)
				.end();*/

			//fib(i1, i2, s1).end();
			
			foo(s1, i1).to(Receive_C_S_BYE.cast).receive(Adder.S, Adder.BYE);
			//foo(s1, i1);
			
			System.out.println("Client: " + i1.val);
		}
	}
	
	private static Succ_Out_S_BYE foo(Select_C_S_ADD_Int_Int__S_BYE<?, ?> s, Buf<Integer> i) throws ClassNotFoundException, ScribRuntimeException, IOException
	//private static EndSocket foo(Select_C_S_ADD_Integer_Integer__S_BYE<?, ?> s, Buf<Integer> i) throws ClassNotFoundException, ScribRuntimeException, IOException
	{
		return (i.val < 100)
				? foo(
						s.send(Adder.S, Adder.ADD, i.val, i.val)
						 .to(Receive_C_S_RES_Int.cast)
						 .receive(Adder.S, Adder.RES, i)
						 .to(Select_C_S_ADD_Int_Int__S_BYE.cast)
					, i)
				: s.send(Adder.S, Adder.BYE);
	}

	/*private static EndSocket<Adder, C> fib(Buf<Integer> i1, Buf<Integer> i2, Adder_C_1 s1) throws ScribRuntimeException, IOException, ClassNotFoundException, ExecutionException, InterruptedException
	{
		return (i1.val < 100)
				? fib(i1, i2,
							side(i1, i2, s1.send(Adder.S, Adder.ADD, i1.val, i2.val)).receive(Adder.S, Adder.RES, i2)
					   )
				: s1.send(Adder.S, Adder.BYE).receive(Adder.S, Adder.BYE);
	}
	
	private static Adder_C_2 side(Buf<Integer> i1, Buf<Integer> i2, Adder_C_2 s2)
	{
		i1.val = i2.val;
		System.out.print(i1.val + " ");
		return s2;
	}*/
}
