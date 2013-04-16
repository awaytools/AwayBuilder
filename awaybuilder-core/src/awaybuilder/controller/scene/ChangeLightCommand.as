package awaybuilder.controller.scene
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.CubeMapShadowMapper;
	import away3d.lights.shadowmaps.DirectionalShadowMapper;
	
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.scene.LightVO;
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
			
			var vo:LightVO = document.getLight( newAsset.linkedObject ) as LightVO;
			
			var oldLight:LightBase = vo.linkedObject as LightBase;
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
					newAsset.shadowMapper = new DirectionalShadowMapper();
				}
				else {
					newAsset.shadowMapper = new CubeMapShadowMapper();
				}
				
			}
			if( newAsset.shadowMapper )
			{
				vo.shadowMapper = newAsset.shadowMapper;
			}
			
			
			var linkedObjectChanged:Boolean = false;
			
			if( event.isUndoAction )
			{
				if( vo.linkedObject != newAsset.linkedObject )
				{
					vo.linkedObject = newAsset.linkedObject;
					linkedObjectChanged = true;
				}
			}
			else
			{
				if( (newAsset.type == LightVO.POINT) && (vo.linkedObject is DirectionalLight) )
				{
					vo.linkedObject = new PointLight();
					linkedObjectChanged = true;
				}
				if( (newAsset.type == LightVO.DIRECTIONAL) && (vo.linkedObject is PointLight) )
				{
					vo.linkedObject = new DirectionalLight( newAsset.directionX, newAsset.directionY, newAsset.directionZ );
					linkedObjectChanged = true;
				}
			}
			
			
			vo.apply();
			
			if( linkedObjectChanged ) // update all current
			{
				Scene3DManager.removeLight( oldLight );
				Scene3DManager.addLight( vo.linkedObject as LightBase );
			}
			
			event.items = [vo];
			addToHistory( event );
		}
	}
}