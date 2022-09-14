package scribblevercors.codegen;

import org.scribble.core.model.endpoint.EState;
import scribblevercors.util.ArrayList;

import java.util.List;

class RunMethodPool extends ArrayList<RunMethod> {

    int auxCounter = 0;
    EState initialState;
    EState terminalState;
    String protocolName;
    boolean terminalFound = false;

    RunMethodPool(EState initialState, String protocolName) {
        this.initialState = initialState;
        this.protocolName = protocolName;
    }

    /**
     * Find all the run methods needed.
     */
    void fillPool() {
        recursiveFill(initialState, new ArrayList<>());
    }

    /**
     * Find the run methods needed.
     */
    private void recursiveFill(EState currentState, ArrayList<Integer> statesTraversed) {
        if (initialState.id != currentState.id)
            statesTraversed.add(currentState.id);
        List<EState> succs = currentState.getSuccs();
        for (EState succ : succs)
            if (succ.isTerminal()) {
                if (!terminalFound)
                    add(0, new RunMethod(initialState, protocolName));
                terminalState = succ;
                terminalFound = true;
            }
            else if (statesTraversed.contains(succ.id))
                add(new RunMethod(succ, protocolName + "Aux" + ++auxCounter));
            else
                recursiveFill(succ, statesTraversed);
    }

}
