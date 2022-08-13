package scribblevercors.codegen;

import org.scribble.core.model.endpoint.EState;
import org.scribble.core.model.endpoint.actions.EAction;
import org.scribble.core.type.name.Role;
import scribblevercors.util.ArrayList;
import scribblevercors.util.HashSet;

import java.util.Iterator;
import java.util.Set;

public class OperationPool extends ArrayList<Operation> {

    public void fillPool(EState initialState) {
        Set<EState> all = new HashSet<>();
        all.add(initialState);
        all.addAll(initialState.getReachableStates());
        int counter = 0;
        for (EState s : all)
        {
            Iterator<EAction> as = s.getActions().iterator();
            Iterator<EState> succs = s.getSuccs().iterator();
            while (as.hasNext())
                add(new Operation(counter++, s, as.next(), succs.next()));
        }
    }

    @Override
    public boolean add(Operation toBeAdded) {
        for (Operation op : this)
            if (op.hasSameSignature(toBeAdded)) {
                op.addTransitions(toBeAdded.transitions);
                return false;
            }
        return super.add(toBeAdded);
    }

    public ArrayList<Role> getTargetRoles() {
        ArrayList<Role> res = new ArrayList<>();
        for (Operation op : this)
            if (!res.contains(op.targetRole))
                res.add(op.targetRole);
        return res;
    }
}
