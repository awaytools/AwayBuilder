package awaybuilder.controller.history
{
    import awaybuilder.model.UndoRedoModel;
    
    import org.robotlegs.mvcs.Command;

    public class HistoryCommandBase extends Command
    {
        [Inject]
        public var undoRedoModel:UndoRedoModel;
		
		
		protected function saveOldValue( event:HistoryEvent, oldValue:Object ):void 
		{
			if( !event.oldValue ) 
			{
				event.oldValue = oldValue;
			}
		}
        protected function addToHistory(event:HistoryEvent):void 
		{
            if (!event.isUndoAction&&!event.isRedoAction)
            {
                if( event.canBeCombined )
                {
                    var lastEvent:HistoryEvent = undoRedoModel.getLastActon();
                    if( lastEvent && lastEvent.canBeCombined && (lastEvent.type==event.type) && (event.timeStamp-lastEvent.timeStamp<500) )
                    {
						lastEvent.timeStamp = event.timeStamp;
                        lastEvent.newValue = event.newValue;
                        return;
                    }
                }

                undoRedoModel.registerAction(event.clone() as HistoryEvent);
            }
        }
    }
}