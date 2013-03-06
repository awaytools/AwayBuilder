package awaybuilder.model
{
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
		
		function get selectedObjects():Vector.<Object>;
		function set selectedObjects(value:Vector.<Object>):void;
		
//		function addObject(object:IEditorObjectView):void;
//		function removeObject(object:IEditorObjectView):void;

	}
}
