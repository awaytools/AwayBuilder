package awaybuilder.controller.scene
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.BitmapTextureVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	
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
			if( event.isUndoAction )
			{
				undo(); 
				return;
			}
			
			var material:MaterialVO = event.items[0] as MaterialVO;
			
			if( !event.oldValue ) 
			{
				var oldValue:DocumentVO = new DocumentVO();
				oldValue.textures.addItem( material.texture.clone() );
				event.oldValue = oldValue;
			}
				
			var data:DocumentVO = event.newValue as DocumentVO;
			var newTexture:BitmapTextureVO = data.textures.getItemAt( 0 ) as BitmapTextureVO;
			
			document.textures.addItemAt( newTexture, 0 );
			
			
			material.texture = newTexture;
			material.apply();
			
			addToHistory( event );
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function undo():void
		{
			var material:MaterialVO = event.items[0] as MaterialVO;
			var oldValue:DocumentVO = event.oldValue as DocumentVO;
			var newValue:DocumentVO = event.newValue as DocumentVO;
			removeItems( document.textures, oldValue.textures );
			var texture:BitmapTextureVO = newValue.textures.getItemAt( 0 ) as BitmapTextureVO;
			material.texture = texture;
			material.apply();
			
			this.dispatch(new DocumentModelEvent(DocumentModelEvent.DOCUMENT_UPDATED));
		}
		
		private function removeItems( source:ArrayCollection, items:ArrayCollection ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				for each( var oddItem:AssetVO in items ) 
				{
					if( item.linkedObject == oddItem.linkedObject )
					{
						source.removeItemAt( i );
						i--;
					}
				}
			}
		}
		
	}
}