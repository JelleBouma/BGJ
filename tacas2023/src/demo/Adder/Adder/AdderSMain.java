package demo.Adder.Adder;

import demo.Adder.Adder.concr.*;

public class AdderSMain
{
	static AdderS adderS;
	
	//@ requires Perm(adderS, 1);
	//@ requires args != null && args.length >= 1;
	//@ requires Perm(args[0], 1);
	public static void main(String[] args) throws Exception
	{
		setup(Utilities.parseInt(args[0]));
		adderS();
	}
	
	//@ context Perm(adderS, 1);
	//@ ensures Perm(adderS.state, 1);
	//@ ensures Perm(adderS.choice, 1);
	//@ ensures Perm(adderS.EXTERNAL_CHOICE_ADD, 1);
	//@ ensures Perm(adderS.EXTERNAL_CHOICE_BYE, 1);
	//@ ensures adderS.state == 14 && adderS.choice == -1 && adderS.EXTERNAL_CHOICE_ADD == 0 && adderS.EXTERNAL_CHOICE_BYE == 1;
	public static void setup(int port) throws Exception
	{
		adderS = new AdderS(port);
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
	public static void adderS() throws Exception
	{
		int externalChoice;
		externalChoice = adderS.receiveExternalChoice();
		if (externalChoice == adderS.EXTERNAL_CHOICE_ADD)
		{
			adderS.addFromC();
			adderS.resToC(0);
			adderS();
		}
		else 
		{
			adderS.byeFromC();
		}
	}
}
