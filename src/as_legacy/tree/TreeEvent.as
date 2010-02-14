package net.guttershark.ui.controls.tree 
{
	
	import flash.events.Event;
	
	public class TreeEvent extends Event
	{

		public static const SELECT:String = "select";
		public static const OVER:String = "over";
		
		public var nodeType:String;
		public var data:*;
		public var state:String;
		
		public function TreeEvent(type:String, state:String, nodeType:String, data:*, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable);
			this.data = data;
			this.state = state;
			this.nodeType = nodeType;
		}	}}