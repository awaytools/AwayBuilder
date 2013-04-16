package awaybuilder.controller.scene
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.DiffuseMethodVO;
	import awaybuilder.utils.AssetFactory;

	public class ChangeDiffuseMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var method:DiffuseMethodVO = event.newValue as DiffuseMethodVO;
			var vo:DiffuseMethodVO = AssetFactory.assets[method.linkedObject] as DiffuseMethodVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.name = method.name;
			vo.alpha = method.alpha;
			vo.color = method.color;
			vo.texture = method.texture;
			
			vo.apply();
			
			addToHistory( event );
		}
	}
}