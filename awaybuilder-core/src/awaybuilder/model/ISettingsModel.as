package awaybuilder.model
{
	public interface ISettingsModel
	{
		function get snapToGrid():Boolean;
		function set snapToGrid(value:Boolean):void;
		function get gridSize():int;
		function set gridSize(value:int):void;
		function get showGrid():Boolean;
		function set showGrid(value:Boolean):void;

		function reset():void;
	}
}
