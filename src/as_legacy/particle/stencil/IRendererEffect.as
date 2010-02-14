package net.guttershark.display.particle.stencil
{
	
	import flash.display.DisplayObject;
	
	/**
	 * The IRenderEffect interface creates the contract for objects
	 * that are implementing a render effect to be used with the StencilRenderer.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public interface IRendererEffect 
	{
		
		/**
		 * Render method that is called internally from the StencilRenderer.
		 */
		function render(stencil:DisplayObject, particles:Array, leftOvers:Array):void;
		
		/**
		 * Render particles to be visible.
		 */
		function renderIn(particle:*):void;
		
		/**
		 * Render particles out of visibility.
		 */
		function renderOut(particle:*):void;
		
		/**
		 * Render all particles on the display list out.
		 */
		function renderAllOut(particles:Array):void;
		
		/**
		 * Update the currently rendererd particles.
		 */
		function updateRender(particles:Array):void;
		
		/**
		 * Update any options available to this render effect.
		 */
		function updateOptions(object:Object):void;
	}
}