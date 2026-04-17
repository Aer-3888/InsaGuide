import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import static org.junit.jupiter.api.Assertions.*;


public class testA {

    public A at;
    public int vb=1;
    public B beh;
    public B b;
    public AnException anex = new AnException("Good test kid !");



    @BeforeEach
    void setUp() throws AnException {
        b = Mockito.mock(B.class);
        Mockito.when(b.getB1()).thenReturn(vb); /*Test du getter non possible donc on fait un when pour lui demander de renvoyer vb*/
        beh = Mockito.mock(B.class);
        Mockito.when(beh.getB1()).thenThrow(anex); /*Test du getter non possible donc on fait un when pour lui demander de renvoyer l'exception*/
        at = new A(b);
    }

    @Test
    void testgetB1b() throws AnException {
        assertEquals(vb,b.getB1());
    }

    @Test
    void testgetB1beh() throws AnException {
        assertThrows(AnException.class,()->{beh.getB1();});
    }
    @Test
    void testconstructwithnull() throws IllegalArgumentException{ 		/* On teste le throw d'une erreur d'argument*/
        assertThrows(IllegalArgumentException.class, ()->{A at=new A(null);});
    }

    @Test
    void testgetstr() { 		/* On teste le throw d'une erreur d'argument*/
    assertNull(at.getStr());
    }
    @Test
    void testal1() throws AnException {
        assertEquals(0,at.al(false));

    }
    @Test
    void testaldosomcase() throws AnException {
        assertEquals(4*vb,at.al(true));
    }
    @Test
    void testgetb(){
        assertEquals(b,at.getB());
    }
    @Test
    void testcreat(){
        assertNull(A.create(null));
    }
@Test
    void testcreatgood(){
        assertEquals(at.getB(),A.create(b).getB());
        assertEquals(at.getStr(),A.create(b).getStr());
    }
}

