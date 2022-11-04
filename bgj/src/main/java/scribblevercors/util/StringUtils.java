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

    /**
     * String.join where blank strings are filtered out first.
     * @see String#join(CharSequence, Iterable)
     */
    public static String trimJoin(String delimiter, String... strings) {
        return trimJoin(delimiter, new ArrayList<>(strings));
    }

    /**
     * String.join where blank strings are filtered out first.
     * @see String#join(CharSequence, Iterable)
     */
    public static String trimJoin(String delimiter, ArrayList<String> strings) {
        return String.join(delimiter, strings.filter(s -> !s.isBlank()));
    }

}
