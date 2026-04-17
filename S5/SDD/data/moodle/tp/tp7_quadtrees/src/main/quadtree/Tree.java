package quadtree;

import java.util.ArrayList;
import java.util.List;

public class Tree implements QuadTree {
    private static class Node {
        Color value;
        List<Node> children;
        Node parent;

        public Node(Color c, Node p) {
            this.value = c;
            this.parent = p;
            this.children = new ArrayList<>();
        }

        public void addChild(Node n) {
            if (n == null) throw new IllegalArgumentException("Null node child");
            if (this.children.contains(n))
                throw new IllegalArgumentException("Already in there");
            if (this.children.size() == 4)
                throw new RuntimeException("List full");
            // Overwrite the parent pointer
            n.parent = this;
            this.children.add(n);
        }

        public void removeChildren() {
            this.children.clear();
        }
    }

    private Node root;
    private Node current;

    public Tree() {;}

    private Node buildFromImageRec(Image u, int low_x, int low_y, int high_x, int high_y) {
        //System.out.println("REGION:((" + low_x + "," + low_y + "),(" + high_x + "," + high_y + "))");
        // If we're focused on a pixel
        if (low_x + 1 == high_x && low_y + 1 == high_y) {
            // Set the pixel
            // Parent is null because I have no bloody clue how to set it right now
            //System.out.println("Built pixel at (" + low_x + "," + low_y + ")");
            return new Node(u.getPixel(low_x, low_y), null);
        } else {
            // Divide and build
            Node ch = new Node(null, null);
            ch.addChild(buildFromImageRec(u, low_x, low_y, (low_x+high_x)/2, (low_y+high_y)/2));
            ch.addChild(buildFromImageRec(u, (low_x+high_x)/2, low_y, high_x, (low_y+high_y)/2));
            ch.addChild(buildFromImageRec(u, (low_x+high_x)/2, (low_y+high_y)/2, high_x, high_y));
            ch.addChild(buildFromImageRec(u, low_x, (low_y+high_y)/2, (low_x+high_x)/2, high_y));
            return ch;
        }
    }

    public Tree(Image u) {
        if (u == null) { throw new IllegalArgumentException("Null building image"); }
        int size = u.getSize();
        this.root = this.buildFromImageRec(u, 0, 0, size, size);
        this.current = this.root;
        this.prune(0);
    }

/*    private pruneRec() {

    }*/

    public void prune(int threshold) {
        if (this.onLeaf()) {
            // Go back up there's nothing to simplify here
            if (this.onRoot()) return;
            //System.out.println("Hit the ground");
        } else {
            // Prune all of the children
            //System.out.println("CURR:" + this.current + "\tNEXT:" + this.current.children);
            for (int i = 0; i < 4; i++) {
                //System.out.println("Going to child " + i);
                this.goToChild(i);
                prune(threshold);
                this.goToParent();
            }
            // Do they all have colours?
            Color avg = null;
            for (int i = 0; i < 4; i++) {
                this.goToChild(i);
                if (this.current.value == null) {
                    this.goToParent(); // Go back to us
                    return;
                }
                this.goToParent(); // Get back to us
                for (int j = 0; j < i; j++) {
                    // Check against previous colours (we know they exist)
                    if (!this.current.children.get(i).value.near(this.current.children.get(j).value, threshold)) {
                        // Break, there's no point in pruning if those are too high
                        // We're already at the right level to exit
                        return;
                    }
                }
                if (avg == null) {
                    avg = this.current.children.get(i).value;
                } else {
                    avg = avg.average(this.current.children.get(i).value, .25);
                }
            }
            // If this survived, get the average colour
            this.current.removeChildren();
            this.current.value = avg;
        }
    }

    public Tree(Color c) { this.createRoot(c);}

    public boolean isEmpty() {
        return this.root == null;
    }

    public boolean outOfTree() {
        return this.current == null;
    }

    public void goToRoot() {
        this.current = this.root;
    }

    public void goToParent() {
        if (this.outOfTree()) throw new ArrayIndexOutOfBoundsException("Parent of node outside tree");
        this.current = this.current.parent;
    }

    public void goToChild(int i) {
        if (this.outOfTree()) throw new ArrayIndexOutOfBoundsException("child of node out of tree");
        try {
            this.current = this.current.children.get(i);
        } catch (IndexOutOfBoundsException e) {
            this.current = null;
        }
    }

    public boolean onRoot() {
        return this.current == this.root;
    }

    public boolean onLeaf() {
        return !this.outOfTree() && this.current.children.isEmpty();
    }

    public boolean hasChild(int i) {
        return !this.outOfTree() && this.current.children.size() >= i;
    }

    public Color getValue() {
        if (this.outOfTree()) throw new ArrayIndexOutOfBoundsException("value out of tree");
        return this.current.value;
    }

    public void setValue(Color c) {
        if (this.outOfTree()) throw new ArrayIndexOutOfBoundsException("value on out of tree");
        if (c == null) throw new IllegalArgumentException("Adding null color to node");
        this.current.value = c;
    }

    public void addChildren(Color[] c) {
        if (this.outOfTree()) throw new ArrayIndexOutOfBoundsException("adding children out of tree");
        if (c == null) throw new IllegalArgumentException("null array of children");
        if (c.length != 4) throw new RuntimeException("invalid number of children for a quadtree");
        for (Color ci : c) {
            this.current.addChild(new Node(ci, this.current));
        }
    }

    public void createRoot(Color c) {
        if (!this.isEmpty()) throw new RuntimeException("trying to recreate a tree");
        if (c == null) throw new IllegalArgumentException("null color for root of new tree");
        this.root = new Node(c, null);
        this.current = this.root;
    }

    public void delete() {
        if (this.outOfTree()) throw new RuntimeException("Trying to delete out of tree");
        this.goToParent();
        this.current.removeChildren();
    }

    public String toString() {
        return "nope";
    }

    private void recreateRec(Image out, int low_x, int low_y, int high_x, int high_y) {
        if (this.onLeaf()) {
            // Paint the whole damn region
            Color c = this.getValue();
            for (int x = low_x; x < high_x; x++) {
                for (int y = low_y; y < high_y; y++)
                    out.setPixel(x, y, c);
            }
        } else {
            // 0 is top left quadrant
            this.goToChild(0);
            this.recreateRec(out, low_x, low_y, (high_x+low_x)/2, (high_y+low_y)/2);
            // 1 is top right quadrant
            this.goToChild(1);
            this.recreateRec(out,  (low_x+high_x)/2, low_y, high_x, (high_y+low_y)/2);
            // 2 is lower right quadrant
            this.goToChild(2);
            this.recreateRec(out, (high_x+low_x)/2, (low_y+high_y)/2, high_x, high_y);
            // 3 is lower left quadrant
            this.goToChild(3);
            this.recreateRec(out, low_x, (high_y+low_y)/2, (high_x+low_x)/2, high_y);
        }
        // Leave this level
        this.goToParent();
    }

    public void recreate(Image out) {
        if (out == null) { throw new IllegalArgumentException("Null out image"); }
        // We're not gonna check the image size
        int size = out.getSize();
        // Launch recursive
        this.goToRoot();
        recreateRec(out, 0, 0, size, size);
    }
}
