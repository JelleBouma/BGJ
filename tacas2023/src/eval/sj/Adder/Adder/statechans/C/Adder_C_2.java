package eval.sj.Adder.Adder.statechans.C;

import eval.sj.Adder.Adder.Adder;
import eval.sj.Adder.Adder.ops.Res;
import eval.sj.Adder.Adder.roles.C;
import eval.sj.Adder.Adder.roles.S;
import eval.sj.Adder.Adder.statechans.C.ioifaces.Receive_C_S_Res_Int;

public final class Adder_C_2 extends eval.sj.org.scribble.runtime.statechans.ReceiveSocket<Adder, C> implements Receive_C_S_Res_Int<Adder_C_1> {
	public static final Adder_C_2 cast = null;

	protected Adder_C_2(eval.sj.org.scribble.runtime.session.SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	public Adder_C_1 receive(S role, Res op, eval.sj.org.scribble.runtime.util.Buf<? super Integer> arg1) throws eval.sj.org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		//org.scribble.runtime.message.ScribMessage m = super.readScribMessage(Adder.S);
		//arg1.val = (java.lang.Integer) m.payload[0];
		arg1.val = -1;
		return new Adder_C_1(this.se, true);
	}

	public Adder_C_1 async(S role, Res op, eval.sj.org.scribble.runtime.util.Buf<Adder_C_2_Future> arg) throws eval.sj.org.scribble.main.ScribRuntimeException {
		arg.val = new Adder_C_2_Future(super.getFuture(Adder.S));
		return new Adder_C_1(this.se, true);
	}

	public boolean isDone() {
		return super.isDone(Adder.S);
	}

	@SuppressWarnings("unchecked")
	public Adder_C_1 async(S role, Res op) throws eval.sj.org.scribble.main.ScribRuntimeException {
		return async(Adder.S, op, (eval.sj.org.scribble.runtime.util.Buf<Adder_C_2_Future>) this.se.gc);
	}
}