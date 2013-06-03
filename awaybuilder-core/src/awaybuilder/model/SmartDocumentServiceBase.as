package awaybuilder.model
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.TextureProjector;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.BitmapDataAsset;
	import away3d.lights.LightBase;
	import away3d.loaders.parsers.AWDParser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.MaterialBase;
	import away3d.primitives.SkyBox;
	
	import awaybuilder.controller.events.ErrorLogEvent;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.utils.logging.AwayBuilderLoadErrorLogger;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Actor;
	
	import spark.components.Application;
	
	public class SmartDocumentServiceBase extends Actor
	{
		
		[Inject]
		public var assets:AssetsModel;
		
		private var _document:DocumentVO;
		
		private var _objects:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
		
		protected function loadBitmap( url:String  ):void
		{
			var loader:Loader = new Loader();             
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHander); 
			loader.load( new URLRequest(url) );
		}
		protected function parseBitmap( data:ByteArray ):void
		{
			var loader:Loader = new Loader();             
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHander); 
			loader.loadBytes( data );
		}
		private function loader_completeHander(event:Event):void
		{
			var loader:LoaderInfo = LoaderInfo( event.currentTarget );       
			bitmapReady(loader.content as Bitmap);
		}
		
		protected function loadAssets( url:String):void
		{
			_document = new DocumentVO();
			_objects.length = 0;
			
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
		
		protected function parse( data:ByteArray ):void
		{
			_document = new DocumentVO();
			_objects.length = 0;
			
			AwayBuilderLoadErrorLogger.clearLog();
			
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR, textureSizeErrorHandler);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			AssetLibrary.loadData(data);	
			
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
			
			documentReady( _document );
			
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
						mesh.material = assets.GetObject(assets.defaultMaterial) as MaterialBase;
					}
					if( !isGeometryInList( assets.GetAsset(mesh.geometry) as GeometryVO ) )
					{
						_document.geometry.addItem( assets.GetAsset(mesh.geometry) as GeometryVO );
					}
					_objects.push( mesh  );
					break;
				case AssetType.CONTAINER:
					var c:ObjectContainer3D = event.asset as ObjectContainer3D;
					_objects.push( c );
					break;
				case AssetType.TEXTURE_PROJECTOR:
					var tp:TextureProjector = event.asset as TextureProjector;
					_objects.push( tp );
					break;
				case AssetType.SKYBOX:
					var sb:SkyBox = event.asset as SkyBox;
					_objects.push( sb );
					break;
				case AssetType.EFFECTS_METHOD:
					_document.methods.addItem( assets.GetAsset( event.asset ) );
					break;	
				case AssetType.LIGHT:
					var light:LightBase = event.asset as LightBase;
					_objects.push( light );
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
					var geometry:GeometryVO = assets.GetAsset( event.asset ) as GeometryVO;
					if( !isGeometryInList( geometry ) )
					{
						_document.geometry.addItem( geometry );
					}
					break;
				case AssetType.ANIMATION_SET:
				case AssetType.ANIMATION_STATE:
				case AssetType.ANIMATION_NODE:
				case AssetType.SKELETON:
//				case AssetType.ANIMATOR:
//				case AssetType.SKELETON_POSE:
					_document.animations.addItem( assets.GetAsset( event.asset ) );
					break;
			}
		}
		
		private function isGeometryInList( geometry:GeometryVO ):Boolean
		{
			for each ( var asset:AssetVO in _document.geometry )
			{
				if( asset.equals( geometry ) ) return true;
				
			}
			return false;
		}
		
		protected function documentReady( _document:DocumentVO ):void {
			throw new Error( "Abstract method error" );
		}
		
		protected function bitmapReady( bitmap:Bitmap ):void {
			throw new Error( "Abstract method error" );
		}
	}
}