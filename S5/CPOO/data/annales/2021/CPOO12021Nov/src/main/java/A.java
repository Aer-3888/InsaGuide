public class A {

    private String str;
    private B b;

    public A(final B b) {
        if (b == null) {
            throw new IllegalArgumentException();
        }
        str = null;
        this.b = b;
    }

    public B getB() {
        return b;
    }

    public String getStr() {
        return str;
    }

    public int al(final boolean value) throws SecurityException, NumberFormatException, AnException {
        doSomething();
        if (str == null || !value) {
            return 0;
        }
        return str.length() * b.getB1();
    }


    private void doSomething() {
        str = "yolo";
    }

    //Returns a new instance of A on each call. May return null.//
    public static A create(final B b) {
        try {
            return new A(b);
        } catch (final IllegalArgumentException ex) {
            return null;
        }
    }
}
