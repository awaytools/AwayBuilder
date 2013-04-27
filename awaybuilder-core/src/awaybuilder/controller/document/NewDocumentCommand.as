package awaybuilder.controller.document
{
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class NewDocumentCommand extends Command
	{	
		[Inject]
		public var document:DocumentModel;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;

		override public function execute():void
		{
			AssetLibrary.removeAllAssets(true);
			
			assets.Clear();
			undoRedo.clear();
			Scene3DManager.clear();
			document.clear();
			
			document.name = "Untitled Library " + AssetUtil.GetNextId("document");
			document.edited = false;
			document.path = null;

			document.materials.addItem( assets.GetDefaultMaterial() );
			document.textures.addItem( assets.GetDefaultTexture() );
			document.textures.addItem( assets.GetDefaultCubeTexture() );
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
	}
}