package awaybuilder.controller.scene
{
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.materials.MaterialBase;

    import awaybuilder.controller.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MaterialItemVO;
    import awaybuilder.model.vo.MeshItemVO;
    import awaybuilder.model.vo.SubMeshVO;

    public class ChangeMeshCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        [Inject]
        public var document:IDocumentModel;

        override public function execute():void
        {
            var mesh:MeshItemVO = event.newValue as MeshItemVO;
            var vo:MeshItemVO = document.getScenegraphItem( mesh.item ) as MeshItemVO;

            vo.name = mesh.name;
            vo.item.name = mesh.name;

            var subMeshes:Vector.<SubMesh> = new Vector.<SubMesh>();
            var newSubMeshes:Array = new Array();

            for( var i:int = 0; i < mesh.subMeshes.length; i++ )
            {
                var updatedSubMesh:SubMeshVO = mesh.subMeshes[i] as SubMeshVO;
                var subMesh:SubMeshVO = vo.subMeshes[i] as SubMeshVO;
                subMesh.material = new MaterialItemVO( updatedSubMesh.material.item as MaterialBase );
                subMesh.linkedObject.material = updatedSubMesh.material.item as MaterialBase;
            }

            Mesh(vo.item).subMeshes
            addToHistory( event );
        }
    }
}