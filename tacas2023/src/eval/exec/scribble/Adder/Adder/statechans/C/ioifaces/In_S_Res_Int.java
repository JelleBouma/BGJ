package eval.exec.scribble.Adder.Adder.statechans.C.ioifaces;

import eval.exec.scribble.Adder.Adder.ops.Res;
import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;
import eval.exec.scribble.org.scribble.runtime.util.Buf;

import java.io.IOException;

public interface In_S_Res_Int<__Succ extends Succ_In_S_Res_Int> {

	abstract public __Succ receive(S role, Res op, Buf<? super Integer> arg1) throws ScribRuntimeException, IOException, ClassNotFoundException;
}