package pingpong.Pingpong.Pingpong;

import org.scribble.runtime.message.ObjectStreamFormatter;
import org.scribble.runtime.net.SocketChannelEndpoint;
import org.scribble.runtime.session.MPSTEndpoint;
import pingpong.Pingpong.Pingpong.roles.C;
import pingpong.Pingpong.Pingpong.statechans.C.Pingpong_C_1;
import pingpong.Pingpong.Pingpong.statechans.C.Pingpong_C_2;

public class PingpongC {
    public static void main(String[] args) throws Exception {
        Pingpong pingpong = new Pingpong();
        try (MPSTEndpoint<Pingpong, C> client =
                     new MPSTEndpoint<>(pingpong, Pingpong.C, new ObjectStreamFormatter())) {
            client.request(Pingpong.S, SocketChannelEndpoint::new, "localhost", 8888);
            long startTime = 0;
            Pingpong_C_1 c1 = new Pingpong_C_1(client);
            for (int pp = 0; pp <= 1000000; pp++) {
                Pingpong_C_2 c2 = c1.send(Pingpong.S, Pingpong.Ping);
                c1 = c2.receive(Pingpong.S, Pingpong.Pong);
                if (pp == 0)
                    startTime = System.currentTimeMillis();
            }
            c1.send(Pingpong.S, Pingpong.Bye);
            System.out.println(System.currentTimeMillis() - startTime);
        }
    }
}
