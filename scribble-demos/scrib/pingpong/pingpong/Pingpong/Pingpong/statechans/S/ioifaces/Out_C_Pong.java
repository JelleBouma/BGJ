package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;

public interface Out_C_Pong<__Succ extends Succ_Out_C_Pong> {

	abstract public __Succ send(C role, Pong op) throws org.scribble.main.ScribRuntimeException, IOException;
}