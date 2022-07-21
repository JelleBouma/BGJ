package scribblevercors.util;

public class MethodBuilder extends ControlBuilder {

    ArrayList<String> comments = new ArrayList<>();

    MethodBuilder(int depth, String access, String returnType, String name, ArrayList<String> parameters) {
        this(depth, access, returnType, name, parameters, "");
    }

    MethodBuilder(int depth, String access, String returnType, String name, ArrayList<String> parameters, String throwing) {
        super(depth, StringUtils.trimJoin(" ", access, returnType, name) + "(" + StringUtils.trimJoin(", ", parameters) + ")" + (throwing.isBlank() ? "" : " throws " + throwing));
    }

    public void appendComment(String comment) {
        comments.add("//" + comment);
    }

}