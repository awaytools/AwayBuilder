package awaybuilder.controller
{
	import flash.net.URLRequest;
	
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