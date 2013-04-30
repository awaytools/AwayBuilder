package awaybuilder.controller.scene 
{
	import away3d.core.base.SubMesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SubMeshVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.AssetUtil;
	
	import mx.collections.ArrayCollection;
	
	public class ChangeMaterialCommand extends HistoryCommandBase
	{
	    [Inject]
	    public var event:SceneEvent;
	
	    [Inject]
	    public var document:DocumentModel;
	
	    override public function execute():void
	    {
	        var newMaterial:MaterialVO = event.newValue as MaterialVO;
	        var vo:MaterialVO = event.items[0] as MaterialVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.fillFromMaterial( newMaterial );
			
	        addToHistory( event );
	    }
	}
}