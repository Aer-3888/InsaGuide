package test;

import main.ExprArith;
import main.TreeTwo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ExprArithTest {
    ExprArith exp;
    TreeTwo tr;

    @BeforeEach
    void setup() {
        tr = new TreeTwo("+");

        TreeTwo droit = new TreeTwo("/");
        droit.modifArbreD(new TreeTwo("2"));
        droit.modifArbreG(new TreeTwo("5"));
        tr.modifArbreD(droit);

        TreeTwo gauche = new TreeTwo("*");
        gauche.modifArbreD(new TreeTwo("pi"));
        gauche.modifArbreG(new TreeTwo("4"));
        tr.modifArbreG(gauche);

        exp = new ExprArith(tr);
    }

    @Test
    public void toStringCorrect() {
        assertEquals("( 4 * pi ) + ( 5 / 2 )", exp.toString());
    }

    @Test
    public void expressCorrect() {
        exp.associerValeur("pi", 3.141592);
        assertEquals(15.06636, exp.evaluer(), 1e-5);
    }

    @Test
    public void simplifyWithAllValues() {
        assertEquals(2, exp.simplifier().hauteur());
        exp.associerValeur("pi", 3.141592);
        assertEquals(0, exp.simplifier().hauteur());
    }

}
