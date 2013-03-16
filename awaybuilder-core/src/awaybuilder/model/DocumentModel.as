package awaybuilder.model
{
	import mx.collections.ArrayCollection;
	
	import spark.collections.Sort;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.ScenegraphItemVO;
	
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
		
		private var _savedNativePath:String;
		public function get path():String
		{
			return this._savedNativePath;
		}
		public function set path(value:String):void
		{
			this._savedNativePath = value;
		}
		
		
		private var _scenegraphSort:Sort = new Sort();
		private var _scenegraph:ArrayCollection = new ArrayCollection();
		public function get scenegraph():ArrayCollection
		{
			return this._scenegraph;
		}
		public function set scenegraph(value:ArrayCollection):void
		{
			this._scenegraph = value;
			_scenegraphSort.compareFunction = compareGroupItems;
			this._scenegraph.sort = _scenegraphSort;
			this._scenegraph.refresh();
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		private function compareGroupItems( a:Object, b:Object ):int
		{
			var group1:ScenegraphGroupItemVO = a as ScenegraphGroupItemVO;
			var group2:ScenegraphGroupItemVO = b as ScenegraphGroupItemVO;
			if (group1 == null && group2 == null) return 0;
			if (group1 == null)	return 1;
			if (group2 == null)	return -1;
			if (group1.weight < group2.weight) return -1;
			if (group1.weight > group2.weight) return 1;
			return 0;
		}

		private var _selectedObjects:Vector.<ScenegraphItemVO> = new Vector.<ScenegraphItemVO>();
		public function get selectedObjects():Vector.<ScenegraphItemVO>
		{
			return this._selectedObjects;
		}
		public function set selectedObjects(value:Vector.<ScenegraphItemVO>):void
		{
			this._selectedObjects = value;
			//this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		public function getScenegraphGroup( type:String ):ScenegraphGroupItemVO 
		{
			for each( var item:ScenegraphItemVO in _scenegraph ) 
			{
				if( item is ScenegraphGroupItemVO ) 
				{
					var group:ScenegraphGroupItemVO = item as ScenegraphGroupItemVO;
					if( group.type == type ) {
						return group;
					}
				}
			}
			return null;
		}

        public function getScenegraphItem( value:Object ):ScenegraphItemVO
        {
            return getItemInCollection( _scenegraph, value );
        }
        private function getItemInCollection( children:ArrayCollection, value:Object ):ScenegraphItemVO
        {
            for each( var vo:ScenegraphItemVO in children )
            {
                if( vo.item == value ) {
                    return vo;
                }
                if( vo.children && vo.children.length )
                {
                    var item:ScenegraphItemVO = getItemInCollection( vo.children, value );
                    if( item ) {
                        return item;
                    }

                }
            }
            return null;
        }

		
	}
}