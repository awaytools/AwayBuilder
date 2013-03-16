package awaybuilder.model.vo
{
	import mx.collections.ArrayCollection;

	public class ScenegraphGroupItemVO extends ScenegraphItemVO
	{
		public static const SCENE_GROUP:String      = "sceneGroup";
		public static const MATERIAL_GROUP:String   = "materialGroup";
		public static const ANIMATION_GROUP:String  = "animationGroup";
		public static const GEOMETRY_GROUP:String   = "geometryGroup";
        public static const LIGHT_GROUP:String      = "lightGroup";
		public static const TEXTURE_GROUP:String    = "textureGroup";
        public static const SKELETON_GROUP:String   = "skeletonGroup";
		
		public function ScenegraphGroupItemVO(label:String, type:String)
		{
			super(label, null);
			this.children = new ArrayCollection();
			this.type = type;
			switch(type)
			{
				case SCENE_GROUP:
					weight = 0;
					break;
				case MATERIAL_GROUP:
					weight = 1;
					break;
                case TEXTURE_GROUP:
                    weight = 2;
                    break;
                case GEOMETRY_GROUP:
                    weight = 3;
                    break;
				case ANIMATION_GROUP:
					weight = 4;
					break;
				case LIGHT_GROUP:
					weight = 10;
					break;
                case SKELETON_GROUP:
                    weight = 5;
                    break;
			}
		}
		
		public var type:String;
		
		public var weight:int = 100;
	}
}