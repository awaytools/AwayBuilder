package awaybuilder.controller.scene
{
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.history.HistoryEvent;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.vo.DroppedAssetVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	public class ReparentLightCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			saveOldValue( event, event.newValue );
			
			if( event.isUndoAction )
			{
				undo();
				return;
			}
			var picker:LightPickerVO;
			
			for each( var item:DroppedAssetVO in event.newValue ) 
			{
				if( item.value is LightVO )
				{
					if( item.newParent == item.oldParent ) return;
					
					if( item.newParent && !item.oldParent )
					{
						picker = item.newParent as LightPickerVO;
						if( picker && !itemIsInList(picker.lights, item.value as AssetVO) ) 
						{
							if( item.newPosition < picker.lights.length )
							{
								picker.lights.addItemAt( item.value, item.newPosition );
							}
							else
							{
								picker.lights.addItem( item.value );
							}
						}
					}
				}
			}
			
			commitHistoryEvent( event );
		}
		private function undo():void
		{
			var picker:LightPickerVO;
			
			for each( var item:DroppedAssetVO in event.newValue ) 
			{
				if( item.value is LightVO )
				{
					
					if( item.oldParent )
					{ 
						picker = item.oldParent as LightPickerVO;
						if( picker && itemIsInList(picker.lights, item.value as AssetVO) ) 
						{
							removeItem( picker.lights, item.value as AssetVO );
						}
					}
				}
			}
		}
		private function itemIsInList( collection:ArrayCollection, asset:AssetVO ):Boolean
		{
			for each( var a:AssetVO in collection )
			{
				if( a.equals( asset ) ) return true;
			}
			return false;
		}
		
		private function removeItem( source:ArrayCollection, oddItem:AssetVO ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				var item:AssetVO = source[i] as AssetVO;
				if( item.equals( oddItem ) )
				{
					source.removeItemAt( i );
					i--;
				}
			}
		}
		
		override protected function saveOldValue( event:HistoryEvent, prevValue:Object ):void 
		{
			if( !event.oldValue ) 
			{
				var oldValue:Dictionary = new Dictionary();
				for each( var item:DroppedAssetVO in event.newValue ) 
				{
					var newItem:DroppedAssetVO = new DroppedAssetVO();
					newItem.value = item.value;
					newItem.newParent = item.oldParent;
					newItem.newPosition = item.newPosition;
					newItem.oldParent = item.newParent;
					newItem.oldPosition = item.oldPosition;
					oldValue[item.value] = newItem;
				}
				event.oldValue = oldValue;
			}
		}
		
	}
}