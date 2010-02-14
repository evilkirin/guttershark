package net.guttershark.display.particle.stencil
{
	import net.guttershark.display.particle.stencil.Pixel;
	
	import flash.display.MovieClip;	

	/**
	 * The StencilParticle must extend the movie clip you are
	 * using as a particle for an IRendererEffect.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class StencilParticle extends MovieClip
	{

		/**
		 * The pixel that this particle currently represents.
		 */
		public var pixel:Pixel;
	}
}