package demo.Adder.Adder;

import demo.Adder.Adder.concr.*;

public class AdderCMain
{
	static AdderC adderC;
	
	//@ requires Perm(adderC, 1);
	//@ requires args != null && args.length >= 2;
	//@ requires Perm(args[0], 1);
	//@ requires Perm(args[1], 1);
	public static void main(String[] args) throws Exception
	{
		setup(args[0], Utilities.parseInt(args[1]));
		adderC();
	}
	
	//@ context Perm(adderC, 1);
	//@ ensures Perm(adderC.state, 1);
	//@ ensures adderC.state == 5;
	public static void setup(String hostS, int portS) throws Exception
	{
		adderC = new AdderC(hostS, portS);
	}
	
	//@ context Perm(adderC, 1);
	//@ context Perm(adderC.state, 1);
	//@ requires adderC.state == 5;
	//@ ensures adderC.state == 6;
	public static void adderC() throws Exception
	{
		if (Utilities.random(2) == 0)
		{
			adderC.addToS(0, 0);
			adderC.resFromS();
			adderC();
		}
		else 
		{
			adderC.byeToS();
		}
	}
}
