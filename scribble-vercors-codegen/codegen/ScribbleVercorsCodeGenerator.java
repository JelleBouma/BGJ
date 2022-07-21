package scribblevercors.codegen;

import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import org.scribble.util.ScribUtil;

import java.util.HashMap;
import java.util.Set;

public class ScribbleVercorsCodeGenerator {
    private ScribbleVercorsCodeGenerator() {}

    public static void generateFiles(Job job, GProtoName gpn, Role role, String dir, String vercorsDir) throws ScribException {
        ProtocolGenerator generator = new ProtocolGenerator(job, gpn, role);
        HashMap<String, String> files = generator.generateClasses(false);
        HashMap<String, String> verificationClasses = generator.generateClasses(true);
        files.putAll(generateBat(verificationClasses.keySet(), vercorsDir));
        files.putAll(verificationClasses);
        outputFiles(files, dir);
    }

    private static HashMap<String, String> generateBat(Set<String> classFiles, String vercorsDir) {
        HashMap<String, String> res = new HashMap<>();
        res.put("verify.bat", "start \"Verifying Scribble Protocol\" " + vercorsDir + "/bin/vercors --silicon " + String.join(" ", classFiles));
        return res;
    }

    private static void outputFiles(HashMap<String, String> files, String dir) throws ScribException {
        for (String file : files.keySet())
            ScribUtil.writeToFile(dir + "\\" + file, files.get(file));
    }



}
