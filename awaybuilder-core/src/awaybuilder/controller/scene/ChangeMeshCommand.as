package awaybuilder.controller.scene
{
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.library.AssetLibrary;
    import away3d.materials.MaterialBase;
    
    import awaybuilder.controller.history.HistoryCommandBase;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.scene.ExtraItemVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.utils.AssetUtil;
    
    import mx.collections.ArrayCollection;

    public class ChangeMeshCommand extends HistoryCommandBase
    {
        [Inject]
        public var event:SceneEvent;

        override public function execute():void
        {
            var mesh:MeshVO = event.newValue as MeshVO;
            var vo:MeshVO = event.items[0] as MeshVO;
			
			if( !event.oldValue ) {
				event.oldValue = vo.clone();
			}
			
            vo.name = mesh.name;

			vo.pivotX = mesh.pivotX;
			vo.pivotY = mesh.pivotY;
			vo.pivotZ = mesh.pivotZ;
			
			trace( "mesh.animator = " + mesh.animator );
			vo.animator = mesh.animator;
			
			vo.castsShadows = mesh.castsShadows;
			
			vo.geometry = mesh.geometry;
			
			var e:Array = new Array();
			for each( var extra:ExtraItemVO in mesh.extras )
			{
				e.push(extra.clone());
			}
			vo.extras = new ArrayCollection( e );
			
			commitHistoryEvent( event );
        }
    }
}