package awaybuilder.controller.document.events
{
	import awaybuilder.controller.events.ReadDocumentEvent;
	
	import flash.events.Event;

	public class ImportTextureEvent extends ReadDocumentEvent
	{
		public static const IMPORT_AND_BITMAP_REPLACE:String = "importBitmapAndRplace";
		public static const LOAD_AND_BITMAP_REPLACE:String = "loadBitmapAndRplace";
		
		public static const IMPORT_AND_ADD:String = "importTextureForMaterial";
		public static const LOAD_AND_ADD:String = "loadTextureForMaterial";
		
		public function ImportTextureEvent( type:String, items:Array, options:Object=null )
		{
			super( type );
			this.items = items;
			this.options = options;
		}
		
		public var items:Array;
		public var options:Object;
		
		override public function clone():Event
		{
			return new ImportTextureEvent(this.type, this.items, this.options );
		}
	}
}