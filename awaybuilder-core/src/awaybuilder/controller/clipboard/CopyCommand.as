package awaybuilder.controller.clipboard
{
	import away3d.entities.Mesh;
	
	import awaybuilder.controller.clipboard.events.ClipboardEvent;
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.vo.AssetVO;
	import awaybuilder.model.vo.MeshVO;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;

	public class CopyCommand extends Command
	{
		
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var event:ClipboardEvent;
		
		override public function execute():void
		{
			if( !document.selectedObjects || (document.selectedObjects.length == 0))
			{
				return;
			}
			
			var copiedObjects:Vector.<AssetVO> = new Vector.<AssetVO>();
			for each( var vo:AssetVO in document.selectedObjects )
			{
				var meshVO:MeshVO = vo as MeshVO;
				if( meshVO )
				{
					var newMesh:Mesh = meshVO.mesh.clone() as Mesh;
					copiedObjects.push( new MeshVO(newMesh) );
					trace( "newMesh.name  = " + newMesh.name );
				}
				
			}
			document.copiedObjects = copiedObjects;
			if(event.type == ClipboardEvent.CLIPBOARD_CUT)
			{
				this.dispatch(new SceneEvent(SceneEvent.DELETE_OBJECTS, [], document.selectedObjects.concat() ));
			}
		}
	}
}