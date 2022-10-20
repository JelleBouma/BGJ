package demo.Adder.Adder.concr;

import org.scribble.core.type.name.Op;
import org.scribble.core.type.name.Role;
import org.scribble.runtime.message.ScribMessage;
import org.scribble.runtime.session.MPSTEndpoint;
import org.scribble.runtime.session.Session;
import org.scribble.core.type.session.STypeFactory;
import org.scribble.main.ScribRuntimeException;
import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.statechans.OutputSocket;
import org.scribble.runtime.statechans.ReceiveSocket;
import org.scribble.runtime.net.ScribServerSocket;
import org.scribble.runtime.net.SocketChannelServer;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

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
		Session session = new Session(new LinkedList<>(), "getSource", STypeFactory.parseGlobalProtocolName("demo.Adder.Adder"), roles);
		endpoint = new MPSTEndpoint<>(session, C, new ObjectStreamFormatter());
		endpoint.request(S, SocketChannelEndpoint::new, hostS, portS);
		endpoint.init();
		receiveSocket = new ReceiveSocket<>(endpoint);
		outputSocket = new OutputSocket<>(endpoint);
	}
	
	private ScribMessage receiveScribMessage(Role role) throws Exception
	{
		return receiveSocket.readScribMessage(role);
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 5;
	//@ ensures state == 7;
	public void addToS(int arg0, int arg1) throws Exception
	{
		outputSocket.writeScribMessage(S, new Op("Add"), arg0, arg1);
		state = 7;
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 5;
	//@ ensures state == 6;
	public void byeToS() throws Exception
	{
		outputSocket.writeScribMessage(S, new Op("Bye"));
		state = 6;
		endpoint.setCompleted();
		endpoint.close();
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 7;
	//@ ensures state == 5;
	public int resFromS() throws Exception
	{
		int res = (int)(receiveSocket.readScribMessage(S).payload[0]);
		state = 5;
		return res;
	}
}
