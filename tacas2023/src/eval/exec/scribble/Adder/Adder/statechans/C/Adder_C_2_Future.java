package eval.exec.scribble.Adder.Adder.statechans.C;

import eval.exec.scribble.org.scribble.runtime.message.ScribMessage;
import eval.exec.scribble.org.scribble.runtime.util.ScribFuture;

import java.io.IOException;
import java.util.concurrent.CompletableFuture;

public class Adder_C_2_Future extends ScribFuture {
	public Integer pay1;

	protected Adder_C_2_Future(CompletableFuture<ScribMessage> fut) {
		super(fut);
	}

	public Adder_C_2_Future sync() throws IOException {
		ScribMessage m = super.get();
		this.pay1 = (Integer) m.payload[0];
		return this;
	}
}