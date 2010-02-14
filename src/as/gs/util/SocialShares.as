package gs.util 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * The SocialShares class contains methods that have shortcuts
	 * for navigating to social sites, to share a link.
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public class SocialShares
	{
		
		/**
		 * info lookup
		 */
		private static var info:Dictionary = new Dictionary(true);
		
		/**
		 * Share to myspace.
		 * 
		 * @param url The url to share.
		 * @param title The link title.
		 * @param window The window for the url.
		 */
		public static function myspace(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://www.myspace.com/Modules/PostTo/Pages/?t='+escape(title)+'&c=&u='+escape(url)),window);
			//navigateToURL(new URLRequest('http://www.myspace.com/Modules/PostTo/Pages/?t='+escape(title)+'&c=&u='+escape(url)),window);
		}
		
		/**
		 * Handles a myspace button for you.
		 * 
		 * @param obj The display object button that triggers the myspace share.
		 * @param url The url to share.
		 * @param title The url title.
		 * @param window The window type.
		 */
		public static function handleMyspace(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info["myspace"])info["myspace"]=new Dictionary();
			info["myspace"][obj]={url:url,title:title,window:window};
			obj.addEventListener(MouseEvent.CLICK,onMyspace);
		}
		
		/**
		 * Unhandles myspace.
		 * 
		 * @param obj The myspace sprite.
		 */
		public static function unhandleMyspace(obj:Sprite):void
		{
			delete info["myspace"][obj];
			delete info["myspace"];
			obj.removeEventListener(MouseEvent.CLICK,onMyspace);
		}
		
		/**
		 * On myspace.
		 */
		private static function onMyspace(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["myspace"][obj];
			myspace(params.url,params.title,params.window);
		}
		
		/**
		 * Share to stumble-upon.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function stumbleupon(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://www.stumbleupon.com/submit?url='+escape(url)),window);
			//navigateToURL(new URLRequest('http://www.stumbleupon.com/submit?url='+escape(url)),window);
		}
		
		/**
		 * Handles stumble upon for you.
		 */
		public static function handleStumbleUpon(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['su'])info['su']=new Dictionary();
			info['su'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onStumbleUpon);
		}
		
		/**
		 * Unhandles stumble upon.
		 * 
		 * @param obj The sprite that is triggering stumble upon sharing.
		 */
		public static function unhandleStumbleupon(obj:Sprite):void
		{
			delete info["su"][obj];
			delete info["su"];
			obj.removeEventListener(MouseEvent.CLICK,onStumbleUpon);
		}
		
		/**
		 * On stumble upon click.
		 */
		private static function onStumbleUpon(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["su"][obj];
			stumbleupon(params.url,params.window);
		}
		
		/**
		 * Share to digg.
		 * 
		 * @param url The url to share.
		 * @param title The link title.
		 * @param window The window for the url.
		 */
		public static function digg(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://digg.com/submit?url='+escape(url)+'&title='+escape(title)),window);
			//navigateToURL(new URLRequest('http://digg.com/submit?url='+escape(url)+'&title='+escape(title)),window);
		}
		
		/**
		 * Handles digg.
		 */
		public static function handleDigg(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['digg'])info['digg']=new Dictionary();
			info['digg'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onDigg);
		}
		
		/**
		 * Unhandles digg.
		 * 
		 * @param obj The display object that's triggering digg sharing.
		 */
		public static function unhandleDigg(obj:Sprite):void
		{
			delete info["digg"][obj];
			delete info["digg"];
			obj.removeEventListener(MouseEvent.CLICK,onDigg);
		}
		
		/**
		 * On digg click.
		 */
		private static function onDigg(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["digg"][obj];
			digg(params.url,params.title,params.window);
		}
		
		/**
		 * Share to delicious.
		 * 
		 * @param url The url to share.
		 * @param title The link title.
		 * @param window The window for the url.
		 */
		public static function delicious(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://del.icio.us/loginName?url='+escape(url)+'&title='+escape(title)+'&v=4'),window);
			//navigateToURL(new URLRequest('http://del.icio.us/loginName?url='+escape(url)+'&title='+escape(title)+'&v=4'),window);
		}
		
		/**
		 * Handles delicious.
		 */
		public static function handleDelicious(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['del'])info['del']=new Dictionary();
			info['del'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onDelicious);
		}
		
		/**
		 * Unhandles delicious.
		 * 
		 * @param obj The sprite that is triggering delicious sharing.
		 */
		public static function unhandleDelicious(obj:Sprite):void
		{
			delete info["del"][obj];
			delete info["del"];
			obj.removeEventListener(MouseEvent.CLICK,onDelicious);
		}
		
		/**
		 * On delicious click.
		 */
		private static function onDelicious(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["del"][obj];
			delicious(params.url,params.title,params.window);
		}
		
		/**
		 * Share to facebook.
		 * 
		 * @param url The url to share.
		 * @param title The link title.
		 * @param window The window for the url.
		 */
		public static function facebook(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://www.facebook.com/share.php?u='+escape(url)+'&t='+escape(title)),window);
			//navigateToURL(new URLRequest('http://www.facebook.com/share.php?u='+escape(url)+'&t='+escape(title)),window);
		}
		
		/**
		 * Handles facebook.
		 */
		public static function handleFacebook(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['face'])info['face']=new Dictionary();
			info['face'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onFacebook);
		}
		
		/**
		 * Unhandles facebook.
		 * 
		 * @param obj The sprite that triggers facebook sharing.
		 */
		public static function unhandleFacebook(obj:Sprite):void
		{
			delete info["face"][obj];
			delete info["face"];
			obj.removeEventListener(MouseEvent.CLICK,onFacebook);
		}
		
		/**
		 * On facebook click.
		 */
		private static function onFacebook(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["face"][obj];
			facebook(params.url,params.title,params.window);
		}
		
		/**
		 * Share to reddit.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function reddit(url:String,window:String="_blank"):void
		{
			NavigateToURL.navToURL(new URLRequest("http://www.reddit.com/submit?url="+escape(url)),window);
			//navigateToURL(new URLRequest("http://www.reddit.com/submit?url="+escape(url)),window);
		}
		
		/**
		 * Handles reddit.
		 */
		public static function handleReddit(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['red'])info['red']=new Dictionary();
			info['red'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onReddit);
		}
		
		/**
		 * Unhandles reddit.
		 * 
		 * @param obj The sprite that is triggering reddit sharing.
		 */
		public static function unhandleReddit(obj:Sprite):void
		{
			delete info["red"][obj];
			delete info["red"];
			obj.removeEventListener(MouseEvent.CLICK,onReddit);
		}
		
		/**
		 * On reddit click.
		 */
		private static function onReddit(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["red"][obj];
			reddit(params.url,params.window);
		}
		
		/**
		 * Share to furl.
		 * 
		 * @param url The url to share.
		 * @param title The link title.
		 * @param window The window for the url.
		 */
		public static function furl(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://www.furl.net/storeIt.jsp?u='+escape(url)+'&keywords=&t='+escape(title)),window);
			//navigateToURL(new URLRequest('http://www.furl.net/storeIt.jsp?u='+escape(url)+'&keywords=&t='+escape(title)),window);
		}
		
		/**
		 * Handles furl.
		 */
		public static function handleFurl(obj:Sprite,url:String,title:String,window:String="_blank"):void
		{
			if(!info['furl'])info['furl']=new Dictionary();
			info['furl'][obj]={url:url,window:window,title:title};
			obj.addEventListener(MouseEvent.CLICK,onFurl);
		}
		
		/**
		 * Unhandles furl.
		 * 
		 * @param obj The object that is triggering furl sharing.
		 */
		public static function unhandleFurl(obj:Sprite):void
		{
			delete info["furl"][obj];
			delete info["furl"];
			obj.removeEventListener(MouseEvent.CLICK,onFurl);	
		}
		
		/**
		 * On furl click.
		 */
		private static function onFurl(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["furl"][obj];
			furl(params.url,params.title,params.window);
		}
		
		/**
		 * Share to windows live.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function winlive(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('https://favorites.live.com/quickadd.aspx?url='+escape(url)),window);
			//navigateToURL(new URLRequest('https://favorites.live.com/quickadd.aspx?url='+escape(url)),window);
		}
		
		/**
		 * Handles winlive.
		 */
		public static function handleWinlive(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['win'])info['win']=new Dictionary();
			info['win'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onWin);
		}
		
		/**
		 * Unhandles windows live.
		 * 
		 * @param obj The object that's triggering windows live sharing.
		 */
		public static function unhandleWinlive(obj:Sprite):void
		{
			delete info["win"][obj];
			delete info["win"];
			obj.removeEventListener(MouseEvent.CLICK,onWin);
		}
		
		/**
		 * On furl click.
		 */
		private static function onWin(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["win"][obj];
			winlive(params.url,params.window);
		}
		
		/**
		 * Share to technorati.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function technorati(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://www.technorati.com/faves/loginName?add='+escape(url)),window);
			//navigateToURL(new URLRequest('http://www.technorati.com/faves/loginName?add='+escape(url)),window);
		}
		
		/**
		 * Share to mr. wong.
		 * 
		 * @param url The url to share.
		 * @param description The description of the page you're adding.
		 * @param window The window for the url.
		 */
		public static function mrwong(url:String,description:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!description)return;
			NavigateToURL.navToURL(new URLRequest('http://www.mister-wong.com/index.php?action=addurl&bm_url='+escape(url)+'&bm_description='+escape(description)),window);
			//navigateToURL(new URLRequest('http://www.mister-wong.com/index.php?action=addurl&bm_url='+escape(url)+'&bm_description='+escape(description)),window);
		}
		
		/**
		 * Share to sphinn.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function sphinn(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://sphinn.com/submit.php?url='+escape(url)),window);
			//navigateToURL(new URLRequest('http://sphinn.com/submit.php?url='+escape(url)),window);
		}
		
		/**
		 * Tweet this shit.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function twitter(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://twitter.com/home?status='+escape(url)),window);
			//navigateToURL(new URLRequest('http://twitter.com/home?status='+escape(url)),window);
		}
		
		/**
		 * Handles twitter.
		 */
		public function handleTwitter(obj:Sprite,url:String,window:String="_blank"):void
		{
			if(!info['twitter'])info['twitter']=new Dictionary();
			info['twitter'][obj]={url:url,window:window};
			obj.addEventListener(MouseEvent.CLICK,onTwitter);
		}
		
		/**
		 * Unhandles twitter.
		 * 
		 * @param obj The object that is triggering twitter sharing.
		 */
		public static function unhandleTwitter(obj:Sprite):void
		{
			delete info["twitter"][obj];
			delete info["twitter"];
			obj.removeEventListener(MouseEvent.CLICK,onTwitter);
		}
		
		/**
		 * On furl click.
		 */
		private static function onTwitter(e:*):void
		{
			var obj:* =e.currentTarget;
			var params:Object=info["twitter"][obj];
			twitter(params.url,params.window);
		}
		
		/**
		 * Share to myjeeves.ask.com.
		 * 
		 * @param url The url to share.
		 * @param title The title of the page you're adding.
		 * @param window The window for the url.
		 */
		public static function ask(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			NavigateToURL.navToURL(new URLRequest('http://myjeeves.ask.com/mysearch/BookmarkIt?v=1.2&t=webpages&url='+escape(url)+'&title='+escape(title)),window);
			//navigateToURL(new URLRequest('http://myjeeves.ask.com/mysearch/BookmarkIt?v=1.2&t=webpages&url='+escape(url)+'&title='+escape(title)),window);
		}
		
		/**
		 * Share to slashdot.
		 * 
		 * @param url The url to share.
		 * @param window The window for the url.
		 */
		public static function slashdot(url:String,window:String="_blank"):void
		{
			if(!url)return;
			NavigateToURL.navToURL(new URLRequest('http://slashdot.org/bookmark.pl?url='+escape(url)),window);
			//navigateToURL(new URLRequest('http://slashdot.org/bookmark.pl?url='+escape(url)),window);
		}
		
		/**
		 * Share to news vine.
		 * 
		 * @param url The url to share.
		 * @param title The title of the page you're adding.
		 * @param window The window for the url.
		 */
		public static function newsvine(url:String,title:String,window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			NavigateToURL.navToURL(new URLRequest('http://www.newsvine.com/_tools/seed&save?u='+escape(url)+'&h='+escape(title)),window);
			//navigateToURL(new URLRequest('http://www.newsvine.com/_tools/seed&save?u='+escape(url)+'&h='+escape(title)),window);
		}
	}
}