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
package org.scribble.parser.scribble;

import java.util.List;
import java.util.stream.Collectors;

import org.antlr.runtime.tree.CommonErrorNode;
import org.antlr.runtime.tree.CommonTree;
import org.scribble.ast.AstFactory;
import org.scribble.ast.Module;
import org.scribble.ast.ScribNode;
import org.scribble.parser.scribble.ScribbleAntlrConstants.AntlrNodeType;
import org.scribble.parser.scribble.ast.AntlrPayloadElemList;
import org.scribble.util.ScribParserException;

// ANTLR CommonTree -> ScribNode
// Parses ANTLR nodes into ScribNodes using the parser.ast.Antlr[...] helper classes
public class AntlrToScribParser
{
	public AntlrToScribParser()
	{

	}

	public ScribNode parse(CommonTree ct, AstFactory af) throws ScribParserException
	{
		AntlrToScribParser.checkForAntlrErrors(ct);
		
		AntlrNodeType type = AntlrToScribParserUtil.getAntlrNodeType(ct);
		switch (type)
		{
			case PAYLOAD:                   return AntlrPayloadElemList.parsePayloadElemList(this, ct, af);

			case MODULE:                    
			
				// HERE  deprecating Antlr->Scrib parsing
				System.out.println("CCC1");
				
				//return AntlrModule.parseModule(this, ct, af);
				return (Module) ct;

			/*case MODULEDECL:                return AntlrModuleDecl.parseModuleDecl(this, ct, af);
			case MESSAGESIGNATUREDECL:      return AntlrMessageSigDecl.parseMessageSigDecl(this, ct, af);
			case PAYLOADTYPEDECL:           return AntlrDataTypeDecl.parseDataTypeDecl(this, ct, af);
			case IMPORTMODULE:              return AntlrImportModule.parseImportModule(this, ct, af);
			case GLOBALPROTOCOLDECL:        return AntlrGProtocolDecl.parseGPrototocolDecl(this, ct, af);
			case ROLEDECLLIST:              return AntlrRoleDeclList.parseRoleDeclList(this, ct, af);
			case ROLEDECL:                  return AntlrRoleDecl.parseRoleDecl(this, ct, af);
			//case CONNECTDECL:             return AntlrConnectDecl.parseConnectDecl(this, ct);
			case PARAMETERDECLLIST:
			//case EMPTY_PARAMETERDECLLST:
                                      return AntlrNonRoleParamDeclList.parseNonRoleParamDeclList(this, ct, af);
			case PARAMETERDECL:             return AntlrNonRoleParamDecl.parseNonRoleParamDecl(this, ct, af);
			case ROLEINSTANTIATIONLIST:     return AntlrRoleArgList.parseRoleArgList(this, ct, af);
			case ROLEINSTANTIATION:         return AntlrRoleArg.parseRoleArg(this, ct, af);
			case ARGUMENTINSTANTIATIONLIST: return AntlrNonRoleArgList.parseNonRoleArgList(this, ct, af);

			case GLOBALPROTOCOLHEADER:      return AntlrGProtocolHeader.parseGProtocolHeader(this, ct, af);
			case GLOBALPROTOCOLDEF:         return AntlrGProtocolDefinition.parseGProtocolDefinition(this, ct, af);
			case GLOBALPROTOCOLBLOCK:       return AntlrGProtocolBlock.parseGProtocolBlock(this, ct, af);
			case GLOBALINTERACTIONSEQUENCE: return AntlrGInteractionSequence.parseGInteractionSequence(this, ct, af);
			case MESSAGESIGNATURE:          return AntlrMessageSig.parseMessageSig(this, ct, af);
			case GLOBALCONNECT:             return AntlrGConnect.parseGConnect(this, ct, af);
			case GLOBALDISCONNECT:          return AntlrGDisconnect.parseGDisconnect(this, ct, af);
			case GLOBALMESSAGETRANSFER:     return AntlrGMessageTransfer.parseGMessageTransfer(this, ct, af);
			case GLOBALCHOICE:              return AntlrGChoice.parseGChoice(this, ct, af);
			case GLOBALRECURSION:           return AntlrGRecursion.parseGRecursion(this, ct, af);
			case GLOBALCONTINUE:            return AntlrGContinue.parseGContinue(this, ct, af);
			case GLOBALDO:                  return AntlrGDo.parseGDo(this, ct, af);
			case GLOBALWRAP:                return AntlrGWrap.parseGWrap(this, ct, af);*/
			default:                        throw new RuntimeException("Unknown ANTLR node type: " + type);
		}
	}

	public static void checkForAntlrErrors(CommonTree ct)
	{
		if (ct.getChildCount() > 0)  // getChildren returns null instead of empty list 
		{
			List<CommonErrorNode> errors = ((List<?>) ct.getChildren()).stream()
					.filter(c -> (c instanceof CommonErrorNode))
					.map(c -> (CommonErrorNode) c)
					.collect(Collectors.toList());
			if (errors.size() > 0)  // Antlr prints errors to System.err by default, but then attempts to carry on
						// Should never get here now, Antlr displayRecognitionError overridden to force exit: Antlr error recovery means not all errors produce CommonErrorNode
			{
				//throw new ScribParserException("Parsing errors: " + errors);  // FIXME: improve feedback message
				System.err.println("[ScribParser] Aborting due to parsing errors: " + errors);
				System.exit(1);
			}
		}
	}
}
