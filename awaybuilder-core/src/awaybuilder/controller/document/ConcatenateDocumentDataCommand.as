package awaybuilder.controller.document
{
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.DocumentEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.services.ProcessDataService;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Command;
	
	import spark.components.Application;

	public class ConcatenateDocumentDataCommand extends HistoryCommandBase
	{
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:DocumentDataOperationEvent;
		
		private var _sceneObjects:Array;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			var data:DocumentVO = event.newValue as DocumentVO;
			addObjects( data.scene.source );
			document.animations = new ArrayCollection(document.animations.source.concat( data.animations.source ));
			document.geometry = new ArrayCollection(document.geometry.source.concat( data.geometry.source ));
			document.materials = new ArrayCollection(document.materials.source.concat( data.materials.source ));
			document.scene = new ArrayCollection(document.scene.source.concat( data.scene.source ));
			document.skeletons = new ArrayCollection(document.skeletons.source.concat( data.skeletons.source ));
			document.textures = new ArrayCollection(document.textures.source.concat( data.textures.source ));
			document.lights = new ArrayCollection(document.lights.source.concat( data.lights.source ));
			
			if( event.canUndo ) 
			{
				addToHistory( event );
			}
			
			CursorManager.setBusyCursor();
			Application(FlexGlobals.topLevelApplication).mouseEnabled = false;
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function undo():void
		{
			var data:DocumentVO = event.oldValue as DocumentVO;
			for each( var vo:AssetVO in data.scene ) {
				if( vo is MeshVO ) {
					Scene3DManager.removeMesh( vo.linkedObject as Mesh );
				}
			}
			removeItems( document.animations, data.animations );
			removeItems( document.geometry, data.geometry );
			removeItems( document.materials, data.materials );
			removeItems( document.scene, data.scene );
			removeItems( document.skeletons, data.skeletons );
			removeItems( document.textures, data.textures );
			removeItems( document.lights, data.lights );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function removeItems( source:ArrayCollection, items:ArrayCollection ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				for each( var oddItem:AssetVO in items ) 
				{
					if( item.linkedObject == oddItem.linkedObject )
					{
						source.removeItemAt( i );
						i--;
					}
				}
			}
		}
		
		private function addObjects( objects:Array ):void 
		{
			_sceneObjects = objects.concat();
			DisplayObject(FlexGlobals.topLevelApplication).addEventListener( Event.ENTER_FRAME, addNextObject_enterFrameHandler );
		}
		private function addNextObject_enterFrameHandler( event:Event ):void 
		{
			if( _sceneObjects.length == 0 )
			{
				DisplayObject(FlexGlobals.topLevelApplication).removeEventListener( Event.ENTER_FRAME, addNextObject_enterFrameHandler );
				
				CursorManager.removeBusyCursor();
				Application(FlexGlobals.topLevelApplication).mouseEnabled = true;
				return;
			}
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
			addObject( _sceneObjects.shift() );
		}
		private function addObject( value:Object ):void
		{
			var mesh:MeshVO = value as MeshVO;
			if( mesh ) 
			{
				Scene3DManager.addMesh( mesh.linkedObject as Mesh );
			}
		}
		
	}
}