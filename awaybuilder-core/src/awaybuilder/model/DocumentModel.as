package awaybuilder.model
{
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.model.vo.DocumentBaseVO;
	import awaybuilder.model.vo.TextureMaterialVO;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;
	
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
		
//		private var _scenegraphSort:Sort = new Sort();
//		private var _scenegraph:ArrayCollection = new ArrayCollection();
//		public function get scenegraph():ArrayCollection
//		{
//			return this._scenegraph;
//		}
//		public function set scenegraph(value:ArrayCollection):void
//		{
//			this._scenegraph = value;
//			_scenegraphSort.compareFunction = compareGroupItems;
//			this._scenegraph.sort = _scenegraphSort;
//			this._scenegraph.refresh();
//			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
//		}
//		private function compareGroupItems( a:Object, b:Object ):int
//		{
//			var group1:ScenegraphGroupItemVO = a as ScenegraphGroupItemVO;
//			var group2:ScenegraphGroupItemVO = b as ScenegraphGroupItemVO;
//			if (group1 == null && group2 == null) return 0;
//			if (group1 == null)	return 1;
//			if (group2 == null)	return -1;
//			if (group1.weight < group2.weight) return -1;
//			if (group1.weight > group2.weight) return 1;
//			return 0;
//		}

		private var _selectedObjects:Vector.<Object> = new Vector.<Object>();
		public function get selectedObjects():Vector.<Object>
		{
			return this._selectedObjects;
		}
		public function set selectedObjects(value:Vector.<Object>):void
		{
			this._selectedObjects = value;
			//this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
//		public function getScenegraphGroup( type:String ):ScenegraphGroupItemVO 
//		{
//			for each( var item:ScenegraphItemVO in _scenegraph ) 
//			{
//				if( item is ScenegraphGroupItemVO ) 
//				{
//					var group:ScenegraphGroupItemVO = item as ScenegraphGroupItemVO;
//					if( group.type == type ) {
//						return group;
//					}
//				}
//			}
//			return null;
//		}
//
//        public function getScenegraphItem( value:Object ):ScenegraphItemVO
//        {
//            return getItemInCollection( _scenegraph, value );
//        }
        

		private var _animations:ArrayCollection;
		public function get animations():ArrayCollection
		{
			return _animations;
		}
		
		public function set animations(value:ArrayCollection):void
		{
			this._animations = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _geometry:ArrayCollection;
		public function get geometry():ArrayCollection
		{
			return _geometry;
		}
		
		public function set geometry(value:ArrayCollection):void
		{
			this._geometry = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _materials:ArrayCollection;
		public function get materials():ArrayCollection
		{
			return _materials;
		}
		
		public function set materials(value:ArrayCollection):void
		{
			this._materials = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _scene:ArrayCollection;
		public function get scene():ArrayCollection
		{
			return _scene;
		}
		
		public function set scene(value:ArrayCollection):void
		{
			this._scene = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _skeletons:ArrayCollection;
		public function get skeletons():ArrayCollection
		{
			return _skeletons;
		}
		
		public function set skeletons(value:ArrayCollection):void
		{
			this._skeletons = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _textures:ArrayCollection;
		public function get textures():ArrayCollection
		{
			return _textures;
		}
		
		public function set textures(value:ArrayCollection):void
		{
			this._textures = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		private var _lights:ArrayCollection;
		public function get lights():ArrayCollection
		{
			return _lights;
		}
		
		public function set lights(value:ArrayCollection):void
		{
			this._lights = value;
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.OBJECTS_UPDATED));
		}
		
		public function getAnimation(value:Object):DocumentBaseVO
		{
			return getItemInCollection( animations, value );
		}
		
		public function getGeometry(value:Object):DocumentBaseVO
		{
			return getItemInCollection( geometry, value );
		}
		
		public function getLight(value:Object):DocumentBaseVO
		{
			return getItemInCollection( lights, value );
		}
		
		public function getMaterial(value:Object):DocumentBaseVO
		{
			return getItemInCollection( materials, value );
		}
		
		public function getSceneObject(value:Object):DocumentBaseVO
		{
			return getItemInCollection( scene, value );
		}
		
		public function getSkeleton(value:Object):DocumentBaseVO
		{
			return getItemInCollection( skeletons, value );
		}
		
		public function getTexture(value:Object):DocumentBaseVO
		{
			return getItemInCollection( textures, value );
		}
		
		private function getItemInCollection( children:ArrayCollection, value:Object ):DocumentBaseVO
		{
			for each( var vo:DocumentBaseVO in children )
			{
				if( vo.linkedObject == value ) {
					return vo;
				}
			}
			return null;
		}
	}
}