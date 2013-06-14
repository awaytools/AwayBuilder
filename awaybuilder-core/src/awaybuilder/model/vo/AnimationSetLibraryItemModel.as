package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.utils.CollectionUtil;
	import awaybuilder.utils.LibraryFactory;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	
	public class AnimationSetLibraryItemModel extends LibraryItemVO
	{
		public function AnimationSetLibraryItemModel( asset:AssetVO, parent:LibraryItemVO )
		{
			super(asset, parent, LibraryItemVO.ANIMATION_SET);
			IEventDispatcher(asset).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, asset_propertyChangeHandler );
			watchChildren();
		}
		
		private var animations:ArrayCollection;
		private var animators:ArrayCollection;
		
		private function asset_propertyChangeHandler( event:PropertyChangeEvent ):void
		{
		}
		private function replace( oldValue:AssetVO, newValue:AssetVO ):void
		{
			for( var i:int = 0; i < children.length; i++ )
			{
				var item:LibraryItemVO = children.getItemAt(i) as LibraryItemVO;
				if( item.asset.equals(oldValue) )
				{
					children.setItemAt( new LibraryItemVO( newValue, this ), i);
				}
			}
		}
		private function watchChildren():void
		{
			animations = LibraryFactory.CreateBranch( AnimationSetVO(asset).animations, this );
			animators = LibraryFactory.CreateBranch( AnimationSetVO(asset).animators, this );
			CollectionUtil.sync( children, AnimationSetVO(asset).animations, addItemFunction );
			CollectionUtil.sync( children, AnimationSetVO(asset).animators, addItemFunction );
			
			animations.addEventListener(CollectionEvent.COLLECTION_CHANGE, source_collectionChangeHandler );
			animators.addEventListener(CollectionEvent.COLLECTION_CHANGE, source_collectionChangeHandler );
		}
		private function source_collectionChangeHandler( event:CollectionEvent ):void
		{
			var newChildren:ArrayCollection = new ArrayCollection();
			newChildren.addAll(animators);
			newChildren.addAll(animations);
			
			children = newChildren;
		}
	}
}