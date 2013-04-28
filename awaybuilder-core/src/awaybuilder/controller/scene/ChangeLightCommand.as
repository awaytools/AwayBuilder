package awaybuilder.controller.scene
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.CubeMapShadowMapper;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	import away3d.tools.commands.Merge;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.DocumentModel;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.utils.AssetUtil;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.geom.Point;

	public class ChangeLightCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:DocumentModel;
		
		override public function execute():void
		{
			var newAsset:LightVO = event.newValue as LightVO;
			var vo:LightVO = event.items[0] as LightVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.fillFromLight( newAsset );
			
			addToHistory( event );
		}
	}
}