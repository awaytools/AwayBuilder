    package awaybuilder.controller.scene {
    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MeshVO;

    import flash.geom.Vector3D;

    public class ScaleObjectCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        [Inject]
        public var document:IDocumentModel;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:MeshVO = document.getSceneObject( event.items[0] ) as MeshVO;

            vo.scaleX = vector.x;
            vo.scaleY = vector.y;
            vo.scaleZ = vector.z;

            vo.linkedObject.scaleX = vector.x;
            vo.linkedObject.scaleY = vector.y;
            vo.linkedObject.scaleZ = vector.z;

            addToHistory( event );
        }
    }
}