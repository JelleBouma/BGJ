package scribblevercors.util;

import java.util.Locale;

public class StringUtils {

    private StringUtils(){}

    public static String capitalise(String str) {
        return str.substring(0, 1).toUpperCase(Locale.ROOT) + str.substring(1);
    }

    public static String decapitalise(String str) {
        return str.substring(0, 1).toLowerCase(Locale.ROOT) + str.substring(1);
    }

}
