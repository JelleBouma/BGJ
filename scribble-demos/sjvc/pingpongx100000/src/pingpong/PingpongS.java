package pingpong;

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

public class PingpongS
{
	int state;
	Role C = new Role("C");
	Role S = new Role("S");
	MPSTEndpoint<Session, Role> endpoint;
	private boolean choiceMade = false;
	private ScribMessage chosenMessage;
	ReceiveSocket<Session, Role> receiveSocket;
	OutputSocket<Session, Role> outputSocket;
	public final int EXTERNAL_CHOICE_PING;
	public final int EXTERNAL_CHOICE_BYE;
	
	public PingpongS(int port) throws Exception
	{
		state = 14;
		LinkedList<Role> roles = new LinkedList<>();
		roles.add(C);
		roles.add(S);
		Session session = new Session(new LinkedList<>(), "getSource", STypeFactory.parseGlobalProtocolName("pingpong.Pingpong.Pingpong"), roles);
		ScribServerSocket ss = new SocketChannelServer(port);
		endpoint = new MPSTEndpoint<>(session, S, new ObjectStreamFormatter());
		endpoint.accept(ss, C);
		endpoint.init();
		receiveSocket = new ReceiveSocket<>(endpoint);
		outputSocket = new OutputSocket<>(endpoint);
		EXTERNAL_CHOICE_PING = 0;
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
		if (choice.equals("Ping"))
		{
			return 0;
		}
		else 
		{
			return 1;
		}
	}
	
	public void pingFromC() throws Exception
	{
		receiveScribMessage(C);
		state = 16;
	}
	
	public void byeFromC() throws Exception
	{
		receiveScribMessage(C);
		state = 15;
		endpoint.setCompleted();
		endpoint.close();
	}
	
	public void pongToC() throws Exception
	{
		outputSocket.writeScribMessage(C, new Op("Pong"));
		state = 14;
	}
}
