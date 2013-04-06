package awaybuilder.model.vo
{
	import awaybuilder.model.vo.scene.AssetVO;
	
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class ScenegraphItemVO
	{
		
		public static const LIGHT:String = "light";
		public static const MESH:String = "mesh";
		public static const MATERIAL:String = "material";
		public static const GEOMETRY:String = "geometry";
		public static const SKELETON:String = "skeleton";
		public static const SKELETON_POSE:String = "skeletonPose";
		public static const CONTAINER:String = "container";
		public static const BEAR:String = "bear";
		public static const ANIMATION_NODE:String = "animationNode";
		public static const TEXTURE:String = "texture";
		
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
		
	}
}