package eval.sj.Adder.Adder.statechans.C.ioifaces;

import eval.sj.Adder.Adder.statechans.C.Adder_C_1;

public interface Select_C_S_Add_Int_Int__S_Bye<__Succ1 extends Succ_Out_S_Add_Int_Int, __Succ2 extends Succ_Out_S_Bye> extends Out_S_Add_Int_Int<__Succ1>, Out_S_Bye<__Succ2>, Succ_In_S_Res_Int {
	public static final Select_C_S_Add_Int_Int__S_Bye<?, ?> cast = null;

	@Override
	default Select_C_S_Add_Int_Int__S_Bye<?, ?> to(Select_C_S_Add_Int_Int__S_Bye<?, ?> cast) {
		return (Select_C_S_Add_Int_Int__S_Bye<?, ?>) this;
	}

	default Adder_C_1 to(Adder_C_1 cast) {
		return (Adder_C_1) this;
	}
}