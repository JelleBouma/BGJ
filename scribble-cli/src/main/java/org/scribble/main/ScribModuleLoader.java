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
package org.scribble.main;

import org.scribble.ast.AstFactory;
import org.scribble.ast.Module;
import org.scribble.job.ScribbleException;
import org.scribble.main.resource.Resource;
import org.scribble.main.resource.ResourceLocator;
import org.scribble.parser.scribble.AntlrToScribParser;
import org.scribble.type.name.ModuleName;
import org.scribble.util.Pair;
import org.scribble.util.ScribParserException;

// loading = ModuleName -> Module
//   ModuleName --> Path --ResourceLocator--> Resource --AntlrParser--> ANTLR --ScribParser--> ScribNode
// FIXME: should be in core org.scribble.main -- here due to Maven dependency restrictions
public class ScribModuleLoader extends DefaultModuleLoader //implements ModuleLoader
{
	private ResourceLocator locator;
	private ScribbleAntlrWrapper antlr;
	private AntlrToScribParser parser;

	public ScribModuleLoader(ResourceLocator locator, ScribbleAntlrWrapper antlr,
			AntlrToScribParser parser)
	{
		this.locator = locator;
		this.antlr = antlr;
		this.parser = parser;
	}

	@Override
	public Pair<Resource, Module> loadModule(ModuleName modname, AstFactory af)
			throws ScribParserException, ScribbleException
	{
		Pair<Resource, Module> cached = super.loadModule(modname, af);
		if (cached != null)
		{
			return cached;
		}
		Resource res = this.locator.getResource(modname.toPath());
		/*Module parsed = (Module) this.parser.parse(this.antlr.parseAntlrTree(res),
				af);*/
		Module parsed = this.antlr.parseAntlrTree(res);  // Does del decoration
		checkModuleName(modname, res, parsed);
		registerModule(res, parsed);
		return new Pair<>(res, parsed);
	}

	private static void checkModuleName(ModuleName mn, Resource res, Module mod)
	{
		if (!mn.equals(mod.getFullModuleName()))
		{
			throw new RuntimeException("Invalid module name "
					+ mod.getFullModuleName() + " at location: " + res.getLocation());
		}
	}
}
