package pingpong;


public class PingpongS
{
	int state;
	int choice;
	public final int EXTERNAL_CHOICE_PING;
	public final int EXTERNAL_CHOICE_BYE;
	
	//@ ensures Perm(state, 1) ** Perm(choice, 1) ** Perm(EXTERNAL_CHOICE_PING, 1) ** Perm(EXTERNAL_CHOICE_BYE, 1);
	//@ ensures state == 14 && choice == -1 && EXTERNAL_CHOICE_PING == 0 && EXTERNAL_CHOICE_BYE == 1;
	public PingpongS(int port)
	{
		state = 14;
		choice = -1;
		EXTERNAL_CHOICE_PING = 0;
		EXTERNAL_CHOICE_BYE = 1;
	}
	
	//@ context Perm(state, 1) ** Perm(choice, 1);
	//@ requires choice == -1 && (state == 14 || state == 14);
	//@ ensures (state == 14 && \result == 0 || state == 14 && \result == 1) && \old(state) == state && \result == choice;
	public int receiveExternalChoice() throws Exception
	{
		if (state == 14)
		{
			choice = 0;
			return 0;
		}
		if (state == 14)
		{
			choice = 1;
			return 1;
		}
	}
	
	//@ context Perm(state, 1) ** Perm(choice, 1);
	//@ requires state == 14 && choice == 0;
	//@ ensures state == 16 && choice == -1;
	public void pingFromC() throws Exception
	{
		state = 16;
		choice = -1;
	}
	
	//@ context Perm(state, 1) ** Perm(choice, 1);
	//@ requires state == 14 && choice == 1;
	//@ ensures state == 15 && choice == -1;
	public void byeFromC() throws Exception
	{
		state = 15;
		choice = -1;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 16;
	//@ ensures state == 14;
	public void pongToC() throws Exception
	{
		state = 14;
	}
}
