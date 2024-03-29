package bgj.codegen;

import org.scribble.ast.Module;
import org.scribble.core.job.Core;
import org.scribble.core.job.CoreArgs;
import org.scribble.core.job.CoreContext;
import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.EStateKind;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import bgj.util.*;

import java.util.HashMap;
import java.util.Locale;

/**
 * Generates the Java classes for a role.
 */
class ProtocolGenerator {

    static String pkg;
    String className;
    Job job;
    static Module main;
    Core core;
    GProtoName gpn;
    Role role; // the role for which we are generating code
    ArrayList<Role> targetRoles; // the roles that interact with ProtocolGenerator.role (excluding ProtocolGenerator.role)
    HashSet<Role> allRoles; // the roles that interact with ProtocolGenerator.role (including ProtocolGenerator.role)
    EState initialState;
    ClassBuilder classBuilder;
    OperationPool operations = new OperationPool(); // all operations for ProtocolGenerator.role
    ArrayList<Operation> externalChoices; // all operations for ProtocolGenerator.role which can be externally chosen
    ArrayList<StateTransition> transitions = new ArrayList<>(); // all state transitions for ProtocolGenerator.role
    boolean hasExternalChoice; // whether there are any externally chosen state transitions for ProtocolGenerator.role
    HashMap<Role, Boolean> isClientTo = new HashMap<>(); // for each targetRole, whether ProtocolGenerator.role sends first.
    RunMethodPool runMethodPool;

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
        buildConnectionMaps(initialState, new HashSet<>());
        operations.fillPool(initialState);
        operations.distinguishOperations();
        for (Operation operation : operations)
            transitions.addAll(operation.transitions);
        targetRoles = operations.getTargetRoles();
        allRoles = new HashSet<>();
        allRoles.addAll(targetRoles);
        allRoles.add(role);
        externalChoices = operations.filter(Operation::isExternalChoice);
        hasExternalChoice = !externalChoices.isEmpty();
        processNames();
        runMethodPool = new RunMethodPool(initialState, StringUtils.decapitalise(className));
    }

    void buildConnectionMaps(EState state, HashSet<EState> history) {
        for (EAction action : state.getActions())
            if (!isClientTo.containsKey(action.obj))
                isClientTo.put(action.obj, action.isSend());
        history.add(state);
        for (EState succ : state.getSuccs())
            if (!history.contains(succ))
                buildConnectionMaps(succ, history);
    }

    void processNames() {
        className = StringUtils.capitalise(gpn.getSimpleName().toString()) + StringUtils.capitalise(role.toString());
        ArrayList<String> pkgElements = new ArrayList<>(gpn.getElements());
        pkg = String.join(".", pkgElements).toLowerCase(Locale.ROOT);
    }

    /**
     * Generate the protocol class and payload classes if needed.
     * @param verificationSkeleton Whether the generated classes are to be used for verification (as opposed to execution).
     * @return A hashmap of file names and contents of the protocol class and payload classes.
     */
    HashMap<String, String> generateClasses(boolean verificationSkeleton) {
        String dir = "";
        String basepkg = pkg;
        pkg += verificationSkeleton ? ".abstr" : ".concr";

        HashMap<String, String> res = new HashMap<>();
        classBuilder = new ClassBuilder(pkg, "public", className);
        generateAttributes(verificationSkeleton);
        ArrayList<String> constructorParams = new ArrayList<>();
        if (isClientTo.containsValue(false))
            constructorParams.add("int port");
        for (Role role : isClientTo.keySet())
            if (isClientTo.get(role)) {
                constructorParams.add("String host" + role);
                constructorParams.add("int port" + role);
            }
        if (verificationSkeleton)
            generateConstructor(classBuilder.createConstructor("public", constructorParams), verificationSkeleton);
        else
            generateConstructor(classBuilder.createConstructor("public", constructorParams, "Exception"), verificationSkeleton);
        generatePayloadImports(classBuilder);
        if (!verificationSkeleton) {
            generateExecutionImports();
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

        // Sung edit
        pkg = basepkg;

        return res;
    }

    /**
     * Generate the main class.
     * @return A hashmap of file name and content of the main class.
     */
    HashMap<String, String> generateMainClass() {
        ClassBuilder mainClass = new ClassBuilder(pkg, "public", className + "Main");
        mainClass.appendImport(pkg + ".concr.*");
        generatePayloadImports(mainClass);
        mainClass.appendAttribute("", className, StringUtils.decapitalise(className), true, false);
        MethodBuilder mainMethod = mainClass.appendMethod("public", true, "void", "main", new ArrayList<>("String[] args"), "Exception");
        mainMethod.appendComment("@ requires Perm(" + StringUtils.decapitalise(className) + ", 1);");
        int argCount = isClientTo.containsValue(false) ? 1 : 0;
        for (boolean server : isClientTo.values())
            if (server)
                argCount += 2;
        mainMethod.appendComment("@ requires args != null && args.length >= " + argCount + ";");
        ArrayList<String> args = new ArrayList<>();
        for (int aa = 0; aa < argCount; aa++) {
            mainMethod.appendComment("@ requires Perm(args[" + aa + "], 1);");
            if (aa % 2 == argCount % 2)
                args.add("args[" + aa + "]");
            else
                args.add("Utilities.parseInt(args[" + aa + "])");
        }
        mainMethod.appendStatement("setup(" + String.join(", ", args) + ");");
        mainMethod.appendStatement(StringUtils.decapitalise(className) + "();");
        ArrayList<String> setupParams = new ArrayList<>();
        if (isClientTo.containsValue(false))
            setupParams.add("int port");
        for (Role role : isClientTo.keySet())
            if (isClientTo.get(role)) {
                setupParams.add("String host" + role);
                setupParams.add("int port" + role);
            }
        ArrayList<String> constructorParams = setupParams.convertAll(s -> s.split(" ")[1]);
        MethodBuilder setup = mainClass.appendMethod("public", true, "void", "setup", setupParams, "Exception");
        setup.appendComment("@ context Perm(" + StringUtils.decapitalise(className) + ", 1);");
        ArrayList<String> setupEnsuringPerms = new ArrayList<>(".state");
        ArrayList<String> setupEnsuring = new ArrayList<>(".state == " + initialState.id);
        if (hasExternalChoice) {
            setupEnsuringPerms.add(".choice");
            setupEnsuringPerms.addAll(externalChoices.convertAll(o -> ".EXTERNAL_CHOICE_" + o.getName().toUpperCase(Locale.ROOT)));
            setupEnsuring.add(".choice == -1");
            setupEnsuring.addAll(externalChoices.convertAll(o -> ".EXTERNAL_CHOICE_" + o.getName().toUpperCase(Locale.ROOT) + " == " + o.id));
        }
        setupEnsuringPerms = setupEnsuringPerms.convertAll(s -> StringUtils.decapitalise(className) + s);
        setupEnsuring = setupEnsuring.convertAll(s -> StringUtils.decapitalise(className) + s);
        for (String perm : setupEnsuringPerms)
            setup.appendComment("@ ensures Perm(" + perm + ", 1);");
        setup.appendComment("@ ensures " + String.join(" && ", setupEnsuring) + ";");
        setup.appendStatement(StringUtils.decapitalise(className) + " = new " + className + "(" + String.join(", ", constructorParams) + ");");
        setupEnsuringPerms.add(0, StringUtils.decapitalise(className));
        generateRunMethods(mainClass, setupEnsuringPerms);
        return mainClass.mapContentsToFileName("");
    }

    /**
     * Generate the run methods of the main class.
     * These methods are used to actually run the scribble protocol, and will be equivalent to it.
     */
    void generateRunMethods(ClassBuilder mainClass, ArrayList<String> permissions) {
        runMethodPool.fillPool();
        for (RunMethod runMethod : runMethodPool) {
            MethodBuilder run = mainClass.appendMethod("public", true, "void", runMethod.name, new ArrayList<>(), "Exception");
            for (String perm : permissions)
                run.appendComment("@ context Perm(" + perm + ", 1);");
            run.appendComment("@ requires " + StringUtils.decapitalise(className) + ".state == " + runMethod.head.id + ";");
            if (hasExternalChoice) {
                ArrayList<String> choiceRequirements = externalChoices.convertAll(o -> ".EXTERNAL_CHOICE_" + o.getName().toUpperCase(Locale.ROOT) + " == " + o.id + ";");
                for (String choiceRequirement : choiceRequirements)
                    run.appendComment("@ requires " + StringUtils.decapitalise(className) + choiceRequirement);
                ArrayList<StateTransition> enabledTransitions = transitions.filter(t -> t.originState == runMethod.head);
                ArrayList<Operation> enabledOperations = operations.filter(o -> o.transitions.containsAny(enabledTransitions));
                if (enabledOperations.size() == 1 && runMethod.head.getStateKind() == EStateKind.POLY_RECIEVE)
                    run.appendComment("@ requires " + StringUtils.decapitalise(className) + ".choice == " + enabledOperations.first().id + ";");
                else
                    run.appendComment("@ requires " + StringUtils.decapitalise(className) + ".choice == -1;");
                run.appendComment("@ ensures " + StringUtils.decapitalise(className) + ".choice == -1;");
            }
            run.appendComment("@ ensures " + StringUtils.decapitalise(className) + ".state == " + runMethodPool.terminalState + ";");
            generateRunMethod(run, runMethod.head, false);
        }
    }

    /**
     * Generate a run method of the main class.
     * These methods are used to actually run the scribble protocol, and will be equivalent to it.
     */
    void generateRunMethod(ControlBuilder control, EState state, boolean choiceVariable) {
        ArrayList<StateTransition> enabledTransitions = transitions.filter(t -> t.originState == state);
        ArrayList<Operation> enabledOperations = operations.filter(o -> o.transitions.containsAny(enabledTransitions));
        if (enabledOperations.size() > 1) {
            boolean externalChoice = enabledOperations.get(0).transitions.getMatch(t -> t.originState == state).isExternalChoice();
            if (externalChoice) {
                if (!choiceVariable)
                    control.appendStatement("int externalChoice;");
                control.appendStatement("externalChoice = " + StringUtils.decapitalise(className) + ".receiveExternalChoice();");
            }
            for (int oo = 0; oo < enabledOperations.size(); oo++) {
                Operation op = enabledOperations.get(oo);
                StateTransition transition = op.transitions.getMatch(t -> t.originState == state);
                String option = transition.isExternalChoice() ?
                        ("externalChoice == " + StringUtils.decapitalise(className) + ".EXTERNAL_CHOICE_" + op.getName().toUpperCase(Locale.ROOT)) :
                        ("Utilities.random(" + enabledOperations.size() + ") == " + oo);
                ControlBuilder choice = control.appendControl((oo == 0 ? "" : "else ") + (oo == enabledOperations.size() - 1 ? "" : "if (" + option + ")"));
                String params = (op.action.isSend() ? String.join(", ", op.payload.getDefaultValues()) : "");
                choice.appendStatement(StringUtils.decapitalise(className) + "." + op.getFullName() + "(" + params + ");");
                RunMethod methodCall = runMethodPool.firstMatch(r -> r.head.id == transition.targetState.id);
                if (methodCall == null)
                    generateRunMethod(choice, transition.targetState, choiceVariable);
                else
                    choice.appendStatement(methodCall.name + "();");
            }
        }
        else if (enabledOperations.size() == 1) {
            Operation op = enabledOperations.first();
            String params = (op.action.isSend() ? String.join(", ", op.payload.getDefaultValues()) : "");
            control.appendStatement(StringUtils.decapitalise(className) + "." + op.getFullName() + "(" + params + ");");
            EState targetState = enabledTransitions.first().targetState;
            RunMethod methodCall = runMethodPool.firstMatch(r -> r.head.id == targetState.id);
            if (methodCall == null)
                generateRunMethod(control, targetState, choiceVariable);
            else
                control.appendStatement(methodCall.name + "();");
        }
    }

    /**
     * Generate the utilities class, which purpose is to provide utility methods with a verifiable skeleton.
     * @param verificationSkeleton Whether the generated class is to be used for verification (as opposed to execution).
     * @return A hashmap of file name and content of the utilities class.
     */
    HashMap<String, String> generateUtilities(boolean verificationSkeleton) {

        // Sung edit
        String basepkg = pkg;
        pkg += verificationSkeleton ? ".abstr" : ".concr";

        ClassBuilder util = new ClassBuilder(pkg, "public", "Utilities");
        MethodBuilder random = util.appendMethod("public", true, "int", "random", new ArrayList<>("int bound"), "");
        MethodBuilder parseInt = util.appendMethod("public", true, "int", "parseInt", new ArrayList<>("String str"), "");
        if (verificationSkeleton) {
            random.appendComment("@ requires bound > 0;");
            random.appendComment("@ ensures \\result >= 0 && \\result < bound;");
            random.appendStatement("return 0;");
            parseInt.appendStatement("return 0;");
        }
        else {
            random.appendStatement("return (int)(Math.random() * bound);");
            parseInt.appendStatement("return Integer.parseInt(str);");
        }

        // Sung edit
        HashMap<String, String> result = util.mapContentsToFileName("");
        pkg = basepkg;
        return result;

        //return util.mapContentsToFileName(verificationSkeleton ? "verification-skeleton\\" : "src\\");
    }

    /**
     * Generate imports needed for the executing protocol class (as opposed to the protocol class meant for verification).
     */
    void generateExecutionImports() {
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

    /**
     * Import the classes we generated that hold the payloads for the message passing operations.
     * @param cb The class which we are adding imports to.
     */
    void generatePayloadImports(ClassBuilder cb) {
        for (String imprt : operations.getPayloadImports())
            cb.appendImport(imprt);
    }

    void generateAttributes(boolean verificationSkeleton) {
        classBuilder.appendAttribute("int", "state");
        if (verificationSkeleton) {
            if (hasExternalChoice)
                classBuilder.appendAttribute("int", "choice");
        }
        else {
            for (Role r : allRoles)
                classBuilder.appendAttribute("", "Role", r.toString(), "new Role(\"" + r + "\")");
            for (Operation op : operations)
                classBuilder.appendAttribute("", "Op", op.getName(),"new Op(\"" + op.getName() + "\")");
            classBuilder.appendAttribute("MPSTEndpoint<Session, Role>", "endpoint");
            if (hasExternalChoice) {
                classBuilder.appendAttribute("private", "boolean", "choiceMade", "false");
                classBuilder.appendAttribute("private", "ScribMessage", "chosenMessage");
            }
            classBuilder.appendAttribute("ReceiveSocket<Session, Role>", "receiveSocket");
            classBuilder.appendAttribute("OutputSocket<Session, Role>", "outputSocket");
        }
        for (Operation operation : externalChoices)
            classBuilder.appendAttribute("public", "int", "EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT), false, true);
    }

    /**
     * Generate the constructor for the protocol class.
     * @param constructor The constructor for which contents need to be generated.
     * @param verificationSkeleton true if this is a constructor on the verification side, false otherwise.
     */
    void generateConstructor(MethodBuilder constructor, boolean verificationSkeleton) {
        constructor.appendStatement("state = " + initialState.id + ";");
        if (verificationSkeleton) {
            ArrayList<String> perms = new ArrayList<>("Perm(state, 1)");
            ArrayList<String> ensures = new ArrayList<>("state == " + initialState.id);
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
            if (isClientTo.containsValue(false))
                constructor.appendStatement("ScribServerSocket ss = new SocketChannelServer(port);");
            constructor.appendStatement("endpoint = new MPSTEndpoint<>(session, " + role + ", new ObjectStreamFormatter());");
            for (Role target : targetRoles)
                if (isClientTo.get(target))
                    constructor.appendStatement("endpoint.request(" + target + ", SocketChannelEndpoint::new, host" + target + ", port" + target + ");");
                else
                    constructor.appendStatement("endpoint.accept(ss, " + target + ");");
            constructor.appendStatement("endpoint.init();");
            constructor.appendStatement("receiveSocket = new ReceiveSocket<>(endpoint);");
            constructor.appendStatement("outputSocket = new OutputSocket<>(endpoint);");
        }
        for (Operation operation : externalChoices)
            constructor.appendStatement("EXTERNAL_CHOICE_" + operation.getName().toUpperCase(Locale.ROOT) + " = " + operation.id + ";");
    }

    /**
     * Generate the method which receives external choice.
     * @param verificationSkeleton true if this is the external choice receiver on the verification side, false otherwise.
     */
    void generateExternalChoiceReceive(boolean verificationSkeleton) {
        MethodBuilder method = classBuilder.appendMethod("public", "int", "receiveExternalChoice", new ArrayList<>(), "Exception");
        if (verificationSkeleton) {
            ArrayList<String> requiredStates = new ArrayList<>();
            ArrayList<String> ensuredResults = new ArrayList<>();
            for (Operation operation : externalChoices) {
                ArrayList<StateTransition> externalChoiceTransitions = new ArrayList<>();  // all state transitions for ProtocolGenerator.role which are externally chosen
                externalChoiceTransitions.addAll(operation.transitions.filter(StateTransition::isExternalChoice));
                ArrayList<String> originStates = externalChoiceTransitions.convertAll(t -> "state == " + t.originState.id);
                requiredStates.add(String.join(" || ", originStates));
                ArrayList<String> results = originStates.convertAll(o -> o + " && \\result == " + operation.id);
                ensuredResults.add(String.join(" || ", results));
                ControlBuilder choice = method.appendControl("if (" + String.join(" || ", originStates) + ")");
                choice.appendStatement("choice = " + operation.id + ";");
                choice.appendStatement("return " + operation.id + ";");
            }
            method.appendStatement("throw new Exception();");
            method.appendComment("@ context Perm(state, 1) ** Perm(choice, 1);");
            method.appendComment("@ requires choice == -1 && (" + String.join(" || ", requiredStates) +");");
            method.appendComment("@ ensures (" + String.join(" || ", ensuredResults) + ") && \\old(state) == state && \\result == choice;");
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

    /**
     * Generate the "private ScribMessage receiveScribMessage(Role role)" method which willl receive the ScribMessage internally.
     */
    void generateReceiver() {
        MethodBuilder method = classBuilder.appendMethod("private", "ScribMessage", "receiveScribMessage", new ArrayList<>("Role role"), "Exception");
        if (hasExternalChoice) {
            ControlBuilder ifChoiceMade = method.appendControl("if (choiceMade)");
            ifChoiceMade.appendStatement("choiceMade = false;");
            ifChoiceMade.appendStatement("return chosenMessage;");
        }
        method.appendStatement("return receiveSocket.readScribMessage(role);");
    }

    /**
     * Generate the method for a message passing operation.
     * @param operation The operation for which to generate the method
     * @param verificationSkeleton true if this is the operation on the verification side, false otherwise.
     */
    void generateOperation(Operation operation, boolean verificationSkeleton) {
        MethodBuilder method = classBuilder.appendMethod("public", operation.getReturnType(), operation.getFullName(), operation.getParameters(), "Exception");
        if (verificationSkeleton)
            generateVerification(operation, method);
        else
            generateExecutableCode(operation, method);
    }

    /**
     * Generate the method to be executed for a message passing operation.
     * @param operation The operation for which to generate the method
     * @param method The method for the operation.
     */
    void generateExecutableCode(Operation operation, MethodBuilder method) {
        generateContract(operation, method);
        if (operation.payload.isSend) {
            ArrayList<String> parameters = new ArrayList<>(operation.targetRole.toString(), operation.getName());
            parameters.addAll(operation.payload.contents.convertAll(a -> a.name));
            method.appendStatement("outputSocket.writeScribMessage(" + String.join(", ", parameters) + ");");
        } else if (operation.getReturnType().equals("void"))
            method.appendStatement("receiveScribMessage(" + operation.targetRole + ");");
        else if (operation.payload.name.isBlank())
            method.appendStatement(operation.getReturnType() + " res = (" + operation.getReturnType() + ")(receiveSocket.readScribMessage(" + operation.targetRole + ").payload[0]);");
        else {
            method.appendStatement("Object[] payload = receiveScribMessage(" + operation.targetRole + ").payload;");
            ArrayList<String> payloadParams = operation.payload.contents.combineAll(ArrayList.range(0, operation.payload.contents.size()), (a, i) -> "(" + a.type + ")payload[" + i + "]");
            method.appendStatement(operation.payload.name + " res = new " + operation.payload.name + "(" + String.join(", ", payloadParams) + ");");
        }
        generateStateChange(operation, method, false);
        if (!operation.getReturnType().equals("void"))
            method.appendStatement("return res;");
    }

    /**
     * Generate the method to be verified for a message passing operation.
     * @param operation The operation for which to generate the method
     * @param method The method for the operation.
     */
    void generateVerification(Operation operation, MethodBuilder method) {
        generateContract(operation, method);
        generateStateChange(operation, method, true);
        if (operation.isExternalChoice())
            method.appendStatement("choice = -1;");
        if (!operation.getReturnType().equals("void"))
            method.appendStatement(operation.payload.getDefaultReturnStatement());
    }

    /**
     * Generate the VerCors contract (permissions, preconditions, postconditions) for a message passing operation.
     * @param operation The operation for which to generate the contract
     * @param method The method for the operation.
     */
    void generateContract(Operation operation, MethodBuilder method) {
        method.appendComment("@ context Perm(state, 1)" + (operation.isExternalChoice() ? " ** Perm(choice, 1);" : ";"));
        String nonNullCondition = operation.payload.name.equals("") ? "" : " && \\result != null";
        String choiceRequirement = operation.isExternalChoice() ? " && choice == " + operation.id : "";
        String choiceGuarantee = operation.isExternalChoice() ? " && choice == " + -1 : "";
        if (operation.transitions.size() == 1) {
            StateTransition transition = operation.transitions.iterator().next();
            method.appendComment("@ requires state == " + transition.originState.id + choiceRequirement + ";");
            method.appendComment("@ ensures state == " + transition.targetState.id + choiceGuarantee + nonNullCondition + ";");
        }
        else {
            HashSet<String> preconditions = operation.transitions.convertAll(t -> "state == " + t.originState.id + (t.isExternalChoice() ? choiceRequirement : ""));
            HashSet<String> postconditions = operation.transitions.convertAll(t -> "\\old(state) == " + t.originState.id + " && state == " + t.targetState.id);
            method.appendComment("@ requires " + String.join(" || ", preconditions) + ";");
            method.appendComment("@ ensures (" + String.join(" || ", postconditions) + ")" + choiceGuarantee + nonNullCondition + ";");
        }

        if (!operation.payload.name.equals("")) {
            method.appendComment("@ ensures \\result.permAll();");
        }

    }

    /**
     * Generate a state change (changing the state attribute) for a message passing operation.
     * @param operation The operation for which to generate the state change
     * @param method The method for the operation.
     * @param vercorsSkeleton true if this is the operation on the verification side, false otherwise.
     */
    void generateStateChange(Operation operation, MethodBuilder method, boolean vercorsSkeleton) {
        if (operation.transitions.size() == 1) { // only one state transition exists for this operation
            StateTransition transition = operation.transitions.iterator().next();
            method.appendStatement("state = " + transition.targetState.id + ";");
            if (!vercorsSkeleton && transition.targetState.isTerminal()) { // if the protocol has reached the terminal state, the endpoint should be closed
                method.appendStatement("endpoint.setCompleted();");
                method.appendStatement("endpoint.close();");
            }
        }
        else { // multiple state transitions exists for this operation
            ControlBuilder stateSwitch = method.appendControl("switch(state)");
            HashSet<String> stateChanges = operation.transitions.convertAll(t -> "case " + t.originState.id + ": state = " + t.targetState.id + "; break;");
            stateSwitch.appendStatements(stateChanges);
            StateTransition terminal = operation.transitions.getMatch(t -> t.targetState.isTerminal());
            if (!vercorsSkeleton && terminal != null) { // if the protocol has reached the terminal state, the endpoint should be closed
                ControlBuilder terminalControl = method.appendControl("if (state == " + terminal.targetState.id + ")");
                terminalControl.appendStatement("endpoint.setCompleted();");
                terminalControl.appendStatement("endpoint.close();");
            }
        }
    }
}