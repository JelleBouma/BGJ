package pingpong.Pingpong.Pingpong.statechans.S;

import java.io.IOException;
import pingpong.Pingpong.Pingpong.*;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.statechans.S.ioifaces.*;

public final class Pingpong_S_1 extends org.scribble.runtime.statechans.BranchSocket<Pingpong, S> implements Branch_S_C_Bye__C_Ping<EndSocket, Pingpong_S_2> {
	public static final Pingpong_S_1 cast = null;

	protected Pingpong_S_1(org.scribble.runtime.session.SessionEndpoint<Pingpong, S> se, boolean dummy) {
		super(se);
	}

	public Pingpong_S_1(org.scribble.runtime.session.MPSTEndpoint<Pingpong, S> se) throws org.scribble.main.ScribRuntimeException {
		super(se);
		se.init();
	}

	@Override
	public Pingpong_S_1_Cases branch(C role) throws org.scribble.main.ScribRuntimeException, IOException, ClassNotFoundException {
		org.scribble.runtime.message.ScribMessage m = super.readScribMessage(Pingpong.C);
		Branch_S_C_Bye__C_Ping_Enum openum;
		if (m.op.equals(Pingpong.Ping)) {
			openum = Branch_S_C_Bye__C_Ping_Enum.Ping;
		}
		else if (m.op.equals(Pingpong.Bye)) {
			openum = Branch_S_C_Bye__C_Ping_Enum.Bye;
		}
		else {
			throw new RuntimeException("Won't get here: " + m.op);
		}
		return new Pingpong_S_1_Cases(this.se, true, openum, m);
	}

	public void branch(C role, Pingpong_S_1_Handler handler) throws org.scribble.main.ScribRuntimeException, IOException, ClassNotFoundException {
		branch(role, (Handle_S_C_Bye__C_Ping<EndSocket, Pingpong_S_2>) handler);
	}

	@Override
	public void branch(C role, Handle_S_C_Bye__C_Ping<EndSocket, Pingpong_S_2> handler) throws org.scribble.main.ScribRuntimeException, IOException, ClassNotFoundException {
		org.scribble.runtime.message.ScribMessage m = super.readScribMessage(Pingpong.C);
		if (m.op.equals(Pingpong.Ping)) {
			handler.receive(new Pingpong_S_2(this.se, true), Pingpong.Ping);
		}
		else
		if (m.op.equals(Pingpong.Bye)) {
			this.se.setCompleted();
			handler.receive(new EndSocket(this.se, true), Pingpong.Bye);
		}
		else {
			throw new RuntimeException("Won't get here: " + m.op);
		}
	}

	@Override
	public void handle(C role, Handle_S_C_Bye__C_Ping<Succ_In_C_Bye, Succ_In_C_Ping> handler) throws org.scribble.main.ScribRuntimeException, IOException, ClassNotFoundException {
		org.scribble.runtime.message.ScribMessage m = super.readScribMessage(Pingpong.C);
		if (m.op.equals(Pingpong.Ping)) {
			handler.receive(new Pingpong_S_2(this.se, true), Pingpong.Ping);
		}
		else
		if (m.op.equals(Pingpong.Bye)) {
			this.se.setCompleted();
			handler.receive(new EndSocket(this.se, true), Pingpong.Bye);
		}
		else {
			throw new RuntimeException("Won't get here: " + m.op);
		}
	}
}