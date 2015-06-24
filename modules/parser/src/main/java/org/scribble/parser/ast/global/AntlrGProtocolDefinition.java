package org.scribble.parser.ast.global;

import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactoryImpl;
import org.scribble.ast.global.GProtocolBlock;
import org.scribble.ast.global.GProtocolDef;
import org.scribble.parser.ScribbleParser;

public class AntlrGProtocolDefinition
{
	public static final int BLOCK_CHILD_INDEX = 0;

	public static GProtocolDef parseGProtocolDefinition(ScribbleParser parser, CommonTree ct)
	{
		GProtocolBlock gpb = (GProtocolBlock) parser.parse(getBlockChild(ct));
		return AstFactoryImpl.FACTORY.GProtocolDefinition(gpb);
	}

	public static CommonTree getBlockChild(CommonTree ct)
	{
		return (CommonTree) ct.getChild(BLOCK_CHILD_INDEX);
	}
}
