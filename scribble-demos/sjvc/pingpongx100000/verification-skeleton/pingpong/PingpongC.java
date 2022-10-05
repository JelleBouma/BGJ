package pingpong;


public class PingpongC
{
	int state;
	
	//@ ensures Perm(state, 1);
	//@ ensures state == 5;
	public PingpongC(String hostS, int portS)
	{
		state = 5;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 5;
	//@ ensures state == 7;
	public void pingToS() throws Exception
	{
		state = 7;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 5;
	//@ ensures state == 6;
	public void byeToS() throws Exception
	{
		state = 6;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 7;
	//@ ensures state == 5;
	public void pongFromS() throws Exception
	{
		state = 5;
	}
}
