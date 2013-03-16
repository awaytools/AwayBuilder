package awaybuilder.model
{
import awaybuilder.model.vo.ScenegraphItemVO;

import mx.collections.ArrayCollection;
	
	import awaybuilder.model.vo.ScenegraphGroupItemVO;

	public interface IDocumentModel
	{
		function get name():String;
		function set name(value:String):void;
		function get edited():Boolean;
		function set edited(value:Boolean):void;
		function get path():String;
		function set path(value:String):void;
		
		function get scenegraph():ArrayCollection; // main tree provider
		function set scenegraph(value:ArrayCollection):void;
		
		function getScenegraphGroup( type:String ):ScenegraphGroupItemVO;

        function getScenegraphItem( value:Object ):ScenegraphItemVO;
		
		function get selectedObjects():Vector.<ScenegraphItemVO>;
		function set selectedObjects(value:Vector.<ScenegraphItemVO>):void;
		
//		function addObject(object:IEditorObjectView):void;
//		function removeObject(object:IEditorObjectView):void;

	}
}
