package awaybuilder.controller
{
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.utils.Cast;
	
	import awaybuilder.events.ReadDocumentDataEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.IEditorModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.ScenegraphTreeVO;
	import awaybuilder.scene.controllers.Scene3DManager;
	
	import org.robotlegs.mvcs.Command;

	public class ReadDocumentDataCommand extends Command
	{
		private static const FUTURE_VERSION_ERROR:String = "Unable to open file. This document appears to have been created in a newer version of awaybuilder.";
		private static const INVALID_FORMAT_ERROR:String = "Unable to open file. Cannot parse data.";
		
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var editor:IEditorModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;
		
		[Inject]
		public var event:ReadDocumentDataEvent;
		
		override public function execute():void
		{
//			scenegraph = new ArrayCollection();
			document.name = event.name;
			Parsers.enableAllBundled();
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);		
			AssetLibrary.load(new URLRequest(event.path));	
		}
		
		[Embed(source="assets/bear/polarbear_diffuse.jpg")]
		private var BearDiffuse:Class;
		
		[Embed(source="assets/bear/polarbear_normals.jpg")]
		private var BearNormal:Class;
		
		[Embed(source="assets/bear/polarbear_specular.jpg")]
		private var BearSpecular:Class;			
		
//		private var tm:Number;
		private var bear:Mesh;
		
		private function onAssetComplete(e:AssetEvent):void
		{		
			var scenegraph = new ArrayCollection();
			var item:ScenegraphTreeVO = new ScenegraphTreeVO( "Mesh" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "ObjectContainer3D" );
			item.children = new ArrayCollection();
			item.children.addItem( new ScenegraphTreeVO( "subitem1" ) );
			item.children.addItem( new ScenegraphTreeVO( "subitem2" ) );
			item.children.addItem( new ScenegraphTreeVO( "subitem3" ) );
			item.children.addItem( new ScenegraphTreeVO( "subitem4" ) );
			item.children.addItem( new ScenegraphTreeVO( "subitem42" ) );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Material" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Geometry" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Animator" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "AnimationSet" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "AnimationNode" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Texture" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "LightPicker" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Light" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "ShadowMapper" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "ShadowMethod" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "EffectsMethod" );
			scenegraph.addItem( item );
			item = new ScenegraphTreeVO( "Camera" );
			scenegraph.addItem( item );
				
			document.scenegraph = scenegraph;
//				-- ObjectContainer3D
//				|    |
//				|    -- ObjectContainer3D...
//				|    -- Camera §
//				|    -- Light §
//				|    -- Mesh...
//				|    -- Mesh...
//				|    -- Mesh
//				|         |
//				|         -- Material §
//				|         -- Geometry §
//				|         -- Animator §
//				|         -- SubMesh...
//				|         -- SubMesh...
//				|         -- SubMesh
//				|              |
//				|              -- Material §
//				|              -- SubGeometry §
//				|
//				-- Material
//				|    |
//				|    -- LightPicker §
//				|    -- DiffuseTexture §
//				|    -- DiffuseMethod
//				|    -- SpecularTexture §
//				|    -- SpecularMethod
//				|    -- NormalTexture §
//				|    -- NormalMethod
//				|    -- ShadowMethod §
//				|    -- EffectsMethod §
//				|    -- EffectsMethod §
//				|    -- EffectsMethod §...
//				|
//				-- Geometry
//				|   |
//				|   -- SubGeometry
//				|   -- SubGeometry
//				|   -- SubGeometry...
//				|
//				-- Animator
//				|    |
//				|    -- AnimationSet §
//				|
//				-- AnimationSet
//				|    |
//				|    -- AnimationNode
//				|    -- AnimationNode
//				|    -- AnimationNode...
//				|
//				-- AnimationNode
//				|
//				-- Texture
//				|
//				-- LightPicker
//				|    |
//				|    -- Light §
//				|
//				-- Light
//				|    |
//				|    -- ShadowMapper §
//				|
//				-- ShadowMapper
//				|
//				-- ShadowMethod
//				|
//				-- EffectsMethod
//				|
//				-- Camera

			
			if (e.asset.assetType == AssetType.MESH) 
			{			
				bear = e.asset as Mesh;
				
				var meshMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(BearDiffuse));
				//bearMaterial.shadowMethod = filteredShadowMapMethod;
				meshMaterial.normalMap = Cast.bitmapTexture(BearNormal);
				meshMaterial.specularMap = Cast.bitmapTexture(BearSpecular);
				meshMaterial.gloss = 50;
				meshMaterial.specular = 0.5;
				meshMaterial.ambientColor = 0xAAAAAA;
				meshMaterial.ambient = 0.5;					
				
				//var meshMaterial:ColorMaterial = new ColorMaterial();
				
				bear.material = meshMaterial;
				bear.castsShadows = true;
				bear.rotationY = 45;
				
				Scene3DManager.addMesh(bear);
				Scene3DManager.addLightToMesh(bear, "SunLight");
				
			}
		}				

	}
}