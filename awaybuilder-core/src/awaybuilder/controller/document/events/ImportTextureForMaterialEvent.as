package awaybuilder.controller.document.events
{
	import awaybuilder.controller.events.ReadDocumentEvent;
	
	import flash.events.Event;

	public class ImportTextureForMaterialEvent extends ReadDocumentEvent
	{
		public static const IMPORT:String = "importTextureForMaterial";
		public static const LOAD:String = "loadTextureForMaterial";
		
		public function ImportTextureForMaterialEvent( type:String, items:Array )
		{
			super( type );
			this.items = items;
		}
		
		public var items:Array;
		
		override public function clone():Event
		{
			return new ImportTextureForMaterialEvent(this.type, this.items );
		}
	}
}