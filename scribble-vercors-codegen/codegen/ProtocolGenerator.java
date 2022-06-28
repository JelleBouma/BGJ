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

import java.util.HashMap;
import java.util.Locale;

class ProtocolGenerator {

    static String pkg;
    static String className;
    Job job;
    static Module main;
    Core core;
    GProtoName gpn;
    Role role;
    EState initialState;
    ClassBuilder classBuilder;
    OperationPool operations = new OperationPool();
    ArrayList<Operation> externalChoices;
    HashSet<StateTransition> externalChoiceTransitions = new HashSet<>();
    boolean hasExternalChoice;

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
        System.out.println(initialState.toAut());
        operations.fillPool(initialState);
        externalChoices = operations.filter(Operation::isExternalChoice);
        hasExternalChoice = !externalChoices.isEmpty();
        for (Operation operation : externalChoices)
            externalChoiceTransitions.addAll(operation.transitions.filter(StateTransition::isExternalChoice));
        processNames();
    }

    void processNames() {
        className = StringUtils.capitalise(gpn.getSimpleName().toString());
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
        generateConstructor(classBuilder.createConstructor("public"), verificationSkeleton);
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

    void generateAttributes(boolean verificationSkeleton) {
        if (verificationSkeleton) {
            classBuilder.appendAttribute("", "int", "state");
            if (hasExternalChoice)
                classBuilder.appendAttribute("", "int", "choice");
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
        MethodBuilder method = classBuilder.appendMethod("public", operation.getReturnType(), StringUtils.decapitalise(operation.getName()), operation.getParameters());
        if (verificationSkeleton)
            addVerification(operation, method);
        else
            addExecutableCode(operation, method);
    }

    void addExecutableCode(Operation operation, MethodBuilder method) {
        // TODO
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