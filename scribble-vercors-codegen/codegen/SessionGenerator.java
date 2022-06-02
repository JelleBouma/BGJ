package scribblevercors.codegen;

import org.scribble.core.type.name.GProtoName;
import org.scribble.job.Job;
import scribblevercors.util.ClassBuilder;

import java.util.Locale;

public class SessionGenerator {

    Job job;
    GProtoName gpn;

    public SessionGenerator(Job job, GProtoName gpn) {
        this.job = job;
        this.gpn = gpn;
    }

    public String generateClass() {
        String name = gpn.getSimpleName().toString();
        ClassBuilder classBuilder = new ClassBuilder(name.toLowerCase(Locale.ROOT), "public", name);
        classBuilder.appendAttribute("int", "state");
        return classBuilder.toString();
    }

}
