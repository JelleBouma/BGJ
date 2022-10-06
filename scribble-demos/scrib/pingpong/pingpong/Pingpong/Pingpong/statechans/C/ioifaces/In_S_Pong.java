package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;

public interface In_S_Pong<__Succ extends Succ_In_S_Pong> {

	abstract public __Succ receive(S role, Pong op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;
}