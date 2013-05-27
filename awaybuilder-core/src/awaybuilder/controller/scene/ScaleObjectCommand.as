    package awaybuilder.controller.scene {
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ObjectVO;
    
    import flash.geom.Vector3D;

    public class ScaleObjectCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:ObjectVO = event.items[0] as ObjectVO;

			if( !event.oldValue ) {
				event.oldValue = new Vector3D( vo.scaleX, vo.scaleY, vo.scaleZ );
			}
			
            vo.scaleX = vector.x;
            vo.scaleY = vector.y;
            vo.scaleZ = vector.z;

			commitHistoryEvent( event );
        }
    }
}