package awaybuilder.controller.scene
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AmbientMethodVO;
	import awaybuilder.utils.AssetFactory;

	public class ChangeAmbientMethodCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var method:AmbientMethodVO = event.newValue as AmbientMethodVO;
			var vo:AmbientMethodVO = AssetFactory.assets[method.linkedObject] as AmbientMethodVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.name = method.name;
			vo.ambient = method.ambient;
			vo.color = method.color;
			vo.texture = method.texture;
			
			vo.apply();
			
			addToHistory( event );
		}
	}
}