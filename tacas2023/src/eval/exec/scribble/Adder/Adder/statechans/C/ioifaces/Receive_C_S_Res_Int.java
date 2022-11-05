package eval.exec.scribble.Adder.Adder.statechans.C.ioifaces;

import eval.exec.scribble.Adder.Adder.ops.Res;
import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.Adder.Adder.statechans.C.Adder_C_2;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;

public interface Receive_C_S_Res_Int<__Succ1 extends Succ_In_S_Res_Int> extends In_S_Res_Int<__Succ1>, Succ_Out_S_Add_Int_Int {
	public static final Receive_C_S_Res_Int<?> cast = null;

	abstract public __Succ1 async(S role, Res op) throws ScribRuntimeException;

	@Override
	default Receive_C_S_Res_Int<?> to(Receive_C_S_Res_Int<?> cast) {
		return (Receive_C_S_Res_Int<?>) this;
	}

	default Adder_C_2 to(Adder_C_2 cast) {
		return (Adder_C_2) this;
	}
}