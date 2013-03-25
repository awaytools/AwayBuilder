package awaybuilder.controller.scene
{
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.materials.MaterialBase;

    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.MaterialVO;
    import awaybuilder.model.vo.MeshVO;
    import awaybuilder.model.vo.SubMeshVO;

    public class ChangeMeshCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        [Inject]
        public var document:IDocumentModel;

        override public function execute():void
        {
            var mesh:MeshVO = event.newValue as MeshVO;
            var vo:MeshVO = document.getSceneObject( mesh.linkedObject ) as MeshVO;
			
			if( !event.oldValue ) {
				event.oldValue = vo.clone();
			}
			
            vo.name = mesh.name;
            vo.linkedObject.name = mesh.name;

            var subMeshes:Vector.<SubMesh> = new Vector.<SubMesh>();
            var newSubMeshes:Array = new Array();

            for( var i:int = 0; i < mesh.subMeshes.length; i++ )
            {
                var updatedSubMesh:SubMeshVO = mesh.subMeshes[i] as SubMeshVO;
                var subMesh:SubMeshVO = vo.subMeshes[i] as SubMeshVO;
                subMesh.material = updatedSubMesh.material.clone();
                subMesh.linkedObject.material = updatedSubMesh.material.linkedObject as MaterialBase;
            }

            addToHistory( event );
        }
    }
}