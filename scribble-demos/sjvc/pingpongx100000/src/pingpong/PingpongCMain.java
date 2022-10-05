package pingpong;


public class PingpongCMain
{
	static PingpongC pingpongC;
	
	//@ requires Perm(pingpongC, 1);
	//@ requires args != null && args.length >= 2;
	//@ requires Perm(args[0], 1);
	//@ requires Perm(args[1], 1);
	public static void main(String[] args) throws Exception
	{
		setup(args[0], Utilities.parseInt(args[1]));
		pingpongC();
	}
	
	//@ context Perm(pingpongC, 1);
	//@ ensures Perm(pingpongC.state, 1);
	//@ ensures pingpongC.state == 5;
	public static void setup(String hostS, int portS) throws Exception
	{
		pingpongC = new PingpongC(hostS, portS);
	}
	
	//@ context Perm(pingpongC, 1);
	//@ context Perm(pingpongC.state, 1);
	//@ requires pingpongC.state == 5;
	//@ ensures pingpongC.state == 6;
	public static void pingpongC() throws Exception
	{
		long startTime = 0; // value is never used
		for (int pp = 0; pp <= 100000; pp++)
		{
			pingpongC.pingToS();
			pingpongC.pongFromS();
			if (pp == 0)
				startTime = System.currentTimeMillis();
		}
		System.out.println(System.currentTimeMillis() - startTime);
		pingpongC.byeToS();
	}
}
