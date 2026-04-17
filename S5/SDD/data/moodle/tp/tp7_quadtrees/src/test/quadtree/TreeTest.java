package quadtree;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

import java.io.IOException;

public class TreeTest {
    @Test
    public void importImage() {
        Image im;
        try {
            im = new Image("/home/limefox/Nextcloud/INSA/INFO/S5/SDD/TPs/SDD-TP07/183050_zM6xsAwH.png");
        } catch (IOException e) {
            System.out.println("Unhandled I/O exception");
            throw new RuntimeException();
        }
        Image imout = new Image(im.getSize());
        for (int i = 0; i < 250; i++) {
            Tree t = new Tree(im);
            t.goToRoot();
            t.prune(i);
            t.recreate(imout);
            try {
                imout.save("/tmp/amelia/merp-" + fmt(i) +".png", "png");
            } catch (IOException e) {
                System.out.println("Unhandled I/O exception");
                throw new RuntimeException();
            }
        }
    }

    private String fmt(int s) {
        StringBuilder u = new StringBuilder(s + "");
        while (u.length() < 3) {
            u.insert(0, "0");
        }
        return u.toString();
    }
}
