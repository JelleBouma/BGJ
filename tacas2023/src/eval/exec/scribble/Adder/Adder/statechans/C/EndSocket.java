package eval.exec.scribble.Adder.Adder.statechans.C;

import eval.exec.scribble.org.scribble.runtime.session.SessionEndpoint;
import eval.exec.scribble.Adder.Adder.Adder;
import eval.exec.scribble.Adder.Adder.roles.C;
import eval.exec.scribble.Adder.Adder.statechans.C.ioifaces.Succ_Out_S_Bye;

public final class EndSocket extends eval.exec.scribble.org.scribble.runtime.statechans.EndSocket<Adder, C> implements Succ_Out_S_Bye {
	public static final EndSocket cast = null;

	protected EndSocket(SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	@Override
	public EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}