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
		public static const MATERIAL:String = "material";
		public static const GEOMETRY:String = "geometry";
		public static const SKELETON:String = "skeleton";
		public static const SKELETON_POSE:String = "skeletonPose";
		public static const CONTAINER:String = "container";
		public static const BEAR:String = "bear";
		public static const ANIMATION_NODE:String = "animationNode";
		public static const TEXTURE:String = "texture";
		public static const AMBIENT:String = "ambient";
		public static const NORMAL:String = "normal";
		public static const DIFFUSE:String = "diffuse";
		public static const SHADOW:String = "shadow";
		public static const EFFECT:String = "effect";
		public static const SPECULAR:String = "specular";
		
		public function ScenegraphItemVO( label:String, item:AssetVO, type:String="default" )
		{
			this.label = label;
			this.item = item;
			
			this.type = type;
		}
		
		public var label:String;
		
		public var item:AssetVO;
		
		public var children:ArrayCollection;
		
		public var type:String = "default";
		
		public function merge( item:Object ):void
		{
			var newItem:ScenegraphItemVO = item as ScenegraphItemVO;
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