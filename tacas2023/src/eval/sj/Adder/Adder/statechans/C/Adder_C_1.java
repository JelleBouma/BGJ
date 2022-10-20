package eval.sj.Adder.Adder.statechans.C;

import eval.sj.Adder.Adder.Adder;
import eval.sj.Adder.Adder.ops.Add;
import eval.sj.Adder.Adder.ops.Bye;
import eval.sj.Adder.Adder.roles.C;
import eval.sj.Adder.Adder.roles.S;
import eval.sj.Adder.Adder.statechans.C.ioifaces.Select_C_S_Add_Int_Int__S_Bye;

import java.io.IOException;

public final class Adder_C_1 extends eval.sj.org.scribble.runtime.statechans.OutputSocket<Adder, C> implements Select_C_S_Add_Int_Int__S_Bye<Adder_C_2, EndSocket> {
	public static final Adder_C_1 cast = null;

	protected Adder_C_1(eval.sj.org.scribble.runtime.session.SessionEndpoint<Adder, C> se, boolean dummy) {
		super(se);
	}

	public Adder_C_1(eval.sj.org.scribble.runtime.session.MPSTEndpoint<Adder, C> se) throws eval.sj.org.scribble.main.ScribRuntimeException {
		super(se);
		se.init();
	}

	public Adder_C_2 send(S role, Add op, Integer arg0, Integer arg1) throws eval.sj.org.scribble.main.ScribRuntimeException, IOException {
		//super.writeScribMessage(role, Adder.Add, arg0, arg1);

		return new Adder_C_2(this.se, true);
	}

	public EndSocket send(S role, Bye op) throws eval.sj.org.scribble.main.ScribRuntimeException, IOException {
		//super.writeScribMessage(role, Adder.Bye);

		this.se.setCompleted();
		return new EndSocket(this.se, true);
	}
}