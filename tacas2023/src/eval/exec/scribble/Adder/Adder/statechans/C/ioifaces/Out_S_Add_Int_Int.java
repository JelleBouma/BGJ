package eval.exec.scribble.Adder.Adder.statechans.C.ioifaces;

import eval.exec.scribble.Adder.Adder.ops.Add;
import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;

import java.io.IOException;

public interface Out_S_Add_Int_Int<__Succ extends Succ_Out_S_Add_Int_Int> {

	abstract public __Succ send(S role, Add op, Integer arg0, Integer arg1) throws ScribRuntimeException, IOException;
}