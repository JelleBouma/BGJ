package eval.exec.bgj.Adder.Adder.concr;

import org.scribble.core.type.name.Role;
import org.scribble.core.type.session.STypeFactory;
import eval.exec.bgj.org.scribble.runtime.message.ObjectStreamFormatter;
import eval.exec.bgj.org.scribble.runtime.message.ScribMessage;
import eval.exec.bgj.org.scribble.runtime.session.MPSTEndpoint;
import eval.exec.bgj.org.scribble.runtime.session.Session;
import eval.exec.bgj.org.scribble.runtime.statechans.OutputSocket;
import eval.exec.bgj.org.scribble.runtime.statechans.ReceiveSocket;

import java.util.LinkedList;

public class AdderC
{
	int state;
	Role S = new Role("S");
	Role C = new Role("C");
	MPSTEndpoint<Session, Role> endpoint;
	ReceiveSocket<Session, Role> receiveSocket;
	OutputSocket<Session, Role> outputSocket;
	
	public AdderC(String hostS, int portS) throws Exception
	{
		state = 5;
		LinkedList<Role> roles = new LinkedList<>();
		roles.add(S);
		roles.add(C);
		Session session = new Session(new LinkedList<>(), "getSource", STypeFactory.parseGlobalProtocolName("tutorial.adder.Adder.Adder"), roles);
		endpoint = new MPSTEndpoint<>(session, C, new ObjectStreamFormatter());
		//endpoint.request(S, SocketChannelEndpoint::new, hostS, portS);
		//endpoint.init();
		receiveSocket = new ReceiveSocket<>(endpoint);
		outputSocket = new OutputSocket<>(endpoint);
	}
	
	private ScribMessage receiveScribMessage(Role role) throws Exception
	{
		return receiveSocket.readScribMessage(role);
	}
	
	public void addToS(int arg0, int arg1) throws Exception
	{
		//outputSocket.writeScribMessage(S, new Op("Add"), arg0, arg1);
		state = 7;
	}
	
	public void byeToS() throws Exception
	{
		//outputSocket.writeScribMessage(S, new Op("Bye"));
		state = 6;
		endpoint.setCompleted();
		endpoint.close();
	}
	
	public int resFromS() throws Exception
	{
		//int res = (int)(receiveSocket.readScribMessage(S).payload[0]);
		int res = -1;
		state = 5;
		return res;
	}
}
