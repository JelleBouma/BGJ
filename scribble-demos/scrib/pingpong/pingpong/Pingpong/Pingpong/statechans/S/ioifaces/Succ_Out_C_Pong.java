package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

public interface Succ_Out_C_Pong {

	default Branch_S_C_Bye__C_Ping<?, ?> to(Branch_S_C_Bye__C_Ping<?, ?> cast) {
		return (Branch_S_C_Bye__C_Ping<?, ?>) this;
	}
}