package awaybuilder.web.view.mediators
{

	import awaybuilder.model.ApplicationModel;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.UndoRedoModel;
	
	import org.robotlegs.mvcs.Mediator;

	public class ApplicationMediator extends Mediator
	{
		
		[Inject]
		public var app:AwayBuilderApplication;
		
		[Inject]
		public var model:ApplicationModel;
		
		override public function onRegister():void
		{
			model.simpleSaveEnabled = false;
		}
	}
}