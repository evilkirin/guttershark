package net.guttershark.display.controls.buttons 
{
	import flash.events.Event;	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import net.guttershark.util.FramePulse;	

	//import net.guttershark.util.FramePulse;	
	public class DialButton extends MovieClipButton
	{

		public var dial:MovieClip;
		public var pixelToDegreeRatio:int = 4;
		public var minDegrees:int = 0;
		public var maxDegrees:int = 360;
		private var fakeRotation:Number = 0;
		private var lastr:Number;
		
		public function DialButton():void
		{
			fakeRotation = rotation;
		}
		
		override protected function __onMouseDown(me:MouseEvent):void
		{
			super.__onMouseDown(me);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			FramePulse.AddEnterFrameListener(onFrame);
		}

		override protected function __onMouseUp(me:MouseEvent):void
		{
			super.__onMouseUp(me);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			FramePulse.RemoveEnterFrameListener(onFrame);
		}

		private function onFrame(e:Event):void
		{
			var an:Number = Math.atan2(mouseY - dial.y, mouseX - dial.x);
			an = (an / Math.PI) * 180;
			var min:Number = 0;
			var max:Number = 360;
			dial.rotation = an;
			var value:Number = an - min;
			var target:Number = 100;
			max -= min;
			value /= max;
			value *= target;
			//if(value < 0) value = 180 + (value - 180);
			trace(value);
		}

		protected function __onMouseMove(e:MouseEvent):void
		{
			
		}
	}}