package net.guttershark.ui.controls.tree
{
	
	import flash.display.MovieClip;
	
	import net.guttershark.core.IDataProviderConsumer;
	
	/**
	 * The TreeNodeRenderer class is used as the clip that renders
	 * what you want to display for each tree node.
	 */
	public class TreeNodeRenderer extends MovieClip implements IDataProviderConsumer
	{

		private var _dataProvider:*;
		
		public function TreeNodeRenderer()
		{
			super();
		}
		
		public function set dataProvider(data:*):void
		{
			_dataProvider = data;
			invalidate();
		}
		
		public function get dataProvider():*
		{
			return _dataProvider;
		}
		
		protected function invalidate():void
		{
			
		}	}}