package awaybuilder.controller
{
	import mx.collections.ArrayCollection;
	
	import awaybuilder.model.IDocumentModel;
	import awaybuilder.model.ISettingsModel;
	import awaybuilder.model.UndoRedoModel;
	import awaybuilder.model.vo.ScenegraphGroupItemVO;
	
	import org.robotlegs.mvcs.Command;

	public class NewDocumentCommand extends Command
	{	
		[Inject]
		public var document:IDocumentModel;
		
		[Inject]
		public var undoRedo:UndoRedoModel;

		[Inject]
		public var settings:ISettingsModel;

		
		override public function execute():void
		{
			undoRedo.clear();
			
			document.name = "Untitled Library 1";
			document.edited = false;
			document.path = null;

			var graph:ArrayCollection = new ArrayCollection();
			
			var _lightGroup:ScenegraphGroupItemVO = new ScenegraphGroupItemVO( "Lights", ScenegraphGroupItemVO.LIGHT_GROUP );
			graph.addItem( _lightGroup );
			
			document.scenegraph = graph;
				
//			Scene3DManager.clear();
			
		}
	}
}