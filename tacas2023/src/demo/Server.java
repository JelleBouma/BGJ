package demo;

public class Server {

    public static void main(String[] args) throws Exception {
        server(new demo.Adder.Adder.concr.AdderS(8888));
    }

    //@ context Perm(adderS, 1);
    //@ context Perm(adderS.state, 1);
    //@ context Perm(adderS.choice, 1);
    //@ context Perm(adderS.EXTERNAL_CHOICE_ADD, 1);
    //@ context Perm(adderS.EXTERNAL_CHOICE_BYE, 1);
    //@ requires adderS.state == 14;
    //@ requires adderS.EXTERNAL_CHOICE_ADD == 0;
    //@ requires adderS.EXTERNAL_CHOICE_BYE == 1;
    //@ requires adderS.choice == -1;
    //@ ensures adderS.choice == -1;
    //@ ensures adderS.state == 15;
    public static void server(demo.Adder.Adder.concr.AdderS a) throws Exception {
        int choice = a.receiveExternalChoice();
        if (choice == a.EXTERNAL_CHOICE_ADD) {
            demo.Adder.Adder.concr.AddPayload pay = a.addFromC();
            a.resToC(pay.arg0 + pay.arg1);
            server(a);
        } else {
            a.byeFromC();
        }
    }
}
