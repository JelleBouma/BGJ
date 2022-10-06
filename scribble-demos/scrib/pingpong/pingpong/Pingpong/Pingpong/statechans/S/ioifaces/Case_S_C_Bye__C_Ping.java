package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import pingpong.Pingpong.Pingpong.ops.*;

public interface Case_S_C_Bye__C_Ping<__Succ1 extends Succ_In_C_Bye, __Succ2 extends Succ_In_C_Ping> extends In_C_Bye<__Succ1>, In_C_Ping<__Succ2> {
	public static final Branch_S_C_Bye__C_Ping<?, ?> cast = null;

	abstract Branch_S_C_Bye__C_Ping.Branch_S_C_Bye__C_Ping_Enum getOp();

	abstract public pingpong.Pingpong.Pingpong.statechans.S.EndSocket receive(Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	abstract public __Succ2 receive(Ping op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;
}