package demo;

import demo.Adder.Adder.concr.AddPayload;
import demo.Adder.Adder.concr.AdderS;
import demo.Adder.Adder.concr.Utilities;

public class Server {

    //@ requires args != null ** args.length == 1 ** Perm(args[0], 1);
    public static void main(String[] args) throws Exception {
        server(new AdderS(Utilities.parseInt(args[0])));
    }

    //@ context_everywhere Perm(a.state, 1);
    //@ context_everywhere Perm(a.choice, 1);
    //@ context_everywhere Perm(a.EXTERNAL_CHOICE_ADD, 1);
    //@ context_everywhere Perm(a.EXTERNAL_CHOICE_BYE, 1);
    //@ requires a.choice == -1;
    //@ requires a.EXTERNAL_CHOICE_ADD == 0;
    //@ requires a.EXTERNAL_CHOICE_BYE == 1;
    //@ requires a.state == 14;
    //@ ensures a.state == 15;
    public static void server(AdderS a) throws Exception {
        int choice = a.receiveExternalChoice();
        if (choice == a.EXTERNAL_CHOICE_ADD) {
            AddPayload pay = a.addFromC();
            a.resToC(pay.arg0 + pay.arg1);
            server(a);
        } else {
            a.byeFromC();
        }
    }
}
