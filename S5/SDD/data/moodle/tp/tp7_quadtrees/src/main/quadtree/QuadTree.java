package quadtree;

/**
 * QuadTree
 * 
 * QuadTree interface
 */
public interface QuadTree {
	/**
	 * Test if a tree is empty.
	 * 
	 * @return true if the tree is empty, false otherwise.
	 */
	boolean isEmpty();

	/**
	 * Test if the current element is out of the tree. 
	 * 
	 * @return true if the current element is out of the tree, false otherwise.
	 */
	boolean outOfTree();

	/**
	 * Prunes the tree from useless components
	 * A threshold of difference is given
	 */
	void prune(int threshold);

	/**
	 * Change the current element to the root of the tree.
	 */
	void goToRoot();

	/**
	 * Change the current element to its parent.
	 */
	void goToParent();

	/**
	 * Change the current element to one of its child.
	 * 
	 * @param i The number of the child, starting to 1.
	 */
	void goToChild(int i);

	/**
	 * Test if the current element is the root of the tree.
	 * 
	 * @return true if the current element is the root, false otherwise.
	 */
	boolean onRoot();

	/**
	 * Test if the current element is a leaf (a node without child).
	 * 
	 * @return true if the current element is a leaf, false otherwise.
	 */
	boolean onLeaf();

	/**
	 * Test if the current element has a child at a given position.
	 * 
	 * @param i The number of the child.
	 * @return true if the child exist, false otherwise.
	 */
	boolean hasChild(int i);

	/**
	 * Provide the value of the current element.
	 * 
	 * @return The value of the current element.
	 */
	Color getValue();

	/**
	 * Modify the value of the current element.
	 * 
	 * @param c The new value of the current element.
	 */
	void setValue(Color c);

	/**
	 * Add four children to the current element if it's a leaf.
	 * 
	 * @param c The values of the four children.
	 */
	void addChildren(Color[] c);

	/**
	 * create the root of an empty tree.
	 * 
	 * @param c The value of the root.
	 */
	void createRoot(Color c);

	/**
	 * Delete the subtree represented by the current element and
	 * go to the parent node.
	 */
	void delete();

	/**
	 * Generate a string representation of the tree.
	 * 
	 * @return The generated string.
	 * @see java.lang.Object#toString()
	 */
	String toString();

	/**
	 * Recreate an image from the data stored in a tree
	 */
	void recreate(Image c);

} // interface QuadTree
