package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.C.*;

public interface Select_C_S_Bye__S_Ping<__Succ1 extends Succ_Out_S_Bye, __Succ2 extends Succ_Out_S_Ping> extends Out_S_Bye<__Succ1>, Out_S_Ping<__Succ2>, Succ_In_S_Pong {
	public static final Select_C_S_Bye__S_Ping<?, ?> cast = null;

	@Override
	default Select_C_S_Bye__S_Ping<?, ?> to(Select_C_S_Bye__S_Ping<?, ?> cast) {
		return (Select_C_S_Bye__S_Ping<?, ?>) this;
	}

	default Pingpong_C_1 to(Pingpong_C_1 cast) {
		return (Pingpong_C_1) this;
	}
}