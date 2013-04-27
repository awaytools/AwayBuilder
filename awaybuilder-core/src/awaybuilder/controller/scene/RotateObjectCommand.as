package awaybuilder.controller.scene
{
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

        [Inject]
        public var document:DocumentModel;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:ObjectVO = event.items[0] as ObjectVO;

			if( !event.oldValue ) {
				event.oldValue = new Vector3D( vo.rotationX, vo.rotationY, vo.rotationZ );
			}
			
            vo.rotationX = vector.x;
            vo.rotationY = vector.y;
            vo.rotationZ = vector.z;

//			vo.apply();

            addToHistory( event );
        }
    }
}