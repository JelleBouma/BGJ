package scribblevercors.util;

public class ClassBuilder {

    private String pkg;
    private ArrayList<String> imports = new ArrayList<>();
    private String access;
    private String name;
    private ArrayList<String> attributes = new ArrayList<>();
    private ArrayList<MethodBuilder> methods = new ArrayList<>();

    public ClassBuilder(String pkg, String access, String name) {
        this.pkg = pkg;
        this.access = access;
        this.name = name;
    }

    public void appendAttribute(String access, String type, String name) {
        attributes.add(type + " " + name + ";");
    }

    public void appendImport(String imprt) {
        imports.add(imprt);
    }

    public MethodBuilder createConstructor(String access, ArrayList<String> parameters) {
        MethodBuilder res = new MethodBuilder(access, "", name, parameters);
        methods.add(0, res);
        return res;
    }

    public MethodBuilder appendMethod(String access, String returnType, String name, ArrayList<String> parameters) {
        MethodBuilder res = new MethodBuilder(access, returnType, name, parameters);
        methods.add(res);
        return res;
    }

    private String buildIdentifier() {
        return String.join(" ", access, "class", name);
    }

    private String buildBlock() {
        StringBuilder res = new StringBuilder();
        for (String attribute : attributes)
            res.appendLine(1, attribute);
        for (MethodBuilder method : methods) {
            res.skipLine(1);
            for (String comment : method.comments)
                res.appendLine(1, comment);
            res.append(method.toString());
        }
        return res.toString();
    }

    @Override
    public String toString() {
        StringBuilder res = new StringBuilder();
        if (!pkg.isBlank()) {
            res.appendLine(0, "package " + pkg + ";");
            res.skipLine(0);
        }
        for (String imprt : imports)
            res.appendLine(0, "import " + imprt + ";");
        res.skipLine(0);
        res.appendLine(0, buildIdentifier());
        res.appendBlock(0, buildBlock());
        return res.toString();
    }
}
