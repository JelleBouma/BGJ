package eval.sj.Adder.Adder.statechans.C.ioifaces;

import eval.sj.Adder.Adder.ops.Res;
import eval.sj.Adder.Adder.roles.S;
import eval.sj.Adder.Adder.statechans.C.Adder_C_2;

public interface Receive_C_S_Res_Int<__Succ1 extends Succ_In_S_Res_Int> extends In_S_Res_Int<__Succ1>, Succ_Out_S_Add_Int_Int {
	public static final Receive_C_S_Res_Int<?> cast = null;

	abstract public __Succ1 async(S role, Res op) throws eval.sj.org.scribble.main.ScribRuntimeException;

	@Override
	default Receive_C_S_Res_Int<?> to(Receive_C_S_Res_Int<?> cast) {
		return (Receive_C_S_Res_Int<?>) this;
	}

	default Adder_C_2 to(Adder_C_2 cast) {
		return (Adder_C_2) this;
	}
}