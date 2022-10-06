package pingpong.Pingpong.Pingpong.statechans.S;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.S.ioifaces.*;

public final class Pingpong_S_2 extends org.scribble.runtime.statechans.OutputSocket<Pingpong, S> implements Select_S_C_Pong<Pingpong_S_1> {
	public static final Pingpong_S_2 cast = null;

	protected Pingpong_S_2(org.scribble.runtime.session.SessionEndpoint<Pingpong, S> se, boolean dummy) {
		super(se);
	}

	public Pingpong_S_1 send(C role, Pong op) throws org.scribble.main.ScribRuntimeException, IOException {
		super.writeScribMessage(role, Pingpong.Pong);

		return new Pingpong_S_1(this.se, true);
	}
}