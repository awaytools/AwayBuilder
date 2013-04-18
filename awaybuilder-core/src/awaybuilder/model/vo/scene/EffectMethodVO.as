package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.EffectMethodBase;

	public class EffectMethodVO extends AssetVO
	{
		
		public var type:String;
		
		public function clone():EffectMethodVO
		{
			var vo:EffectMethodVO = new EffectMethodVO();
			vo.name = this.name;
			vo.id = this.id;
			return vo;
		}
		
		public static const Alpha_Mask:String = "AlphaMask";
		public static const Color_Matrix:String = "ColorMatrix";
		public static const Color_Transform:String = "ColorTransform";
		public static const Env_Map:String = "EnvMap";
		public static const Fog:String = "Fog";
		public static const Fresnel_Env_Map:String = "FresnelEnvMap";
		public static const Fresnel_Planar_Reflection:String = "FresnelPlanarReflection";
		public static const Light_Map:String = "LightMap";
		public static const Outline:String = "Outline";
		public static const Planar_Reflection:String = "PlanarReflection";
		public static const Projective_Texture:String = "ProjectiveTexture";
		public static const Refraction_Env_Map:String = "RefractionEnvMap";
		public static const Rim_Light:String = "RimLight";
		
		
	}
}
