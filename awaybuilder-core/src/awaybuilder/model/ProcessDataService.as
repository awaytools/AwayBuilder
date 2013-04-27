package awaybuilder.model
{
	import awaybuilder.view.scene.controls.ContainerGizmo3D;
	import awaybuilder.controller.events.ErrorLogEvent;
	import awaybuilder.utils.logging.AwayBuilderLoadErrorLogger;
	import away3d.library.assets.BitmapDataAsset;
	import awaybuilder.utils.logging.AwayBuilderLogger;
	import away3d.events.ParserEvent;
	import away3d.animators.AnimationSetBase;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.managers.SystemManager;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.components.Application;

	public class ProcessDataService extends Actor
	{
		
		private var _document:DocumentVO;
		
		private var _objects:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		
		private var _nextEvent:HistoryEvent;
		
		public function load( url:String, nextEvent:HistoryEvent ):void
		{
			_document = new DocumentVO();
			_nextEvent = nextEvent;
			
			AwayBuilderLoadErrorLogger.clearLog();
			
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR, textureSizeErrorHandler);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			AssetLibrary.load(new URLRequest(url));	
			
			CursorManager.setBusyCursor();
			Application(FlexGlobals.topLevelApplication).mouseEnabled = false;
		}
		
		private function loadErrorHandler( event:LoaderEvent ):void
		{
			Alert.show( event.message, "Asset not loaded" );
		}

		private function textureSizeErrorHandler( event:AssetEvent ):void
		{
			var bdAsset:BitmapDataAsset = event.asset as BitmapDataAsset;
			AwayBuilderLoadErrorLogger.logError("WARN:"+bdAsset.name+" - Bitmap dimensions are not a power of 2 or larger than 2048. Size:"+bdAsset.bitmapData.width+"x"+bdAsset.bitmapData.height, { assetEvent:bdAsset });
		}
		
		private function resourceCompleteHandler( event:LoaderEvent ):void
		{
			AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.removeEventListener(AssetEvent.TEXTURE_SIZE_ERROR, textureSizeErrorHandler);
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.removeEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			
			for each( var o:ObjectContainer3D in _objects )
			{
				if( !o.parent )
				{
					_document.scene.addItem( AssetFactory.GetAsset( o ) );
				}
			}
			
			if (AwayBuilderLoadErrorLogger.log.length>0) {
				dispatch( new ErrorLogEvent(ErrorLogEvent.LOG_ENTRY_MADE));
			}
			
			_nextEvent.newValue = _document;
			dispatch( _nextEvent );
			
			CursorManager.removeBusyCursor();
			Application(FlexGlobals.topLevelApplication).mouseEnabled = true;
		}
		
		private function assetCompleteHandler( event:AssetEvent ):void
		{		
			switch( event.asset.assetType )
			{
				case AssetType.MESH:
					var mesh:Mesh = event.asset as Mesh;
					if( !mesh.material )
					{
						mesh.material = AssetFactory.GetObject(AssetFactory.GetDefaultMaterial()) as MaterialBase;
					}
					_objects.push( mesh  );
					break;
				case AssetType.CONTAINER:
					var c:ObjectContainer3D = event.asset as ObjectContainer3D;
					if (c.numChildren == 0) {
						Scene3DManager.containers.push(c);
						c.addChild(new ContainerGizmo3D(c));
					}
					_objects.push( c );
					break;
				case AssetType.LIGHT:
					_document.lights.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.LIGHT_PICKER:
					_document.lights.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.MATERIAL:
					_document.materials.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.TEXTURE:
					_document.textures.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.GEOMETRY:
					_document.geometry.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.ANIMATION_SET:
				case AssetType.ANIMATION_STATE:
				case AssetType.ANIMATION_NODE:
					_document.animations.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
				case AssetType.SKELETON:
				case AssetType.SKELETON_POSE:
					_document.skeletons.addItem( AssetFactory.GetAsset( event.asset ) );
					break;
			}
		}
	}
}