package pingpong.Pingpong.Pingpong.statechans.C;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.C.ioifaces.*;

public final class Pingpong_C_1 extends org.scribble.runtime.statechans.OutputSocket<Pingpong, C> implements Select_C_S_Bye__S_Ping<EndSocket, Pingpong_C_2> {
	public static final Pingpong_C_1 cast = null;

	protected Pingpong_C_1(org.scribble.runtime.session.SessionEndpoint<Pingpong, C> se, boolean dummy) {
		super(se);
	}

	public Pingpong_C_1(org.scribble.runtime.session.MPSTEndpoint<Pingpong, C> se) throws org.scribble.main.ScribRuntimeException {
		super(se);
		se.init();
	}

	public Pingpong_C_2 send(S role, Ping op) throws org.scribble.main.ScribRuntimeException, IOException {
		super.writeScribMessage(role, Pingpong.Ping);

		return new Pingpong_C_2(this.se, true);
	}

	public pingpong.Pingpong.Pingpong.statechans.C.EndSocket send(S role, Bye op) throws org.scribble.main.ScribRuntimeException, IOException {
		super.writeScribMessage(role, Pingpong.Bye);

		this.se.setCompleted();
		return new EndSocket(this.se, true);
	}
}