package scribblevercors.codegen;

import org.scribble.ast.Module;
import org.scribble.core.job.Core;
import org.scribble.core.job.CoreArgs;
import org.scribble.core.job.CoreContext;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.EStateKind;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import scribblevercors.util.*;

import java.util.HashMap;
import java.util.Locale;

class ProtocolGenerator {

    static String pkg;
    static String className;
    Job job;
    static Module main;
    Core core;
    GProtoName gpn;
    Role role; // the role for which we are generating code
    HashSet<Role> targetRoles; // the roles that interact with ProtocolGenerator.role (excluding ProtocolGenerator.role)
    HashSet<Role> allRoles; // the roles that interact with ProtocolGenerator.role (including ProtocolGenerator.role)
    EState initialState;
    ClassBuilder classBuilder;
    OperationPool operations = new OperationPool();
    ArrayList<Operation> externalChoices;
    ArrayList<StateTransition> transitions = new ArrayList<>();
    HashSet<StateTransition> externalChoiceTransitions = new HashSet<>();
    boolean hasExternalChoice;
    boolean isClient;

    ProtocolGenerator(Job job, GProtoName gpn, Role role) throws ScribException {
        this.job = job;
        core = job.getCore();
        this.gpn = gpn;
        this.role = role;
        main = job.getContext().getMainModule();
        CoreContext corec = this.core.getContext();
        initialState = job.config.args.get(CoreArgs.MIN_EFSM) // not sure what is the difference if the graph is minimised.
            ? corec.getMinimisedEGraph(gpn, role).init
            : corec.getEGraph(gpn, role).init;
        isClient = initialState.getStateKind() == EStateKind.OUTPUT;
        System.out.println(initialState.toAut());
        operations.fillPool(initialState);
        for (Operation operation : operations)
            transitions.addAll(operation.transitions);
        targetRoles = operations.getTargetRoles();
        allRoles = new HashSet<>();
        allRoles.addAll(targetRoles);
        allRoles.add(role);
        externalChoices = operations.filter(Operation::isExternalChoice);
        hasExternalChoice = !externalChoices.isEmpty();
        for (Operation operation : externalChoices)
            externalChoiceTransitions.addAll(operation.transitions.filter(StateTransition::isExternalChoice));
        processNames();
    }

    void processNames() {
        className = StringUtils.capitalise(gpn.getSimpleName().toString()) + StringUtils.capitalise(role.toString());
        ArrayList<String> pkgElements = new ArrayList<>(gpn.getElements());
        pkgElements.remove(pkgElements.size() - 1); // remove the last two elements as these contain the protocol name
        pkgElements.remove(pkgElements.size() - 1);
        pkg = String.join(".", pkgElements).toLowerCase(Locale.ROOT);
    }

    HashMap<String, String> generateClasses(boolean verificationSkeleton) {
        String dir = verificationSkeleton ? "verification-skeleton\\" : "src\\";
        HashMap<String, String> res = new HashMap<>();
        classBuilder = new ClassBuilder(pkg, "public", className);
        generateAttributes(verificationSkeleton);
        ArrayList<String> constructorParams = new ArrayList<>("int port");
        if (isClient)
            constructorParams.add(0, "String host");
        generateConstructor(classBuilder.createConstructor("public", constructorParams, "Exception"), verificationSkeleton);
        if (!verificationSkeleton) {
            generateImports();
            generateReceiver();
        }
        if (hasExternalChoice)
            generateExternalChoiceReceive(verificationSkeleton);
        for (Operation operation : operations) {
            generateOperation(operation, verificationSkeleton);
            if (!operation.payload.name.isEmpty())
                res.putAll(operation.payload.getPayloadClass().mapContentsToFileName(dir));
        }
        res.putAll(classBuilder.mapContentsToFileName(dir));
        return res;
    }

    HashMap<String, String> generateMainClass() {
        ClassBuilder mainClass = new ClassBuilder(pkg, "public", className + "Main");
        mainClass.appendAttribute("", className, StringUtils.decapitalise(className), true, false);
        MethodBuilder mainMethod = mainClass.appendMethod("public", true, "void", "main", new ArrayList<>("String[] args"), "Exception");
        mainMethod.appendComment("@ requires Perm(" + StringUtils.decapitalise(className) + ", 1);");
        if (isClient) {
            mainMethod.appendComment("@ requires args != null && args.length > 0;");
            mainMethod.appendComment("@ requires Perm(args[0], 1);");
            mainMethod.appendStatement("setup(args[0]);");
        }
        else
            mainMethod.appendStatement("setup();");
        mainMethod.appendStatement("run();");
        MethodBuilder setup = mainClass.appendMethod("public", true, "void", "setup", isClient ? new ArrayList<>("String host") : new ArrayList<>(), "Exception");
        setup.appendComment("@ context Perm(" + StringUtils.decapitalise(className) + ", 1);");
        setup.appendComment("@ ensures Perm(" + StringUtils.decapitalise(className) + ".state, 1);");
        setup.appendComment("@ ensures " + StringUtils.decapitalise(className) + ".state == " + initialState.id + ";");
        setup.appendStatement(StringUtils.decapitalise(className) + " = new " + className + (isClient ? "(host, " : "(") + "8888);");
        MethodBuilder run = mainClass.appendMethod("public", true, "void", "run", new ArrayList<>(), "Exception");
        run.appendComment("@ context Perm(" + StringUtils.decapitalise(className) + ", 1);");
        run.appendComment("@ context Perm(" + StringUtils.decapitalise(className) + ".state, 1);");
        run.appendComment("@ requires " + StringUtils.decapitalise(className) + ".state == " + initialState.id + ";");
        run.appendComment("@ ensures " + StringUtils.decapitalise(className) + ".state == " + transitions.firstMatch(t -> t.targetState.isTerminal()).targetState.id + ";");
        generateRunner(run, initialState);
        return mainClass.mapContentsToFileName("src\\");
    }

    void generateRunner(ControlBuilder control, EState state) {
        ArrayList<StateTransition> enabledTransitions = transitions.filter(t -> t.originState == state);
        ArrayList<Operation> enabledOperations = operations.filter(o -> o.transitions.containsAny(enabledTransitions));
        if (enabledOperations.size() > 1)
            for (int oo = 0; oo < enabledOperations.size(); oo++) {
                Operation op = enabledOperations.get(oo);
                StateTransition transition = op.transitions.getMatch(t -> t.originState == state);
                String option = transition.isExternalChoice() ?
                    (StringUtils.decapitalise(className) + ".receiveExternalChoice() == " + StringUtils.decapitalise(className) + ".EXTERNAL_CHOICE_" + op.getName().toUpperCase(Locale.ROOT)) :
                    ("Utilities.random(" + enabledOperations.size() + ") == " + oo);
                ControlBuilder choice = control.appendControl((oo == 0 ? "" : "else ") + ( oo == enabledOperations.size() - 1 ? "" : "if (" + option + ")"));
                String params = (op.action.isSend() ? String.join(", ", op.payload.getDefaultValues()) : "");
                choice.appendStatement(StringUtils.decapitalise(className) + "." + op.getFullName() + "(" + params + ");");
                generateRunner(choice, transition.targetState);
            }
        else if (enabledOperations.size() == 1) {
            Operation op = enabledOperations.first();
            String params = (op.action.isSend() ? String.join(", ", op.payload.getDefaultValues()) : "");
            control.appendStatement(StringUtils.decapitalise(className) + "." + op.getFullName() + "(" + params + ");");
            EState targetState = enabledTransitions.first().targetState;
            if (targetState.id == initialState.id)
                control.appendStatement("run();");
            else
                generateRunner(control, targetState);
        }
    }

    HashMap<String, String> generateUtilities(boolean verificationSkeleton) {
        ClassBuilder util = new ClassBuilder(pkg, "public", "Utilities");
        MethodBuilder random = util.appendMethod("public", true, "int", "random", new ArrayList<>("int bound"), "");
        if (verificationSkeleton) {
            random.appendComment("@ requires bound > 0;");
            random.appendComment("@ ensures \\result >= 0 && \\result < bound;");
            random.appendStatement("return 0;");
        }
        else
            random.appendStatement("return (int)(Math.random() * bound);");
        return util.mapContentsToFileName(verificationSkeleton ? "verification-skeleton\\" : "src\\");
    }

    void generateImports() {
        classBuilder.appendImport("org.scribble.core.type.name.Op");
        classBuilder.appendImport("org.scribble.core.type.name.Role");
        classBuilder.appendImport("org.scribble.runtime.message.ScribMessage");
        classBuilder.appendImport("org.scribble.runtime.session.MPSTEndpoint");
        classBuilder.appendImport("org.scribble.runtime.session.Session");
        classBuilder.appendImport("org.scribble.core.type.session.STypeFactory");
        classBuilder.appendImport("org.scribble.main.ScribRuntimeException");
        classBuilder.appendImport("org.scribble.runtime.message.ObjectStreamFormatter");
        classBuilder.appendImport("org.scribble.runtime.net.SocketChannelEndpoint");
        classBuilder.appendImport("org.scribble.runtime.statechans.OutputSocket");
        classBuilder.appendImport("org.scribble.runtime.statechans.ReceiveSocket");
        classBuilder.appendImport("org.scribble.runtime.net.ScribServerSocket");
        classBuilder.appendImport("org.scribble.runtime.net.SocketChannelServer");
        classBuilder.appendImport("java.io.IOException");
        classBuilder.appendImport("java.util.LinkedList");
        classBuilder.appendImport("java.util.List");
    }

    void generateAttributes(boolean verificationSkeleton) {
        if (verificationSkeleton) {
            classBuilder.appendAttribute("int", "state");
            if (hasExternalChoice)
                classBuilder.appendAttribute("int", "choice");
        }
        else {
            for (Role r : allRoles)
                classBuilder.appendAttribute("", "Role", r.toString(), "new Role(\"" + r + "\")");
            classBuilder.appendAttribute("MPSTEndpoint<Session, Role>", "endpoint");
            if (hasExternalChoice) {
                classBuilder.appendAttribute("private", "boolean", "choiceMade", "false");
                classBuilder.appendAttribute("private", "ScribMessage", "chosenMessage");
            }
        }
        for (Operation operation : externalChoices)
            classBuilder.appendAttribute("public", "int", "EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT), false, true);
    }

    void generateConstructor(MethodBuilder constructor, boolean verificationSkeleton) {
        if (verificationSkeleton) {
            ArrayList<String> perms = new ArrayList<>("Perm(state, 1)");
            ArrayList<String> ensures = new ArrayList<>("state == " + initialState.id);
            constructor.appendStatement("state = " + initialState.id + ";");
            if (hasExternalChoice) {
                perms.add("Perm(choice, 1)");
                ensures.add("choice == -1");
                constructor.appendStatement("choice = -1;");
                for (Operation operation : externalChoices) {
                    perms.add("Perm(EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT) + ", 1)");
                    ensures.add("EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT) + " == " + operation.id);
                }
            }
            constructor.appendComment("@ ensures " + String.join(" ** ", perms) + ";");
            constructor.appendComment("@ ensures " + String.join(" && ", ensures) + ";");
        }
        else {
            constructor.appendStatement("LinkedList<Role> roles = new LinkedList<>();");
            for (Role r : allRoles)
                constructor.appendStatement("roles.add(" + r + ");");
            constructor.appendStatement("Session session = new Session(new LinkedList<>(), \"getSource\", STypeFactory.parseGlobalProtocolName(\"" + gpn + "\"), roles);");
            if (!isClient)
                constructor.appendStatement("ScribServerSocket ss = new SocketChannelServer(port);");
            constructor.appendStatement("endpoint = new MPSTEndpoint<>(session, " + role + ", new ObjectStreamFormatter());");
            for (Role target : targetRoles)
                if (isClient)
                    constructor.appendStatement("endpoint.request(" + target + ", SocketChannelEndpoint::new, host, port);");
                else
                    constructor.appendStatement("endpoint.accept(ss, " + target + ");");
            constructor.appendStatement("endpoint.init();");
        }
        for (Operation operation : externalChoices)
            constructor.appendStatement("EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT) + " = " + operation.id + ";");
    }
    void generateExternalChoiceReceive(boolean verificationSkeleton) {
        MethodBuilder method = classBuilder.appendMethod("public", "int", "receiveExternalChoice", new ArrayList<>(), "Exception");
        if (verificationSkeleton) {
            method.appendComment("@ context Perm(state, 1) ** Perm(choice, 1);");
            HashSet<String> startingStates = externalChoiceTransitions.convertAll(t -> "state == " + t.originState.id);
            method.appendComment("@ requires choice == -1 && (" + String.join(" || ", startingStates) +");");
            ArrayList<String> results = externalChoices.convertAll(o -> "\\result == " + o.id);
            method.appendComment("@ ensures (" + String.join(" || ", results) + ") && \\old(state) == state && \\result == choice;");
            method.appendStatement("choice = " + externalChoices.first().id + ";");
            method.appendStatement("return " + externalChoices.first().id + ";");
        } else {
            method.appendStatement("chosenMessage = receiveScribMessage(" + externalChoices.first().action.peer + ");");
            method.appendStatement("String choice = chosenMessage.op.getLastElement();");
            method.appendStatement("choiceMade = true;");
            for (int cc = 0; cc < externalChoices.size(); cc++) {
                Operation choice = externalChoices.get(cc);
                String controlStatement = (cc > 0 ? "else " : "") + (cc < externalChoices.size() - 1 ? "if (choice.equals(\"" + choice.getName() + "\"))" : "");
                ControlBuilder controlBuilder = method.appendControl(controlStatement);
                controlBuilder.appendStatement("return " + choice.id + ";");
            }
        }
    }

    void generateReceiver() {
        MethodBuilder method = classBuilder.appendMethod("private", "ScribMessage", "receiveScribMessage", new ArrayList<>("Role role"), "Exception");
        if (hasExternalChoice) {
            ControlBuilder ifChoiceMade = method.appendControl("if (choiceMade)");
            ifChoiceMade.appendStatement("choiceMade = false;");
            ifChoiceMade.appendStatement("return chosenMessage;");
        }
        method.appendStatement("return new ReceiveSocket<Session, Role>(endpoint).readScribMessage(role);");
    }

    void generateOperation(Operation operation, boolean verificationSkeleton) {
        MethodBuilder method = classBuilder.appendMethod("public", operation.getReturnType(), operation.getFullName(), operation.getParameters(), "Exception");
        if (verificationSkeleton)
            generateVerification(operation, method);
        else
            generateExecutableCode(operation, method);
    }

    void generateExecutableCode(Operation operation, MethodBuilder method) {
        StateTransition transition = operation.transitions.getMatch(t -> true);
        if (operation.payload.isSend) {
            ArrayList<String> parameters = new ArrayList<>(operation.targetRole.toString(), "new Op(\"" + operation.getName() + "\")");
            parameters.addAll(operation.payload.contents.convertAll(a -> a.name));
            method.appendStatement("new OutputSocket<Session, Role>(endpoint).writeScribMessage(" + String.join(", ", parameters) + ");");
        } else if (operation.getReturnType().equals("void"))
            method.appendStatement("receiveScribMessage(" + operation.targetRole + ");");
        else if (operation.payload.name.isBlank())
            method.appendStatement("return (" + operation.getReturnType() + ")(new ReceiveSocket<Session, Role>(endpoint).readScribMessage(" + operation.targetRole + ").payload[0]);");
        else {
            method.appendStatement("Object[] payload = receiveScribMessage(" + operation.targetRole + ").payload;");
            ArrayList<String> payloadParams = operation.payload.contents.combineAll(ArrayList.range(0, operation.payload.contents.size()), (a, i) -> "(" + a.type + ")payload[" + i + "]");
            method.appendStatement("return new " + operation.payload.name + "(" + String.join(", ", payloadParams) + ");");
        }
        if (transition.targetState.isTerminal()) { // FIXME: problem with multiple state transitions if only one is terminal.
            method.appendStatement("endpoint.setCompleted();");
            method.appendStatement("endpoint.close();");
        }
    }

    void generateVerification(Operation operation, MethodBuilder method) {
        method.appendComment("@ context Perm(state, 1)" + (operation.isExternalChoice() ? " ** Perm(choice, 1);" : ";"));
        String nonNullCondition = operation.payload.name.equals("") ? "" : " && \\result != null";
        String choiceRequirement = operation.isExternalChoice() ? " && choice == " + operation.id : "";
        String choiceGuarantee = operation.isExternalChoice() ? " && choice == " + -1 : "";
        if (operation.transitions.size() == 1) {
            StateTransition transition = operation.transitions.iterator().next();
            method.appendComment("@ requires state == " + transition.originState.id + choiceRequirement + ";");
            method.appendComment("@ ensures state == " + transition.targetState.id + choiceGuarantee + nonNullCondition + ";");
            method.appendStatement("state = " + transition.targetState.id + ";");
        }
        else {
            HashSet<String> preconditions = operation.transitions.convertAll(t -> "state == " + t.originState.id + (t.isExternalChoice() ? choiceRequirement : ""));
            HashSet<String> postconditions = operation.transitions.convertAll(t -> "\\old(state) == " + t.originState.id + " && state == " + t.targetState.id);
            method.appendComment("@ requires " + String.join(" || ", preconditions) + ";");
            method.appendComment("@ ensures " + String.join(" || ", postconditions) + choiceGuarantee + nonNullCondition + ";");
            ControlBuilder stateSwitch = method.appendControl("switch(state)");
            HashSet<String> stateChanges = operation.transitions.convertAll(t -> "case " + t.originState.id + ": state = " + t.targetState.id + "; break;");
            stateSwitch.appendStatements(stateChanges);
        }
        if (operation.isExternalChoice())
            method.appendStatement("choice = -1;");
        if (!operation.getReturnType().equals("void"))
            method.appendStatement(operation.payload.getDefaultReturnStatement());
    }
}