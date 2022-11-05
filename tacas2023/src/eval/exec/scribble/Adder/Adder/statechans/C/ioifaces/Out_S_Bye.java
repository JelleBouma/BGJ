package eval.exec.scribble.Adder.Adder.statechans.C.ioifaces;

import eval.exec.scribble.Adder.Adder.ops.Bye;
import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;

import java.io.IOException;

public interface Out_S_Bye<__Succ extends Succ_Out_S_Bye> {

	abstract public __Succ send(S role, Bye op) throws ScribRuntimeException, IOException;
}