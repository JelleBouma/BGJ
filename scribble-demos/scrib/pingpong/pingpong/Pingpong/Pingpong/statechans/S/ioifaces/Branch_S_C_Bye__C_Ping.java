package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.S.*;

public interface Branch_S_C_Bye__C_Ping<__Succ1 extends Succ_In_C_Bye, __Succ2 extends Succ_In_C_Ping> extends Succ_Out_C_Pong {
	public static final Branch_S_C_Bye__C_Ping<?, ?> cast = null;

	abstract Case_S_C_Bye__C_Ping<__Succ1, __Succ2> branch(C role) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	abstract void branch(C role, Handle_S_C_Bye__C_Ping<__Succ1, __Succ2> handler) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	abstract void handle(C role, Handle_S_C_Bye__C_Ping<Succ_In_C_Bye, Succ_In_C_Ping> handler) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	@Override
	default Branch_S_C_Bye__C_Ping<?, ?> to(Branch_S_C_Bye__C_Ping<?, ?> cast) {
		return (Branch_S_C_Bye__C_Ping<?, ?>) this;
	}

	default Pingpong_S_1 to(Pingpong_S_1 cast) {
		return (Pingpong_S_1) this;
	}

public enum Branch_S_C_Bye__C_Ping_Enum implements org.scribble.runtime.session.OpEnum {
	Ping, Bye
}
}