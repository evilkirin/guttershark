package net.guttershark.display.particle.stencil 
{
	import net.guttershark.managers.AssetManager;
	import net.guttershark.util.cache.Cache;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.*;
	import flash.utils.Dictionary;	

	/**
	 * The StencilRenderer class renders display objects out of particles, you
	 * can see an example at <a href="http://www.populistsf.com/">populist.com</a>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class StencilRenderer
	{
		
		/**
		 * Pool of all particles, particles are split up into arrays by the key. 
		 * The key is the name of the stencil.
		 */
		private var particlesPool:Dictionary;

		/**
		 * The currently rendered particles
		 */
		private var currentRenderParticles:Dictionary;
		
		/**
		 * A cache for bitmap data scans.
		 */
		private var bitmapDataCache:Cache;
		
		/**
		 * A cache for pixels that were read
		 * from the bitmap data.
		 */
		private var bitmapReadCache:Cache;
		
		/**
		 * The density in rows of particles
		 */
		private var rowPixelRatio:int;
		
		/**
		 * The density in colummns of particles 
		 */
		private var colPixelRatio:int;
		
		/**
		 * Asset manager singleton instance.
		 */
		private var am:AssetManager;

		/**
		 * Constructor for StencilRenderer instances.
		 */
		public function StencilRenderer(rowDensity:int, columnDensity:int)
		{
			if(rowDensity < 1 || columnDensity < 1) throw new Error("Row and Column density must be greater than 0"); 
			am=AssetManager.gi();
			bitmapDataCache = new Cache();
			bitmapReadCache = new Cache();
			currentRenderParticles = new Dictionary();
			particlesPool = new Dictionary();
			rowPixelRatio = rowDensity;
			colPixelRatio = columnDensity;
		}

		/**
		 * Render a stencil from a display object.
		 * 
		 * @param	stencil	The movie clip you want to act as a stencil.
		 * @param	particle	The id of the movie clip in the library you want as a particle.
		 * @param	renderer	The effect renderer you are using to render the stencil.
		 */
		public function renderStencil(stencil:DisplayObject, particle:String, renderer:IRendererEffect):void
		{
			//var t:* = getTimer();
			if(!particlesPool[particle]) particlesPool[particle] = [];
			if(!currentRenderParticles[particle]) currentRenderParticles[particle] = [];
			
			var i:int = 0;
			var bmd:BitmapData;
			if(bitmapDataCache.isCached(stencil.name)) bmd = bitmapDataCache.getCachedObject(stencil.name);
			else
			{
				bmd = new BitmapData(stencil.width, stencil.height, true, 0x000);
				bmd.draw(stencil);
				bitmapDataCache.cacheObject(stencil.name, bmd);
			}
			
			var pixels:Array = [];
			var readCacheKey:String = stencil.name + rowPixelRatio.toString() + colPixelRatio.toString();
			if(bitmapReadCache.isCached(readCacheKey)) pixels = bitmapReadCache.getCachedObject(readCacheKey) as Array;
			else
			{
				var rows:int = stencil.height;
				var cols:int = stencil.width;
				var px:Pixel;
				var pixelValue:int;
				var alphaValue:uint;
				var red:uint;
				var blue:uint;
				var green:uint;
				for(var r:int = 0; r < rows; r += rowPixelRatio)
				{
					for(var c:int = 0; c < cols; c += colPixelRatio)
					{
						pixelValue = bmd.getPixel32(c,r);
						alphaValue = pixelValue >> 24 & 0xFF;
						if(alphaValue < 50) continue;
						red = pixelValue >> 16 & 0xFF;
						green = pixelValue >> 8 & 0xFF;
						blue = pixelValue & 0xFF;
						px = new Pixel(c,r,pixelValue,alphaValue,red,green,blue);
						pixels.push(px);
					}
				}
				bitmapReadCache.cacheObject(readCacheKey,pixels);
			}

			var pclass:Class = am.getClass(particle);
			var sparticle:*;
			var l:int = pixels.length;
			var ppl:int = particlesPool[particle].length;
			var leftOvers:Array = [];
			var toRender:Array = [];

			if(ppl >= l) //if enough in particles pool to cover all particles, take out the ones to render
			{
				//trace("ppl >= l");
				leftOvers = currentRenderParticles[particle].slice(l,currentRenderParticles[particle].length);
				toRender = particlesPool[particle].slice(0,l);
			}
			else if(particlesPool[particle].length > 0) //there are some particles in the pool, but not enough
			{
				//trace("particlesPool[particle].length > 0");
				var diff:int = l - ppl; //how many additional particles to create.
				for(var k:int = 0; k < diff; k++) //create additional particles
				{
					sparticle = new pclass();
					particlesPool[particle].push(sparticle);
				}
				toRender = particlesPool[particle].concat();
			}
			else
			{
				//trace("else");
				for(var p:int = 0; p < l; p++) //create all particles to cover the pixels needed
				{
					sparticle = sparticle = new pclass();
					particlesPool[particle].push(sparticle);
				}
				toRender = particlesPool[particle];
			}
			
			//now go through all particles in the pool other than ones for
			//the currently rendering template.
			var key:*;
			for(key in currentRenderParticles)
			{
				if(key == particle) continue;
				if(!currentRenderParticles[key]) continue;
				if(currentRenderParticles[key].length < 0) continue;
				leftOvers.concat(currentRenderParticles[key].concat());
				currentRenderParticles[key] = [];
			}
			
			//store current rendered particles
			currentRenderParticles[particle] = toRender;
			
			//trace(currentRenderParticles[particle]);
			//trace("particle",particle);
			
			//re-set partical values for new pixels
			for(i = 0; i < toRender.length; i++) toRender[i].pixel = pixels[i];
			
			//trace("done - time before render call: " + (getTimer() - t));
			renderer.render(stencil,toRender,leftOvers);
		}
		
		/**
		 * Prepopulate the render sandbox with particles
		 */
		public function populateParticlePool(sandbox:MovieClip, count:int, particle:String):void
		{
			if(!particlesPool[particle]) particlesPool[particle] = [];
			var pclass:Class = am.getClass(particle);
			var sparticle:*;
			for(var i:int = 0; i < count; i++)
			{
				sparticle = new pclass();
				sparticle.alpha = 0;
				particlesPool[particle].push(sparticle);
				if(!sandbox.contains(sparticle))
				{
					sandbox.addChild(sparticle);
				}
			}
		}
		
		/**
		 * Render all currently rendered particles out with a given render effect.
		 * @param	renderer	An IRendererEffect to use as the render out effect.
		 */
		public function renderAllOut(renderer:IRendererEffect):void
		{
			var key:*;
			for(key in currentRenderParticles)
			{
				if(!currentRenderParticles[key]) continue;
				if(currentRenderParticles[key].length < 0) continue;
				renderer.renderAllOut(currentRenderParticles[key]);
				currentRenderParticles[key] = [];
			}
		}
		
		/**
		 * Update the currently rendered particles with a given render effect.
		 * @param	renderer	An IRendererEffect to use as the render update effect.
		 */
		public function updateRender(renderer:IRendererEffect):void
		{
			var key:*;
			for(key in currentRenderParticles)
			{
				if(!currentRenderParticles[key]) continue;
				if(currentRenderParticles[key].length < 0) continue;
				renderer.updateRender(currentRenderParticles[key]);
			}
		}
	}
}
