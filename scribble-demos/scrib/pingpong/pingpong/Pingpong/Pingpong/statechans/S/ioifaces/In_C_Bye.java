package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;

public interface In_C_Bye<__Succ extends Succ_In_C_Bye> {

	abstract public __Succ receive(C role, Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException;
}