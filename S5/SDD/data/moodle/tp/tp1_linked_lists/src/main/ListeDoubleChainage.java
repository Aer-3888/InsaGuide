package main;

public class ListeDoubleChainage implements MyList<Object> {
    // A node is an element of the linked chain
    static class Node {
        public Object value;
        public Node successor;
        public Node predecessor;
        public Node(Object o) { this.value = o; }
    }

    private final Node head;
    private Node cursor;
    private final Node tail;

    public ListeDoubleChainage() {
        head = cursor = new Node(null);
        tail = new Node(null);
        head.successor = tail;
    }

    public void entete() {
        // Set the cursor on head
        this.cursor = this.head.successor;
        System.out.println("Cursor on " + this.cursor);
    }

    public void enqueue() {
        // Set the cursor on tail
        this.cursor = this.tail.predecessor;
    }

    public boolean estSorti() {
        // We're out if we're either on the predecessor of head
        // or the successor of tail, i.e., null
        return this.cursor == this.head || this.cursor == this.tail;
    }

    public boolean estVide() {
        // If head points to tail, we're empty
        return this.head.successor == this.tail;
    }

    public void succ() {
        // Check that we're not out of bounds
        if (this.estSorti()) {
            throw new MyListOutOfBoundsException("Trying to get successor from tail");
        }

        // Move forward once
        this.cursor = this.cursor.successor;
    }

    public void pred() {
        // Check that we're not out of bounds
        if (this.estSorti()) {
            throw new MyListOutOfBoundsException("Trying to get predecessor from head");
        }

        // Move backwards once
        this.cursor = this.cursor.predecessor;
    }

    public void ajouterD(Object o) {
        // Check that we're empty or not out of bounds
        if (!this.estVide() && this.estSorti()) {
            // Ah, fuck
            throw new MyListOutOfBoundsException();
        }

        if (this.estVide())
            this.cursor = head;

        // Add node
        Node nn = new Node(o);
        // Chain backwards
        nn.predecessor = this.cursor;
        this.cursor.successor.predecessor = nn;
        // Chain forward
        nn.successor = this.cursor.successor;
        this.cursor.successor = nn;
        // We move onto
        this.cursor = nn;
        System.out.println("New node : " + this.cursor.toString());
        System.out.println("Tail : " + this.tail);
        System.out.println("Head : " + this.head);
    }

    public void oterec() {
       // Check that we're not out of bounds
        if (this.estSorti()) {
            throw new MyListOutOfBoundsException("Trying to remove from out of space");
        }

        // Successor of predecessor is our successor
        this.cursor.predecessor.successor = this.cursor.successor;
        this.cursor.successor.predecessor = this.cursor.predecessor;
        this.cursor = this.cursor.successor;
    }

    public Object valec() {
        // Check that we're not out of bounds
        if (this.estSorti()) {
            throw new MyListOutOfBoundsException("Trying to get something from nothing");
        }

        return this.cursor.value;
    }
}
