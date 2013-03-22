package awaybuilder.desktop
{
    import awaybuilder.CoreContext;
    import awaybuilder.controller.events.DocumentEvent;
    import awaybuilder.controller.events.DocumentLoadEvent;
    import awaybuilder.controller.events.DocumentRequestEvent;
    import awaybuilder.controller.events.HelpEvent;
    import awaybuilder.controller.events.MessageBoxEvent;
    import awaybuilder.controller.events.SettingsEvent;
    import awaybuilder.desktop.controller.CloseDocumentCommand;
    import awaybuilder.desktop.controller.DocumentRequestCommand;
    import awaybuilder.desktop.controller.OpenFromInvokeCommand;
    import awaybuilder.desktop.controller.ShowAboutWindowCommand;
    import awaybuilder.desktop.controller.ShowApplicationSettingsWindowCommand;
    import awaybuilder.desktop.controller.ShowDocumentLoadProgressWindowCommand;
    import awaybuilder.desktop.controller.ShowDocumentSettingsWindowCommand;
    import awaybuilder.desktop.controller.ShowMessageBoxCommand;
    import awaybuilder.desktop.controller.ShowSamplesWindowCommand;
    import awaybuilder.desktop.controller.events.AboutEvent;
    import awaybuilder.desktop.controller.events.OpenFromInvokeEvent;
    import awaybuilder.desktop.model.FileSystemDocumentService;
    import awaybuilder.desktop.model.UpdateModel;
    import awaybuilder.desktop.view.components.AboutWindow;
    import awaybuilder.desktop.view.components.DocumentLoadProgressWindow;
    import awaybuilder.desktop.view.components.EditedDocumentWarningWindow;
    import awaybuilder.desktop.view.components.WelcomeWindow;
    import awaybuilder.desktop.view.mediators.AboutWindowMediator;
    import awaybuilder.desktop.view.mediators.ApplicationMediator;
    import awaybuilder.desktop.view.mediators.DocumentLoadProgressWindowMediator;
    import awaybuilder.desktop.view.mediators.EditedDocumentWarningWindowMediator;
    import awaybuilder.desktop.view.mediators.WelcomeWindowMediator;
    import awaybuilder.services.IDocumentService;
    
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
			
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_NEW_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_OPEN_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_IMPORT_DOCUMENT, DocumentRequestCommand);
			this.commandMap.mapEvent(DocumentRequestEvent.REQUEST_CLOSE_DOCUMENT, DocumentRequestCommand);
			
			this.commandMap.mapEvent(OpenFromInvokeEvent.OPEN_FROM_INVOKE, OpenFromInvokeCommand);
			
			this.commandMap.mapEvent(DocumentEvent.CLOSE_DOCUMENT, CloseDocumentCommand);
			
			this.commandMap.mapEvent(MessageBoxEvent.SHOW_MESSAGE_BOX, ShowMessageBoxCommand);
			this.commandMap.mapEvent(HelpEvent.SHOW_WELCOME, ShowSamplesWindowCommand);
			this.commandMap.mapEvent(SettingsEvent.SHOW_APPLICATION_SETTINGS, ShowApplicationSettingsWindowCommand);
			this.commandMap.mapEvent(SettingsEvent.SHOW_APPLICATION_SETTINGS_DOCUMENT_DEFAULTS, ShowApplicationSettingsWindowCommand);
			this.commandMap.mapEvent(SettingsEvent.SHOW_DOCUMENT_SETTINGS, ShowDocumentSettingsWindowCommand);
			this.commandMap.mapEvent(AboutEvent.SHOW_ABOUT, ShowAboutWindowCommand);
			
			this.commandMap.mapEvent(DocumentLoadEvent.SHOW_DOCUMENT_LOAD_PROGRESS, ShowDocumentLoadProgressWindowCommand);
			
			this.injector.mapSingleton(UpdateModel);
			this.injector.mapSingletonOf(IDocumentService, FileSystemDocumentService);
			this.injector.mapValue(AwayBuilderApplication, FlexGlobals.topLevelApplication);
			
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespace();
			this.injector.mapValue(String, descriptor.ns::versionNumber, "version");
			
			this.mediatorMap.mapView(AwayBuilderApplication, ApplicationMediator);
//			this.mediatorMap.mapView(ObjectPropertiesWindow, ObjectPropertiesWindowMediator);
//			this.mediatorMap.mapView(DocumentSettingsWindow, DocumentSettingsWindowMediator);
//			this.mediatorMap.mapView(ApplicationSettingsWindow, ApplicationSettingsWindowMediator);
			this.mediatorMap.mapView(EditedDocumentWarningWindow, EditedDocumentWarningWindowMediator);
			this.mediatorMap.mapView(WelcomeWindow, WelcomeWindowMediator);
//			this.mediatorMap.mapView(MessageBox, MessageBoxMediator);
			this.mediatorMap.mapView(AboutWindow, AboutWindowMediator);
			this.mediatorMap.mapView(DocumentLoadProgressWindow, DocumentLoadProgressWindowMediator);
			
			this.mediatorMap.createMediator(FlexGlobals.topLevelApplication);
			this.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}