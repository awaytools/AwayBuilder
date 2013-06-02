package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.interfaces.IMergeable;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class LibraryItemVO implements IMergeable
	{
		
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
		
		public function LibraryItemVO( label:String, item:AssetVO, parent:LibraryItemVO, type:String="default" )
		{
			this.label = label;
			this.asset = item;
			this.parent = parent;
			this.type = type;
		}
		
		public var label:String;
		
		public var asset:AssetVO; // key field, used to compare items
		
		public var children:ArrayCollection;
		
		public var type:String = "default";
		
		public var parent:LibraryItemVO;
		
		public var isLinkToSharedObject:Boolean = false;
		
		public function merge( item:Object ):void
		{
			var newItem:LibraryItemVO = item as LibraryItemVO;
			
			this.label = newItem.label;
			
			this.parent = newItem.parent;
			
			if( newItem.children && this.children )
			{
				this.children = DataMerger.syncArrayCollections( this.children, newItem.children, "asset" );
			}
			else if( newItem.children )
			{
				this.children = new ArrayCollection( newItem.children.source.concat() );
			}
			
		}
	}
}