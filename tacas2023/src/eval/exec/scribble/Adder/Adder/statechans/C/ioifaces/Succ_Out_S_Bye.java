package eval.exec.scribble.Adder.Adder.statechans.C.ioifaces;

import eval.exec.scribble.Adder.Adder.statechans.C.EndSocket;

public interface Succ_Out_S_Bye {

	default EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}