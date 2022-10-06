package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;

public interface Out_S_Bye<__Succ extends Succ_Out_S_Bye> {

	abstract public __Succ send(S role, Bye op) throws org.scribble.main.ScribRuntimeException, IOException;
}