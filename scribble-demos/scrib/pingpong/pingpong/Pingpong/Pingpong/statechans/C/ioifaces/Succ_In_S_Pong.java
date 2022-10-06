package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

public interface Succ_In_S_Pong {

	default Select_C_S_Bye__S_Ping<?, ?> to(Select_C_S_Bye__S_Ping<?, ?> cast) {
		return (Select_C_S_Bye__S_Ping<?, ?>) this;
	}
}