package pingpong.Pingpong.Pingpong.statechans.C;

import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.C.ioifaces.*;

public final class Pingpong_C_2 extends org.scribble.runtime.statechans.ReceiveSocket<Pingpong, C> implements Receive_C_S_Pong<Pingpong_C_1> {
	public static final Pingpong_C_2 cast = null;

	protected Pingpong_C_2(org.scribble.runtime.session.SessionEndpoint<Pingpong, C> se, boolean dummy) {
		super(se);
	}

	public Pingpong_C_1 receive(S role, Pong op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		super.readScribMessage(Pingpong.S);
		return new Pingpong_C_1(this.se, true);
	}

	public Pingpong_C_1 async(S role, Pong op, org.scribble.runtime.util.Buf<Pingpong_C_2_Future> arg) throws org.scribble.main.ScribRuntimeException {
		arg.val = new Pingpong_C_2_Future(super.getFuture(Pingpong.S));
		return new Pingpong_C_1(this.se, true);
	}

	public boolean isDone() {
		return super.isDone(Pingpong.S);
	}

	@SuppressWarnings("unchecked")
	public Pingpong_C_1 async(S role, Pong op) throws org.scribble.main.ScribRuntimeException {
		return async(Pingpong.S, op, (org.scribble.runtime.util.Buf<Pingpong_C_2_Future>) this.se.gc);
	}
}