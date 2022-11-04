package bgj.util;

public class StatementBuilder extends BlockBuilder {
    private int depth;
    private String statement;

    StatementBuilder(int depth, String statement) {
        this.statement = statement;
        this.depth = depth;
    }

    @Override
    public String toString() {
        return new StringBuilder().appendLine(depth, statement).toString();
    }
}