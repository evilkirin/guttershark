package net.guttershark.managers 
{
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import net.guttershark.display.buttons.IToggleable;	

	/**
	 * The FormManager class simplifies managing InteractiveObjects
	 * that compose a form - THIS IS STILL IN DEVELOPMENT, BUT EVERYTHING
	 * HERE WORKS, IT'S JUST NOT FEATURE COMPLETE.
	 */
	final public class FormManager
	{

		private var tfs:Array;
		private var tbs:Array;
		private var trusub:String;
		private var falssub:String;
		
		/**
		 * Constructor for FormFieldManager instances.
		 */
		public function FormManager()
		{
			tfs = new Array();
			tbs = new Array();
		}
		
		/**
		 * Shortcut for a method that would otherwise have duplicate logic.
		 */
		private function getOutputAsType(type:Class):*
		{
			var out:*;
			var i:int;
			if(type == URLVariables) out = new URLVariables();
			else if(type == Object) out = new Object();
			for(i = 0; i < tfs.length; i++) out[tfs[i].name] = tfs[i].text;
			for(i = 0; i < tbs.length; i++)
			{
				out[tbs[i].name] = tbs[i].toggled;
				if(tbs[i].toggled && trusub) out[tbs[i].name] = trusub;
				else if((tbs[i].toggled === false) && falssub) out[tbs[i].name] = falssub;
			}
			return out;
		}
		
		/**
		 * Change what the output value is displayed as for a boolean. You could
		 * substitue true with "yes" or false with "no" etc. Values for booleans
		 * are only substituded with the <code><em>getOutputAsObject</em></code> and 
		 * <code><em>getOutputAsURLVariables</em></code> methods.
		 */
		public function displayBooleansAs(truSubstitute:String, falsSubstitute:String):void
		{
			trusub = truSubstitute;
			falssub = falsSubstitute;
		}
		
		/**
		 * Add a TextField to the manager.
		 * @param	tf	A TextField.
		 */
		public function addTextField(tf:TextField):void
		{
			tfs.push(tf);
		}
		
		/**
		 * Add multiple TextFields to the manager.
		 * @param	tfs	An array of TextFields.
		 */
		public function addTextFields(tfs:Array):void
		{
			for(var i:int = 0; i < tfs.length; i++)
			{
				this.tfs.push(tfs[i]);
			}
		}
		
		/**
		 * Add an IToggleable instance to the manager.
		 * @param	toggleable An IToggleable instance.
		 */
		public function addToggleable(toggleable:IToggleable):void
		{
			tbs.push(toggleable);
		}
		
		/**
		 * Add multiple IToggleable clips to the manager.
		 * @param	toggleables	An array of IToggleable clips.
		 */
		public function addToggleables(toggleables:Array):void
		{
			for(var i:int = 0; i < toggleables.length; i++)
			{
				this.tbs.push(toggleables[i]);
			}
		}
		
		/**
		 * Get all data from the form as a URLVariables instance.
		 * @return 	URLVariables
		 */
		public function getOutputAsURLVariables():URLVariables
		{
			return getOutputAsType(URLVariables);
		}
		
		/**
		 * Get all data from the form as a generic Object.
		 * @return	Object
		 */
		public function getOutputAsObject():Object
		{
			return getOutputAsType(Object);
		}
		
		/**
		 * Get all data from the form as a URL encoded string.
		 * @return	String
		 */
		public function getOutputAsQueryString():String
		{
			var uv:URLVariables = getOutputAsType(URLVariables);
			return uv.toString();
		}

		/**
		 * Set the tabs for all fields in the form.
		 * 
		 * <p>It will set tabs in this order:</p>
		 * <ol>
		 * <li>TextFields</li>
		 * <li>IToggleables</li>
		 * </ol>
		 * 
		 * <p><strong>Or</strong> if you provide an array of clips
		 * in the call to set tabs, it will use whatever order
		 * the array is in.</p>
		 */
		public function setTabs(clips:Array = null):void
		{
			var i:int;
			var c:int = 0;
			if(clips)
			{
				for(i = 0; i < clips.length; i++)
				{
				 	clips[i].tabIndex = i;
				}	
			}
			else
			{
				for(i = 0; i < tfs.length; i++)
				{
					tfs[i].tabIndex = c;
					c++;
				}
				
				for(i = 0; i < tbs.length; i++)
				{
					tbs[i].tabIndex = c;
					c++;
				}
			}
		}
		
		/**
		 * Sets the tabEnabled property to false on all toggleable clips
		 * in the manager.
		 */
		public function disableTabsOnToggleables():void
		{
			for(var i:int = 0; i < tbs.length; i++)
			{
				tbs[i].tabEnabled = false;
			}
		}
		
		/**
		 * Sets the tabEnabled property to true on all toggleable clips
		 * in the manager.
		 */
		public function enableTabsOnToggleables():void
		{
			for(var i:int = 0; i < tbs.length; i++)
			{
				tbs[i].tabEnabled = true;
			}
		}
		
		/**
		 * Dispose of this FormFieldManager.
		 */
		public function dispose():void
		{
			tfs = null;
			tbs = null;
			trusub = null;
			falssub = null;
		}	}}