package pingpong.Pingpong.Pingpong.statechans.S.ioifaces;

public interface Succ_In_C_Ping {

	default Select_S_C_Pong<?> to(Select_S_C_Pong<?> cast) {
		return (Select_S_C_Pong<?>) this;
	}
}