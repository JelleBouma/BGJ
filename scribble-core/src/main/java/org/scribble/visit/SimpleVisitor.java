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
package org.scribble.visit;

import org.scribble.ast.ScribNode;
import org.scribble.job.Job;
import org.scribble.job.ScribbleException;

// Apart from delegating to del-specific visiting methods, SimpleVisitors are mainly for holding data and collecting common operations 
// TODO CHECKME: refactor AstVisitor as a SimpleVisitor?  i.e., T=ScribNode ?
public abstract class SimpleVisitor<T>
{
	public final Job job;

	public SimpleVisitor(Job job)
	{
		this.job = job;
	}
	
	// Override to delegate to del-specific method, e.g., n.del().visit(n, this)
  // N.B. ScribNode has getParent
	public abstract T visit(ScribNode n) throws ScribbleException;
}
