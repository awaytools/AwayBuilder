package awaybuilder.controller.scene
{
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.BitmapTextureVO;
	import awaybuilder.model.vo.scene.DocumentVO;

	public class ReplaceTextureCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var newDoc:DocumentVO = event.newValue as DocumentVO;
			var newTexture:BitmapTextureVO = newDoc.textures.getItemAt(0) as BitmapTextureVO;
			
			var vo:BitmapTextureVO = event.items[0] as BitmapTextureVO;

			if( !event.oldValue ) 
			{
				event.oldValue = new DocumentVO();
				event.oldValue.textures.addItem( vo.clone() );
			}
			
			vo.bitmapData = newTexture.bitmapData;
			BitmapTexture(vo.linkedObject).bitmapData = newTexture.bitmapData;

			addToHistory( event );
		}
	}
}