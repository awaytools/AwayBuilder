package awaybuilder.desktop.model
{
	import awaybuilder.controller.events.SaveDocumentEvent;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.IDocumentService;
	import awaybuilder.model.SmartDocumentServiceBase;
	import awaybuilder.model.vo.DocumentVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.encoders.AWDEncoder;
	import awaybuilder.utils.encoders.ISceneGraphEncoder;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.managers.CursorManager;
	
	public class DesktopDocumentService extends SmartDocumentServiceBase implements IDocumentService
	{
		private static const FILE_EXTENSION : String = '.awd';
		
		private var _fileToData:Dictionary = new Dictionary();
		
		private var _nextEvent:HistoryEvent;
		
		private var _items:Array;
		
		private var _property:String;
		
		public function openBitmap( items:Array, property:String ):void
		{
			_items = items;
			_property = property;
			var file:File = new File();
			file.addEventListener(Event.SELECT, bitmapFile_open_selectHandler);
			file.addEventListener(Event.CANCEL, bitmapFile_open_cancelHandler);
			var filters:Array = [];
			var title:String = "Import Bitmap";
			filters.push( new FileFilter("Bitmap (*.png, *.jpg)", "*.png;*.jpg") );
			file.browseForOpen(title, filters);
		}
		
		public function open( type:String, event:HistoryEvent ):void
		{
			_nextEvent = event;
			var file:File = new File();
			file.addEventListener(Event.SELECT, file_open_selectHandler);
			file.addEventListener(Event.CANCEL, file_open_cancelHandler);
			var filters:Array = [];
			var title:String;
			switch( type ) 
			{
				case "open":
					title = "Open File";
					filters.push( new FileFilter("Away3D (*.awd)", "*.awd") );
					break;
				case "import":
					title = "Import File";
					filters.push( new FileFilter("3D and Images", "*.awd;*.3ds;*.obj;*.md2;*.png;*.jpg;*.dae;*.md5mesh;*.md5anim") );
					filters.push( new FileFilter("3D (*.awd, *.3ds, *.obj, *.md2, *.dae, *.md5mesh, *.md5anim)", "*.awd;*.3ds;*.obj;*.md2;*.dae;*.md5mesh;*.md5anim") );
					filters.push( new FileFilter("Images (*.png, *.jpg)", "*.png;*.jpg") );
					break;
				case "images":
					title = "Import Texture";
					filters.push( new FileFilter("Images (*.png, *.jpg)", "*.png;*.jpg") );
					break;
			}
			file.browseForOpen(title, filters);
		}
		
		public function saveAs(data:Object, defaultName:String):void
		{
			if(defaultName.toLowerCase().lastIndexOf(FILE_EXTENSION) != defaultName.length - FILE_EXTENSION.length)
			{
				defaultName += FILE_EXTENSION;
			}
			var file:File = File.documentsDirectory.resolvePath("./" + defaultName);
			file.addEventListener(Event.SELECT, file_save_selectHandler);
			file.addEventListener(Event.CANCEL, file_save_cancelHandler);
			file.browseForSave("Save Document As");
			//this should probably never hold more than one file, but let's just
			//be careful eh?
			this._fileToData[file] = data;
		}
		
		public function save(data:Object, path:String):void
		{	
			var bytes : ByteArray;
			var success : Boolean;
			var encoder : ISceneGraphEncoder;
			var document : DocumentModel = DocumentModel(data);
			
			bytes = new ByteArray();
			encoder = new AWDEncoder();
			success = encoder.encode(document, bytes);
			
			try
			{
				var file:File = new File(path);
				var saveStream:FileStream = new FileStream();
				saveStream.open(file, FileMode.WRITE);
				saveStream.writeBytes(bytes);
				saveStream.close();
				this.dispatch(new SaveDocumentEvent(SaveDocumentEvent.SAVE_DOCUMENT_SUCCESS, file.name, file.nativePath));
			}
			catch(error:Error)
			{
				this.dispatch(new SaveDocumentEvent(SaveDocumentEvent.SAVE_DOCUMENT_FAIL, file.name, file.nativePath));
			}
			
		}
		
		private function file_save_selectHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			trace('saving!');
			trace(file.nativePath);
			trace(file.nativePath.toLowerCase().lastIndexOf(FILE_EXTENSION));
			trace(file.nativePath.length - FILE_EXTENSION.length);
			if(file.nativePath.toLowerCase().lastIndexOf(FILE_EXTENSION) != file.nativePath.length - FILE_EXTENSION.length)
			{
				//this is kind of nasty, but there's no way to force AIR to add
				//a file extension with browseForSave()! WTF?
				file.nativePath += FILE_EXTENSION;
				
				//if we can safely add the extension without overwriting another
				//file, then awesome! otherwise, display the save dialog again
				//and make the file include the extension.
				//not ideal, but I shouldn't be required to make my own
				//overwrite dialog to allow forced extensions
				if(file.exists)
				{
					file.browseForSave("Save Document As");
					return;
				}
			}
			file.removeEventListener(Event.SELECT, file_save_selectHandler);
			file.removeEventListener(Event.CANCEL, file_save_cancelHandler);
			var data:Object = this._fileToData[file];
			delete this._fileToData[file];
			
			this.save(data, file.nativePath);
		}
		
		private function file_save_cancelHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_save_selectHandler);
			file.removeEventListener(Event.CANCEL, file_save_cancelHandler);
			delete this._fileToData[file];
		}
		
		private function bitmapFile_open_selectHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			loadBitmap( file.url );
		}
		private function bitmapFile_open_cancelHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
		}
		
		private function file_open_selectHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			
			load( file.url );
		}
		
		private function file_open_cancelHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
		}
		
		override protected function documentReady( _document:DocumentVO ):void 
		{
			_nextEvent.newValue = _document;
			dispatch( _nextEvent );
		}
		
		override protected function bitmapReady( bitmap:Bitmap ):void
		{
			var asset:AssetVO = _items[0] as AssetVO;
			var clone:AssetVO;
			if( asset is CubeTextureVO )
			{
				clone = CubeTextureVO(asset).clone();
				clone[_property] = bitmap.bitmapData;
				dispatch( new SceneEvent( SceneEvent.CHANGE_CUBE_TEXTURE, _items, clone ) );
			}
			else if( asset is TextureVO )
			{
				clone = TextureVO(asset).clone();
				TextureVO(clone).bitmapData = bitmap.bitmapData;
				dispatch( new SceneEvent( SceneEvent.CHANGE_TEXTURE, _items, clone ) );
			}
			
			CursorManager.removeBusyCursor();
		}
	}
}