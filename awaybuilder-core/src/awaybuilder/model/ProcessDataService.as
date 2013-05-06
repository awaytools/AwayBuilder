package awaybuilder.model
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.BitmapDataAsset;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import away3d.primitives.SkyBox;
	
	import awaybuilder.controller.events.ErrorLogEvent;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.utils.logging.AwayBuilderLoadErrorLogger;
	
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.components.Application;

	// TODO move logic into command
	// Do not interfere loading progress
	public class ProcessDataService extends Actor 
	{
		
		[Inject]
		public var assets:AssetsModel;
		
		private var _document:DocumentVO;
		
		private var _objects:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		
		private var _nextEvent:HistoryEvent;
		
		public function load( url:String, nextEvent:HistoryEvent ):void
		{
			_document = new DocumentVO();
			_objects.length = 0;
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
					_document.scene.addItem( assets.GetAsset( o ) );
				}
			}
			
			if (AwayBuilderLoadErrorLogger.log.length>0) {
				dispatch( new ErrorLogEvent(ErrorLogEvent.LOG_ENTRY_MADE));
			}
			
			trace( "_document.lights = " + _document.lights );
			
			_nextEvent.newValue = _document;
			trace( "_nextEvent = " + _nextEvent );
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
						mesh.material = assets.GetObject(assets.GetDefaultMaterial()) as MaterialBase;
					}
					_objects.push( mesh  );
					break;
				case AssetType.CONTAINER:
					var c:ObjectContainer3D = event.asset as ObjectContainer3D;
					_objects.push( c );
					break;
				case AssetType.ENTITY:
					var sb:SkyBox = event.asset as SkyBox;
					_objects.push( sb );
					break;
				case AssetType.EFFECTS_METHOD:
					_document.methods.addItem( assets.GetAsset( event.asset ) );
					break;	
				case AssetType.LIGHT:
					_document.lights.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.LIGHT_PICKER:
					_document.lights.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.MATERIAL:
					_document.materials.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.TEXTURE:
					_document.textures.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.GEOMETRY:
					_document.geometry.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.ANIMATION_SET:
				case AssetType.ANIMATION_STATE:
				case AssetType.ANIMATION_NODE:
					_document.animations.addItem( assets.GetAsset( event.asset ) );
					break;
				case AssetType.SKELETON:
				case AssetType.SKELETON_POSE:
					_document.skeletons.addItem( assets.GetAsset( event.asset ) );
					break;
			}
		}
	}
}