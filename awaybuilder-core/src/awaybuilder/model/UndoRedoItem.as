package awaybuilder.model
{
	public class UndoRedoItem
	{
		public function UndoRedoItem(undo:Function, redo:Function)
		{
			this.undo = undo;
			this.redo = redo;
		}
		
		public var undo:Function;
		public var redo:Function;
	}
}