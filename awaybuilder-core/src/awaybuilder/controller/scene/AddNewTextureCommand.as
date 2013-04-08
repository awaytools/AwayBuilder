package awaybuilder.controller.scene
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
	import flash.display3D.textures.Texture;
	
	import mx.collections.ArrayCollection;

	public class AddNewTextureCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			var material:MaterialVO;
			if( event.items && event.items.length )
			{
				material = document.getMaterial(event.items[0].linkedObject) as MaterialVO;
			}
			
			var oldValue:DocumentVO = event.oldValue as DocumentVO;
			var newValue:DocumentVO = event.newValue as DocumentVO;
			
			saveOldValue( event, material );
			
			var newTexture:TextureVO;
			if( newValue.textures && newValue.textures.length )
			{
				newTexture = newValue.textures.getItemAt( 0 ) as TextureVO;
			}
			
			if( event.isUndoAction ) //handle undo-redo specific execution
			{
				document.removeAssets( document.textures, oldValue.textures );
			}
			else 
			{
				document.textures.addItemAt( newTexture, 0 ); // add new texture to library
				
			}
			
			if( material )
			{
				material.diffuseTexture = newTexture;
				material.apply();
			}
			else if( newTexture )
			{
				this.dispatch(new SceneEvent(SceneEvent.SELECT,[newTexture]));
			}
			
			addToHistory( event );
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
			document.empty = false;
			
			
			
		}
		override protected function saveOldValue( event:HistoryEvent, prevValue:Object ):void 
		{
			if( !event.oldValue )
			{
				var oldDocument:DocumentVO = new DocumentVO();
				if( prevValue ) {
					oldDocument.textures.addItem( MaterialVO(prevValue).diffuseTexture.clone() );
				}
				event.oldValue = oldDocument;
			}
		}
		
		
	}
}