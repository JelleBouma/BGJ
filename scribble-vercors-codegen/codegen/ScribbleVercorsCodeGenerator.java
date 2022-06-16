package scribblevercors.codegen;

import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;

import java.util.HashMap;

public class ScribbleVercorsCodeGenerator {
    private ScribbleVercorsCodeGenerator() {}

    public static HashMap<String, String> generateClasses(Job job, GProtoName gpn, Role role) throws ScribException {
        SessionGenerator generator = new SessionGenerator(job, gpn, role);
        HashMap<String, String> res = generator.generateClasses(false);
        res.putAll(generator.generateClasses(true));
        return res;
    }

}
