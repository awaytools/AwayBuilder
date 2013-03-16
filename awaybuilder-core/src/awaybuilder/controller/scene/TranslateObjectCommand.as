package awaybuilder.controller.scene
{
    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MeshItemVO;

    import flash.geom.Vector3D;

    public class TranslateObjectCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        [Inject]
        public var document:IDocumentModel;

        override public function execute():void
        {
            var vector:Vector3D = event.newValue as Vector3D;
            var vo:MeshItemVO = document.getScenegraphItem( event.items[0] ) as MeshItemVO;

            vo.x = vector.x;
            vo.y = vector.y;
            vo.z = vector.z;

            vo.item.x = vector.x;
            vo.item.y = vector.y;
            vo.item.z = vector.z;

            addToHistory( event );
        }
    }
}