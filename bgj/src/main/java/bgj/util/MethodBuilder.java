package bgj.util;

public class MethodBuilder extends ControlBuilder {

    ArrayList<String> comments = new ArrayList<>();

    MethodBuilder(int depth, String access, String returnType, String name, ArrayList<String> parameters) {
        this(depth, access, returnType, name, parameters, "");
    }

    MethodBuilder(int depth, String access, String returnType, String name, ArrayList<String> parameters, String throwing) {
        this(depth, access, false, returnType, name, parameters, throwing);
    }

    MethodBuilder(int depth, String access, boolean statik, String returnType, String name, ArrayList<String> parameters, String throwing) {
        super(depth, StringUtils.trimJoin(" ", access, statik ? "static" : "", returnType, name) + "(" + StringUtils.trimJoin(", ", parameters) + ")" + (throwing.isBlank() ? "" : " throws " + throwing));
    }

    public void appendComment(String comment) {
        comments.add("//" + comment);
    }

}