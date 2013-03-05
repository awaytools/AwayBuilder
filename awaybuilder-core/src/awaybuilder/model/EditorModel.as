package awaybuilder.model
{
	import awaybuilder.events.EditorStateChangeEvent;
	
	import org.robotlegs.mvcs.Actor;

	public class EditorModel extends Actor implements IEditorModel
	{
		private var _zoom:Number = 0.9;

		public function get zoom():Number
		{
			return this._zoom;
		}

		public function set zoom(value:Number):void
		{
			if(this._zoom == value)
			{
				return;
			}
			this._zoom = value;
			this.dispatch(new EditorStateChangeEvent(EditorStateChangeEvent.ZOOM_CHANGE));
		}
		
		private var _panX:Number = 0;
		
		public function get panX():Number
		{
			return this._panX;
		}
		
		public function set panX(value:Number):void
		{
			if(this._panX == value)
			{
				return;
			}
			this._panX = value;
			this.dispatch(new EditorStateChangeEvent(EditorStateChangeEvent.PAN_CHANGE));
		}
		
		private var _panY:Number = 0;
		
		public function get panY():Number
		{
			return this._panY;
		}
		
		public function set panY(value:Number):void
		{
			if(this._panY == value)
			{
				return;
			}
			this._panY = value;
			this.dispatch(new EditorStateChangeEvent(EditorStateChangeEvent.PAN_CHANGE));
		}
		
//		private var _selectedObjects:Vector.<IEditorObjectView> = new <IEditorObjectView>[];
//
//		public function get selectedObjects():Vector.<IEditorObjectView>
//		{
//			return this._selectedObjects;
//		}
//
//		public function set selectedObjects(value:Vector.<IEditorObjectView>):void
//		{
//			if(!value)
//			{
//				this._selectedObjects.length = 0;
//			}
//			else
//			{
//				this._selectedObjects = value;
//			}
//			this.dispatch(new EditorStateChangeEvent(EditorStateChangeEvent.SELECTION_CHANGE));
//		}

	}
}