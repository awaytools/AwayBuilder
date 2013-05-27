package awaybuilder.controller.scene
{
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ObjectVO;
    
    import flash.geom.Vector3D;

    public class RotateObjectCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:ObjectVO = event.items[0] as ObjectVO;

			if( !event.oldValue ) {
				event.oldValue = new Vector3D( vo.rotationX, vo.rotationY, vo.rotationZ );
			}
			
			var lvo:LightVO = vo as LightVO;
			if (lvo && lvo.type == LightVO.DIRECTIONAL) 
			{
				lvo.elevationAngle = ((vector.x + 360 + 90) % 360) - 90;
				lvo.azimuthAngle = (vector.y + 360) % 360;
			} else 
			{
	            vo.rotationX = vector.x;
	            vo.rotationY = vector.y;
	            vo.rotationZ = vector.z;
			}

			commitHistoryEvent( event );
        }
    }
}