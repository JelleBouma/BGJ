package eval.exec.bgj;

import eval.exec.bgj.Adder.Adder.concr.AdderC;

public class Client {

    public static void main(String[] args) throws Exception {
        long duration = args.length == 1 ? Long.parseLong(args[0]) : 0;
        client(new AdderC("localhost", 8888), duration);
    }

    public static void client(AdderC a, long duration) throws Exception {
        duration = duration == 0 ? Integer.MAX_VALUE : duration;
        long start = -1;
        for (long i = 0; i < duration; i++) {
            a.addToS(5, 6);
            a.resFromS();
            start = start == -1 ? System.currentTimeMillis() : start;
        }
        System.out.println(System.currentTimeMillis() - start);

        a.byeToS();
    }
}
