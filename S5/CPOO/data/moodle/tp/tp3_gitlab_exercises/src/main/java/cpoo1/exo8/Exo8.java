package cpoo1.exo8;

import java.util.random.RandomGenerator;

class Random {
    public int nextRandom() {
        return RandomGenerator.getDefault().nextInt();
    }
}

public class Exo8 {
    private final Random rand;

    public Exo8() {
        rand = new Random();
    }

    public int uneFonctionInutile(int coeff) {
        return rand.nextRandom() * coeff;
    }

    public int uneAutreFonctionInutile(int coeff) {
        return RandomGenerator.getDefault().nextInt() * coeff;
    }
}
