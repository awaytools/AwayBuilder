package awaybuilder.controller
{
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import away3d.animators.AnimationSetBase;
	import away3d.animators.AnimationStateBase;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.events.ReadDocumentDataEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.IEditorModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.ScenegraphTreeVO;
	import awaybuilder.scene.controllers.Scene3DManager;
	
	import org.robotlegs.mvcs.Command;

	public class ReadDocumentDataCommand extends Command
	{

		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var editor:IEditorModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;
		
		[Inject]
		public var event:ReadDocumentDataEvent;
		
		
		private var _scenegraph:ArrayCollection;
		
		private var _sceneObjects:ArrayCollection;
		
		private var _materialObjects:ArrayCollection;
		
		private var _animationObjects:ArrayCollection;
		
		private var _geometryObjects:ArrayCollection;
		
		private var _lightObjects:ArrayCollection;
		
		override public function execute():void
		{
			_scenegraph = new ArrayCollection();
			_sceneObjects = new ArrayCollection();
			_materialObjects = new ArrayCollection();
			_animationObjects = new ArrayCollection();
			_geometryObjects = new ArrayCollection();
			_lightObjects = new ArrayCollection();
			
			document.name = event.name;
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);		
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, resourceCompleteHandler);		
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, loadErrorHandler);
			AssetLibrary.load(new URLRequest(event.path));	
		}
		
		private function loadErrorHandler( event:LoaderEvent ):void
		{
			Alert.show( event.message, "Resource not loaded" );
		}
		
		private function resourceCompleteHandler( event:LoaderEvent ):void
		{
			if( _animationObjects.length ) 
			{
				var animationItem:ScenegraphTreeVO = new ScenegraphTreeVO( "Animation", null );
				animationItem.children = _animationObjects;
				_scenegraph.addItemAt( animationItem, 0 );
			}
			if( _geometryObjects.length ) 
			{
				var geometryItem:ScenegraphTreeVO = new ScenegraphTreeVO( "Geometry", null );
				geometryItem.children = _geometryObjects;
				_scenegraph.addItemAt( geometryItem, 0 );
			}
			if( _sceneObjects.length ) 
			{
				var sceneItem:ScenegraphTreeVO = new ScenegraphTreeVO( "Scene", null );
				sceneItem.children = _sceneObjects;
				_scenegraph.addItemAt( sceneItem, 0 );
			}
			
			var lightsItem:ScenegraphTreeVO = new ScenegraphTreeVO( "Lights", null );
			_scenegraph.addItem( lightsItem );
			
			document.scenegraph = _scenegraph;
			document.sceneObjects = _sceneObjects;
//			trace( _mesh.parent );
//			if( _mesh.material ) {
//				Scene3DManager.addMesh( _mesh );
//			}
//			else {
//				Alert.show( "Mesh was not added to scene, material is undefined", "Warning" ); 
//			}
			
		}
		private function assetCompleteHandler( event:AssetEvent ):void
		{		
				
			trace( event.asset.assetType );
			
//			var _light:DirectionalLight = new DirectionalLight(-1, -1, 1);
////			_direction = new Vector3D(-1, -1, 1);
//			var _lightPicker:StaticLightPicker = new StaticLightPicker([_light]);
//			Scene3DManager.addLight( _light );
//			
			var item:ScenegraphTreeVO;
			if (event.asset.assetType == AssetType.MESH) 
			{
				var mesh:Mesh = event.asset as Mesh;
				item = new ScenegraphTreeVO( mesh.name , mesh );
				_sceneObjects.addItem( item );
				
				if( mesh.material ) {
					Scene3DManager.addMesh( mesh );
				}
				else {
					Alert.show( "Mesh was not added to scene, material is undefined", "Warning" ); 
				}
				
//				mesh.castsShadows = true;
			} 
			else if (event.asset.assetType == AssetType.CONTAINER) 
			{
				var c:ObjectContainer3D = event.asset as ObjectContainer3D;
				item = new ScenegraphTreeVO( "Container (" + c.name +")", c );
				item.children = new ArrayCollection();
				_sceneObjects.addItem( item );
			}
			else if (event.asset.assetType == AssetType.MATERIAL) 
			{
				var material:TextureMaterial = event.asset as TextureMaterial;
				item = new ScenegraphTreeVO( "Material (" + material.name +")", material );
				item.children = new ArrayCollection();
				if( material.lightPicker ) {
					item.children.addItem( new ScenegraphTreeVO( "LightPicker (" + material.lightPicker.name +")", material.lightPicker ) );
				}
				if( material.diffuseMethod ) {
					item.children.addItem( new ScenegraphTreeVO( "DiffuseMethod", material.diffuseMethod ) );
				}
				if( material.normalMethod ) {
					item.children.addItem( new ScenegraphTreeVO( "NormalMethod", material.normalMethod ) );
				}
				
				/*item.children.addItem( new ScenegraphTreeVO( "Material (" + material.name +")" ) );
				item.children.addItem( new ScenegraphTreeVO( "Material (" + material.name +")" ) );
				item.children.addItem( new ScenegraphTreeVO( "Material (" + material.name +")" ) );
				item.children.addItem( new ScenegraphTreeVO( "Material (" + material.name +")" ) );*/
				_scenegraph.addItem( item );
			}
			else if (event.asset.assetType == AssetType.TEXTURE) 
			{
				var texture:BitmapTexture = event.asset as BitmapTexture;
				item = new ScenegraphTreeVO( "Texture (" + texture.originalName.split("/").pop() +")", texture );
				_scenegraph.addItem( item );
			}
			else if (event.asset.assetType == AssetType.GEOMETRY) 
			{
				var geometry:Geometry = event.asset as Geometry;
				item = new ScenegraphTreeVO( geometry.name ,geometry );
				_geometryObjects.addItem( item );
				item.children = new ArrayCollection();
				for each( var g:SubGeometry in geometry.subGeometries ) {
					item.children.addItem( new ScenegraphTreeVO( "SubGeometry",g ) );
				}
			}
			else if (event.asset.assetType == AssetType.ANIMATION_SET) 
			{
				var animationSet:AnimationSetBase = event.asset as AnimationSetBase;
				item = new ScenegraphTreeVO( "Animation Set (" + animationSet.name +")",animationSet );
				_animationObjects.addItem( item );
			}
			else if (event.asset.assetType == AssetType.ANIMATION_STATE) 
			{
				var animationState:AnimationStateBase = event.asset as AnimationStateBase;
				item = new ScenegraphTreeVO( "Animation State (" + animationState.name +")",animationState );
				_animationObjects.addItem( item );
			}
			else if (event.asset.assetType == AssetType.ANIMATION_NODE) 
			{
				var animationNode:AnimationNodeBase = event.asset as AnimationNodeBase;
				item = new ScenegraphTreeVO( "Animation Node (" + animationNode.name +")",animationNode );
				_animationObjects.addItem( item );
			}
//			switch( event.asset.assetType ) {
//				case AssetType.MESH:
//					var mesh:Mesh = event.asset as Mesh;
////					mesh.castsShadows = true;
//					Scene3DManager.addMesh(mesh);
//					break;
//				case AssetType.MATERIAL:
//					var material:TextureMaterial = event.asset as TextureMaterial;
////					material.shadowMethod = new FilteredShadowMapMethod(_light);
////					material.lightPicker = _lightPicker;
//					material.gloss = 30;
//					material.specular = 1;
//					material.ambientColor = 0x303040;
//					material.ambient = 1;
////					Scene3DManager.a
//					break;
//			}
			
//			if (e.asset.assetType == AssetType.MESH) 
//			{			
//				bear = e.asset as Mesh;
//				
//				var meshMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(BearDiffuse));
//				//bearMaterial.shadowMethod = filteredShadowMapMethod;
//				meshMaterial.normalMap = Cast.bitmapTexture(BearNormal);
//				meshMaterial.specularMap = Cast.bitmapTexture(BearSpecular);
//				meshMaterial.gloss = 50;
//				meshMaterial.specular = 0.5;
//				meshMaterial.ambientColor = 0xAAAAAA;
//				meshMaterial.ambient = 0.5;					
//				
//				//var meshMaterial:ColorMaterial = new ColorMaterial();
//				
//				bear.material = meshMaterial;
//				bear.castsShadows = true;
//				bear.rotationY = 45;
//				
//				Scene3DManager.addMesh(bear);
//				Scene3DManager.addLightToMesh(bear, "SunLight");
//				
//			}
			
		}				

	}
}