package pingpong.Pingpong.Pingpong.statechans.C;

import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.C.ioifaces.*;

public final class EndSocket extends org.scribble.runtime.statechans.EndSocket<Pingpong, C> implements Succ_Out_S_Bye {
	public static final EndSocket cast = null;

	protected EndSocket(org.scribble.runtime.session.SessionEndpoint<Pingpong, C> se, boolean dummy) {
		super(se);
	}

	@Override
	public EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}