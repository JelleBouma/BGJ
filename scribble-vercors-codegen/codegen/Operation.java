package scribblevercors.codegen;

import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.Role;
import scribblevercors.util.ArrayList;
import scribblevercors.util.HashSet;
import scribblevercors.util.StringUtils;

public class Operation {

    int id;
    HashSet<StateTransition> transitions = new HashSet<>();
    EAction action;
    Payload payload;
    Role targetRole;

    Operation(int id, EState origin, EAction eAction, EState target) {
        this.id = id;
        action = eAction;
        transitions.add(new StateTransition(origin, target));
        payload = new Payload(action);
        targetRole = action.obj;
    }

    void addTransitions(HashSet<StateTransition> toBeAdded) {
        this.transitions.addAll(toBeAdded);
    }

    String getReturnType() {
        return payload.getReturnType();
    }

    /**
     * @return name of the operation. If none is defined: "send" or "receive" respectively.
     */
    String getName() {
        String name = action.mid.toString();
        if (name.equals("EMPTY_OP"))
            name = action.isSend() ? "send" : "receive";
        return name;
    }

    /**
     * @return operation name in format: nameDirectionRole
     */
    String getFullName() {
        String direction = action.isSend() ? "To" : "From";
        return StringUtils.decapitalise(getName()) + direction + StringUtils.capitalise(targetRole.toString());
    }

    ArrayList<String> getParameters() {
        return payload.getParameters();
    }

    /**
     * @param operation the operation to compare with this one
     * @return whether they have the same target role, direction, name (not case sensitive) and payload.
     */
    boolean hasSameSignature(Operation operation) {
        return targetRole == operation.targetRole && action.isSend() == operation.action.isSend() && getName().equalsIgnoreCase(operation.getName()) && payload.equals(operation.payload);
    }

    /**
     * @return whether this operation can be externally chosen.
     */
    boolean isExternalChoice() {
        return transitions.anyMatch(StateTransition::isExternalChoice);
    }
}