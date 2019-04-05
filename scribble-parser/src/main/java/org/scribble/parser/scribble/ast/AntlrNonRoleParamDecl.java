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
package org.scribble.parser.scribble.ast;

import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.NonRoleParamDecl;
import org.scribble.ast.name.simple.NonRoleParamNode;
import org.scribble.core.type.kind.DataTypeKind;
import org.scribble.core.type.kind.Kind;
import org.scribble.core.type.kind.NonRoleParamKind;
import org.scribble.core.type.kind.SigKind;
import org.scribble.parser.scribble.ScribbleAntlrConstants;
import org.scribble.parser.scribble.AntlrToScribParser;
import org.scribble.parser.scribble.ast.name.AntlrSimpleName;

public class AntlrNonRoleParamDecl
{
	public static final int KIND_CHILD_INDEX = 0;
	public static final int NAME_CHILD_INDEX = 1;

	public static NonRoleParamDecl<? extends NonRoleParamKind> parseNonRoleParamDecl(AntlrToScribParser parser, CommonTree ct, AstFactory af)
	{
		Kind kind = parseKind(getKindChild(ct));
		if (kind.equals(SigKind.KIND))
		{
			NonRoleParamNode<SigKind> name = AntlrSimpleName.toParamNode(SigKind.KIND, getNameChild(ct), af);
			return af.NonRoleParamDecl(ct, SigKind.KIND, name);
		}
		else if (kind.equals(DataTypeKind.KIND))
		{
			NonRoleParamNode<DataTypeKind> name = AntlrSimpleName.toParamNode(DataTypeKind.KIND, getNameChild(ct), af);
			return af.NonRoleParamDecl(ct, DataTypeKind.KIND, name);
		}
		else
		{
			throw new RuntimeException("Shouldn't get in here: " + kind);
		}
	}

	private static Kind parseKind(CommonTree ct)
	{
		String kind = ct.getText();
		switch (kind)
		{
			case ScribbleAntlrConstants.KIND_MESSAGESIGNATURE:
			{
				return SigKind.KIND;
			}
			case ScribbleAntlrConstants.KIND_PAYLOADTYPE:
			{
				return DataTypeKind.KIND;
			}
			default:
			{
				throw new RuntimeException("Unknown parameter declaration kind: " + kind);
			}
		}
	}

	public static CommonTree getKindChild(CommonTree ct)
	{
		return (CommonTree) ct.getChild(KIND_CHILD_INDEX);
	}

	public static CommonTree getNameChild(CommonTree ct)
	{
		return (CommonTree) ct.getChild(NAME_CHILD_INDEX);
	}
}
