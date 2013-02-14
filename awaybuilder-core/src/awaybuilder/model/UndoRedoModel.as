package awaybuilder.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class UndoRedoModel extends Actor
	{
		public function UndoRedoModel()
		{
			super();
		}
		
		private var _undoStack:Vector.<UndoRedoItem> = new <UndoRedoItem>[];
		private var _redoStack:Vector.<UndoRedoItem> = new <UndoRedoItem>[];
		
		public var maxUndoActions:int = 20;
		
		public function get canUndo():Boolean
		{
			return this._undoStack.length > 0;
		}
		
		public function get canRedo():Boolean
		{
			return this._redoStack.length > 0;
		}
		
		public function registerAction(item:UndoRedoItem):void
		{
			this._redoStack.length = 0;
			this._undoStack.push(item);
			while(this._undoStack.length > this.maxUndoActions)
			{
				this._undoStack.shift();
			}
		}
		
		public function clear():void
		{
			this._undoStack.length = this._redoStack.length = 0;
		}
		
		public function undo():void
		{
			if(this._undoStack.length == 0)
			{
				return;
			}
			
			const item:UndoRedoItem = this._undoStack.pop();
			item.undo();
			this._redoStack.push(item);
		}
		
		public function redo():void
		{
			if(this._redoStack.length == 0)
			{
				return;
			}
			const item:UndoRedoItem = this._redoStack.pop();
			item.redo();
			this._undoStack.push(item);
		}
	}
}