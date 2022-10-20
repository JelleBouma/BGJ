package eval.sjvc.Adder.Adder;

import eval.sjvc.Adder.Adder.concr.AdderC;

public class AdderCMain
{
	static AdderC adderC;
	
	//@ requires Perm(adderC, 1);
	//@ requires args != null && args.length >= 2;
	//@ requires Perm(args[0], 1);
	//@ requires Perm(args[1], 1);
	public static void main(String[] args) throws Exception
	{
		long duration = args.length == 1 ? Long.parseLong(args[0]) : 0;
		setup("localhost", 8888);
		adderC(duration);
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
	public static void adderC(long duration) throws Exception
	{
//		long n = 0;
//		long deadline = Long.MAX_VALUE;
//		while (System.currentTimeMillis() < deadline) {
//			adderC.addToS(5, 6);
//			adderC.resFromS();
//			n++;
//			deadline = deadline == Long.MAX_VALUE ? System.currentTimeMillis() + duration : deadline;
//		}
//		System.err.println(n);

		duration = duration == 0 ? Integer.MAX_VALUE : duration;
		long start = -1;
		for (long i = 0; i < duration; i++) {
			adderC.addToS(5, 6);
			adderC.resFromS();
			start = start == -1 ? System.currentTimeMillis() : start;
		}
		System.out.println(System.currentTimeMillis() - start);

		adderC.byeToS();
	}
}
