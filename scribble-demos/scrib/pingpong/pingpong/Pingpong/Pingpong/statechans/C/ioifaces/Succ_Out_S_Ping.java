package pingpong.Pingpong.Pingpong.statechans.C.ioifaces;

public interface Succ_Out_S_Ping {

	default Receive_C_S_Pong<?> to(Receive_C_S_Pong<?> cast) {
		return (Receive_C_S_Pong<?>) this;
	}
}