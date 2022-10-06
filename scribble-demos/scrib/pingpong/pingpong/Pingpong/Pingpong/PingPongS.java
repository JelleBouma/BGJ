package pingpong.Pingpong.Pingpong;

import org.scribble.main.ScribRuntimeException;
import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.ScribServerSocket;
import org.scribble.runtime.net.SocketChannelServer;
import org.scribble.runtime.session.MPSTEndpoint;
import pingpong.Pingpong.Pingpong.roles.S;
import pingpong.Pingpong.Pingpong.statechans.S.Pingpong_S_1;
import pingpong.Pingpong.Pingpong.statechans.S.Pingpong_S_1_Cases;

import java.io.IOException;

public class PingPongS {
    public static void main(String[] args) throws Exception {
        try (ScribServerSocket ss = new SocketChannelServer(8888)) {
            while (true) {
                Pingpong pingpong = new Pingpong();
                try (MPSTEndpoint<Pingpong, S> server
                             = new MPSTEndpoint<>(pingpong, Pingpong.S, new ObjectStreamFormatter())) {
                    server.accept(ss, Pingpong.C);
                    new PingPongS().run(new Pingpong_S_1(server));
                } catch (ScribRuntimeException | IOException | ClassNotFoundException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void run(Pingpong_S_1 s1) throws Exception {
        while (true) {
            Pingpong_S_1_Cases cases = s1.branch(Pingpong.C);
            switch (cases.op) {
                case Ping: s1 = cases.receive(Pingpong.Ping)
                        .send(Pingpong.C, Pingpong.Pong);
                        break;
                case Bye: cases.receive(Pingpong.Bye);
                        return;
            }
        }
    }
}
