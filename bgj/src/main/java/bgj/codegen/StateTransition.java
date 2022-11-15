package bgj.codegen;

import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.EStateKind;

import java.util.Objects;

/**
 * A transition from a state to another state, part of an Operation.
 */
class StateTransition {
    EState originState;
    EState targetState;

    StateTransition(EState originState, EState targetState) {
        this.originState = originState;
        this.targetState = targetState;
    }

    boolean isExternalChoice() {
        return originState.getStateKind() == EStateKind.POLY_RECIEVE;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StateTransition that = (StateTransition) o;
        return originState.id == that.originState.id && targetState.id == that.targetState.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(originState.id, targetState.id);
    }
}
