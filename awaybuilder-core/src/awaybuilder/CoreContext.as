package awaybuilder
{
	import flash.display.DisplayObjectContainer;
	
	import awaybuilder.controller.CopyCommand;
	import awaybuilder.controller.NewDocumentCommand;
	import awaybuilder.controller.OpenDocumentCommand;
	import awaybuilder.controller.PasteCommand;
	import awaybuilder.controller.PrintDocumentCommand;
	import awaybuilder.controller.ReadDocumentDataCommand;
	import awaybuilder.controller.ReadDocumentDataFaultCommand;
	import awaybuilder.controller.ReplaceDocumentCommand;
	import awaybuilder.controller.ResetDefaultSettingsCommand;
	import awaybuilder.controller.SaveDocumentCommand;
	import awaybuilder.controller.SaveDocumentFailCommand;
	import awaybuilder.controller.SaveDocumentSuccessCommand;
	import awaybuilder.controller.StartupCommand;
	import awaybuilder.controller.WebLinkCommand;
	import awaybuilder.events.ClipboardEvent;
	import awaybuilder.events.DocumentEvent;
	import awaybuilder.events.ReadDocumentDataEvent;
	import awaybuilder.events.ReadDocumentDataResultEvent;
	import awaybuilder.events.SaveDocumentEvent;
	import awaybuilder.events.SettingsEvent;
	import awaybuilder.events.WebLinkEvent;
	import awaybuilder.model.DesktopObjectPickerModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.EditorModel;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.IEditorModel;
	import awaybuilder.model.IObjectPickerModel;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.SamplesModel;
	import awaybuilder.model.SettingsModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.WindowModel;
	import awaybuilder.view.components.ApplicationSettingsForm;
	import awaybuilder.view.components.CoreEditor;
	import awaybuilder.view.components.DocumentDefaultsSettingsForm;
	import awaybuilder.view.components.DocumentSettingsForm;
	import awaybuilder.view.components.EditStatusBar;
	import awaybuilder.view.components.EditToolBar;
	import awaybuilder.view.components.EditingSurfaceSettingsForm;
	import awaybuilder.view.components.SamplePicker;
	import awaybuilder.view.mediators.ApplicationSettingsFormMediator;
	import awaybuilder.view.mediators.CoreEditorMediator;
	import awaybuilder.view.mediators.DocumentDefaultsSettingsFormMediator;
	import awaybuilder.view.mediators.DocumentSettingsFormMediator;
	import awaybuilder.view.mediators.EditStatusBarMediator;
	import awaybuilder.view.mediators.EditToolBarMediator;
	import awaybuilder.view.mediators.EditingSurfaceSettingsFormMediator;
	import awaybuilder.view.mediators.SamplePickerMediator;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	public class CoreContext extends Context
	{
		public function CoreContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			super.startup();
			
			this.commandMap.mapEvent(ContextEvent.STARTUP, StartupCommand);
			
			this.commandMap.mapEvent(DocumentEvent.NEW_DOCUMENT, NewDocumentCommand);
			this.commandMap.mapEvent(DocumentEvent.OPEN_DOCUMENT, OpenDocumentCommand);
			this.commandMap.mapEvent(ReadDocumentDataEvent.REPLACE_DOCUMENT, ReplaceDocumentCommand);
			this.commandMap.mapEvent(ReadDocumentDataEvent.READ_DOCUMENT_DATA, ReadDocumentDataCommand);
			this.commandMap.mapEvent(ReadDocumentDataResultEvent.READ_DOCUMENT_DATA_FAULT, ReadDocumentDataFaultCommand);
			
			this.commandMap.mapEvent(SaveDocumentEvent.SAVE_DOCUMENT, SaveDocumentCommand);
			this.commandMap.mapEvent(SaveDocumentEvent.SAVE_DOCUMENT_AS, SaveDocumentCommand);
			this.commandMap.mapEvent(SaveDocumentEvent.SAVE_DOCUMENT_SUCCESS, SaveDocumentSuccessCommand);
			this.commandMap.mapEvent(SaveDocumentEvent.SAVE_DOCUMENT_FAIL, SaveDocumentFailCommand);
			
			this.commandMap.mapEvent(DocumentEvent.PRINT_DOCUMENT, PrintDocumentCommand);
			
			this.commandMap.mapEvent(ClipboardEvent.CLIPBOARD_CUT, CopyCommand);
			this.commandMap.mapEvent(ClipboardEvent.CLIPBOARD_COPY, CopyCommand);
			this.commandMap.mapEvent(ClipboardEvent.CLIPBOARD_PASTE, PasteCommand);
			
			this.commandMap.mapEvent(SettingsEvent.RESET_DEFAULT_SETTINGS, ResetDefaultSettingsCommand);
			
			this.commandMap.mapEvent(WebLinkEvent.LINK_BLOG, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_FACEBOOK, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_NEWSLETTER, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_TWITTER, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_BUG_REPORTS, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_DOWNLOAD, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_HOME, WebLinkCommand);
			this.commandMap.mapEvent(WebLinkEvent.LINK_ONLINE_HELP, WebLinkCommand);
			
			this.injector.mapSingletonOf(IDocumentModel, DocumentModel);
			this.injector.mapSingletonOf(IEditorModel, EditorModel);
			this.injector.mapSingletonOf(ISettingsModel, SettingsModel);
			this.injector.mapSingletonOf(IObjectPickerModel, DesktopObjectPickerModel)
			this.injector.mapSingleton(UndoRedoModel);
			this.injector.mapSingleton(WindowModel);
			this.injector.mapSingleton(SamplesModel);
			this.injector.mapValue(DesktopObjectPickerModel, this.injector.getInstance(IObjectPickerModel));
			this.injector.mapValue(SettingsModel, this.injector.getInstance(ISettingsModel));
			
			this.mediatorMap.mapView(CoreEditor, CoreEditorMediator);
//			this.mediatorMap.mapView(ObjectPickerItemRenderer, ObjectPickerItemRendererMediator);
			this.mediatorMap.mapView(EditToolBar, EditToolBarMediator);
			this.mediatorMap.mapView(EditStatusBar, EditStatusBarMediator);
			this.mediatorMap.mapView(ApplicationSettingsForm, ApplicationSettingsFormMediator);
			this.mediatorMap.mapView(DocumentSettingsForm, DocumentSettingsFormMediator);
			this.mediatorMap.mapView(EditingSurfaceSettingsForm, EditingSurfaceSettingsFormMediator);
			this.mediatorMap.mapView(DocumentDefaultsSettingsForm, DocumentDefaultsSettingsFormMediator);
			this.mediatorMap.mapView(SamplePicker, SamplePickerMediator);
//			this.mediatorMap.mapView(SampleItemRenderer, SampleItemRendererMediator);
//			this.mediatorMap.mapView(ShapePropertyEditor, RectanglePropertyEditorMediator);
		}
	}
}