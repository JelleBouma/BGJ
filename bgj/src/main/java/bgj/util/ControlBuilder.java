package bgj.util;

public class ControlBuilder extends BlockBuilder {
    private int depth;
    private String controlStatement;
    private ArrayList<BlockBuilder> content = new ArrayList<>();

    ControlBuilder(int depth, String controlStatement) {
        this.depth = depth;
        this.controlStatement = controlStatement;
    }

    public ControlBuilder appendControl(String controlStatement) {
        ControlBuilder res = new ControlBuilder(depth + 1, controlStatement);
        content.add(res);
        return res;
    }

    public ControlBuilder appendStatements(Iterable<String> statements) {
        for (String statement : statements)
            content.add(new StatementBuilder(depth + 1, statement));
        return this;
    }

    public ControlBuilder appendStatement(String statement) {
        content.add(new StatementBuilder(depth + 1, statement));
        return this;
    }

    @Override
    public String toString() {
        StringBuilder res = new StringBuilder();
        res.appendLine(depth, controlStatement);
        res.appendBlock(depth, content.convertAll(BlockBuilder::toString));
        return res.toString();
    }

}
