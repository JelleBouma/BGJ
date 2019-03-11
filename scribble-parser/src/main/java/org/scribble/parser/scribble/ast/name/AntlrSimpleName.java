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
package org.scribble.parser.scribble.ast.name;

import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.name.qualified.DataTypeNode;
import org.scribble.ast.name.qualified.GProtocolNameNode;
import org.scribble.ast.name.qualified.LProtocolNameNode;
import org.scribble.ast.name.qualified.MessageSigNameNode;
import org.scribble.ast.name.qualified.ModuleNameNode;
import org.scribble.ast.name.simple.NonRoleParamNode;
import org.scribble.ast.name.simple.OpNode;
import org.scribble.ast.name.simple.RecVarNode;
import org.scribble.ast.name.simple.RoleNode;
import org.scribble.parser.scribble.ScribbleAntlrConstants;
import org.scribble.type.kind.DataTypeKind;
import org.scribble.type.kind.Global;
import org.scribble.type.kind.Local;
import org.scribble.type.kind.ModuleKind;
import org.scribble.type.kind.NonRoleParamKind;
import org.scribble.type.kind.OpKind;
import org.scribble.type.kind.RecVarKind;
import org.scribble.type.kind.RoleKind;
import org.scribble.type.kind.SigKind;

public class AntlrSimpleName
{
	public static ModuleNameNode toModuleNameNode(CommonTree ct, AstFactory af)
	{
		return (ModuleNameNode) af.QualifiedNameNode(ct, ModuleKind.KIND, getName(ct));  // Cannot use SimpleNameNode because qualified uses the node's elements, not the node's text itself
	}

	public static GProtocolNameNode toGProtocolNameNode(CommonTree ct, AstFactory af)
	{
		return (GProtocolNameNode) af.QualifiedNameNode(ct, Global.KIND, getName(ct));  // Cannot use SimpleNameNode because qualified uses the node's elements, not the node's text itself
	}

	public static LProtocolNameNode toLProtocolNameNode(CommonTree ct, AstFactory af)
	{
		return (LProtocolNameNode) af.QualifiedNameNode(ct, Local.KIND, getName(ct));
	}

	public static DataTypeNode toDataTypeNameNode(CommonTree ct, AstFactory af)
	{
		return (DataTypeNode) af.QualifiedNameNode(ct, DataTypeKind.KIND, getName(ct));
	}

	public static MessageSigNameNode toMessageSigNameNode(CommonTree ct, AstFactory af)
	{
		return (MessageSigNameNode) af.QualifiedNameNode(ct, SigKind.KIND, getName(ct));
	}

	public static RoleNode toRoleNode(CommonTree ct, AstFactory af)
	{
		return (RoleNode) af.SimpleNameNode(ct, RoleKind.KIND, getName(ct));
	}

	public static <K extends NonRoleParamKind> NonRoleParamNode<K> toParamNode(K kind, CommonTree ct, AstFactory af)
	{
		return af.NonRoleParamNode(ct, kind, getName(ct));
	}
	
	public static OpNode toOpNode(CommonTree ct, AstFactory af)
	{
		String op = getName(ct);
		return op.equals(ScribbleAntlrConstants.ANTLR_EMPTY_OPERATOR)
				? (OpNode) af.SimpleNameNode(ct, OpKind.KIND, OpNode.EMPTY_OP_IDENTIFIER)
				: (OpNode) af.SimpleNameNode(ct, OpKind.KIND, getName(ct));
	}
	
	public static RecVarNode toRecVarNode(CommonTree ct, AstFactory af)
	{
		return (RecVarNode) af.SimpleNameNode(ct, RecVarKind.KIND, getName(ct));
	}

	public static String getName(CommonTree ct)
	{
		return ct.getText();
	}
}
