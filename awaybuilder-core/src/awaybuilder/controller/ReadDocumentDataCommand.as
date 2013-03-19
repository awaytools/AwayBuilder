package awaybuilder.controller
{
import away3d.animators.AnimationSetBase;
import away3d.animators.data.Skeleton;
import away3d.animators.data.SkeletonPose;
import away3d.animators.nodes.AnimationNodeBase;
import away3d.animators.states.AnimationStateBase;
import away3d.containers.ObjectContainer3D;
import away3d.core.base.Geometry;
import away3d.core.base.SubGeometry;
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

import awaybuilder.controller.events.ReadDocumentDataEvent;
import awaybuilder.model.IDocumentModel;
import awaybuilder.model.UndoRedoModel;
import awaybuilder.model.vo.BitmapTextureVO;
import awaybuilder.model.vo.DocumentBaseVO;
import awaybuilder.model.vo.MaterialVO;
import awaybuilder.model.vo.MeshVO;
import awaybuilder.model.vo.ScenegraphGroupItemVO;
import awaybuilder.model.vo.ScenegraphItemVO;
import awaybuilder.model.vo.TextureMaterialVO;
import awaybuilder.utils.scene.Scene3DManager;

import flash.events.ProgressEvent;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.managers.CursorManager;

import org.robotlegs.mvcs.Command;

	public class ReadDocumentDataCommand extends Command
	{

		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:ReadDocumentDataEvent;
		
		override public function execute():void
		{
			document.name = event.name;
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			AssetLibrary.load(new URLRequest(event.path));	
			CursorManager.setBusyCursor();
		}
		
		
		private function loadErrorHandler( event:LoaderEvent ):void
		{
			Alert.show( event.message, "Resource not loaded" );
		}
		
		private function resourceCompleteHandler( event:LoaderEvent ):void
		{
			AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);
			AssetLibrary.removeEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
//			trace( _mesh.parent );
//			if( _mesh.material ) {
//				Scene3DManager.addMesh( _mesh );
//			}
//			else {
//				Alert.show( "Mesh was not added to scene, material is undefined", "Warning" ); 
//			}
//			for each( var vo:DocumentBaseVO in document.scene ) {
//				
//			}
			
			dispatch( new ReadDocumentDataEvent(ReadDocumentDataEvent.READ_DOCUMENT_DATA_COMPLETE, null, null ) );
			CursorManager.removeBusyCursor();
		}
		private function assetCompleteHandler( event:AssetEvent ):void
		{		
				
//			trace( event.asset.assetType );
			
//			var _light:DirectionalLight = new DirectionalLight(-1, -1, 1);
////			_direction = new Vector3D(-1, -1, 1);
//			var _lightPicker:StaticLightPicker = new StaticLightPicker([_light]);
//			Scene3DManager.addLight( _light );
//			
//			var item:DocumentBaseVO;

            switch( event.asset.assetType )
            {
                case AssetType.MESH:
                    var mesh:Mesh = event.asset as Mesh;
                    if( !mesh.material )
                    {
                        mesh.material = DefaultMaterialManager.getDefaultMaterial();
                    }
					Scene3DManager.addMesh( mesh );
                    document.scene.addItem( new MeshVO( mesh ) );
                    break;
                case AssetType.CONTAINER:
                    var c:ObjectContainer3D = event.asset as ObjectContainer3D;
					document.scene.addItem( new DocumentBaseVO( c.name, c ) );
                    break;
                case AssetType.MATERIAL:
                    var material:TextureMaterial = event.asset as TextureMaterial;
                    if( material )
                    {
						document.materials.addItem( new TextureMaterialVO( material ) );
                    }
                    else
                    {
                        trace( "MATERIAL is " + event.asset );
                    }
                    break;
                case AssetType.TEXTURE:
                    var texture:BitmapTexture = event.asset as BitmapTexture;
					document.textures.addItem( new BitmapTextureVO( texture ) );
                    break;
                case AssetType.GEOMETRY:
                    var geometry:Geometry = event.asset as Geometry;
					document.geometry.addItem( new DocumentBaseVO( geometry.name, geometry )  );
                    break;
                case AssetType.ANIMATION_SET:
                    var animationSet:AnimationSetBase = event.asset as AnimationSetBase;
					document.animations.addItem( new DocumentBaseVO( "Animation Set (" + animationSet.name +")",animationSet )  );
                    break;
                case AssetType.ANIMATION_STATE:
                    var animationState:AnimationStateBase = event.asset as AnimationStateBase;
					document.animations.addItem( new DocumentBaseVO( "Animation State" ,animationState )  );
                    break;
                case AssetType.ANIMATION_NODE:
                    var animationNode:AnimationNodeBase = event.asset as AnimationNodeBase;
					document.animations.addItem( new DocumentBaseVO( "Animation Node (" + animationNode.name +")",animationNode )  );
                    break;
                case AssetType.SKELETON:
                    var s:Skeleton = event.asset as Skeleton;
					document.skeletons.addItem( new DocumentBaseVO( "Skeleton (" + s.name +")",s )  );
                    break;
                case AssetType.SKELETON_POSE:
                    var sp:SkeletonPose = event.asset as SkeletonPose;
					document.skeletons.addItem( new DocumentBaseVO( "Skeleton Pose (" + sp.name +")", sp )  );
                    break;
            }
		}
	}
}