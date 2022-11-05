package eval.exec.scribble.Adder.Adder.statechans.C;

import eval.exec.scribble.Adder.Adder.Adder;
import eval.exec.scribble.Adder.Adder.ops.Res;
import eval.exec.scribble.Adder.Adder.roles.C;
import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;
import eval.exec.scribble.org.scribble.runtime.session.SessionEndpoint;
import eval.exec.scribble.org.scribble.runtime.statechans.ReceiveSocket;
import eval.exec.scribble.org.scribble.runtime.util.Buf;
import eval.exec.scribble.Adder.Adder.statechans.C.ioifaces.Receive_C_S_Res_Int;

public final class Adder_C_2 extends ReceiveSocket<Adder, C> implements Receive_C_S_Res_Int<Adder_C_1> {
	public static final Adder_C_2 cast = null;

	protected Adder_C_2(SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	public Adder_C_1 receive(S role, Res op, Buf<? super Integer> arg1) throws ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		//org.scribble.runtime.message.ScribMessage m = super.readScribMessage(Adder.S);
		//arg1.val = (java.lang.Integer) m.payload[0];
		arg1.val = -1;
		return new Adder_C_1(this.se, true);
	}

	public Adder_C_1 async(S role, Res op, Buf<Adder_C_2_Future> arg) throws ScribRuntimeException {
		arg.val = new Adder_C_2_Future(super.getFuture(Adder.S));
		return new Adder_C_1(this.se, true);
	}

	public boolean isDone() {
		return super.isDone(Adder.S);
	}

	@SuppressWarnings("unchecked")
	public Adder_C_1 async(S role, Res op) throws ScribRuntimeException {
		return async(Adder.S, op, (Buf<Adder_C_2_Future>) this.se.gc);
	}
}