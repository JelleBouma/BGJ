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

public class AdderS
{
	int state;
	Role C = new Role("C");
	Role S = new Role("S");
	MPSTEndpoint<Session, Role> endpoint;
	private boolean choiceMade = false;
	private ScribMessage chosenMessage;
	ReceiveSocket<Session, Role> receiveSocket;
	OutputSocket<Session, Role> outputSocket;
	public final int EXTERNAL_CHOICE_ADD;
	public final int EXTERNAL_CHOICE_BYE;
	
	public AdderS(int port) throws Exception
	{
		state = 14;
		LinkedList<Role> roles = new LinkedList<>();
		roles.add(C);
		roles.add(S);
		Session session = new Session(new LinkedList<>(), "getSource", STypeFactory.parseGlobalProtocolName("demo.Adder.Adder"), roles);
		ScribServerSocket ss = new SocketChannelServer(port);
		endpoint = new MPSTEndpoint<>(session, S, new ObjectStreamFormatter());
		endpoint.accept(ss, C);
		endpoint.init();
		receiveSocket = new ReceiveSocket<>(endpoint);
		outputSocket = new OutputSocket<>(endpoint);
		EXTERNAL_CHOICE_ADD = 0;
		EXTERNAL_CHOICE_BYE = 1;
	}
	
	private ScribMessage receiveScribMessage(Role role) throws Exception
	{
		if (choiceMade)
		{
			choiceMade = false;
			return chosenMessage;
		}
		return receiveSocket.readScribMessage(role);
	}
	
	public int receiveExternalChoice() throws Exception
	{
		chosenMessage = receiveScribMessage(C);
		String choice = chosenMessage.op.getLastElement();
		choiceMade = true;
		if (choice.equals("Add"))
		{
			return 0;
		}
		else 
		{
			return 1;
		}
	}
	
	//@ context Perm(state, 1) ** Perm(choice, 1);
	//@ requires state == 14 && choice == 0;
	//@ ensures state == 16 && choice == -1 && \result != null;
	//@ ensures \result.permAll();
	public AddPayload addFromC() throws Exception
	{
		Object[] payload = receiveScribMessage(C).payload;
		AddPayload res = new AddPayload((int)payload[0], (int)payload[1]);
		state = 16;
		return res;
	}
	
	//@ context Perm(state, 1) ** Perm(choice, 1);
	//@ requires state == 14 && choice == 1;
	//@ ensures state == 15 && choice == -1;
	public void byeFromC() throws Exception
	{
		receiveScribMessage(C);
		state = 15;
		endpoint.setCompleted();
		endpoint.close();
	}
	
	//@ context Perm(state, 1);
	//@ requires state == 16;
	//@ ensures state == 14;
	public void resToC(int arg0) throws Exception
	{
		outputSocket.writeScribMessage(C, new Op("Res"), arg0);
		state = 14;
	}
}
