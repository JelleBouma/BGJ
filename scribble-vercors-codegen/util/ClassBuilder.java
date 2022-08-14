package scribblevercors.util;

import java.util.HashMap;

public class ClassBuilder {

    private String pkg = "";
    private ArrayList<String> imports = new ArrayList<>();
    private String access = "";
    private String name;
    private String extendsLine = "";
    private ArrayList<String> attributes = new ArrayList<>();
    private ArrayList<MethodBuilder> methods = new ArrayList<>();
    private ArrayList<ClassBuilder> inners = new ArrayList<>();
    private int depth = 0;

    public ClassBuilder(String pkg, String access, String name) {
        this(pkg, access, name, "");
    }

    public ClassBuilder(String pkg, String access, String name, String extending) {
        this.pkg = pkg;
        this.access = access;
        this.name = name;
        this.extendsLine = extending.isBlank() ? "" : "extends " + extending;
    }

    public void appendImport(String imprt) {
        imports.add(imprt);
    }

    public void appendAttribute(String type, String name) {
        appendAttribute("", type, name);
    }

    public void appendAttribute(String access, String type, String name) {
        appendAttribute(access, type, name, false, false);
    }

    public void appendAttribute(String access, String type, String name, String assignment) {
        appendAttribute(access, type, name, assignment, false, false);
    }

    public void appendAttribute(String access, String type, String name, boolean statik, boolean finall) {
        appendAttribute(access, type, name, "", statik, finall);
    }

    public void appendAttribute(String access, String type, String name, String assignment, boolean statik, boolean finall) {
        ArrayList<String> parts = new ArrayList<>(access);
        if (statik)
            parts.add("static");
        if (finall)
            parts.add("final");
        parts.addAll(type, name);
        parts.removeIf(String::isBlank);
        if (!assignment.isBlank())
            parts.addAll("=", assignment);
        attributes.add(String.join(" ", parts) + ";");
    }

    public MethodBuilder createConstructor(String access, ArrayList<String> parameters) {
        MethodBuilder res = new MethodBuilder(depth + 1, access, "", name, parameters);
        methods.add(0, res);
        return res;
    }

    public MethodBuilder createConstructor(String access, ArrayList<String> parameters, String throwing) {
        MethodBuilder res = new MethodBuilder(depth + 1, access, "", name, parameters, throwing);
        methods.add(0, res);
        return res;
    }

    public MethodBuilder appendMethod(String access, String returnType, String name, ArrayList<String> parameters, String throwing) {
        return appendMethod(access, false, returnType, name, parameters, throwing);
    }

    public MethodBuilder appendMethod(String access, boolean statik, String returnType, String name, ArrayList<String> parameters, String throwing) {
        MethodBuilder res = new MethodBuilder(depth + 1, access, statik, returnType, name, parameters, throwing);
        methods.add(res);
        return res;
    }

    String buildIdentifier() {
        return StringUtils.trimJoin(" ", access, "class", name, extendsLine);
    }

    String buildBlock() {
        StringBuilder res = new StringBuilder();
        for (String attribute : attributes) // build attributes
            res.appendLine(depth + 1, attribute);
        for (ClassBuilder inner : inners) { // build inner classes
            res.skipLine(depth + 1);
            res.appendLine(depth + 1, inner.buildIdentifier());
            res.appendBlock(depth + 1, inner.buildBlock());
        }
        for (MethodBuilder method : methods) { // build methods
            res.skipLine(depth + 1);
            for (String comment : method.comments)
                res.appendLine(depth + 1, comment);
            res.append(method.toString());
        }
        return res.toString();
    }

    public HashMap<String, String> mapContentsToFileName(String directory) {
        HashMap<String, String> res = new HashMap<>();
        res.put(directory + pkg.replace('.', '\\') + (pkg.isEmpty() ? "" : "\\") + name + ".java", toString());
        return res;
    }

    @Override
    public String toString() {
        StringBuilder res = new StringBuilder();
        if (!pkg.isBlank()) { // build package declaration
            res.appendLine(0, "package " + pkg + ";");
            res.skipLine(0);
        }
        for (String imprt : imports) // build imports
            res.appendLine(0, "import " + imprt + ";");
        res.skipLine(0);
        res.appendLine(0, buildIdentifier());
        res.appendBlock(0, buildBlock());
        return res.toString();
    }
}
