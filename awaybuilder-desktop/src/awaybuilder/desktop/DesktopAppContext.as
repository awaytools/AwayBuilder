package awaybuilder.desktop
{
    import awaybuilder.CoreContext;
    import awaybuilder.controller.events.DocumentEvent;
    import awaybuilder.controller.events.DocumentRequestEvent;
    import awaybuilder.controller.events.MessageBoxEvent;
    import awaybuilder.controller.events.SceneReadyEvent;
    import awaybuilder.controller.events.SettingsEvent;
    import awaybuilder.desktop.controller.CloseDocumentCommand;
    import awaybuilder.desktop.controller.DocumentRequestCommand;
    import awaybuilder.desktop.controller.OpenFromInvokeCommand;
    import awaybuilder.desktop.controller.SceneReadyCommand;
    import awaybuilder.desktop.controller.ShowAboutWindowCommand;
    import awaybuilder.desktop.controller.ShowDocumentLoadProgressWindowCommand;
    import awaybuilder.desktop.controller.ShowMessageBoxCommand;
    import awaybuilder.desktop.controller.ShowTextureSizeErrorsCommand;
    import awaybuilder.desktop.controller.events.AboutEvent;
    import awaybuilder.desktop.controller.events.OpenFromInvokeEvent;
    import awaybuilder.desktop.controller.events.TextureSizeErrorsEvent;
    import awaybuilder.desktop.model.DesktopDocumentService;
    import awaybuilder.desktop.view.components.AboutWindow;
    import awaybuilder.desktop.view.components.EditedDocumentWarningWindow;
    import awaybuilder.desktop.view.mediators.AboutWindowMediator;
    import awaybuilder.desktop.view.mediators.ApplicationMediator;
    import awaybuilder.desktop.view.mediators.EditedDocumentWarningWindowMediator;
    import awaybuilder.model.IDocumentService;
    
    import flash.desktop.NativeApplication;
    import flash.display.DisplayObjectContainer;
    
    import mx.core.FlexGlobals;
    
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.base.MultiWindowFlexMediatorMap;
    import org.robotlegs.core.IMediatorMap;
	
	public class DesktopAppContext extends CoreContext
	{
		public function DesktopAppContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap || (_mediatorMap = new MultiWindowFlexMediatorMap(contextView, injector.createChild(), reflector));
		}
		
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
			
			this.commandMap.mapEvent(MessageBoxEvent.SHOW_MESSAGE_BOX, ShowMessageBoxCommand);
			this.commandMap.mapEvent(AboutEvent.SHOW_ABOUT, ShowAboutWindowCommand);
			
			this.commandMap.mapEvent(TextureSizeErrorsEvent.SHOW_TEXTURE_SIZE_ERRORS, ShowTextureSizeErrorsCommand);
			
			
			this.injector.mapSingletonOf(IDocumentService, DesktopDocumentService);
			this.injector.mapValue(AwayBuilderApplication, FlexGlobals.topLevelApplication);
			
			this.mediatorMap.mapView(AwayBuilderApplication, ApplicationMediator);
			this.mediatorMap.mapView(EditedDocumentWarningWindow, EditedDocumentWarningWindowMediator);
			this.mediatorMap.mapView(AboutWindow, AboutWindowMediator);
			
			this.mediatorMap.createMediator(FlexGlobals.topLevelApplication);
			this.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}