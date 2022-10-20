package eval.sj.Adder.Adder.statechans.C.ioifaces;

import eval.sj.Adder.Adder.ops.Add;
import eval.sj.Adder.Adder.roles.S;

import java.io.IOException;

public interface Out_S_Add_Int_Int<__Succ extends Succ_Out_S_Add_Int_Int> {

	abstract public __Succ send(S role, Add op, Integer arg0, Integer arg1) throws eval.sj.org.scribble.main.ScribRuntimeException, IOException;
}