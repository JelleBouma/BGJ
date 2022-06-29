package scribblevercors.util;

public class MethodBuilder extends ControlBuilder {

    ArrayList<String> comments = new ArrayList<>();

    MethodBuilder(int depth, String access, String returnType, String name, ArrayList<String> parameters) {
        super(depth, StringUtils.trimJoin(" ", access, returnType, name) + "(" + StringUtils.trimJoin(", ", parameters) + ")");
    }

    public void appendComment(String comment) {
        comments.add("//" + comment);
    }

}