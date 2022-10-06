package pingpong.Pingpong.Pingpong.statechans.S;

import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.S.ioifaces.*;

public interface Pingpong_S_1_Handler extends Handle_S_C_Bye__C_Ping<EndSocket, Pingpong_S_2> {

	@Override
	abstract public void receive(Pingpong_S_2 schan, Ping op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;

	@Override
	abstract public void receive(EndSocket schan, Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;
}