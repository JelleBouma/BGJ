package demo.Adder.Adder.abstr;


public class AdderC
{
	int state;
	
	//@ ensures Perm(state, 1);
	//@ ensures state == 5;
	public AdderC(String hostS, int portS)
	{
		state = 5;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 5;
	//@ ensures state == 7;
	public void addToS(int arg0, int arg1) throws Exception
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
	public int resFromS() throws Exception
	{
		state = 5;
		return 0;
	}
}
