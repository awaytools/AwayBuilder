package awaybuilder.controller
{
import awaybuilder.model.IDocumentModel;
import awaybuilder.model.ISettingsModel;
import awaybuilder.model.UndoRedoModel;
import awaybuilder.model.vo.ScenegraphGroupItemVO;
import awaybuilder.utils.scene.Scene3DManager;

import mx.collections.ArrayCollection;

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
			
			document.scene = new ArrayCollection();
			document.materials = new ArrayCollection();
			document.animations = new ArrayCollection();
			document.geometry = new ArrayCollection();
			document.textures = new ArrayCollection();
			document.skeletons = new ArrayCollection();
			document.lights = new ArrayCollection();
			
			document.selectedObjects = new Vector.<Object>();
			
			Scene3DManager.clear();
		}
	}
}