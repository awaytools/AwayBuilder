package org.robotlegs.extensions.mvcs
{
	import flash.utils.Dictionary;
	
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.mvcs.Command;
	
	public class AsyncCommand extends Command
	{
		protected static var _commands:Dictionary = new Dictionary();
		protected var _eventMap:IEventMap;
		
		public function AsyncCommand()
		{
			_commands[this] = true;
		}
		
		public function finish():void
		{
			if (_eventMap) _eventMap.unmapListeners();
			delete _commands[this];
		}
		
		protected function fork(commandClass:Class):void
		{
			injector.instantiate(commandClass).execute();
		}
		
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
	}
}