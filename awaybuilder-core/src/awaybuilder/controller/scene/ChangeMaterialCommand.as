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
	        var newMaterial:MaterialVO = event.newValue as MaterialVO;
	        var vo:MaterialVO = event.items[0] as MaterialVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.fillFromMaterial( newMaterial );
			
	        addToHistory( event );
			
			commitHistoryEvent( event );
	    }
	}
}