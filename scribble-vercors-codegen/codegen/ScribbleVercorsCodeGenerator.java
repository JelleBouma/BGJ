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
        HashMap<String, String> main = generator.generateMainClass();
        files.putAll(generateBat(verificationClasses.keySet(), main.keySet().stream().findAny().get(), vercorsDir));
        files.putAll(main);
        files.putAll(verificationClasses);
        outputFiles(files, dir);
    }

    private static HashMap<String, String> generateBat(Set<String> classFiles, String mainFile, String vercorsDir) {
        HashMap<String, String> res = new HashMap<>();

        res.put("verify.bat",
                "robocopy " + mainFile.substring(0, mainFile.lastIndexOf('\\')) + " verification-skeleton\\" + mainFile.substring(4, mainFile.lastIndexOf('\\')) + " " + mainFile.substring(mainFile.lastIndexOf('\\') + 1) + "\r\n" +
                "start \"Verifying Scribble Protocol\" " + vercorsDir + "/bin/vercors --silicon " + String.join(" ", classFiles)+ " verification-skeleton\\" + mainFile.substring(4));
        return res;
    }

    private static void outputFiles(HashMap<String, String> files, String dir) throws ScribException {
        for (String file : files.keySet())
            ScribUtil.writeToFile(dir + "\\" + file, files.get(file));
    }



}
