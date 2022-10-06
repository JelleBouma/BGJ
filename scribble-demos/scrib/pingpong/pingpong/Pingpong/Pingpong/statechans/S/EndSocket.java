package pingpong.Pingpong.Pingpong.statechans.S;

import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.S.ioifaces.*;

public final class EndSocket extends org.scribble.runtime.statechans.EndSocket<Pingpong, S> implements Succ_In_C_Bye {
	public static final EndSocket cast = null;

	protected EndSocket(org.scribble.runtime.session.SessionEndpoint<Pingpong, S> se, boolean dummy) {
		super(se);
	}

	@Override
	public EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}