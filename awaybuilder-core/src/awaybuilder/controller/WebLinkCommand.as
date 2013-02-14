package awaybuilder.controller
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import awaybuilder.events.WebLinkEvent;
	import awaybuilder.utils.logging.AwayBuilderLogger;
	
	import org.robotlegs.mvcs.Command;
	
	public class WebLinkCommand extends Command
	{	
		private static const EVENT_TO_URL:Object = {};
		EVENT_TO_URL[WebLinkEvent.LINK_TWITTER] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_FACEBOOK] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_HOME] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_BLOG] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_BUG_REPORTS] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_DOWNLOAD] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_ONLINE_HELP] = "http://localhost/";
		EVENT_TO_URL[WebLinkEvent.LINK_NEWSLETTER] = "http://localhost/";
		
		[Inject]
		public var event:WebLinkEvent;
		
		override public function execute():void
		{
			if(!EVENT_TO_URL.hasOwnProperty(event.type))
			{
				AwayBuilderLogger.error("Unable to trigger web link to " + event.type + ".");
				return;
			}
			var url:String = EVENT_TO_URL[event.type];
			navigateToURL(new URLRequest(url), "_blank");
		}
	}
}