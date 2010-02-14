package gs.managers
{
	import gs.display.tooltip.BaseToolTip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * The ToolTipManager class manages showing tooltips
	 * over a display object.
	 * 
	 * <p>Each object, must be registered with an instance
	 * of a tooltip - then the manager can handle the rest.</p>
	 * 
	 * @example Using tool tip manager.
	 * <listing>	
	 * var toolTipContainer:MovieClip = new MovieClip();
	 * addChild(toolTipContainer);
	 * 
	 * var ttm:ToolTipManager = new ToolTipManager();
	 * ttm.toolTipHolder = toolTipContainer;
	 * 
	 * var objNeedsTooltip:MovieClip = new MovieClip();
	 * addChild(objNeedsTooltip);
	 * 
	 * //extend base tooltip for your own.
	 * var tooltip:BaseToolTip = new BaseToolTip();
	 * 
	 * //tell the tool tip manager to manage this tooltip
	 * //for the object.
	 * ttm.register(objNeedsTooltip,tooltip);
	 * </listing>
	 */
	public class ToolTipManager
	{
		
		/**
		 * The container clip for all tooltips.
		 */
		public var toolTipHolder:Sprite;
		
		/**
		 * The time to wait before showing a tooltip.
		 */
		public var showAfterTime:Number=1400;
		
		/**
		 * Whether or not to let the tooltip manager
		 * auto adjust the placement points for tooltips
		 * based off of stage size.
		 * 
		 * <p>For example, if the tooltip would be off
		 * the screen because it's too far to the right,
		 * setting this to true will auto adjust the
		 * point at which to show the tooltip.</p>
		 */
		public var autoAdjustPointForStageConstraints:Boolean;
		
		/**
		 * Whether or not a listener was added
		 * to the stage for mouse move.
		 */
		private var hasStageListener:Boolean;
		
		/**
		 * A stage reference.
		 */
		private var stage:Stage;
		
		/**
		 * Objects lookup.
		 */
		private var objects:Dictionary;
		
		/**
		 * The show timeout.
		 */
		private var showTimeout:Number;
		
		/**
		 * The instance currently shown.
		 */
		private var shownInstance:*;
		
		/**
		 * @private
		 * 
		 * Constructor for ToolTipManager instances.
		 */
		public function ToolTipManager()
		{
			super();
			objects=new Dictionary();
		}
		
		/**
		 * Register an object to show a tooltip.
		 * 
		 * @param obj The object to show tooltip over.
		 * @param tooltipInstance A BaseToolTip instance.
		 */
		public function register(obj:DisplayObject,tooltipInstance:BaseToolTip):void
		{
			if(!toolTipHolder || !toolTipHolder.stage)
			{
				trace("ERROR: The ToolTipManager class needs the toolTipHolder property set first. It needs to be on the display list. Not registering for tooltips.");
				return;
			}
			stage=toolTipHolder.stage;
			obj.addEventListener(MouseEvent.MOUSE_OVER,__onMouseOver);
			obj.addEventListener(MouseEvent.MOUSE_OUT,__onMouseOut);
			objects[obj]=tooltipInstance;
		}
		
		/**
		 * On mouse out.
		 */
		private function __onMouseOut(me:MouseEvent):void
		{
			var obj:DisplayObject =me.currentTarget as DisplayObject;
			var instance:* = objects[obj];
			instance.hide();
		}
		
		/**
		 * On mouse over a registered object.
		 */
		private function __onMouseOver(me:MouseEvent):void
		{
			clearTimeout(showTimeout);
			var obj:BaseToolTip =objects[me.currentTarget];
			if(!obj)obj=objects[me.target];
			if(!obj)return;
			if(shownInstance)shownInstance.hide();
			showTimeout=setTimeout(showTooltipInstance,showAfterTime,obj);
			if(!hasStageListener)setTimeout(addStageKiller,500);
		}
		
		/**
		 * Adds a stage listener to kill the show timeout,
		 * if the mouse is moved, just before showing
		 * the tooltip.
		 */
		private function addStageKiller():void
		{
			if(hasStageListener)return;
			hasStageListener=true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
		}
		
		/**
		 * On mouse move.
		 */
		private function __onMouseMove(me:MouseEvent):void
		{
			clearTimeout(showTimeout);
			if(shownInstance) shownInstance.hide();
			hasStageListener=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
		}
		
		/**
		 * Shows a tooltip instance.
		 */
		private function showTooltipInstance(obj:BaseToolTip):void
		{
			var coords:Point=obj.localToGlobal(new Point(obj.mouseX,obj.mouseY));
			if(autoAdjustPointForStageConstraints)
			{
				coords.x-=obj.width/2;
				coords.y+=10;
				coords.x=Math.ceil(coords.x);
				coords.y=Math.ceil(coords.y);
				if(autoAdjustPointForStageConstraints)
				{
					var re:Number;
					if(coords.x<0) coords.x=10;
					if(coords.y<0) coords.y=10;
					if((coords.x+obj.width)>stage.width)
					{
						re=stage.width-obj.width;
						coords.x=(re-10);
					}
					if((coords.y+obj.height)>stage.height)
					{
						re=stage.height-obj.height;
						coords.y=(re-10);
					}
				}
			}
			toolTipHolder.addChild(obj);
			obj.show(coords);
			shownInstance=obj;
		}
		
		/**
		 * Unregister a previously registered tooltip.
		 * 
		 * @param obj The object used to register the tooltip.
		 */
		public function unregister(obj:Sprite):void
		{
			if(!obj) return;
			obj.removeEventListener(MouseEvent.MOUSE_OUT,__onMouseOut);
			obj.removeEventListener(MouseEvent.MOUSE_OVER,__onMouseOver);
			delete objects[obj];
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
		}
		
		/**
		 * Dispose of this tool tip manager.
		 */
		public function dispose():void
		{
		}
	}
}