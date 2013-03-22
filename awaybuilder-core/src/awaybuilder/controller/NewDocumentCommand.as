package awaybuilder.controller
{
import away3d.materials.TextureMaterial;
import away3d.materials.utils.DefaultMaterialManager;
import away3d.textures.BitmapTexture;

import awaybuilder.model.IDocumentModel;
import awaybuilder.model.ISettingsModel;
import awaybuilder.model.UndoRedoModel;
import awaybuilder.model.vo.BitmapTextureVO;
import awaybuilder.model.vo.ScenegraphGroupItemVO;
import awaybuilder.model.vo.TextureMaterialVO;
import awaybuilder.utils.scene.Scene3DManager;

import mx.collections.ArrayCollection;

import org.robotlegs.mvcs.Command;

	public class NewDocumentCommand extends Command
	{	
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;

		[Inject]
		public var settings:ISettingsModel;

		
		override public function execute():void
		{
			undoRedo.clear();
			
			document.name = "Untitled Library 1";
			document.edited = false;
			document.path = null;

			document.scene = new ArrayCollection();
			
			var material:TextureMaterialVO = new TextureMaterialVO( DefaultMaterialManager.getDefaultMaterial() );
			material.name = "Away3D Default";
			document.materials = new ArrayCollection([material]);
			
			document.animations = new ArrayCollection();
			document.geometry = new ArrayCollection();
			
			var texture:BitmapTextureVO = new BitmapTextureVO( DefaultMaterialManager.getDefaultTexture() );
			texture.name = "Away3D Default";
			document.textures = new ArrayCollection([texture]);
			
			document.skeletons = new ArrayCollection();
			document.lights = new ArrayCollection();
			
			
			
			document.selectedObjects = new Vector.<Object>();
			
			Scene3DManager.clear();
		}
	}
}