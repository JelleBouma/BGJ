package pingpong.Pingpong.Pingpong.statechans.S;

import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.S.ioifaces.*;

public final class Pingpong_S_1_Cases extends org.scribble.runtime.statechans.CaseSocket<Pingpong, S> implements Case_S_C_Bye__C_Ping<EndSocket, Pingpong_S_2> {
	public static final Pingpong_S_1_Cases cast = null;
	public final Pingpong_S_1.Branch_S_C_Bye__C_Ping_Enum op;
	private final org.scribble.runtime.message.ScribMessage m;

	protected Pingpong_S_1_Cases(org.scribble.runtime.session.SessionEndpoint<Pingpong, S> se, boolean dummy, Pingpong_S_1.Branch_S_C_Bye__C_Ping_Enum op, org.scribble.runtime.message.ScribMessage m) {
		super(se);
		this.op = op;
		this.m = m;
	}

	public Pingpong_S_2 receive(C role, Ping op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		super.use();
		if (!this.m.op.equals(Pingpong.Ping)) {
			throw new org.scribble.main.ScribRuntimeException("Wrong branch, received: " + this.m.op);
		}
		return new Pingpong_S_2(this.se, true);
	}

	public Pingpong_S_2 receive(Ping op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		return receive(Pingpong.C, op);
	}

	public pingpong.Pingpong.Pingpong.statechans.S.EndSocket receive(C role, Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		super.use();
		if (!this.m.op.equals(Pingpong.Bye)) {
			throw new org.scribble.main.ScribRuntimeException("Wrong branch, received: " + this.m.op);
		}
		this.se.setCompleted();
		return new EndSocket(this.se, true);
	}

	public pingpong.Pingpong.Pingpong.statechans.S.EndSocket receive(Bye op) throws org.scribble.main.ScribRuntimeException, java.io.IOException, ClassNotFoundException {
		return receive(Pingpong.C, op);
	}

	@Override
	public Branch_S_C_Bye__C_Ping.Branch_S_C_Bye__C_Ping_Enum getOp() {
		return this.op;
	}
}