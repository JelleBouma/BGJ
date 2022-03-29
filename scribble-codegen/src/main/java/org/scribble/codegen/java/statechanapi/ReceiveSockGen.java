/**
 * Copyright 2008 The Scribble Authors
 * This file has been modified by Jelle Bouma
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
package org.scribble.codegen.java.statechanapi;

import org.scribble.ast.DataDecl;
import org.scribble.ast.SigDecl;
import org.scribble.ast.Module;
import org.scribble.codegen.java.sessionapi.SessionApiGenerator;
import org.scribble.codegen.java.util.ClassBuilder;
import org.scribble.codegen.java.util.JavaBuilder;
import org.scribble.codegen.java.util.MethodBuilder;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.DataName;
import org.scribble.core.type.name.SigName;
import org.scribble.core.type.name.PayElemType;
import org.scribble.util.ScribException;

public class ReceiveSockGen extends ScribSockGen
{
	public ReceiveSockGen(StateChannelApiGenerator apigen, EState curr)
	{
		super(apigen, curr);
	}

	@Override
	protected String getSuperClassType()
	{
		return (apigen.verCorsSkeleton ? RECEIVESOCKET_CLASS_SHORT : RECEIVESOCKET_CLASS) + "<" + getSessionClassName() + ", " + getSelfClassName() + ">";
	}

	@Override
	protected void addImports()
	{
		super.addImports();
		this.cb.addImports(getOpsPackageName() + ".*");
	}

	// Single receive (unary branch -- singleton next state)
	// But generates a set of methods related to this input (regular receive, async with future, async with discard, arrived polling) -- TODO: call-back
	// FIXME: most general async would also allow whole input-only compound statements (choice, recursion) to be bypassed
	//private void addReceiveMethods(ClassBuilder cb, EndpointState curr)
	@Override
	protected void addMethods() throws ScribException
	{
		EAction a = curr.getDetActions().iterator().next();
		//String nextClass = this.apigen.getSocketClassName(curr.accept(a));
		EState succ = curr.getDetSuccessor(a);
		ClassBuilder futureClass = new InputFutureGen(this.apigen, this.cb, a).generateType();  // Wraps all payload elements as fields (set by future completion)
		// FIXME: problem if package and protocol have the same name -- still?
		this.apigen.addTypeDecl(futureClass);

		makeReceiveMethod(a, succ);  // [nextClass] receive([opClass] op, Buff<? super T> arg, ...)
		makeAsyncMethod(a, succ, futureClass.getName());  // [nextClass] async([opClass] op, Buff<futureClass> arg)
		makeIsDoneMethod(a);  // boolean isDone()
		makeAsyncDiscardMethod(a, succ, futureClass.getName());  // [nextClass] async([opClass] op)
	}

  // [nextClass] receive([opClass] op, Buf<? super T> arg, ...)
	//private void makeReceiveMethod(ClassBuilder cb, Module main, IOAction a, String nextClass, String opClass)
	private void makeReceiveMethod(EAction a, EState succ) throws ScribException
	{
		Module main = this.apigen.getMainModule();  // FIXME: main not necessarily the right module?

		MethodBuilder mb = makeReceiveHeader(a, succ);
		if (apigen.verCorsSkeleton) {
			addVercorsStateChange(mb, getStateNumber(succ));
			addVercorsConditions(mb, getStateNumber(succ));
		}
		else if (a.mid.isOp())
		{
			//addReceiveOpParams(mb, main, a);
			String ln = a.payload.isEmpty() ? "" : StateChannelApiGenerator.SCRIBMESSAGE_CLASS + " " + RECEIVE_MESSAGE_PARAM + " = ";
			ln += JavaBuilder.SUPER + ".readScribMessage(" + getSessionApiRoleConstant(a.obj) + ");";
			mb.addBodyLine(ln);
			addPayloadBuffSetters(main, a, mb);
		}
		else //if (a.mid.isMessageSigName())
		{
			SigDecl msd = main.getSigDeclChild(((SigName) a.mid).getSimpleName());  // FIXME: might not belong to main module
			//addReceiveMessageSigNameParams(mb, a, msd);*/
			mb.addBodyLine(StateChannelApiGenerator.SCRIBMESSAGE_CLASS + " " + RECEIVE_MESSAGE_PARAM + " = "
						+ JavaBuilder.SUPER + ".readScribMessage(" + getSessionApiRoleConstant(a.obj) + ");");
			mb.addBodyLine(RECEIVE_ARG_PREFIX + "." + BUFF_VAL_FIELD + " = (" + msd.getExtName() + ") " + RECEIVE_MESSAGE_PARAM + ";");
		}
		addReturnNextSocket(mb, succ);
	}

	// Payload parameters added later
	private MethodBuilder makeReceiveHeader(EAction a, EState succ) throws ScribException
	{
		MethodBuilder mb = this.cb.newMethod();
		setReceiveHeaderWithoutReturnType(this.apigen, a, mb);
		setNextSocketReturnType(this.apigen, mb, succ);
		return mb;
	}

  // [nextClass] async([opClass] op, Buf<? super futureClass> arg)
	private void makeAsyncMethod(EAction a, EState succ, String futureClass)
	{
		final String ROLE_PARAM = "role";
		String opClass = SessionApiGenerator.getOpClassName(a.mid);
		
		MethodBuilder mb = this.cb.newMethod("async"); 
		// Blurb stuff similar to makeReceiveHeader
		mb.addModifiers(JavaBuilder.PUBLIC);//, ClassBuilder.SYNCHRONIZED);
		//setNextSocketReturnType(mb, succ);
		setNextSocketReturnType(this.apigen, mb, succ);
		mb.addExceptions(apigen.verCorsSkeleton ? StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS_SHORT : StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS);
		mb.addParameters(SessionApiGenerator.getRoleClassName(a.obj) + " " + ROLE_PARAM);
		mb.addParameters(opClass + " " + StateChannelApiGenerator.RECEIVE_OP_PARAM);
		mb.addParameters((apigen.verCorsSkeleton ? BUF_CLASS_SHORT : BUF_CLASS) + "<" + futureClass + "> " + RECEIVE_ARG_PREFIX);  // Method for future-buf even if no payload, for sync action
		//mb.addBodyLine(ClassBuilder.SUPER + ".use();");
		//mb2.addBodyLine(ARG_PREFIX + ".val = " + " " + ClassBuilder.SUPER + ".getFuture(" + getPrefixedRoleClassName(a.peer) + ");");
		if (apigen.verCorsSkeleton) {
			addVercorsStateChange(mb, getStateNumber(succ));
			addVercorsConditions(mb, getStateNumber(succ));
		}
		else
			mb.addBodyLine(RECEIVE_ARG_PREFIX + "." + BUFF_VAL_FIELD + " = "
					+ JavaBuilder.NEW + " " + futureClass + "(" + JavaBuilder.SUPER + ".getFuture(" + getSessionApiRoleConstant(a.obj) + "));");
		addReturnNextSocket(mb, succ);
	}

  // [nextClass] async([opClass] op) -- wrapper for makeAsyncMethod
	private void makeAsyncDiscardMethod(EAction a, EState succ, String futureClass)
	{
		MethodBuilder mb = makeAsyncDiscardHeader(a, succ, futureClass);
		if (apigen.verCorsSkeleton) {
			addVercorsStateChange(mb, getStateNumber(succ));
			addVercorsConditions(mb, getStateNumber(succ));
		}
		else
			mb.addAnnotations("@SuppressWarnings(\"unchecked\")");  // To cast the generic garbage buf
		mb.addBodyLine(JavaBuilder.RETURN + " async(" + SessionApiGenerator.getSessionClassName(apigen.getGProtocolName()) + "." + a.obj + ", " + StateChannelApiGenerator.RECEIVE_OP_PARAM + ", " + getGarbageBuf(futureClass) + ");");
	}

	private MethodBuilder makeAsyncDiscardHeader(EAction a, EState succ, String futureClass)
	{
		MethodBuilder mb = this.cb.newMethod();
		setAsyncDiscardHeaderWithoutReturnType(this.apigen, a, mb, futureClass);
		setNextSocketReturnType(this.apigen, mb, succ);
		return mb;
	}

  // boolean isDone()
	private void makeIsDoneMethod(EAction a)
	{
		MethodBuilder mb = cb.newMethod("isDone");
		mb.addModifiers(JavaBuilder.PUBLIC);
		mb.setReturn("boolean");
		mb.addBodyLine(JavaBuilder.RETURN + " " + JavaBuilder.SUPER + ".isDone(" + getSessionApiRoleConstant(a.obj) + ");");
	}

	// Doesn't include return type
	//public static void makeReceiveHeader(StateChannelApiGenerator apigen, IOAction a, EndpointState succ, MethodBuilder mb)
	public static void setReceiveHeaderWithoutReturnType(StateChannelApiGenerator apigen, EAction a, MethodBuilder mb) throws ScribException
	{
		final String ROLE_PARAM = "role";
		Module main = apigen.getMainModule();  // FIXME: main not necessarily the right module?
		String opClass = SessionApiGenerator.getOpClassName(a.mid);
			
		mb.setName("receive");
		mb.addModifiers(JavaBuilder.PUBLIC);
		mb.addExceptions(apigen.verCorsSkeleton ? StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS_SHORT : StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS, "java.io.IOException", "ClassNotFoundException");
		//, "ExecutionException", "InterruptedException");
		mb.addParameters(SessionApiGenerator.getRoleClassName(a.obj) + " " + ROLE_PARAM, opClass + " " + StateChannelApiGenerator.RECEIVE_OP_PARAM);
		if (a.mid.isOp())
		{
			addReceiveOpParams(mb, main, a, true, apigen.verCorsSkeleton);
		}
		else //if (a.mid.isMessageSigName())
		{
			SigDecl msd = main.getSigDeclChild(((SigName) a.mid).getSimpleName());  // FIXME: might not belong to main module
			addReceiveMessageSigNameParams(mb, msd, true, apigen.verCorsSkeleton);
		}
	}

	// FIXME: main may not be the right module
	protected static void addReceiveOpParams(MethodBuilder mb, Module main, EAction a, boolean superr, boolean verCorsSkeleton) throws ScribException
	{
		if (!a.payload.isEmpty())
		{
			String buffSuper = (verCorsSkeleton ? BUF_CLASS_SHORT : BUF_CLASS) + "<" + ((superr) ? "? " + JavaBuilder.SUPER + " " : "");
			int i = 1;
			for (PayElemType<?> pt : a.payload.elems)
			{
				if (!pt.isDataName())
				{
					throw new ScribException("[TODO] API generation not supported for non- data type payloads: " + pt);
				}
				DataDecl dtd = main.getTypeDeclChild((DataName) pt);  // TODO: if not DataType
				ScribSockGen.checkJavaDataTypeDecl(dtd);
				mb.addParameters(buffSuper + dtd.getExtName() + "> " + RECEIVE_ARG_PREFIX + i++);
			}
		}
	}

	protected static void addPayloadBuffSetters(Module main, EAction a, MethodBuilder mb)
	{
		if (!a.payload.isEmpty())
		{
			int i = 1;
			for (PayElemType<?> pt : a.payload.elems)  // Could factor out this loop (arg names) with addReceiveOpParams (as for send)
			{
				DataDecl dtd = main.getTypeDeclChild((DataName) pt);  // TODO: if not DataType
				mb.addBodyLine(RECEIVE_ARG_PREFIX + i + "." + BUFF_VAL_FIELD + " = (" + dtd.getExtName() + ") "
							+ RECEIVE_MESSAGE_PARAM + "." + SCRIBMESSAGE_PAYLOAD_FIELD + "[" + (i++ - 1) +"];");
			}
		}
	}

	protected static void addReceiveMessageSigNameParams(MethodBuilder mb, SigDecl msd, boolean superr, boolean verCorsSkeleton) throws ScribException
	{
		ScribSockGen.checkMessageSigNameDecl(msd);
		mb.addParameters((verCorsSkeleton ? BUF_CLASS_SHORT : BUF_CLASS) + "<" + ((superr) ? "? " + JavaBuilder.SUPER + " " : "") + msd.getExtName() + "> " + RECEIVE_ARG_PREFIX);
	}

	// Similar to setReceiveHeader
	public static void setAsyncDiscardHeaderWithoutReturnType(StateChannelApiGenerator apigen, EAction a, MethodBuilder mb, String futureClass)
	{
		final String ROLE_PARAM = "role";
		final String opClass = SessionApiGenerator.getOpClassName(a.mid);

		mb.setName("async"); 
		mb.addModifiers(JavaBuilder.PUBLIC);
		mb.addParameters(SessionApiGenerator.getRoleClassName(a.obj) + " " + ROLE_PARAM, opClass + " " + StateChannelApiGenerator.RECEIVE_OP_PARAM);
		mb.addExceptions(apigen.verCorsSkeleton ? StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS_SHORT : StateChannelApiGenerator.SCRIBBLERUNTIMEEXCEPTION_CLASS);
	}
}
