package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.S.*;

public interface Select_S_C_Pong<__Succ1 extends Succ_Out_C_Pong> extends Out_C_Pong<__Succ1>, Succ_In_C_Ping {
	public static final Select_S_C_Pong<?> cast = null;

	@Override
	default Select_S_C_Pong<?> to(Select_S_C_Pong<?> cast) {
		return (Select_S_C_Pong<?>) this;
	}

	default Pingpong_S_2 to(Pingpong_S_2 cast) {
		return (Pingpong_S_2) this;
	}
}