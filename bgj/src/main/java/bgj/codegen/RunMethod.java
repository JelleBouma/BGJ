package bgj.codegen;

import org.scribble.core.model.endpoint.EState;

import java.util.Objects;

/**
 * A run method representation consisting of a starting EState and a name.
 * An object of this class represents a method we need to generate for the implementation (the generated main class).
 */
public class RunMethod {
    EState head;
    String name;

    RunMethod(EState head, String name) {
        this.head = head;
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RunMethod runMethod = (RunMethod) o;
        return head.id == runMethod.head.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(head);
    }
}
