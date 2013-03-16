package awaybuilder.controller.scene
{
    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MeshItemVO;

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
            var vo:MeshItemVO = document.getScenegraphItem( event.items[0] ) as MeshItemVO;

            vo.rotationX = vector.x;
            vo.rotationY = vector.y;
            vo.rotationZ = vector.z;

            vo.item.rotationX = vector.x;
            vo.item.rotationY = vector.y;
            vo.item.rotationZ = vector.z;

            addToHistory( event );
        }
    }
}