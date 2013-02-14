package awaybuilder.controller
{
	import flash.events.Event;
	
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.view.components.events.EditingSurfaceProgressEvent;
	
	import org.robotlegs.extensions.mvcs.AsyncCommand;
	
	public class PrintDocumentCommand extends AsyncCommand
	{
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
//			var xmlData:XML = new XML(writeXML(this.document.objects, documentNamespace).toXMLString());
//			if(this.initializeEditingSurface())
//			{
//				this.loadData(xmlData);
//			}
		}
		
		private function loadData(xmlData:XML):void
		{
//			var discoveredNamespace:Namespace = discoverNamespace(xmlData);
//			if(!discoveredNamespace)
//			{
//				return;
//			}
//			var objects:Vector.<IEditorObjectView> = readEditorObjectsXML(xmlData, this.document.viewFactories, discoveredNamespace);
//			for each(var object:IEditorObjectView in objects)
//			{
//				this._surface.addObject(object);
//			}
//			if(objects.length == 0)
//			{
//				this.surface_progressCompleteHandler(null);
//			}

		}
		
		private function initializeEditingSurface():Boolean
		{
//			this._surface = new EditingSurface();
//			this._surface.editable = false;
//			SkinnableContainer(FlexGlobals.topLevelApplication).addElementAt(this._surface, 0);
//			this._surface.validateNow();
//			this._surface.objectsContainer.clipAndEnableScrolling = false;
//			
//			this._surface.showGrid = false;
//			this._surface.snapToGrid = false;
//			
//			this._surface.addEventListener(EditingSurfaceObjectsEvent.ADD_OBJECTS, surface_addObjectsHandler);
//			this._surface.addEventListener(EditingSurfaceObjectsEvent.DELETE_OBJECTS, surface_deleteObjectsHandler);
//			this._surface.addEventListener(EditingSurfaceProgressEvent.PROGRESS_COMPLETE, surface_progressCompleteHandler);
//			
			return true;
		}
		
//		private function surface_addObjectsHandler(event:EditingSurfaceObjectsEvent):void
//		{
//			const objects:Vector.<IEditorObjectView> = event.objects;
//			const objectCount:int = objects.length;
//			for(var i:int = 0; i < objectCount; i++)
//			{
//				var object:IEditorObjectView = objects[i];
//				object.isBeingSimulated = false;
//			}
//		}
//		
//		private function surface_deleteObjectsHandler(event:EditingSurfaceObjectsEvent):void
//		{
//			const objects:Vector.<IEditorObjectView> = event.objects;
//			const objectCount:int = objects.length;
//			for(var i:int = 0; i < objectCount; i++)
//			{
//				var object:IEditorObjectView = objects[i];
//				
//				//do anything that needs to be done when deleting objects
//			}
//		}
		
		private function surface_progressCompleteHandler(event:EditingSurfaceProgressEvent):void
		{
//			this._surface.addEventListener(Event.ENTER_FRAME, surface_enterFrameHandler);
//			this._surface.validateNow();
		}
		
		private function surface_enterFrameHandler(event:Event):void
		{
//			this._surface.removeEventListener(Event.ENTER_FRAME, surface_enterFrameHandler);
//			
//			const print:FlexPrintJob = new FlexPrintJob();
//			print.printAsBitmap = false;
//			if(Capabilities.playerType == "Desktop")
//			{
////				print.printJob.orientation = PrintJobOrientation.LANDSCAPE;
//				//print.printJob.jobName = "Application Name Document";
//			}
//			if(print.start())
//			{
//				var margin:Number = 0.09 * Math.min(print.pageWidth, print.pageHeight);
//				const bounds:Rectangle = this._surface.objectsContainer.getBounds(this._surface);
//				if((bounds.width + 2 * margin) > print.pageWidth || (bounds.height + 2 * margin) > print.pageHeight)
//				{
//					margin *= Math.max(bounds.width / print.pageWidth, bounds.height / print.pageHeight);
//				}
//				
//				const elementCount:int = this._surface.objectsContainer.numElements;
//				for(var i:int = 0; i < elementCount; i++)
//				{
//					var element:IVisualElement = this._surface.objectsContainer.getElementAt(i);
//					element.x = element.x - bounds.x + margin;
//					element.y = element.y - bounds.y + margin;
//				}
//				this._surface.width = bounds.width + 2 * margin;
//				this._surface.height = bounds.height + 2 * margin;
//				this._surface.validateNow();
//				
//				var terminiated:Boolean = false;
//				try
//				{
//					print.addObject(this._surface.objectsContainer, FlexPrintJobScaleType.SHOW_ALL, 1);
//				} 
//				catch(error:Error) 
//				{
//					terminiated = true;
//					//print.printJob.terminate();
//					this.dispatch(new MessageBoxEvent(MessageBoxEvent.SHOW_MESSAGE_BOX, "Error", "Unable to print document.", "OK"));
//				}
//				if(!terminiated)
//				{
//					print.send();
//				}
//			}
//			else
//			{
//				this.dispatch(new MessageBoxEvent(MessageBoxEvent.SHOW_MESSAGE_BOX, "Error", "Unable to print document.", "OK"));
//			}
//			
//			this._surface.reset();
//			Group(this._surface.parent).removeElement(this._surface);
//			
//			this.finish();
		}
	}
}