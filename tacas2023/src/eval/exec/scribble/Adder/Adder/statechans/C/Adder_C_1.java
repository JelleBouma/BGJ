package eval.exec.scribble.Adder.Adder.statechans.C;

import eval.exec.scribble.Adder.Adder.roles.S;
import eval.exec.scribble.org.scribble.main.ScribRuntimeException;
import eval.exec.scribble.org.scribble.runtime.session.MPSTEndpoint;
import eval.exec.scribble.org.scribble.runtime.session.SessionEndpoint;
import eval.exec.scribble.org.scribble.runtime.statechans.OutputSocket;
import eval.exec.scribble.Adder.Adder.Adder;
import eval.exec.scribble.Adder.Adder.ops.Add;
import eval.exec.scribble.Adder.Adder.ops.Bye;
import eval.exec.scribble.Adder.Adder.roles.C;
import eval.exec.scribble.Adder.Adder.statechans.C.ioifaces.Select_C_S_Add_Int_Int__S_Bye;

import java.io.IOException;

public final class Adder_C_1 extends OutputSocket<Adder, C> implements Select_C_S_Add_Int_Int__S_Bye<Adder_C_2, EndSocket> {
	public static final Adder_C_1 cast = null;

	protected Adder_C_1(SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	public Adder_C_1(MPSTEndpoint<Adder, C> se) throws ScribRuntimeException {
		super(se);
		se.init();
	}

	public Adder_C_2 send(S role, Add op, Integer arg0, Integer arg1) throws ScribRuntimeException, IOException {
		//super.writeScribMessage(role, Adder.Add, arg0, arg1);

		return new Adder_C_2(this.se, true);
	}

	public EndSocket send(S role, Bye op) throws ScribRuntimeException, IOException {
		//super.writeScribMessage(role, Adder.Bye);

		this.se.setCompleted();
		return new EndSocket(this.se, true);
	}
}