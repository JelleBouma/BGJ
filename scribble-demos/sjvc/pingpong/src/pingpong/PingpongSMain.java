package pingpong;


public class PingpongSMain
{
	static PingpongS pingpongS;
	
	//@ requires Perm(pingpongS, 1);
	//@ requires args != null && args.length >= 1;
	//@ requires Perm(args[0], 1);
	public static void main(String[] args) throws Exception
	{
		setup(Utilities.parseInt(args[0]));
		pingpongS();
	}
	
	//@ context Perm(pingpongS, 1);
	//@ ensures Perm(pingpongS.state, 1);
	//@ ensures Perm(pingpongS.choice, 1);
	//@ ensures Perm(pingpongS.EXTERNAL_CHOICE_PING, 1);
	//@ ensures Perm(pingpongS.EXTERNAL_CHOICE_BYE, 1);
	//@ ensures pingpongS.state == 14 && pingpongS.choice == -1 && pingpongS.EXTERNAL_CHOICE_PING == 0 && pingpongS.EXTERNAL_CHOICE_BYE == 1;
	public static void setup(int port) throws Exception
	{
		pingpongS = new PingpongS(port);
	}
	
	//@ context Perm(pingpongS, 1);
	//@ context Perm(pingpongS.state, 1);
	//@ context Perm(pingpongS.choice, 1);
	//@ context Perm(pingpongS.EXTERNAL_CHOICE_PING, 1);
	//@ context Perm(pingpongS.EXTERNAL_CHOICE_BYE, 1);
	//@ requires pingpongS.state == 14;
	//@ requires pingpongS.EXTERNAL_CHOICE_PING == 0;
	//@ requires pingpongS.EXTERNAL_CHOICE_BYE == 1;
	//@ requires pingpongS.choice == -1;
	//@ ensures pingpongS.choice == -1;
	//@ ensures pingpongS.state == 15;
	public static void pingpongS() throws Exception
	{
		int externalChoice;
		externalChoice = pingpongS.receiveExternalChoice();
		if (externalChoice == pingpongS.EXTERNAL_CHOICE_PING)
		{
			pingpongS.pingFromC();
			pingpongS.pongToC();
			pingpongS();
		}
		else 
		{
			pingpongS.byeFromC();
		}
	}
}
