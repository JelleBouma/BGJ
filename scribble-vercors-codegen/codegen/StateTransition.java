package scribblevercors.codegen;

import org.scribble.core.type.name.Role;

import java.util.Objects;

class StateTransition {
    int originState;
    int targetState;
    Role targetRole;

    StateTransition(int originState, int targetState, Role targetRole) {
        this.originState = originState;
        this.targetState = targetState;
        this.targetRole = targetRole;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StateTransition that = (StateTransition) o;
        return originState == that.originState && targetState == that.targetState && targetRole.equals(that.targetRole);
    }

    @Override
    public int hashCode() {
        return Objects.hash(originState, targetState, targetRole);
    }
}
