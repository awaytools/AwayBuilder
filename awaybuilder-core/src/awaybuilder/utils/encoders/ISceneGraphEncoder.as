package awaybuilder.utils.encoders
{
	import awaybuilder.model.IDocumentModel;
	
	import flash.utils.ByteArray;

	public interface ISceneGraphEncoder
	{
		function encode(scenegraph : IDocumentModel, output : ByteArray) : Boolean;
		function dispose() : void;
	}
}