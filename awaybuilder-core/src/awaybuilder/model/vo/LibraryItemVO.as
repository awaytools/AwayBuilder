package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.utils.CollectionUtil;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.LibraryFactory;
	import awaybuilder.utils.interfaces.IMergeable;
	
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	
	[Bindable]
	public class LibraryItemVO
	{
		
		public function LibraryItemVO( asset:AssetVO, parent:LibraryItemVO, type:String="default" )
		{
			this.asset = asset;
			this.parent = parent;
			this.type = type;
			IEventDispatcher(asset).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, asset_propertyChangeHandler );
			watchChildren();
		}
		
		private function asset_propertyChangeHandler( event:PropertyChangeEvent ):void
		{
			switch( true )
			{
				case( asset is ContainerVO ):
					if( event.property == "children" )
					{
						children = LibraryFactory.CreateBranch( ContainerVO(asset).children, this );
						CollectionUtil.sync( children, ContainerVO(asset).children, addItemFunction );
					}
					
					break;
				case( asset is LightPickerVO ):
					if( event.property == "lights" )
					{
						children = LibraryFactory.CreateBranch( LightPickerVO(asset).lights, this );
						CollectionUtil.sync( children, LightPickerVO(asset).lights, addItemFunction );
						for each( var light:LibraryItemVO in this.children )
						{
							light.isLinkToSharedObject = true;
						}
					}
					
					break;
				case( asset is MaterialVO ):
					if( event.property == "ambientMethod" )
					{
						replace( event.oldValue as AssetVO, event.newValue as AssetVO );
					}
					if( event.property == "diffuseMethod" )
					{
						replace( event.oldValue as AssetVO, event.newValue as AssetVO );
					}
					if( event.property == "specularMethod" )
					{
						replace( event.oldValue as AssetVO, event.newValue as AssetVO );
					}
					if( event.property == "normalMethod" )
					{
						replace( event.oldValue as AssetVO, event.newValue as AssetVO );
					}
					break;
			}
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
			switch( true )
			{
				case( asset is ContainerVO ):
					children = LibraryFactory.CreateBranch( ContainerVO(asset).children, this );
					CollectionUtil.sync( children, ContainerVO(asset).children, addItemFunction );
					break;
				case( asset is LightPickerVO ):
					children = LibraryFactory.CreateBranch( LightPickerVO(asset).lights, this );
					CollectionUtil.sync( children, LightPickerVO(asset).lights, addItemFunction );
					for each( var light:LibraryItemVO in this.children )
					{
						light.isLinkToSharedObject = true;
					}
					break;
				case( asset is LightVO ):
					children = LibraryFactory.CreateBranch( LightVO(asset).shadowMethods, this );
					CollectionUtil.sync( children, LightVO(asset).shadowMethods, addItemFunction );
					break;
				case( asset is MaterialVO ):
					children = new ArrayCollection();
					children.addItem( new LibraryItemVO( MaterialVO(asset).ambientMethod, this ) );
					children.addItem( new LibraryItemVO( MaterialVO(asset).diffuseMethod, this ) );
					children.addItem( new LibraryItemVO( MaterialVO(asset).specularMethod, this ) );
					children.addItem( new LibraryItemVO( MaterialVO(asset).normalMethod, this ) );
					break;
			}
		}
		
		protected function addItemFunction( asset:AssetVO ):Object
		{
			return LibraryFactory.CreateScenegraphChild( asset, this );
		}
		
		public var asset:AssetVO; // key field, used to compare items
		
		public var children:ArrayCollection = new ArrayCollection();
		
		public var type:String = "default";
		
		public var parent:LibraryItemVO;
		
		public var isLinkToSharedObject:Boolean = false;
		
		
		public static const LIGHT:String = "light";
		public static const LIGHTPICKER:String = "lightPicker";
		public static const MESH:String = "mesh";
		public static const SKY_BOX:String = "skyBox";
		public static const MATERIAL:String = "material";
		public static const GEOMETRY:String = "geometry";
		public static const SKELETON:String = "skeleton";
		public static const SKELETON_POSE:String = "skeletonPose";
		public static const CONTAINER:String = "container";
		public static const BEAR:String = "bear";
		public static const ANIMATION_NODE:String = "animationNode";
		public static const ANIMATION_SET:String = "animationSet";
		public static const ANIMATOR:String = "animator";
		public static const TEXTURE:String = "texture";
		public static const AMBIENT:String = "ambient";
		public static const NORMAL:String = "normal";
		public static const DIFFUSE:String = "diffuse";
		public static const SHADOW:String = "shadow";
		public static const EFFECT:String = "effect";
		public static const SPECULAR:String = "specular";
		public static const SHADING:String = "shading";
		public static const CAMERA:String = "camera";
		public static const LENS:String = "lens";
	}
}