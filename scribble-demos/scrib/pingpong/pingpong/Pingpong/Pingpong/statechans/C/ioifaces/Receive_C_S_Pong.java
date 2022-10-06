package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.C.*;

public interface Receive_C_S_Pong<__Succ1 extends Succ_In_S_Pong> extends In_S_Pong<__Succ1>, Succ_Out_S_Ping {
	public static final Receive_C_S_Pong<?> cast = null;

	abstract public __Succ1 async(S role, Pong op) throws org.scribble.main.ScribRuntimeException;

	@Override
	default Receive_C_S_Pong<?> to(Receive_C_S_Pong<?> cast) {
		return (Receive_C_S_Pong<?>) this;
	}

	default Pingpong_C_2 to(Pingpong_C_2 cast) {
		return (Pingpong_C_2) this;
	}
}