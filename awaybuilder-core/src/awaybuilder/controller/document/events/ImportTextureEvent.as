package awaybuilder.controller.document.events
{
	import awaybuilder.controller.events.ReadDocumentEvent;
	
	import flash.events.Event;

	public class ImportTextureEvent extends ReadDocumentEvent
	{
		public static const IMPORT_AND_REPLACE:String = "importTextureAndRplace";
		public static const LOAD_AND_REPLACE:String = "loadTextureAndRplace";
		
		public static const IMPORT_AND_ADD:String = "importTextureForMaterial";
		public static const LOAD_AND_ADD:String = "loadTextureForMaterial";
		
		public function ImportTextureEvent( type:String, items:Array )
		{
			super( type );
			this.items = items;
		}
		
		public var items:Array;
		
		override public function clone():Event
		{
			return new ImportTextureEvent(this.type, this.items );
		}
	}
}