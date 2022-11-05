package eval.exec.scribble;

import eval.exec.scribble.Adder.Adder.Adder;
import eval.exec.scribble.Adder.Adder.roles.C;
import eval.exec.scribble.Adder.Adder.statechans.C.Adder_C_1;
import eval.exec.scribble.Adder.Adder.statechans.C.EndSocket;
import eval.exec.scribble.org.scribble.runtime.message.ObjectStreamFormatter;
import eval.exec.scribble.org.scribble.runtime.util.Buf;
import eval.exec.scribble.Adder.Adder.statechans.C.Adder_C_2;
import eval.exec.scribble.org.scribble.runtime.session.MPSTEndpoint;

public class Client {

    public static void main(String[] args) throws Exception {
        long duration = args.length == 1 ? Long.parseLong(args[0]) : 0;
        Adder adder = new Adder();
        try (MPSTEndpoint<Adder, C> client =
                     new MPSTEndpoint<>(adder, Adder.C, new ObjectStreamFormatter())) {
            client(new Adder_C_1(client), duration);
        }
    }

    private static EndSocket client(Adder_C_1 c1, long duration) throws Exception {
        duration = duration == 0 ? Integer.MAX_VALUE : duration;
        long start = -1;
        for (long i = 0; i < duration; i++) {
            Adder_C_2 c2 = c1.send(Adder.S, Adder.Add, 5, 6);
            Buf<Integer> buf = new Buf<>();
            c1 = c2.receive(Adder.S, Adder.Res, buf);
            start = start == -1 ? System.currentTimeMillis() : start;
        }
        System.out.println(System.currentTimeMillis() - start);

        EndSocket c3 = c1.send(Adder.S, Adder.Bye);
        return c3;
    }
}
