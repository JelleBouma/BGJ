package scribblevercors.util;

public class MethodBuilder extends ControlBuilder {

    ArrayList<String> comments = new ArrayList<>();

    MethodBuilder(String access, String returnType, String name, String... parameters) {
        super(1, String.join(" ", access, returnType, name) + "(" + String.join(", ", parameters) + ")");
    }

    MethodBuilder(String access, String returnType, String name, ArrayList<String> parameters) {
        super(1, String.join(" ", access, returnType, name) + "(" + String.join(", ", parameters) + ")");
    }

    public void appendComment(String comment) {
        comments.add("//" + comment);
    }

}