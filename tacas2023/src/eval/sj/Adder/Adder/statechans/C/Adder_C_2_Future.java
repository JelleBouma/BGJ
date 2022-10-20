package eval.sj.Adder.Adder.statechans.C;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

public class Adder_C_2_Future extends eval.sj.org.scribble.runtime.util.ScribFuture {
	public Integer pay1;

	protected Adder_C_2_Future(CompletableFuture<eval.sj.org.scribble.runtime.message.ScribMessage> fut) {
		super(fut);
	}

	public Adder_C_2_Future sync() throws IOException {
		eval.sj.org.scribble.runtime.message.ScribMessage m = super.get();
		this.pay1 = (Integer) m.payload[0];
		return this;
	}
}