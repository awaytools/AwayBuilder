package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.utils.DataMerger;
	import awaybuilder.utils.interfaces.IMergeable;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ScenegraphItemVO implements IMergeable
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
		
		public function ScenegraphItemVO( label:String, item:AssetVO, type:String="default" )
		{
			this.label = label;
			this.item = item;
			
			this.type = type;
		}
		
		public var label:String;
		
		public var item:AssetVO; // key field, used to compare items
		
		public var children:ArrayCollection;
		
		public var type:String = "default";
		
		public var isLinkToSharedObject:Boolean = false;
		
		public function merge( item:Object ):void
		{
			var newItem:ScenegraphItemVO = item as ScenegraphItemVO;
			
			this.label = newItem.label;
			if( newItem.children && this.children )
			{
				this.children = DataMerger.syncArrayCollections( this.children, newItem.children, "item" );
			}
			else if( newItem.children )
			{
				this.children = new ArrayCollection( newItem.children.source.concat() );
			}
			
		}
	}
}