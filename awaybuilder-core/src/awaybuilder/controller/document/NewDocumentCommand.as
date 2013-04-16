package awaybuilder.controller.document
{
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetFactory;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.utils.Dictionary;
	
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
			AssetLibrary.removeAllAssets(true);
			
			AssetFactory.assets = new Dictionary();
			AssetFactory.clear();
			undoRedo.clear();
			Scene3DManager.clear();
			document.clear();
			
			document.name = "Untitled Library " + AssetFactory.GetNextId("document");
			document.edited = false;
			document.path = null;

			document.materials.addItem( AssetFactory.GetDefaultMaterial() );
			document.textures.addItem( AssetFactory.GetDefaultTexture() );
			document.methods.addItem( AssetFactory.GetDefaultDiffuseMethod() );
			document.methods.addItem( AssetFactory.GetDefaultAmbientMethod() );
			document.methods.addItem( AssetFactory.GetDefaultSpecularMethod() );
			document.methods.addItem( AssetFactory.GetDefaultNormalMethod() );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}