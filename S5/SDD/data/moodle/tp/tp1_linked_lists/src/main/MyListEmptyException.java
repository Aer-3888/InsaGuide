package main;

public class MyListEmptyException extends RuntimeException {
    public MyListEmptyException() {}
    public MyListEmptyException(String s) {
        super(s);
    }
}
