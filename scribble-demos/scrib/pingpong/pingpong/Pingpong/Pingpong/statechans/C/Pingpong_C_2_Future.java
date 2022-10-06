package pingpong.Pingpong.Pingpong.statechans.C;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

public class Pingpong_C_2_Future extends org.scribble.runtime.util.ScribFuture {

	protected Pingpong_C_2_Future(CompletableFuture<org.scribble.runtime.message.ScribMessage> fut) {
		super(fut);
	}

	public Pingpong_C_2_Future sync() throws IOException {
		super.get();
		return this;
	}
}