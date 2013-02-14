package awaybuilder.view.mediators
{
	import flash.events.Event;
	
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.scene.controllers.Scene3DManager;
	import awaybuilder.scene.events.Scene3DManagerEvent;
	import awaybuilder.view.components.CoreEditor;
	
	import org.robotlegs.mvcs.Mediator;

	public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var settings:ISettingsModel;
		
		override public function onRegister():void
		{
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.READY, scene_readyHandler);
			Scene3DManager.init( view.stage, 0);
		}
		
		protected function scene_readyHandler(event:Event):void
		{
		}			
		
		
	}
}