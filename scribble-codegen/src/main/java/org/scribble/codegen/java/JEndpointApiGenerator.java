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
package org.scribble.codegen.java;

import java.util.HashMap;
import java.util.Map;

import org.scribble.codegen.java.sessionapi.SessionApiGenerator;
import org.scribble.codegen.java.statechanapi.StateChannelApiGenerator;
import org.scribble.codegen.java.statechanapi.ioifaces.IOInterfacesGenerator;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.RuntimeScribException;
import org.scribble.util.ScribException;

public class JEndpointApiGenerator
{
	public final Job job;
	
	public JEndpointApiGenerator(Job job)
	{
		this.job = job;
	}

	public Map<String, String> generateSessionApi(GProtoName fullname)
			throws ScribException
	{
		this.job.verbosePrintln("\n[Java API gen] Running "
				+ SessionApiGenerator.class + " for " + fullname);
		SessionApiGenerator sg = new SessionApiGenerator(this.job, fullname);  // FIXME: reuse?
		Map<String, String> map = sg.generateApi();  // filepath -> class source
		return map;
	}
	
	// CHECKME: refactor an EndpointApiGenerator -- ?
	public Map<String, String> generateStateChannelApi(GProtoName fullname,
			Role self, boolean subtypes) throws ScribException
	{
		/*JobContext jc = this.job.getContext();
		if (jc.getEndpointGraph(fullname, self) == null)
		{
			buildGraph(fullname, self);
		}*/
		job.verbosePrintln("\n[Java API gen] Running "
				+ StateChannelApiGenerator.class + " for " + fullname + "@" + self);
		StateChannelApiGenerator apigen = new StateChannelApiGenerator(this.job,
				fullname, self);
		IOInterfacesGenerator iogen = null;
		try
		{
			iogen = new IOInterfacesGenerator(apigen, subtypes);
		}
		catch (RuntimeScribException e)  // FIXME: use IOInterfacesGenerator.skipIOInterfacesGeneration
		{
			//System.err.println("[Warning] Skipping I/O Interface generation for protocol featuring: " + fullname);
			this.job.warningPrintln("Skipping I/O Interface generation for: "
					+ fullname + "\n  Cause: " + e.getMessage());
		}
		// Construct the Generators first, to build all the types -- then call generate to "compile" all Builders to text (further building changes will not be output)
		Map<String, String> api = new HashMap<>(); // filepath -> class source  // Store results?
		api.putAll(apigen.generateApi());
		if (iogen != null)
		{
			api.putAll(iogen.generateApi());
		}
		return api;
	}
}
