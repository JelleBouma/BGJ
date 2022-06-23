package scribblevercors.codegen;

import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.EStateKind;
import org.scribble.core.type.name.Role;

import java.util.Objects;

class StateTransition {
    EState originState;
    EState targetState;
    Role targetRole;

    StateTransition(EState originState, EState targetState, Role targetRole) {
        this.originState = originState;
        this.targetState = targetState;
        this.targetRole = targetRole;
    }

    boolean isExternalChoice() {
        return originState.getStateKind() == EStateKind.POLY_RECIEVE;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StateTransition that = (StateTransition) o;
        return originState.id == that.originState.id && targetState.id == that.targetState.id && targetRole.equals(that.targetRole);
    }

    @Override
    public int hashCode() {
        return Objects.hash(originState.id, targetState.id, targetRole);
    }
}
