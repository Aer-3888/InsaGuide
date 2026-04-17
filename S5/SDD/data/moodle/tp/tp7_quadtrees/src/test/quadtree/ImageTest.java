package quadtree;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

/**
 * ImageTest
 *
 * Class implementing the tests of the Image class.
 */
public class ImageTest {

	/**
	 * Test method for {@link Image#Image(int)}.
	 */
	@SuppressWarnings("unused")
	@Test
	public void testImageFailOnImageNot2Power() {
		assertThrows(IllegalArgumentException.class, () -> new Image(25));
	}
	
	@Test
	public void testImageOkOn2Power() {
		int size = 16;
		Image i = new Image(size);
		assertEquals(size, i.image.length);
	}
	
	/**
	 * Test method for {@link Image#getSize()}.
	 */
	@Test
	public void testGetSize() {
		int size = 16;
		Image i = new Image(size);
		assertEquals(size, i.getSize());
	}

	/**
	 * Test method for {@link Image#getWidth()}.
	 */
	@Test
	public void testGetWidth() {
		int size = 16;
		Image i = new Image(size);
		assertEquals(size, i.getWidth());
	}

	/**
	 * Test method for {@link Image#getHeight()}.
	 */
	@Test
	public void testGetHeight() {
		int size = 16;
		Image i = new Image(size);
		assertEquals(size, i.getHeight());
	}

	/**
	 * Test method for {@link Image#getPixel(int, int)}.
	 */
	@Test
	public void testGetPixelOk() {
		int size = 16;
		Image i = new Image(size);
		Color c = new Color(255, 255, 255);
		
		assertEquals(i.getPixel(0, 0), c);
	}
	
	@Test
	public void testGetPixelFailOnBadNegX() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).getPixel(-1, 0));
	}
	
	@Test
	public void testGetPixelFailOnBadNegY() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).getPixel(0, -1));
	}
	
	@Test
	public void testGetPixelFailOnBadLargeX() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).getPixel(16, 0));
	}
	
	@Test
	public void testGetPixelFailOnBadLargeY() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).getPixel(0, 16));
	}

	/**
	 * Test method for {@link Image#setPixel(int, int, Color)}.
	 */
	@Test
	public void testSetPixelOK() {
		Image i = new Image(16);
		Color c2 = new Color(0, 0, 0);
		
		i.setPixel(0, 0, c2);
		assertEquals(i.getPixel(0, 0), c2);
	}
	
	
	@Test
	public void testSetPixelNotOkOnBadNegX() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).setPixel(-1, 0, new Color(0, 0, 0)));
	}
	
	@Test
	public void testSetPixelNotOkOnBadNegY() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).setPixel(0, -1, new Color(0, 0, 0)));
	}
	
	
	@Test
	public void testSetPixelNotOkOnBadLargeX() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).setPixel(16, 0, new Color(0, 0, 0)));
	}
	
	@Test
	public void testSetPixelNotOkOnBadLargeY() {
		assertThrows(IllegalArgumentException.class, () -> new Image(16).setPixel(0, 16, new Color(0, 0, 0)));
	}
	
	/**
	 * Test method for {@link Image#power2(int)}.
	 */
	@Test
	public void testPower2OK() {
		assertTrue(Image.power2(16));
	}
	
	@Test
	public void testPower2NotOK() {
		assertFalse(Image.power2(25));
	}
}
