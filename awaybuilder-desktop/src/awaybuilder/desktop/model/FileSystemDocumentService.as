package awaybuilder.desktop.model
{
	import awaybuilder.controller.events.ReadDocumentDataEvent;
	import awaybuilder.controller.events.SaveDocumentEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.services.IDocumentService;
	import awaybuilder.utils.encoders.AWDEncoder;
	import awaybuilder.utils.encoders.ISceneGraphEncoder;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	public class FileSystemDocumentService extends Actor implements IDocumentService
	{
		private static const INVALID_FORMAT_ERROR:String = "Unable to open file. Cannot parse data.";
		private static const FILE_EXTENSION : String = 'awd';
		
		private var _fileToData:Dictionary = new Dictionary();
		private var _filesToOpen:Vector.<File> = new Vector.<File>;
		
		public function open():void
		{
			var file:File = new File();
			file.addEventListener(Event.SELECT, file_open_selectHandler);
			file.addEventListener(Event.CANCEL, file_open_cancelHandler);
			this._filesToOpen.push(file);
			var filters:Array = [];
			filters.push( new FileFilter("Away3D (*.awd)", "*.awd") );
			file.browseForOpen("Open Away3D Library", filters);
		}
		public function importDocument():void
		{
			var file:File = new File();
			file.addEventListener(Event.SELECT, file_import_selectHandler);
			file.addEventListener(Event.CANCEL, file_import_cancelHandler);
			this._filesToOpen.push(file);
			var filters:Array = [];
			filters.push( new FileFilter("*.awd, *.3ds, *.obj, *.md2, *.md5", "*.awd;*.3ds;*.obj;*.md2;*.md5") );
			file.browseForOpen("Open For Import", filters);
		}
		
		public function saveAs(data:Object, defaultName:String):void
		{
			if(defaultName.toLowerCase().indexOf(FILE_EXTENSION) != defaultName.length - FILE_EXTENSION.length)
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
			var document : IDocumentModel = IDocumentModel(data);
			
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
			if(file.nativePath.toLowerCase().indexOf(FILE_EXTENSION) != file.nativePath.length - FILE_EXTENSION.length)
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
		
		private function file_open_selectHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			this._filesToOpen.splice(this._filesToOpen.indexOf(file), 1);
			
			this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.REPLACE_DOCUMENT, file.name, file.url));
		}
		
		private function file_open_cancelHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			this._filesToOpen.splice(this._filesToOpen.indexOf(file), 1);
		}
		
		private function file_import_selectHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			this._filesToOpen.splice(this._filesToOpen.indexOf(file), 1);
			
			this.dispatch(new ReadDocumentDataEvent(ReadDocumentDataEvent.READ_DOCUMENT_DATA, file.name, file.url));
		}
		
		private function file_import_cancelHandler(event:Event):void
		{
			var file:File = File(event.currentTarget);
			file.removeEventListener(Event.SELECT, file_open_selectHandler);
			file.removeEventListener(Event.CANCEL, file_open_cancelHandler);
			this._filesToOpen.splice(this._filesToOpen.indexOf(file), 1);
		}
	}
}