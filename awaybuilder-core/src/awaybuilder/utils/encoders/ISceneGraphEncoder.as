package awaybuilder.utils.encoders
{
	import awaybuilder.model.DocumentModel;
	
	import flash.utils.ByteArray;

	public interface ISceneGraphEncoder
	{
		function encode(scenegraph : DocumentModel, output : ByteArray) : Boolean;
		function dispose() : void;
	}
}