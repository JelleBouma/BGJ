/**
 * Copyright 2008 The Scribble Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package org.scribble.codegen.java.statechanapi.ioifaces;

import org.scribble.codegen.java.sessionapi.SessionApiGenerator;
import org.scribble.codegen.java.statechanapi.OutputSockGen;
import org.scribble.codegen.java.statechanapi.ReceiveSockGen;
import org.scribble.codegen.java.statechanapi.StateChannelApiGenerator;
import org.scribble.codegen.java.util.AbstractMethodBuilder;
import org.scribble.codegen.java.util.InterfaceBuilder;
import org.scribble.codegen.java.util.JavaBuilder;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.model.endpoint.actions.ERecv;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.PayElemType;
import org.scribble.util.ScribException;

public class ActionIfaceGen extends IOIfaceGen
{
	private final EAction a;
	private final InterfaceBuilder ib = new InterfaceBuilder();

	public ActionIfaceGen(StateChannelApiGenerator apigen, EState curr, EAction a)
	{
		super(apigen, curr);
		this.a = a;
	}

	@Override
	public InterfaceBuilder generateType() throws ScribException
	{
		GProtoName gpn = this.apigen.getGProtocolName();

		this.ib.setName(getActionInterfaceName(this.a));
		this.ib.setPackage(IOInterfacesGenerator.getIOInterfacePackageName(this.apigen.getGProtocolName(), this.apigen.getSelf()));
		this.ib.addImports("java.io.IOException");
		this.ib.addImports(SessionApiGenerator.getEndpointApiRootPackageName(gpn) + ".*");  // FIXME: factor out with ScribSocketGenerator
		this.ib.addImports(SessionApiGenerator.getRolesPackageName(gpn) + ".*");
		this.ib.addImports(SessionApiGenerator.getOpsPackageName(gpn) + ".*");
		this.ib.addModifiers(JavaBuilder.PUBLIC);
		this.ib.addParameters("__Succ extends " + SuccessorIfaceGen.getSuccessorInterfaceName(this.a));
		AbstractMethodBuilder mb = this.ib.newAbstractMethod();  // FIXME: factor out with ReceiveSocketBuilder
		//AbstractMethodBuilder mb2 = null;
		if (this.a instanceof ERecv)
		{
			/*if (this.curr.getAcceptable().size() > 1)
			{
				//CaseSocketGenerator.setCaseReceiveHeaderWithoutReturnType(this.apigen, this.a, mb);
			}
			//else*/
			{
				ReceiveSockGen.setReceiveHeaderWithoutReturnType(this.apigen, this.a, mb);
				/*if (this.curr.getAcceptable().size() == 1)  // FIXME: action interface should not depend on curr state -- should generate this method in the IO State I/f, not here
				{
					mb2 = this.ib.newAbstractMethod();
					ReceiveSocketGenerator.setAsyncDiscardHeaderWithoutReturnType(this.apigen, this.a, mb2, 
							InputFutureGenerator.getInputFutureName(this.apigen.getSocketClassName(this.curr)));
				}
				/*else
				{
					CaseSocketGenerator.setCaseReceiveDiscardHeaderWithoutReturnType(this.apigen, this.a, mb2);
				}*/
			}
		}
		else //if (this.a instanceof Send)
		{
			OutputSockGen.setSendHeaderWithoutReturnType(this.apigen, this.a, mb);
		}
		/*EndpointState succ = this.curr.accept(this.a);
		if (succ.isTerminal())
		{
			ScribSocketGenerator.setNextSocketReturnType(this.apigen, mb, succ);
			/*if (this.a instanceof Receive)
			{
				ScribSocketGenerator.setNextSocketReturnType(this.apigen, mb2, succ);
			}* /
		}
		else*/
		{
			mb.setReturn("__Succ");
			//if (this.a instanceof Receive)
			/*if (this.a instanceof Receive && this.curr.getAcceptable().size() == 1)
			{
				mb2.setReturn("__Succ");
			}*/
		}
		return ib;
	}
	
	// FIXME: curr unnecessary
	public static String getActionInterfaceName(EAction a)
	{
		/*String name = (a instanceof Receive)
				? "In"
				: "Out";*/
		String name;
		//if (curr.getAcceptable().iterator().next() instanceof Receive)
		if (a instanceof ERecv)
		{
			/*if (curr.getAcceptable().size() > 1)
			{
				name = "Case";  // FIXME: make subtype of In?
			}
			//else*/
			{
				name = "In";
			}
		}
		else
		{
			name = "Out";
		}
		name += "_" + getActionString(a);
		return name;
	}

	public static String getActionString(EAction a)  // FIXME: peer not needed for inputs
	{
		//String name = a.peer + "$" + a.mid;
		String name = a.obj + "_" + a.mid;
		for (PayElemType<?> pay : a.payload.elems)
		{
			//name += "$" + pay;
			name += "_" + pay;
		}
		return name;
	}
}
