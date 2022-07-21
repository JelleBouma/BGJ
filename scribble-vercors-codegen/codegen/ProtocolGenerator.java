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
import java.util.stream.IntStream;

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
        if (!verificationSkeleton)
            generateImports();
        generateAttributes(verificationSkeleton);
        ArrayList<String> constructorParams = new ArrayList<>("int port");
        if (isClient)
            constructorParams.add(0, "String host");
        generateConstructor(classBuilder.createConstructor("public", constructorParams, "Exception"), verificationSkeleton);
        if (hasExternalChoice)
            addExternalChoiceReceive(verificationSkeleton);
        for (Operation operation : operations) {
            addOperation(operation, verificationSkeleton);
            if (!operation.payload.name.isEmpty())
                res.putAll(operation.payload.getPayloadClass().mapContentsToFileName(dir));
        }
        res.putAll(classBuilder.mapContentsToFileName(dir));
        return res;
    }

    void generateImports() {
        classBuilder.appendImport("org.scribble.core.type.name.Op");
        classBuilder.appendImport("org.scribble.core.type.name.Role");
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

    void addExternalChoiceReceive(boolean verificationSkeleton) {
        if (verificationSkeleton) {
            MethodBuilder method = classBuilder.appendMethod("public", "int", "receiveExternalChoice");
            method.appendComment("@ context Perm(state, 1) ** Perm(choice, 1);");
            HashSet<String> startingStates = externalChoiceTransitions.convertAll(t -> "state == " + t.originState.id);
            method.appendComment("@ requires choice == -1 && (" + String.join(" || ", startingStates) +");");
            ArrayList<String> results = externalChoices.convertAll(o -> "\\result == " + o.id);
            method.appendComment("@ ensures (" + String.join(" || ", results) + ") && \\old(state) == state && \\result == choice;");
            method.appendStatement("choice = " + externalChoices.first().id + ";");
            method.appendStatement("return " + externalChoices.first().id + ";");
        }
    }

    void addOperation(Operation operation, boolean verificationSkeleton) {
        MethodBuilder method = classBuilder.appendMethod("public", operation.getReturnType(), StringUtils.decapitalise(operation.getName()), operation.getParameters(), "Exception");
        if (verificationSkeleton)
            addVerification(operation, method);
        else
            addExecutableCode(operation, method);
    }

    void addExecutableCode(Operation operation, MethodBuilder method) {
        for (StateTransition transition : operation.transitions) // FIXME: problematic when an operation has multiple state transitions.
            if (operation.payload.isSend) {
                ArrayList<String> parameters = new ArrayList<>(transition.targetRole.toString(), "Op.EMPTY_OP");
                parameters.addAll(operation.payload.contents.convertAll(a -> a.name));
                method.appendStatement("new OutputSocket<Session, Role>(endpoint).writeScribMessage(" + String.join(", ", parameters) + ");");
            }
            else if (operation.getReturnType().equals("void"))
                method.appendStatement("new ReceiveSocket<Session, Role>(endpoint).readScribMessage(" + transition.targetRole + ");");
            else if (operation.payload.name.isBlank())
                method.appendStatement("return (" + operation.getReturnType() + ")(new ReceiveSocket<Session, Role>(endpoint).readScribMessage(" + transition.targetRole + ").payload[0]);");
            else {
                method.appendStatement("Object[] payload = new ReceiveSocket<Session, Role>(endpoint).readScribMessage(" + transition.targetRole + ").payload;");
                ArrayList<String> payloadParams = operation.payload.contents.combineAll(ArrayList.range(0, operation.payload.contents.size()), (a, i) -> "(" + a.type + ")payload[" + i + "]");
                method.appendStatement("return new " + operation.payload.name + "(" + String.join(", ", payloadParams) + ");");
            }
    }

    void addVerification(Operation operation, MethodBuilder method) {
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