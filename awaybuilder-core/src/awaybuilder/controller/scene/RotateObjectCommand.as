package awaybuilder.controller.scene
{
    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MeshVO;

    import flash.geom.Vector3D;

    public class RotateObjectCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        [Inject]
        public var document:IDocumentModel;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:MeshVO = document.getSceneObject( event.items[0] ) as MeshVO;

            vo.rotationX = vector.x;
            vo.rotationY = vector.y;
            vo.rotationZ = vector.z;

            vo.linkedObject.rotationX = vector.x;
            vo.linkedObject.rotationY = vector.y;
            vo.linkedObject.rotationZ = vector.z;

            addToHistory( event );
        }
    }
}