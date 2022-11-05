package eval.exec.scribble.Adder.Adder;

import eval.exec.scribble.org.scribble.runtime.session.Session;
import org.scribble.core.type.name.Role;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public final class Adder extends Session {
	public static final List<String> IMPATH = new LinkedList<>();
	public static final String SOURCE = "getSource";
	public static final org.scribble.core.type.name.GProtoName PROTO = org.scribble.core.type.session.STypeFactory.parseGlobalProtocolName("adder.Adder.Adder");
	public static final eval.exec.scribble.Adder.Adder.roles.C C = eval.exec.scribble.Adder.Adder.roles.C.C;
	public static final eval.exec.scribble.Adder.Adder.roles.S S = eval.exec.scribble.Adder.Adder.roles.S.S;
	public static final eval.exec.scribble.Adder.Adder.ops.Bye Bye = eval.exec.scribble.Adder.Adder.ops.Bye.Bye;
	public static final eval.exec.scribble.Adder.Adder.ops.Add Add = eval.exec.scribble.Adder.Adder.ops.Add.Add;
	public static final eval.exec.scribble.Adder.Adder.ops.Res Res = eval.exec.scribble.Adder.Adder.ops.Res.Res;
	public static final List<Role> ROLES = Collections.unmodifiableList(Arrays.asList(new Role[] {C, S}));

	public Adder() {
		super(Adder.IMPATH, Adder.SOURCE, Adder.PROTO);
	}

	@Override
	public List<Role> getRoles() {
		return Adder.ROLES;
	}
}