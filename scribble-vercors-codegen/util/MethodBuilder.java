package scribblevercors.util;

import java.util.ArrayList;
import java.util.Arrays;

public class MethodBuilder extends ControlBuilder {

    MethodBuilder(String access, String returnType, String name, String... parameters) {
        super(1, String.join(" ", access, returnType, name) + "(" + String.join(", ", parameters) + ")");
    }
}
