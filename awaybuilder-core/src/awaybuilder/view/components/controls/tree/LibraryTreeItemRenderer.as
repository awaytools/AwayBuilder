package awaybuilder.view.components.controls.tree
{
	import spark.components.Label;

	public class LibraryTreeItemRenderer extends TreeItemRendererBase
	{
		public function LibraryTreeItemRenderer()
		{
			super();
		}
		
		private var _label:Label;
		
		override public function set data(value:Object):void {
			super.data = value;
		}
		
		override protected function createChildren() : void        
		{                
			super.createChildren();
			if( !_label ) 
			{
				_label = new Label();           
				_label.setStyle("color", 0xFFFFFF);           
				addElement(_label); 
			}
			      
		}
		
		override protected function commitProperties():void           
		{                
			super.commitProperties();
			_label.text = data.label;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number ) : void
		{        
			super.updateDisplayList(unscaledWidth, unscaledHeight);         
			_label.move(0,0);   
		}
	}
}