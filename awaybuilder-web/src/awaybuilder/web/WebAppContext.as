package awaybuilder.web
{
    import awaybuilder.CoreContext;
    import awaybuilder.controller.events.DocumentEvent;
    import awaybuilder.controller.events.DocumentRequestEvent;
    import awaybuilder.controller.events.SceneReadyEvent;
    import awaybuilder.model.ApplicationModel;
    import awaybuilder.model.IDocumentService;
    import awaybuilder.view.components.editors.GlobalOptionPropertiesEditor;
    import awaybuilder.web.controller.CloseDocumentCommand;
    import awaybuilder.web.controller.DocumentRequestCommand;
    import awaybuilder.web.controller.OpenFromInvokeCommand;
    import awaybuilder.web.controller.SceneReadyCommand;
    import awaybuilder.web.controller.events.OpenFromInvokeEvent;
    import awaybuilder.web.model.DocumentService;
    import awaybuilder.web.view.mediators.ApplicationMediator;
    
    import flash.display.DisplayObjectContainer;
    
    import mx.core.FlexGlobals;
    
    import org.robotlegs.base.ContextEvent;
	
	public class WebAppContext extends CoreContext
	{
		
		override public function startup():void
		{
			super.startup();
			
			this.commandMap.mapEvent(SceneReadyEvent.READY, SceneReadyCommand);
			
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_NEW_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_OPEN_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_IMPORT_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_CLOSE_DOCUMENT, DocumentRequestCommand);
			
			this.commandMap.mapEvent(OpenFromInvokeEvent.OPEN_FROM_INVOKE, OpenFromInvokeCommand);
			
			this.commandMap.mapEvent(DocumentEvent.CLOSE_DOCUMENT, CloseDocumentCommand);
			
			this.injector.mapSingletonOf(IDocumentService, DocumentService);
			
			this.mediatorMap.mapView(AwayBuilderApplication, ApplicationMediator);
			
			this.mediatorMap.createMediator(FlexGlobals.topLevelApplication);
			
			this.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}