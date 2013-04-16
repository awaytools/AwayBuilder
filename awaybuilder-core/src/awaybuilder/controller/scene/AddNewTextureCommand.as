package awaybuilder.controller.scene
{
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.AmbientMethodVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.DiffuseMethodVO;
	import awaybuilder.model.vo.scene.DocumentVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.NormalMethodVO;
	import awaybuilder.model.vo.scene.SpecularMethodVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.model.vo.scene.interfaces.ITextured;
	import awaybuilder.utils.AssetFactory;
	
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
			var method:ITextured;
			if( event.items && event.items.length )
			{
				method = AssetFactory.assets[event.items[0].linkedObject] as ITextured;
			}
			var oldValue:DocumentVO = event.oldValue as DocumentVO;
			var newValue:DocumentVO = event.newValue as DocumentVO;
			
			if( method ) {
				saveOldValue( event, method );
			}
			
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
			
			if( method )
			{
				method.texture = newTexture;
				if( method is DiffuseMethodVO ){
					DiffuseMethodVO( method).apply();
				}
				if( method is AmbientMethodVO ){
					AmbientMethodVO( method).apply();
				}
				if( method is SpecularMethodVO ){
					SpecularMethodVO( method).apply();
				}
				if( method is NormalMethodVO ){
					NormalMethodVO( method).apply();
				}
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
				if( prevValue ) 
				{
					if( ITextured(prevValue).texture ) 
					{
						oldDocument.textures.addItem( ITextured(prevValue).texture.clone() );
					}
				}
				event.oldValue = oldDocument;
			}
		}
		
		
	}
}