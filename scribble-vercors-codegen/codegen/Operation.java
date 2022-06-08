package scribblevercors.codegen;

import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.DataName;
import org.scribble.core.type.name.PayElemType;
import scribblevercors.util.ArrayList;
import scribblevercors.util.HashSet;

public class Operation {

    HashSet<StateTransition> transitions = new HashSet<>();
    EAction action;
    ArrayList<String> payload = new ArrayList<>();

    Operation(int origin, EAction eAction, int target) {
        action = eAction;
        transitions.add(new StateTransition(origin, target, action.obj));
        if (!action.payload.isEmpty())
        {
            int counter = 0;
            for (PayElemType<?> pt : action.payload.elems)
            {
                String typeName = SessionGenerator.main.getTypeDeclChild((DataName) pt).getExtName();
                typeName = objectTypeToPrimitive(typeName);
                String[] typeParts = typeName.split("\\.");
                String argSuffix = action.isSend() ? " arg" + counter : "";
                payload.add(typeParts[typeParts.length - 1] + argSuffix);
                counter++;
            }
        }
    }

    /**
     * If the type is an object representation of a primitive (such as java.lang.Integer), convert it to the primitive.
     * @return The primitive the object represents, if not applicable the input String is returned instead.
     */
    private String objectTypeToPrimitive(String objectType) {
        switch (objectType) {
            case "java.lang.Boolean":
                return "boolean";
            case "java.lang.Byte":
                return "byte";
            case "java.lang.Short":
                return "short";
            case "java.lang.Char":
                return "char";
            case "java.lang.Integer":
                return "int";
            case "java.lang.Float":
                return "float";
            case "java.lang.Long":
                return "long";
            case "java.lang.Double":
                return "double";
            default: return objectType;
        }
    }

    void addTransitions(HashSet<StateTransition> toBeAdded) {
        this.transitions.addAll(toBeAdded);
    }

    String getReturnType() {
        return action.isSend() ? "void" : payload.get(0);
    }

    String getName() {
        return action.mid.toString();
    }

    ArrayList<String> getParameters() {
        return action.isSend() ? payload : new ArrayList<>();
    }

    public boolean hasSameSignature(Operation operation) {
        return action.isSend() == operation.action.isSend() && getName().equalsIgnoreCase(operation.getName()) && payload.equals(operation.payload);
    }
}