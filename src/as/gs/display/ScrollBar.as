package gs.display
{
	
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	/**
	 * The ScrollBar class provides vertical and horizontal scrolling.
	 * 
	 * @example Setting up the scrollbar:
	 * <listing>	
	 * var scrollBar:ScrollBar = new ScrollBar(stage,content,contentMask,handle,track,upArrow,downArrow);
	 * var scrollBar2:ScrollBar = new ScrollBar(stage,content2,contentMask2,handle2,track2,leftArrow,rightArrow,ScrollBar.HORIZONTAL);
	 * </listing>
	 * 
	 * <p>If the content clip contains only one textfield,
	 * and the autoSize property is set to "none," the
	 * scrollbar set's it to "left" otherwise the height of
	 * the content clip is incorrect.</p>
	 * 
	 * <p>The ScrollBar uses initial property values from
	 * the clips you provide, to calculate offsets, max y,
	 * and min y, and also for resetting. So the clips must
	 * be laid out exactly how they are to be used. Otherwise
	 * you'll see weird offsets, which aren't correct.</p>
	 * 
	 * <p><b>Examples</b> are in the <a target="_blank" href="http://gitweb.codeendeavor.com/?p=guttershark.git;a=summary">guttershark</a> repository.</p>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	final public class ScrollBar
	{
		
		/**
		 * Horizontal scrollbar mode.
		 */
		public static const HORIZONTAL:String="horizontal";
		
		/**
		 * Vertical scrollbar mode.
		 */
		public static const VERTICAL:String="vertical";
		
		/**
		 * The amount of pixels to move the handle, when the
		 * mouse wheel is used.
		 */
		public var wheelStep:Number=5;
		
		/**
		 * The amount of pixels to move the handle, when the
		 * up, down, left or right arrow is clicked.
		 */
		public var arrowsStep:Number=5;
		
		/**
		 * Scrolling ease speed.
		 */
		public var easeSpeed:Number=.4;
		
		/**
		 * Whether or not to allow track clicks.
		 */
		public var allowTrackClick:Boolean;
		
		/**
		 * Stage reference for necessary events.
		 */
		private var _stage:Stage;
		
		/**
		 * Mouse down flag.
		 */
		private var down:Boolean;
		
		/**
		 * Mouse wheel delta.
		 */
		private var delta:Number;
		
		/**
		 * Scrollbar direction / mode.
		 */
		private var _direction:String;
		
		/**
		 * The content clip.
		 */
		private var _content:Sprite;
		
		/**
		 * The content mask clip.
		 */
		private var _contentMask:Sprite;
		
		/**
		 * The track clip.
		 */
		private var _track:Sprite;
		
		/**
		 * The handle clip.
		 */
		private var _handle:Sprite;
		
		/**
		 * The up arrow clip.
		 */
		private var _upArrow:Sprite;
		
		/**
		 * The down arrow clip.
		 */
		private var _downArrow:Sprite;
		
		/**
		 * The y maximum for the handle when vertical.
		 */
		private var yMax:Number;
		
		/**
		 * The x maximmum for the handle when horizontal.
		 */
		private var xMax:Number;
		
		/**
		 * Property references from the very initial state of the scrollbar handle.
		 */
		private var _firstHandleProps:Object;
		
		/**
		 * Property references from the very initial state of the scrollbar track.
		 */
		private var _firstTrackProps:Object;
		
		/**
		 * Property references from the very initial state of the scrollbar content.
		 */
		private var _contentFirstProps:Object;
		
		/**
		 * Property references from the very initial state of the scrollbar content mask.
		 */
		private var _contentMaskFirstProps:Object;
		
		/**
		 * The auto scroll interval.
		 */
		private var autoScrollInterval:Number;
		
		/**
		 * Auto scroll time, which decrements over time.
		 */
		private var autoScrollTime:Number;
		
		/**
		 * Constructor for ScrollBar instances.
		 * 
		 * @param stage A stage reference, needed for mouse events.
		 * @param content The content clip.
		 * @param contentMask The content mask clip.
		 * @param handle The scrollbar handle clip.
		 * @param track The scrollbar track clip.
		 * @param upOrLeftArrow An arrow button that causes up or left scrolling.
		 * @param downOrRightArrow An arrow button that causes down or right scrolling.
		 * @param direction The direction for scrolling, horizontal or vertical.
		 * @param allowTrackClick Whether or not to allow clicking on the scroll track.
		 * @param autoScrollOnArrowsDown Whether or not to auto scroll when the mouse is pressed down,
		 * and held, over an arrow button.
		 */
		public function ScrollBar(stage:Stage,content:Sprite,contentMask:Sprite,handle:Sprite,track:Sprite,upOrLeftArrow:Sprite=null,downOrRightArrow:Sprite=null,direction:String="vertical",allowTrackClick:Boolean=true,autoScrollOnArrowsDown:Boolean=true)
		{
			super();
			autoScrollTime=150;
			if(direction!=ScrollBar.HORIZONTAL&&direction!=ScrollBar.VERTICAL) throw new Error("Only horizontal, and vertical directions are supported.");
			_direction=direction;
			delta=0;
			this.allowTrackClick=allowTrackClick;
			_stage=stage;
			_content=content;
			_contentMask=contentMask;
			_handle=handle;
			_track=track;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN,onHandleMouseDown);
			_handle.addEventListener(MouseEvent.MOUSE_UP,onHandleMouseUp);
			_track.addEventListener(MouseEvent.CLICK,onTrackClick);
			if(upOrLeftArrow)
			{
				_upArrow=upOrLeftArrow;
				_upArrow.addEventListener(MouseEvent.CLICK, onUpArrow);
				if(autoScrollOnArrowsDown)_upArrow.addEventListener(MouseEvent.MOUSE_DOWN,onUpArrowDown);
			}
			if(downOrRightArrow)
			{
				_downArrow=downOrRightArrow;
				_downArrow.addEventListener(MouseEvent.CLICK,onDownArrow);
				if(autoScrollOnArrowsDown)_downArrow.addEventListener(MouseEvent.MOUSE_DOWN,onDownArrowDown);
			}
			yMax=(_track.height-_handle.height);
			xMax=(_track.width-_handle.width);
			_contentFirstProps={y:_content.y,x:_content.x,width:_content.width,height:_content.height};
			_contentMaskFirstProps={y:_contentMask.y,x:_contentMask.x,height:_contentMask.height,width:_contentMask.width};
			_firstHandleProps = {y:_handle.y,x:_handle.x,width:_handle.width,height:_handle.height};
			_firstTrackProps = {y:_track.y,x:_track.x,width:_track.width,height:_track.height};
			_content.mask=_contentMask;
			if(_content.numChildren>0&&_content.numChildren<2)
			{
				var child:* =_content.getChildAt(0);
				if(child is TextField && child.autoSize=="none")child.autoSize="left";
				_contentFirstProps.height=_content.height;
			}
		}
		
		/**
		 * On up arrow down, for interval.
		 */
		private function onUpArrowDown(me:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
			autoScrollInterval=setTimeout(scrollUp,200);
		}
		
		/**
		 * Scroll up logic for hold and press arrows.
		 */
		private function scrollUp():void
		{
			onUpArrow();
			autoScrollTime=Math.max(25,autoScrollTime-25);
			autoScrollInterval=setTimeout(scrollUp,autoScrollTime);
		}
		
		/**
		 * On down arrow down, for interval.
		 */
		private function onDownArrowDown(me:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
			autoScrollInterval=setTimeout(scrollDown,200);
		}
		
		/**
		 * Scroll down logic for hold and press arrows.
		 */
		private function scrollDown():void
		{
			onDownArrow();
			autoScrollTime=Math.max(25,autoScrollTime-25);
			autoScrollInterval=setTimeout(scrollDown,autoScrollTime);
		}
		
		/**
		 * Set the scrollbar direction.
		 * 
		 * @param direction The direction, ScrollBar.VERTICAL, or ScrollBar.HORIZONTAL.
		 */
		public function set direction(direction:String):void
		{
			if(direction!=ScrollBar.HORIZONTAL&&direction!=ScrollBar.VERTICAL) throw new Error("Only horizontal, and vertical directions are supported.");
			_direction=direction;
		}
		
		/**
		 * The scroll direction, can be ScrollBar.VERTICAL (default), or ScrollBar.HORIZONTAL.
		 */
		public function get direction():String
		{
			return _direction;
		}
		
		/**
		 * on track click
		 */
		private function onTrackClick(me:MouseEvent):void
		{
			if(!allowTrackClick)return;
			if(_direction==ScrollBar.VERTICAL) _handle.y=Math.min(_stage.mouseY,(yMax+_firstHandleProps.y));
			else if(_direction==ScrollBar.HORIZONTAL) _handle.x=Math.min(_stage.mouseX,(xMax+_firstHandleProps.x));
			update();
		}
		
		/**
		 * On up arrow click.
		 */
		private function onUpArrow(me:MouseEvent=null):void
		{
			if(_direction==ScrollBar.VERTICAL)
			{
				var ny:Number=_handle.y-arrowsStep;
				if(ny<_firstHandleProps.y)ny=_firstHandleProps.y;
				_handle.y=ny;
			}
			else if(_direction==ScrollBar.HORIZONTAL)
			{
				var nx:Number=_handle.x-arrowsStep;
				if(nx<_firstHandleProps.x)nx=_firstHandleProps.x;
				_handle.x=nx;
			}
			update();
		}
		
		/**
		 * On down arrow click.
		 */
		private function onDownArrow(me:MouseEvent=null):void
		{
			if(_direction==ScrollBar.VERTICAL)
			{
				var ny:Number=_handle.y+arrowsStep;
				if(ny>(yMax+_firstTrackProps.y))ny=yMax+_firstTrackProps.y;
				_handle.y=ny;
				update();
			}
			else if(_direction==ScrollBar.HORIZONTAL)
			{
				var nx:Number=_handle.x+arrowsStep;
				if(nx>(xMax+_firstHandleProps.x))nx=xMax+_firstHandleProps.x;
				_handle.x=nx;
				update();
			}
		}
		
		/**
		 * On handle mouse down.
		 */
		private function onHandleMouseDown(me:MouseEvent):void
		{
			down=true;
			_stage.addEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			startDragging();
		}
		
		/**
		 * On handle mouse up
		 */
		private function onHandleMouseUp(me:MouseEvent):void
		{
			down=false;
			_stage.removeEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			stopDragging();
		}
		
		/**
		 * On wheel scroll.
		 */
		private function onWheel(e:MouseEvent):void
		{
			if(e.delta>delta)onUpArrow();
			else onDownArrow();
			delta=e.delta;
		}
		
		/**
		 * On stage mouse up.
		 */
		private function __onMouseUp(e:MouseEvent):void
		{
			autoScrollTime=150;
			stopDragging();
			clearInterval(autoScrollInterval);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
		}
		
		/**
		 * On stage mouse move.
		 */
		private function __onMouseMove(e:Event):void
		{
			update();
		}
		
		/**
		 * Updates the content position.
		 */
		private function update():void
		{
			var sp:Number;
			if(_direction==ScrollBar.VERTICAL)
			{
				sp=(_handle.y-_firstHandleProps.y)/yMax;
				TweenLite.to(_content,easeSpeed,{y:((-sp*(_content.height-_contentMask.height))+_contentFirstProps.y)});
			}
			else if(_direction==ScrollBar.HORIZONTAL)
			{
				sp=(_handle.x-_firstHandleProps.x)/xMax;
				TweenLite.to(_content,easeSpeed,{x:((-sp*(_content.width-_contentMask.width))+_contentFirstProps.x)});
			}
		}
		
		/**
		 * Stop dragging handle.
		 */
		private function stopDragging():void
		{
			_handle.stopDrag();
		}
		
		/**
		 * Start dragging handle.
		 */
		private function startDragging():void
		{
			if(_direction==ScrollBar.VERTICAL) _handle.startDrag(false,new Rectangle(_track.x,_track.y,0,(_track.height-_handle.height)));
			else if(_direction==ScrollBar.HORIZONTAL) _handle.startDrag(false,new Rectangle(_track.x,_track.y,_track.width-_handle.width,0));
		}
		
		/**
		 * Resets the handle x and y position to the very
		 * first positions that were used when the scrollbar
		 * was created, but does not trigger a scroll update.
		 */
		public function resetHandlePosition():void
		{
			_handle.x=_track.x;
			_handle.y=_track.y;
		}

		/**
		 * Dispose of this scroll bar.
		 */
		public function dispose():void
		{
			if(_stage)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE,__onMouseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			}
			if(_upArrow)
			{
				_upArrow.removeEventListener(MouseEvent.CLICK, onUpArrow);
				_upArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onUpArrowDown);
			}
			if(_downArrow)
			{
				_downArrow.removeEventListener(MouseEvent.CLICK,onDownArrow);
				_downArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onDownArrowDown);
			}
			if(_handle)
			{
				_handle.removeEventListener(MouseEvent.MOUSE_DOWN,onHandleMouseDown);
				_handle.removeEventListener(MouseEvent.MOUSE_UP,onHandleMouseUp);
			}
			if(_track)
			{
				_track.removeEventListener(MouseEvent.CLICK,onTrackClick);
			}
			clearInterval(autoScrollInterval);
			autoScrollTime=NaN;
			arrowsStep=NaN;
			easeSpeed=NaN;
			wheelStep=NaN;
			xMax=NaN;
			yMax=NaN;
			delta=0;
			_content=null;
			_contentMask=null;
			_handle=null;
			_track=null;
			_upArrow=null;
			_downArrow=null;
			_contentFirstProps=null;
			_contentMaskFirstProps=null;
			_direction=null;
			_firstHandleProps=null;
			_firstTrackProps=null;
			_stage=null;
			allowTrackClick=false;
			down=false;
		}
	}
}