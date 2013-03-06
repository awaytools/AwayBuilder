package awaybuilder.controller.events
{
	import flash.events.Event;
	
	public class WebLinkEvent extends Event
	{
		public static const LINK_TWITTER:String = "linkTwitter";
		public static const LINK_FACEBOOK:String = "linkFacebook";
		public static const LINK_BLOG:String = "linkBlog";
		public static const LINK_NEWSLETTER:String = "linkNewsletter";
		public static const LINK_BUG_REPORTS:String = "linkBugReports";
		public static const LINK_DOWNLOAD:String = "linkDownload";
		public static const LINK_HOME:String = "linkHome";
		public static const LINK_ONLINE_HELP:String = "linkOnlineHelp";
		
		public function WebLinkEvent(type:String)
		{
			super(type, false, false);
		}
		
		override public function clone():Event
		{
			return new WebLinkEvent(this.type);
		}
	}
}