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
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.utils.AssetFactory;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import flash.geom.Point;

	public class ChangeLightCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var document:IDocumentModel;
		
		override public function execute():void
		{
			
			var newAsset:LightVO = event.newValue as LightVO;
			
			var vo:LightVO = event.items[0] as LightVO;
			
			saveOldValue( event, vo.clone() );
			
			vo.name = newAsset.name;
			vo.color = newAsset.color;
			vo.type = newAsset.type;
			vo.radius = newAsset.radius;
			vo.fallOff = newAsset.fallOff;
			
			vo.ambientColor = newAsset.ambientColor;
			vo.ambient = newAsset.ambient;
			vo.diffuse = newAsset.diffuse;
			
			vo.directionX = newAsset.directionX;
			vo.directionY = newAsset.directionY;
			vo.directionZ = newAsset.directionZ;
			
			vo.diffuse = newAsset.diffuse;
			vo.specular = newAsset.specular;
			
			vo.castsShadows = newAsset.castsShadows;
			
			if( vo.castsShadows && !newAsset.shadowMapper )
			{
				if( vo.type == LightVO.DIRECTIONAL ) {
					newAsset.shadowMapper = "DirectionalShadowMapper";
				}
				else {
					newAsset.shadowMapper = "CubeMapShadowMapper";
				}
				
			}
			if( newAsset.shadowMapper )
			{
				vo.shadowMapper = newAsset.shadowMapper;
			}
			
			var linkedObjectChanged:Boolean = false;
			
			vo.shadowMethods = DataMerger.syncArrayCollections( vo.shadowMethods, newAsset.shadowMethods, "id" );
			
			if( event.isUndoAction )
			{
				if( !vo.equals( newAsset ) )
				{
					linkedObjectChanged = true;
				}
			}
			else
			{
//				if( (newAsset.type == LightVO.POINT) && (vo.linkedObject is DirectionalLight) )
//				{
//					vo.linkedObject = new PointLight();
//					linkedObjectChanged = true;
//				}
//				if( (newAsset.type == LightVO.DIRECTIONAL) && (vo.linkedObject is PointLight) )
//				{
//					vo.linkedObject = new DirectionalLight( newAsset.directionX, newAsset.directionY, newAsset.directionZ );
//					linkedObjectChanged = true;
//				}
			}
			
			
//			if( linkedObjectChanged ) // update all current
//			{
//				Scene3DManager.removeLight( oldLight );
//				Scene3DManager.addLight(  AssetFactory.GetAsset(vo) as LightBase );
//			}
			
			event.items = [vo];
			addToHistory( event );
		}
	}
}