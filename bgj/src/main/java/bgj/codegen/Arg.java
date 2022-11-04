package bgj.codegen;

public class Arg {
    String type;
    String defaultValue;
    String name;
    String classPath;

    Arg (String type, String defaultValue, String name) {
        this(type, defaultValue, name, "");
    }

    Arg (String type, String defaultValue, String name, String classPath) {
        this.type = type;
        this.defaultValue = defaultValue;
        this.name = name;
        this.classPath = classPath;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Arg arg = (Arg) o;
        return type.equals(arg.type);
    }
}