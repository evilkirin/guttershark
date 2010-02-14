package gs.display.tabbar 
{
	import gs.support.bindings.PropertyChangeEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;		

	/**
	 * Dispatched any time a view change occurs.
	 * 
	 * @eventType flash.events.Event
	 */
	[Event("indexChange", type="flash.events.Event")]

	/**
	 * The TabBar class manages views that
	 * are associated with buttons. Only one view
	 * can be shown at a time, and clicking a button,
	 * triggers it's associated view to be shown.
	 * 
	 * <p>The TabBar also uses methods from ITabView,
	 * and ITabButton, to create hooks into the sequence
	 * of switching tabs to another view. Which allows,
	 * you to do some sophisticated things when switching
	 * tabs - like waiting for an event from the current
	 * view before switching, denying a view switch, etc.
	 * See those two interfaces for a description of each
	 * method.</p>
	 * 
	 * <p>This class does not manage any visual
	 * aspects of the tab bar.</p>
	 */
	public class TabBar extends EventDispatcher
	{
		
		/**
		 * Event constant for an index(view) change.
		 */
		public static const INDEX_CHANGE:String = "indexChange";
		
		/**
		 * Tabs / view lookup.
		 */
		private var tabs:Dictionary;
		
		/**
		 * Lookup for tab buttons by index.
		 */
		private var indexLookup:Dictionary;
		
		/**
		 * Cursor counter for adding views.
		 */
		private var cursor:int;
		
		/**
		 * Cur index selected.
		 */
		private var curIndex:int;

		/**
		 * Lookup for buttons to a cursor number.
		 */
		private var buttonToIndex:Dictionary;

		/**
		 * The cur view shown.
		 */
		private var curView:*;
		
		/**
		 * The next view, when a wait for event
		 * happens.
		 */
		private var nextView:*;
		
		/**
		 * The next button, when a wait for
		 * event happens
		 */
		private var nextButton:*;
		
		/**
		 * The cur tab button shown.
		 */
		private var curButton:*;
		
		/**
		 * Total view count.
		 */
		private var totalViews:int;

		/**
		 * Constructor for TabBar instances.
		 */
		public function TabBar()
		{
			super();
			cursor=-1;
			curIndex=-1;
			totalViews=0;
			tabs=new Dictionary(true);
			indexLookup=new Dictionary();
			buttonToIndex=new Dictionary();
		}

		/**
		 * Add a tab to the tab bar.
		 * 
		 * @param button Any button that implements ITabButton.
		 * @param view Any view that implements ITabView.
		 */
		public function addTab(button:ITabButton,view:ITabView):void
		{
			tabs[button]=view;
			button.addEventListener(MouseEvent.CLICK,onButtonClick);
			indexLookup[++cursor]=button;
			buttonToIndex[button]=cursor;
			totalViews++;
		}
		
		/**
		 * Select a view / tab by index.
		 */
		public function selectByIndex(index:Number):void
		{
			selectView(indexLookup[index]);
		}
		
		/**
		 * Select a view by the associated button.
		 */
		public function selectByButton(button:ITabButton):void
		{
			selectView(button);
		}
		
		/**
		 * Hide all views, and select an index.
		 * 
		 * @param i The index to select.
		 */
		public function hideAllAndSelectIndex(i:int):void
		{
			var b:*;
			for each(b in tabs) b.hide();
			selectView(indexLookup[i]);
		}
		
		/**
		 * Hide all views, then select the first one.
		 */
		public function hideAllAndSelectFirst():void
		{
			hideAllAndSelectIndex(0);
		}
		
		/**
		 * Select the first tab.
		 */
		public function selectFirst():void
		{
			selectView(indexLookup[0]);
		}
		
		/**
		 * Select the last tab.
		 */
		public function selectLast():void
		{
			selectView(indexLookup[totalViews-1]);
		}
		
		/**
		 * The current selected index, setting it triggers
		 * a view switch.
		 */
		public function set selectedIndex(index:int):void
		{
			selectView(indexLookup[index]);
		}
		
		/**
		 * [Bindable] The current selected index, setting it triggers
		 * a view switch.
		 */
		public function get selectedIndex():int
		{
			return buttonToIndex[curButton];
		}
		
		/**
		 * trigger bindings.
		 */
		private function updateBindings():void
		{
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.CHANGE+"selectedIndex","selectedIndex"));
		}
		
		/**
		 * Index change event.
		 */
		private function indexChange():void
		{
			dispatchEvent(new Event(TabBar.INDEX_CHANGE));
		}

		/**
		 * Select a view, by button.
		 */
		private function selectView(button:ITabButton):void
		{
			if(curButton==button)return;
			var b:ITabButton=ITabButton(button);
			var v:ITabView=ITabView(tabs[b]);
			if(curView&&!curView.shouldActivateOther())
			{
				curView.couldNotActivateOther();
				return;
			}
			if(curView)
			{
				var e:String=curView.waitForEvent();
				if(e)
				{
					nextView=v;
					nextButton=b;
					curView.addEventListener(e,onEvent);
					curView.tabBarIsWaiting();
					return;
				}
			}
			if(curButton)curButton.deactivate();
			curButton=b;
			curButton.activate();
			if(curView)
			{
				curView.hide();
				curView.deselect();
			}
			curView=v;
			curView.show();
			updateBindings();
			indexChange();
			curView.select();
		}
		
		/**
		 * On the wait event, trigger the switch.
		 */
		private function onEvent(e:Event):void
		{
			curView.removeEventListener(e,onEvent);
			if(curButton)curButton.deactivate();
			curButton=nextButton;
			curButton.activate();
			curView.hide();
			curView.deselect();
			curView=nextView;
			curView.show();
			updateBindings();
			indexChange();
			curView.select();
		}
		
		/**
		 * On button click, do some view switching.
		 */
		private function onButtonClick(me:MouseEvent):void
		{
			if(me.target is ITabButton) selectView(me.target as ITabButton);
			else selectView(me.currentTarget as ITabButton);
		}
		
		/**
		 * Dispose of this tab bar.
		 */
		public function dispose():void
		{
			var button:*;
			for(button in tabs)
			{
				button.removeEventListener(MouseEvent.CLICK,onButtonClick);
				tabs[button]=null;
				delete tabs[button];
			}
			tabs=null;
			var index:*;
			for(index in indexLookup)
			{
				indexLookup[index]=null;
				delete indexLookup[index];
			}
			indexLookup=null;
			for(button in buttonToIndex)
			{
				buttonToIndex[button]=null;
				delete buttonToIndex[button];
			}
			buttonToIndex=null;
			tabs=null;
			curButton=null;
			curIndex = 0;
			cursor = 0;
			curView=null;
		}
	}
}