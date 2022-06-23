package scribblevercors.util;

public class MethodBuilder extends ControlBuilder {

    ArrayList<String> comments = new ArrayList<>();

    MethodBuilder(String access, String returnType, String name, ArrayList<String> parameters) {
        super(1, StringUtils.trimJoin(" ", access, returnType, name) + "(" + StringUtils.trimJoin(", ", parameters) + ")");
    }

    public void appendComment(String comment) {
        comments.add("//" + comment);
    }

}