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
    String setName = "";

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
     * Adds payload types to name to prevent generated methods from having the same erasure.
     */
    void distinguish() {
        setName = getName() + payload;
        if (!payload.name.isBlank())
            payload.name = setName + "Payload";
    }

    /**
     * @return name of the operation. If name is empty, or starts with a number: "send" or "receive" are prefixed to it.
     */
    String getName() {
        String name = setName.isBlank() ? action.mid.toString() : setName;
        if (name.equals("EMPTY_OP"))
            name = action.isSend() ? "send" : "receive";
        else if (Character.isDigit(name.charAt(0)))
            name = (action.isSend() ? "send" : "receive") + name;
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