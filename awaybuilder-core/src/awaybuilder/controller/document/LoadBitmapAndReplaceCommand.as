package awaybuilder.controller.document
{
	import awaybuilder.controller.document.events.ImportTextureEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.ProcessDataService;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.managers.CursorManager;
	
	import org.robotlegs.mvcs.Command;

	public class LoadBitmapAndReplaceCommand extends Command
	{
		public var document:DocumentModel;
		
		[Inject]
		public var importEvent:ImportTextureEvent;
		
		override public function execute():void
		{
			CursorManager.setBusyCursor();
			var loader:Loader = new Loader();
			loader.load( new URLRequest(this.importEvent.path) );
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler )
		}
		
		private function loader_completeHandler( event:Event ):void
		{
			var bitmap:Bitmap = event.target.content;
			var asset:AssetVO = importEvent.items[0] as AssetVO;
			var clone:AssetVO;
			if( asset is CubeTextureVO )
			{
				clone = CubeTextureVO(asset).clone();
				clone[importEvent.options] = bitmap.bitmapData;
				dispatch( new SceneEvent( SceneEvent.CHANGE_CUBE_TEXTURE, importEvent.items, clone ) );
			}
			else if( asset is TextureVO )
			{
				clone = TextureVO(asset).clone();
				TextureVO(clone).bitmapData = bitmap.bitmapData;
				dispatch( new SceneEvent( SceneEvent.CHANGE_TEXTURE, importEvent.items, clone ) );
			}
			
			CursorManager.removeBusyCursor();
		}
	}
}