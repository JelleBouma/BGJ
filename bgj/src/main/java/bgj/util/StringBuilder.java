package bgj.util;

public class StringBuilder {
    java.lang.StringBuilder internal = new java.lang.StringBuilder();

    public StringBuilder append(String toAppend) {
        internal.append(toAppend);
        return this;
    }

    public StringBuilder skipLine(int tabs) {
        return appendLine(tabs, "");
    }

    public StringBuilder appendLine(int tabs, String toAppend) {
        append("\t".repeat(tabs)).append(toAppend).append("\r\n");
        return this;
    }

    public StringBuilder appendBlock(int tabs, String lines) {
        appendLine(tabs, "{");
        append(lines);
        appendLine(tabs, "}");
        return this;
    }

    public StringBuilder appendBlock(int tabs, ArrayList<String> lines) {
        appendLine(tabs, "{");
        for (String line : lines)
            append(line);
        appendLine(tabs, "}");
        return this;
    }

    @Override
    public String toString() {
        return internal.toString();
    }
}