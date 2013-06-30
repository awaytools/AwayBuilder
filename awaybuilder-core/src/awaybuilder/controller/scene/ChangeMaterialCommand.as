package awaybuilder.controller.scene 
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.MaterialVO;
	
	public class ChangeMaterialCommand extends HistoryCommandBase
	{
	    [Inject]
	    public var event:SceneEvent;
	
	    override public function execute():void
	    {
			var newValues:Vector.<MaterialVO> = event.newValue as Vector.<MaterialVO>;
			var oldValues:Vector.<MaterialVO> = new Vector.<MaterialVO>();
			
			for( var i:int = 0; i < event.items.length; i++ )
			{
				var asset:MaterialVO = event.items[i] as MaterialVO;
				oldValues.push( asset.clone() );
				asset.fillFromMaterial( newValues[i] as MaterialVO );
			}
			
			saveOldValue( event, oldValues );
			commitHistoryEvent( event );
	    }
	}
}