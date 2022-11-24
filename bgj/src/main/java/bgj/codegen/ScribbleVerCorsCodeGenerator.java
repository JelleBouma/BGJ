package bgj.codegen;

import org.scribble.core.type.name.GProtoName;
import org.scribble.core.type.name.Role;
import org.scribble.job.Job;
import org.scribble.util.ScribException;
import org.scribble.util.ScribUtil;
import bgj.util.StringUtils;

import java.io.File;
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
        files.putAll(generateScripts(verificationClasses.keySet(), generator.className + "Main.java", vercorsDir, gpn, role));
        files.putAll(main);
        files.putAll(verificationClasses);
        outputFiles(files, dir);
    }

    private static HashMap<String, String> generateScripts(Set<String> classFiles, String mainFile, String vercorsDir, GProtoName gpn, Role role) {
        HashMap<String, String> res = new HashMap<>();

        // vercorsDir   = JAVA_HOME? ; VERCORS_HOME?
        // JAVA_HOME    = "java:" <path>
        // VERCORS_HOME = "vercors:" <path>
        String[] strings = vercorsDir.split(";");
        String javaHome = null;
        String vercorsHome = null;
        for (String s : strings) {
            javaHome = s.startsWith("java:") ? s.substring(s.indexOf(":") + 1) : javaHome;
            vercorsHome = s.startsWith("vercors:") ? s.substring(s.indexOf(":") + 1) : vercorsHome;
        }

        String script = "";
        script += "cp -r abstr tmp\n";
        script += "cp $@ tmp\n";
        script += "sed -i.bak '/^package/d' tmp/*.java\n";
        script += javaHome == null ? "" : ("export JAVA_HOME=" + javaHome + "\n");
        script += vercorsHome + "/bin/vercors --silicon tmp/*.java\n";
        script += "rm -r tmp\n";

        res.put(gpn.toString().replace(".", "/") + "/verify.sh", script);

        String dir = gpn.toString().replace(".", "\\") + "\\";
        res.put(dir + "verify.bat",
                "rmdir .\\tmp /s /q\r\n" +
                "robocopy . .\\tmp *.java\r\n" +
                "robocopy .\\abstr .\\tmp *.java\r\n" +
                "setlocal EnableExtensions DisableDelayedExpansion\r\n" +
                "set \"search=package \"\r\n" +
                "set \"replace=//package \"\r\n" +
                "set \"textFile=*.java\"\r\n" +
                "set \"rootDir=./tmp\"\r\n" +
                "for %%j in (\"%rootDir%\\%textFile%\") do (\r\n" +
                "    for /f \"delims=\" %%i in ('type \"%%~j\" ^& break ^> \"%%~j\"') do (\r\n" +
                "        set \"line=%%i\"\r\n" +
                "        setlocal EnableDelayedExpansion\r\n" +
                "        set \"line=!line:%search%=%replace%!\"\r\n" +
                "        >>\"%%~j\" echo(!line!\r\n" +
                "        endlocal\r\n" +
                "    )\r\n" +
                ")\r\n" +
                "endlocal\r\n" +
                "start \"Verifying Scribble Protocol\" " + vercorsDir + "\\bin\\" + "vercors --silicon tmp\\*.java");
        return res;
    }

    private static void outputFiles(HashMap<String, String> files, String dir) throws ScribException {
        for (String file : files.keySet())
            ScribUtil.writeToFile(dir + File.separator + file, files.get(file));
    }



}
