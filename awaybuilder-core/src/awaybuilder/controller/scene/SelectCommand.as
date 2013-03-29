package awaybuilder.controller.scene
{
	import away3d.materials.utils.DefaultMaterialManager;
	
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	
	import org.robotlegs.mvcs.Command;

	public class SelectCommand extends Command
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var items:Vector.<AssetVO> = new Vector.<AssetVO>();
			for each( var selectedAsset:AssetVO in event.items ) 
			{
				if( selectedAsset.linkedObject == DefaultMaterialManager.getDefaultMaterial() ) continue;
				if( selectedAsset.linkedObject == DefaultMaterialManager.getDefaultTexture() ) continue;
				items.push( selectedAsset );
			}
			document.selectedObjects = items;
			
		}
		
		
		
	}
}