package awaybuilder.model
{
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
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.events.DocumentDataOperationEvent;
	import awaybuilder.controller.events.ReadDocumentEvent;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.BitmapTextureVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
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
		
		private var _nextEvent:HistoryEvent;
		
		public function load( url:String, nextEvent:HistoryEvent ):void
		{
			_document = new DocumentVO();
			_nextEvent = nextEvent;
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
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
		
		private function resourceCompleteHandler( event:LoaderEvent ):void
		{
			AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.removeEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			
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
						mesh.material = DefaultMaterialManager.getDefaultMaterial();
					}
					
					_document.scene.addItem( new MeshVO( mesh ) );
					break;
				case AssetType.CONTAINER:
					var c:ObjectContainer3D = event.asset as ObjectContainer3D;
					_document.scene.addItem( new ContainerVO( c ) );
					break;
				case AssetType.MATERIAL:
					var material:TextureMaterial = event.asset as TextureMaterial;
					if( material )
					{
						_document.materials.addItem( new MaterialVO( material ) );
					}
					else
					{
						trace( "MATERIAL is " + event.asset );
					}
					break;
				case AssetType.TEXTURE:
					var texture:BitmapTexture = event.asset as BitmapTexture;
					_document.textures.addItem( new BitmapTextureVO( texture ) );
					break;
				case AssetType.GEOMETRY:
					var geometry:Geometry = event.asset as Geometry;
					_document.geometry.addItem( new AssetVO( geometry.name, geometry )  );
					break;
				case AssetType.ANIMATION_SET:
					var animationSet:AnimationSetBase = event.asset as AnimationSetBase;
					_document.animations.addItem( new AssetVO( "Animation Set (" + animationSet.name +")",animationSet )  );
					break;
				case AssetType.ANIMATION_STATE:
					var animationState:AnimationStateBase = event.asset as AnimationStateBase;
					_document.animations.addItem( new AssetVO( "Animation State" ,animationState )  );
					break;
				case AssetType.ANIMATION_NODE:
					var animationNode:AnimationNodeBase = event.asset as AnimationNodeBase;
					_document.animations.addItem( new AssetVO( "Animation Node (" + animationNode.name +")",animationNode )  );
					break;
				case AssetType.SKELETON:
					var s:Skeleton = event.asset as Skeleton;
					_document.skeletons.addItem( new AssetVO( "Skeleton (" + s.name +")",s )  );
					break;
				case AssetType.SKELETON_POSE:
					var sp:SkeletonPose = event.asset as SkeletonPose;
					_document.skeletons.addItem( new AssetVO( "Skeleton Pose (" + sp.name +")", sp )  );
					break;
			}
		}
	}
}