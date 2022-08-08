package scribblevercors.codegen;

import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import org.scribble.util.ScribUtil;
import scribblevercors.util.ClassBuilder;
import scribblevercors.util.StringUtils;

import java.util.HashMap;
import java.util.Set;

public class ScribbleVerCorsCodeGenerator {
    private ScribbleVerCorsCodeGenerator() {}

    public static void generateFiles(Job job, GProtoName gpn, Role role, String dir, String vercorsDir) throws ScribException {
        ProtocolGenerator generator = new ProtocolGenerator(job, gpn, role);
        HashMap<String, String> files = generator.generateClasses(false);
        files.putAll(generator.generateUtilities(false));
        HashMap<String, String> verificationClasses = generator.generateClasses(true);
        verificationClasses.putAll(generator.generateUtilities(true));
        HashMap<String, String> main = generator.generateMainClass();
        files.putAll(generateBat(verificationClasses.keySet(), main.keySet().stream().findAny().get(), vercorsDir, role));
        files.putAll(main);
        files.putAll(verificationClasses);
        outputFiles(files, dir);
    }

    private static HashMap<String, String> generateBat(Set<String> classFiles, String mainFile, String vercorsDir, Role role) {
        HashMap<String, String> res = new HashMap<>();
        res.put("verify" + StringUtils.capitalise(role.toString()) + ".bat",
                "robocopy " + mainFile.substring(0, mainFile.lastIndexOf('\\')) + " verification-skeleton\\" + mainFile.substring(4, mainFile.lastIndexOf('\\')) + " " + mainFile.substring(mainFile.lastIndexOf('\\') + 1) + "\r\n" +
                "start \"Verifying Scribble Protocol\" " + vercorsDir + "/bin/vercors --silicon " + String.join(" ", classFiles)+ " verification-skeleton\\" + mainFile.substring(4));
        return res;
    }

    private static void outputFiles(HashMap<String, String> files, String dir) throws ScribException {
        for (String file : files.keySet())
            ScribUtil.writeToFile(dir + "\\" + file, files.get(file));
    }



}
