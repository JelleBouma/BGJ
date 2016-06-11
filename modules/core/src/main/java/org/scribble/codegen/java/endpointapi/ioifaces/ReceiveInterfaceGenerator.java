package org.scribble.codegen.java.endpointapi.ioifaces;

import java.util.Map;

import org.scribble.codegen.java.endpointapi.InputFutureGenerator;
import org.scribble.codegen.java.endpointapi.ReceiveSocketGenerator;
import org.scribble.codegen.java.endpointapi.ScribSocketGenerator;
import org.scribble.codegen.java.endpointapi.SessionApiGenerator;
import org.scribble.codegen.java.endpointapi.StateChannelApiGenerator;
import org.scribble.codegen.java.util.InterfaceBuilder;
import org.scribble.codegen.java.util.MethodBuilder;
import org.scribble.main.ScribbleException;
import org.scribble.model.local.EndpointState;
import org.scribble.model.local.IOAction;
import org.scribble.sesstype.name.GProtocolName;

public class ReceiveInterfaceGenerator extends IOStateInterfaceGenerator
{
	public ReceiveInterfaceGenerator(StateChannelApiGenerator apigen, Map<IOAction, InterfaceBuilder> actions, EndpointState curr)
	{
		super(apigen, actions, curr);
	}

	@Override
	public InterfaceBuilder generateType() throws ScribbleException
	{
		if (this.curr.getAllTakeable().stream().anyMatch((a) -> !a.isReceive())) // TODO (connect/disconnect)
		{
			//return null;
			throw new RuntimeException("TODO: " + this.curr);
		}
		return super.generateType();
	}

	@Override
	protected void constructInterface() throws ScribbleException
	{
		super.constructInterface();
		addAsyncDiscardMethod();
	}

	protected void addAsyncDiscardMethod()
	{
		GProtocolName gpn = this.apigen.getGProtocolName();
		IOAction first = this.curr.getTakeable().iterator().next();

		MethodBuilder mb = this.ib.newAbstractMethod();
		ReceiveSocketGenerator.setAsyncDiscardHeaderWithoutReturnType(this.apigen, first, mb, InputFutureGenerator.getInputFutureName(this.apigen.getSocketClassName(this.curr)));
		this.ib.addImports(SessionApiGenerator.getOpsPackageName(gpn) + ".*");
		EndpointState succ = this.curr.take(first);
		if (succ.isTerminal())
		{
			ScribSocketGenerator.setNextSocketReturnType(this.apigen, mb, succ);
		}
		else
		{
			mb.setReturn("__Succ1");  // Hacky?  // FIXME: factor out Succ
		}
	}
}
