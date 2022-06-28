package scribblevercors.codegen;

import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.DataName;
import org.scribble.core.type.name.PayElemType;
import scribblevercors.util.ArrayList;
import scribblevercors.util.ClassBuilder;
import scribblevercors.util.MethodBuilder;
import scribblevercors.util.StringUtils;

class Payload {
    String name; // Has the class name of the payload if applicable, otherwise an empty string.
    boolean isSend;
    ArrayList<Arg> contents = new ArrayList<>();

    Payload(EAction action) {
        isSend = action.isSend();
        name = action.isReceive() && action.payload.elems.size() >= 2 ? StringUtils.capitalise(action.mid.toString()) + "Payload" : "";
        if (!action.payload.isEmpty())
        {
            int counter = 0;
            for (PayElemType<?> pt : action.payload.elems)
            {
                String typeName = ProtocolGenerator.main.getTypeDeclChild((DataName) pt).getExtName();
                addArg(typeName, "arg" + counter);
                counter++;
            }
        }
    }

    /**
     * Adds a type to the payload, stripping any package paths.
     * If the type is an object representation of a primitive (such as java.lang.Integer), the primitive is used instead.
     */
    private void addArg(String typeName, String name) {
        switch (typeName) {
            case "java.lang.Boolean":
                contents.add(new Arg("boolean", "false", name));
                break;
            case "java.lang.Byte":
                contents.add(new Arg("byte", "0", name));
                break;
            case "java.lang.Short":
                contents.add(new Arg("short", "0", name));
                break;
            case "java.lang.Char":
                contents.add(new Arg("char", "'\\u0000'", name));
                break;
            case "java.lang.Integer":
                contents.add(new Arg("int", "0", name));
                break;
            case "java.lang.Float":
                contents.add(new Arg("float", "0.0f", name));
                break;
            case "java.lang.Long":
                contents.add(new Arg("long", "0L", name));
                break;
            case "java.lang.Double":
                contents.add(new Arg("double", "0.0d", name));
                break;
            default:
                String[] typeParts = typeName.split("\\.");
                contents.add(new Arg(typeParts[typeParts.length - 1], "null", name));
        }
    }

    String getReturnType() {
        return isSend || contents.size() == 0 ? "void" : name.equals("") ? contents.get(0).type : name;
    }

    String getReturnStatement(ArrayList<String> args) {
        return "return " + (name.equals("") ? args.get(0) : "new " + name + "(" + String.join(", ", args) + ")") + ";";
    }

    String getDefaultReturnStatement() {
        return getReturnStatement(contents.convertAll(a -> a.defaultValue));
    }

    ArrayList<String> getParameters() {
        return isSend ? contents.convertAll(a -> a.type + " " + a.name) : new ArrayList<>();
    }

    ClassBuilder getPayloadClass() {
        ClassBuilder cb = new ClassBuilder(ProtocolGenerator.pkg, "public", name);
        MethodBuilder constructor = cb.createConstructor("public", contents.convertAll(a -> a.type + " " + a.name));
        for (Arg arg : contents) {
            cb.appendAttribute("public", arg.type, arg.name);
            constructor.appendStatement("this." + arg.name + " = " + arg.name + ";");
        }
        return cb;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Payload payload = (Payload) o;
        return contents.equals(payload.contents);
    }
}
