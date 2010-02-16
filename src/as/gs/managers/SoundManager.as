package gs.managers
{
	import gs.support.soundmanager.AudioGroup;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * The SoundManager class is a singleton that simplifies managing sounds.
	 * 
	 * <p>To get started, the first thing you must do is
	 * create a group with the <em>createGroup</em> method.</p>
	 * 
	 * @example Creating a new group:
	 * <listing>	
	 * snm.createGroup("myGroup");
	 * </listing>
	 * 
	 * <p>After you've created a group, it becomes a property on the
	 * sound manager you can access by name.</p>
	 * 
	 * @example Accessing the group:
	 * <listing>	
	 * trace(snm.myGroup);
	 * </listing>
	 * 
	 * <p>After you have a group, you can add sound instances and objects
	 * to it, which can be controlled entirely as a group, or
	 * individually.</p>
	 * 
	 * @example Adding a sound and a display object to a group:
	 * <listing>	
	 * var am:AssetManager=AssetManager.gi();
	 * var myFLVPlayer:FLV=new FLV();
	 * snm.myGroup.addObject("sparkle",am.getSound("Sparkle"));
	 * snm.myGroup.addObject("flvPlayer",myFLVPlayer);
	 * </listing>
	 * 
	 * <p>After you've added objects to the group, you can control
	 * the group, or individual objects.</p>
	 * 
	 * @example Controlling a group, and objects:
	 * <listing>	
	 * snm.myGroup.play(); //plays all sound instances in the group
	 * snm.myGroup.volume=.3; //sets the volume to .3 for all objects in the group
	 * snm.myGroup.sparkle.play(); //plays the "sparkle" sound from this group.
	 * snm.myGroup.flvPlayer.mute(); //mutes the flv player object.
	 * </listing>
	 * 
	 * <p>The key thing to note is what object types your accessing, which
	 * will point you in the right direction for what methods
	 * and properties are accessable.</p>
	 * 
	 * @example What objects are you accessing?
	 * <listing>	
	 * trace(snm.myGroup); //-> [Object AudioGroup]
	 * trace(snm.myGroup.sparkle); //-> [Object AudioObject]
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 * 
	 * @see gs.support.soundmanager.AudioObject
	 * @see gs.support.soundmanager.AudioGroup
	 */
	final public dynamic class SoundManager extends Proxy
	{
	
		/**
		 * Singleton instance.
		 */
		private static var inst:SoundManager;
		
		/**
		 * stored groups.
		 */
		private var groups:Dictionary;
		
		/**
		 * Singleton access.
		 */
		public static function gi():SoundManager
		{
			if(!inst)inst=new SoundManager();
			return inst;
		}
		
		/**
		 * @private
		 */
		public function SoundManager()
		{
			groups=new Dictionary();
		}
		
		/**
		 * Create an audio group.
		 * 
		 * @param id The group id.
		 */
		public function createGroup(id:String):void
		{
			groups[id]=new AudioGroup(id);
		}
		
		/**
		 * Destroy an audio group.
		 * 
		 * @param id The group id.
		 */
		public function destroyGroup(id:String):void
		{
			AudioGroup(groups[id]).dispose();
			groups[id]=null;
			delete groups[id];
		}
		
		/**
		 * Check whether or not a group exists.
		 * 
		 * @param id The group id.
		 */
		public function doesGroupExist(id:String):Boolean
		{
			return !(groups[id]==null);
		}
		
		/**
		 * Get an audio group.
		 * 
		 * @param id The group id.
		 */
		public function getGroup(id:String):AudioGroup
		{
			return groups[id];
		}

		/**
		 * @private
		 * 
		 * getProperty - override getters to return null always.
		 */
		flash_proxy override function getProperty(name:*):*
		{
			if(!groups[name])groups[name]=new AudioGroup(name);
			return groups[name];
		}
		
		/**
		 * @private
		 */
		flash_proxy override function callProperty(methodName:*, ...args):*
		{
			trace("Method {"+methodName+"} not found.");
			return null;
		}
	}
}