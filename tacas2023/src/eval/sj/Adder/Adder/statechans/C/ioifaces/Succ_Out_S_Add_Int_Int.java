package eval.sj.Adder.Adder.statechans.C.ioifaces;

public interface Succ_Out_S_Add_Int_Int {

	default Receive_C_S_Res_Int<?> to(Receive_C_S_Res_Int<?> cast) {
		return (Receive_C_S_Res_Int<?>) this;
	}
}