package demo.Adder.Adder.abstr;

public class Client {

    //@ requires args != null ** args.length == 2 ** Perm(args[0], 1) ** Perm(args[1], 1);
    public static void main(String[] args) throws Exception {
        client(new AdderC(args[0], Utilities.parseInt(args[1])));
    }

    //@ context_everywhere Perm(a.state, 1);
    //@ requires a.state == 5;
    //@ ensures a.state == 6;
    public static void client(AdderC a) throws Exception {
        int x = 1;
        int y = 2;
        //@ loop_invariant a.state == 5;
        while (x + y < 100) {
            a.addToS(x, y);
            // a.addToS(x, y); // <- compile-time error
            x = y;
            y = a.resFromS();
        }
        a.byeToS();
    }
}
