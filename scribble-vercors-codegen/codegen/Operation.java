package scribblevercors.codegen;

import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.DataName;
import org.scribble.core.type.name.PayElemType;
import scribblevercors.util.ArrayList;
import scribblevercors.util.HashSet;

public class Operation {

    HashSet<StateTransition> transitions = new HashSet<>();
    EAction action;
    Payload payload;

    Operation(int origin, EAction eAction, int target) {
        action = eAction;
        transitions.add(new StateTransition(origin, target, action.obj));
        payload = new Payload(action);
    }

    void addTransitions(HashSet<StateTransition> toBeAdded) {
        this.transitions.addAll(toBeAdded);
    }

    String getReturnType() {
        return payload.getReturnType();
    }

    String getName() {
        String name = action.mid.toString();
        if (name.equals("EMPTY_OP"))
            name = action.isSend() ? "send" : "receive";
        return name;
    }

    ArrayList<String> getParameters() {
        return payload.getParameters();
    }

    public boolean hasSameSignature(Operation operation) {
        return action.isSend() == operation.action.isSend() && getName().equalsIgnoreCase(operation.getName()) && payload.equals(operation.payload);
    }
}