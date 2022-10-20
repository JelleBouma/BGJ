package eval.sj.Adder.Adder.statechans.C;

import eval.sj.Adder.Adder.Adder;
import eval.sj.Adder.Adder.roles.C;
import eval.sj.Adder.Adder.statechans.C.ioifaces.Succ_Out_S_Bye;

public final class EndSocket extends eval.sj.org.scribble.runtime.statechans.EndSocket<Adder, C> implements Succ_Out_S_Bye {
	public static final EndSocket cast = null;

	protected EndSocket(eval.sj.org.scribble.runtime.session.SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	@Override
	public EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}