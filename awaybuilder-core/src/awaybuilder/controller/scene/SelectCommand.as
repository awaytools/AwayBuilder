package awaybuilder.controller.scene
{
	import away3d.materials.utils.DefaultMaterialManager;
	
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	
	import org.robotlegs.mvcs.Command;

	public class SelectCommand extends Command
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			var items:Vector.<AssetVO> = new Vector.<AssetVO>();
			for each( var selectedAsset:AssetVO in event.items ) 
			{
				if( selectedAsset.isDefault ) continue;
				items.push( selectedAsset );
			}
			document.selectedAssets = items;
			
		}
	}
}