package demo.Adder.Adder.abstr;


public class AddPayload
{
	public int arg0;
	public int arg1;
	
	//@ inline resource permAll() = Perm(arg0, 1) ** Perm(arg1, 1);
	//@ ensures permAll();
	public AddPayload(int arg0, int arg1)
	{
		this.arg0 = arg0;
		this.arg1 = arg1;
	}
}
