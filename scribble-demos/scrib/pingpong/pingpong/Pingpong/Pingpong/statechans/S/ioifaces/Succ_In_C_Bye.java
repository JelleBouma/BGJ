package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

import pingpong.Pingpong.Pingpong.statechans.S.EndSocket;

public interface Succ_In_C_Bye {

	default EndSocket to(EndSocket cast) {
		return (EndSocket) this;
	}
}