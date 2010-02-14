package net.guttershark.display.particle.stencil
{	
	
	/**
	 * The Pixel class represents a pixel that was read from the initial stencil scan.
	 * Values from that read are wrapped in this class for easier access.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class Pixel
	{
		
		/**
		 * The x position of the pixel in the scan.
		 */
		public var x:int;
		
		/**
		 * The y position of the pixel in the scan.
		 */
		public var y:int;
		
		/**
		 * The total color value of the pixel in the scan.
		 */
		public var value:uint;
		
		/**
		 * The alpha value of the pixel in the scan.
		 */
		public var alpha:uint;
		
		/**
		 * The red value of the pixel in the scan.
		 */
		public var red:uint;
		
		/**
		 * The green value of the pixel in the scan.
		 */
		public var green:uint;
		
		/**
		 * The blue valie of the pixel in the scan.
		 */
		public var blue:uint;
		
		/**
		 * Constructor for Pixel instances.
		 * 
		 * @param x	The x position of the pixel.
		 * @param y	The y position of the pixel.
		 * @param value The total color value of the pixel.
		 * @param alpha The alpha value of the pixel.
		 * @param red The red value of the pixel.
		 * @param green The green value of the pixel.
		 * @param blue The blue value of the pixel.
		 */
		public function Pixel(x:int, y:int,value:uint, alpha:uint, red:uint, green:uint, blue:uint)
		{
			this.x = x;
			this.y = y;
			this.value = value;
			this.alpha = alpha;
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
	}
}
