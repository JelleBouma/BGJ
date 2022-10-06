package pingpong.Pingpong.Pingpong;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import org.scribble.core.type.name.Role;
import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import pingpong.Pingpong.Pingpong.roles.*;
import pingpong.Pingpong.Pingpong.ops.*;
import pingpong.Pingpong.Pingpong.statechans.C.Pingpong_C_1;
import pingpong.Pingpong.Pingpong.statechans.C.Pingpong_C_2;

public final class Pingpong extends org.scribble.runtime.session.Session {
	public static final List<String> IMPATH = new LinkedList<>();
	public static final String SOURCE = "getSource";
	public static final org.scribble.core.type.name.GProtoName PROTO = org.scribble.core.type.session.STypeFactory.parseGlobalProtocolName("pingpong.Pingpong.Pingpong");
	public static final C C = pingpong.Pingpong.Pingpong.roles.C.C;
	public static final S S = pingpong.Pingpong.Pingpong.roles.S.S;
	public static final Ping Ping = pingpong.Pingpong.Pingpong.ops.Ping.Ping;
	public static final Bye Bye = pingpong.Pingpong.Pingpong.ops.Bye.Bye;
	public static final Pong Pong = pingpong.Pingpong.Pingpong.ops.Pong.Pong;
	public static final List<Role> ROLES = Collections.unmodifiableList(Arrays.asList(new Role[] {C, S}));

	public Pingpong() {
		super(Pingpong.IMPATH, Pingpong.SOURCE, Pingpong.PROTO);
	}

	@Override
	public List<Role> getRoles() {
		return Pingpong.ROLES;
	}


}