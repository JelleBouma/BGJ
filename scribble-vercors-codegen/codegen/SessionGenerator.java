package scribblevercors.codegen;

import org.scribble.ast.Module;
import org.scribble.core.job.Core;
import org.scribble.core.job.CoreArgs;
import org.scribble.core.job.CoreContext;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import scribblevercors.util.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

public class SessionGenerator {

    Job job;
    static Module main;
    Core core;
    GProtoName gpn;
    Role role;
    EState initialState;
    ClassBuilder classBuilder;
    OperationPool operations = new OperationPool();

    public SessionGenerator(Job job, GProtoName gpn, Role role) throws ScribException {
        this.job = job;
        core = job.getCore();
        this.gpn = gpn;
        this.role = role;
        main = job.getContext().getMainModule();
        CoreContext corec = this.core.getContext();
        initialState = job.config.args.get(CoreArgs.MIN_EFSM) // not sure what is the difference if the graph is minimised.
            ? corec.getMinimisedEGraph(gpn, role).init
            : corec.getEGraph(gpn, role).init;
        System.out.println(initialState.toAut());
        operations.fillPool(initialState);
        String generatedClass = generateClass();
        System.out.println(generatedClass);
        try {
            PrintWriter pw = new PrintWriter("Z:\\onderzoeknieuw\\output.java");
            pw.print(generatedClass);
            pw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public String generateClass() {
        String name = StringUtils.capitalise(gpn.getSimpleName().toString());
        classBuilder = new ClassBuilder(name.toLowerCase(Locale.ROOT), "public", name);
        classBuilder.appendAttribute("int", "state");
        for (Operation operation : operations)
            addOperation(operation);
        return classBuilder.toString();
    }

    void addOperation(Operation operation) {
        MethodBuilder method = classBuilder.appendMethod("public", operation.getReturnType(), StringUtils.decapitalise(operation.getName()), operation.getParameters());
        method.appendComment("@ context Perm(state, 1);");
        if (operation.transitions.size() == 1) {
            StateTransition transition = operation.transitions.iterator().next();
            method.appendComment("@ requires state == " + transition.originState + ";");
            method.appendComment("@ ensures state == " + transition.targetState + ";");
            method.appendStatement("state = " + transition.targetState + ";");
        }
        else {
            HashSet<String> preconditions = operation.transitions.convertAll(t -> "state == " + t.originState);
            HashSet<String> postconditions = operation.transitions.convertAll(t -> "(\\old(state) == " + t.originState + " && state == " + t.targetState + ")");
            method.appendComment("@ requires " + String.join(" || ", preconditions) + ";");
            method.appendComment("@ ensures " + String.join(" || ", postconditions) + ";");
            ControlBuilder stateSwitch = method.appendControl("switch(state)");
            HashSet<String> stateChanges = operation.transitions.convertAll(t -> "case " + t.originState + ": state = " + t.targetState + "; break;");
            stateSwitch.appendStatements(stateChanges);
        }
    }
}