package eval.sj.Adder.Adder.statechans.C.ioifaces;

import eval.sj.Adder.Adder.ops.Bye;
import eval.sj.Adder.Adder.roles.S;

import java.io.IOException;

public interface Out_S_Bye<__Succ extends Succ_Out_S_Bye> {

	abstract public __Succ send(S role, Bye op) throws eval.sj.org.scribble.main.ScribRuntimeException, IOException;
}