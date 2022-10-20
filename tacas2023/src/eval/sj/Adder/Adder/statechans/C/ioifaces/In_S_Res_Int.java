package eval.sj.Adder.Adder.statechans.C.ioifaces;

import eval.sj.Adder.Adder.ops.Res;
import eval.sj.Adder.Adder.roles.S;

import java.io.IOException;

public interface In_S_Res_Int<__Succ extends Succ_In_S_Res_Int> {

	abstract public __Succ receive(S role, Res op, eval.sj.org.scribble.runtime.util.Buf<? super Integer> arg1) throws eval.sj.org.scribble.main.ScribRuntimeException, IOException, ClassNotFoundException;
}