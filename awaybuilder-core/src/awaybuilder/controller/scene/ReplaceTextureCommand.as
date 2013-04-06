package awaybuilder.controller.scene
{
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.TextureVO;
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
			var newTexture:TextureVO = newDoc.textures.getItemAt(0) as TextureVO;
			
			var vo:TextureVO = event.items[0] as TextureVO;

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