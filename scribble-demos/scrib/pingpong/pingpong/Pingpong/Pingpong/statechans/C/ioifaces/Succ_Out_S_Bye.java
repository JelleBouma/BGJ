package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

import pingpong.Pingpong.Pingpong.statechans.C.EndSocket;

public interface Succ_Out_S_Bye {

	default EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}