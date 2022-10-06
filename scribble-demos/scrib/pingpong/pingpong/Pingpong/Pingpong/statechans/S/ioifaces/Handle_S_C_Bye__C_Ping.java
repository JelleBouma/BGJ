package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import pingpong.Pingpong.Pingpong.ops.*;

public interface Handle_S_C_Bye__C_Ping<__Succ1 extends Succ_In_C_Bye, __Succ2 extends Succ_In_C_Ping> extends Callback_C_Bye<__Succ1>, Callback_C_Ping<__Succ2> {

	abstract public void receive(__Succ1 schan, Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	abstract public void receive(__Succ2 schan, Ping op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;
}