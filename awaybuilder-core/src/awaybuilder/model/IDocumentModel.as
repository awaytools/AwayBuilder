package awaybuilder.model
{
import awaybuilder.model.vo.scene.AssetVO;
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
		
		function get selectedObjects():Vector.<AssetVO>;
		function set selectedObjects(value:Vector.<AssetVO>):void;
		
		function get copiedObjects():Vector.<AssetVO>;
		function set copiedObjects(value:Vector.<AssetVO>):void;
		
		function getSceneObject( value:Object ):AssetVO;
		function getMaterial( value:Object ):AssetVO;
		function getAnimation( value:Object ):AssetVO;
		function getGeometry( value:Object ):AssetVO;
		function getTexture( value:Object ):AssetVO;
		function getSkeleton( value:Object ):AssetVO;
		function getLight( value:Object ):AssetVO;
		
		function clear():void;
	}
}
