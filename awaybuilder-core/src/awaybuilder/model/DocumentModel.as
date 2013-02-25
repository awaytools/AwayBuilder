package awaybuilder.model
{
	import mx.collections.ArrayCollection;
	
	import awaybuilder.events.DocumentModelEvent;
	
	import org.robotlegs.mvcs.Actor;

	public class DocumentModel extends Actor implements IDocumentModel
	{
		
		private var _name:String;
		public function get name():String
		{
			return this._name;
		}
		public function set name(value:String):void
		{
			if(this._name == value)
			{
				return;
			}
			this._name = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_NAME_CHANGED));
		}
		
		private var _edited:Boolean = false;
		public function get edited():Boolean
		{
			return this._edited;
		}
		public function set edited(value:Boolean):void
		{
			if(this._edited == value)
			{
				return;
			}
			this._edited = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_EDITED));
		}
		
		private var _suppressEdits:Boolean = false;
		public function get suppressEdits():Boolean
		{
			return this._suppressEdits;
		}
		public function set suppressEdits(value:Boolean):void
		{
			this._suppressEdits = value;
		}
		
		private var _savedNativePath:String;
		public function get path():String
		{
			return this._savedNativePath;
		}
		public function set path(value:String):void
		{
			this._savedNativePath = value;
		}
		
		
		private var _scenegraph:ArrayCollection = new ArrayCollection();
		public function get scenegraph():ArrayCollection
		{
			return this._scenegraph;
		}
		public function set scenegraph(value:ArrayCollection):void
		{
			this._scenegraph = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}