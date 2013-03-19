package awaybuilder.model
{
import awaybuilder.model.vo.DocumentBaseVO;
import awaybuilder.model.vo.ScenegraphGroupItemVO;
import awaybuilder.model.vo.ScenegraphItemVO;

import mx.collections.ArrayCollection;

	public interface IDocumentModel
	{
		function get name():String;
		function set name(value:String):void;
		
		function get edited():Boolean;
		function set edited(value:Boolean):void;
		
		function get path():String;
		function set path(value:String):void;
		
		function get scene():ArrayCollection; // Meshes and Containers
		function set scene(value:ArrayCollection):void;
		
		function get materials():ArrayCollection; 
		function set materials(value:ArrayCollection):void;
		
		function get animations():ArrayCollection; 
		function set animations(value:ArrayCollection):void;
		
		function get geometry():ArrayCollection; 
		function set geometry(value:ArrayCollection):void;
		
		function get textures():ArrayCollection; 
		function set textures(value:ArrayCollection):void;
		
		function get skeletons():ArrayCollection; 
		function set skeletons(value:ArrayCollection):void;
		
		function get lights():ArrayCollection; 
		function set lights(value:ArrayCollection):void;
		
		function get selectedObjects():Vector.<Object>;
		function set selectedObjects(value:Vector.<Object>):void;
		
		function getSceneObject( value:Object ):DocumentBaseVO;
		function getMaterial( value:Object ):DocumentBaseVO;
		function getAnimation( value:Object ):DocumentBaseVO;
		function getGeometry( value:Object ):DocumentBaseVO;
		function getTexture( value:Object ):DocumentBaseVO;
		function getSkeleton( value:Object ):DocumentBaseVO;
		function getLight( value:Object ):DocumentBaseVO;
		
	}
}
