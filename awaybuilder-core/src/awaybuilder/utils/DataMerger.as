package awaybuilder.utils
{
	import awaybuilder.utils.interfaces.IMergeable;
	
	import flash.utils.Dictionary;
	
	import mx.collections.IList;

	public final class DataMerger
	{
		// TODO: make comparePropertyName not required, so items themselves will be compared
		// TODO: write tests for IList collections
		/**
		 * Syncs given arrays.
		 * Rules:
		 * if item from new array is exist in originalList, then all properties of the item is copied to the old item.
		 * if item from new array does'nt exist in originalList - it is added to the end of the originalList array
		 * if item from originalList array doesn't exist in new array, then item is being removed from originalList array (if allowRemove parameter is true).
		 * @param originalList can be Array, Vector or IList
		 * @param newList can be Array, Vector or IList
		 * @param comparePropertyName property name to compare items. It must exist on each item. Property contents will be converted to string before comparing.
		 * @param mergeFunction Function that will be invoked each time when equal items will be found.
		 * @param allowRemove If true, then all items that are not exist in new array will be removed in originalList one.
		 * it must accept 2 arguments: function(originalItem:*, newItem:*)
		 * 
		 */
		public static function syncArrays(originalList:*, newList:*, comparePropertyName:String, mergeFunction:Function = null, allowRemove:Boolean = true):void
		{
			if(allowRemove)
				removeNonExistingItems(originalList, newList, comparePropertyName);

			var item:*;
			var oldItem:*;
			var itemsMap:Object = {};
			

			for each(item in newList)
			{
				oldItem = null;
				
				for each(var originalItem:Object in originalList)
				{
					if( item[comparePropertyName] == originalItem[comparePropertyName] )
					oldItem = originalItem;
				}
				
				if(oldItem )
				{
					if(oldItem != item)
					{
						if(mergeFunction is Function)
							mergeFunction(oldItem, item);
						else if(oldItem is IMergeable)
							IMergeable(oldItem).merge(item);
					}
				}
				else
				{
					switch(true)
					{
						case originalList is IList:
							originalList.addItem(item);
							break;
						
						default:
							originalList.push(item);
					}
				}
			}
		}

		/**
		 * Will remove all items from originalList which are not exist in referenceList.
		 * Comparing will be performed by comparePropertyName
		 * @param originalList can be Array, Vector or IList
		 * @param referenceList can be Array, Vector or IList
		 * @param comparePropertyName
		 * @return
		 */
		private static function removeNonExistingItems(originalList:*, referenceList:*, comparePropertyName:String):void
		{
			var item:*;

			var itemsToRemove:Array = [];
			
			var itemExist:Boolean = false;
			for each(var originalItem:* in originalList)
			{
				itemExist = false;
				for each(var referenceItem:* in referenceList)
				{
					
					if( originalItem[comparePropertyName] == referenceItem[comparePropertyName] )
					{
						itemExist = true;
						break;
					}
				}
				
				if( !itemExist )
				{
					itemsToRemove.push( originalItem );
				}
			}
			
			var i:int;
			switch(true)
			{
				case originalList is IList:
					for each(item in itemsToRemove)
					{
						i = originalList.getItemIndex(item);
						if(i > -1)
							originalList.removeItemAt(i);
					}
					break;

				default:
					for each(item in itemsToRemove)
					{
						i = originalList.indexOf(item);
						if(i > -1)
							originalList.splice(i, 1);
					}
			}
		}
	}
}