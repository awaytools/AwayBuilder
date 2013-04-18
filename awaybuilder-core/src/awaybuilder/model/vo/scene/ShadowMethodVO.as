package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.ShadowMapMethodBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.utils.AssetFactory;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	[Bindable]
	public class ShadowMethodVO extends AssetVO
	{
		
		public var light:LightVO;
		
		public var epsilon:Number = .002;
		public var alpha:Number = 1;
		
		public var type:String;
		
//		override public function apply():void
//		{
//			var method:ShadowMapMethodBase = linkedObject as ShadowMapMethodBase;
//			method.epsilon = epsilon;
//			method.alpha = alpha;
//		}
		public function clone():ShadowMethodVO
		{
			var vo:ShadowMethodVO = new ShadowMethodVO();
			vo.name = this.name;
			vo.id = this.id;
			vo.type = this.type;
			return vo;
		}

		public static const FILTERED_SHADOW_MAP_METHOD:String = "FilteredShadowMapMethod";
		public static const DITHERED_SHADOW_MAP_METHOD:String = "DitheredShadowMapMethod";
		public static const SOFT_SHADOW_MAP_METHOD:String = "SoftShadowMapMethod";
		public static const HARD_SHADOW_MAP_METHOD:String = "HardShadowMapMethod";
		public static const NEAR_SHADOW_MAP_METHOD:String = "NearShadowMapMethod";
		public static const CASCADE_SHADOW_MAP_METHOD:String = "CascadeShadowMapMethod";
	}
}
