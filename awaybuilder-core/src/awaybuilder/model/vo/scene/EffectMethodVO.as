package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.EffectMethodBase;

	[Bindable]
	public class EffectMethodVO extends AssetVO
	{
		
		public var type:String;
		
		public var mode:String = "Multiply";
		
		public var texture:TextureVO;
		public var cubeTexture:CubeTextureVO;
		public var textureProjector:String;
		
		public var refraction:Number;
		public var alpha:Number;
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var a:Number;
		public var rG:Number;
		public var gG:Number;
		public var bG:Number;
		public var aG:Number;
		public var rB:Number;
		public var gB:Number;
		public var bB:Number;
		public var aB:Number;
		public var rA:Number;
		public var gA:Number;
		public var bA:Number;
		public var aA:Number;
		public var rO:Number;
		public var gO:Number;
		public var bO:Number;
		public var aO:Number;
		
		public var color:uint;
		public var strength:Number;
		public var power:Number;
		public var useSecondaryUV:Boolean;
		
		public var showInnerLines:Boolean;
		public var dedicatedMesh:Boolean;
		
		public var size:Number;
		
		public function clone():EffectMethodVO
		{
			var vo:EffectMethodVO = new EffectMethodVO();
			vo.fillFromEffectMethod( this );
			return vo;
		}
		
		public function fillFromEffectMethod( asset:EffectMethodVO ):void
		{
			this.name = asset.name;
			this.alpha = asset.alpha;
			this.type = asset.type;
			this.isDefault = asset.isDefault;
			this.id = asset.id;
			
			this.mode = asset.mode;
			
			this.texture = asset.texture;
			this.cubeTexture = asset.cubeTexture;
			this.textureProjector = asset.textureProjector;
			
			this.refraction = asset.refraction;
			this.alpha = asset.alpha;
			
			this.r = asset.r;
			this.g = asset.g;
			this.b = asset.b;
			this.a = asset.a;
			this.rG = asset.rG;
			this.gG = asset.gG;
			this.bG = asset.bG;
			this.aG = asset.aG;
			this.rB = asset.rB;
			this.gB = asset.gB;
			this.bB = asset.bB;
			this.aB = asset.aB;
			this.rA = asset.rA;
			this.gA = asset.gA;
			this.bA = asset.bA;
			this.aA = asset.aA;
			this.rO = asset.rO;
			this.gO = asset.gO;
			this.bO = asset.bO;
			this.aO = asset.aO;
			
			this.color = asset.color;
			this.strength = asset.strength;
			this.power = asset.power;
			this.useSecondaryUV = asset.useSecondaryUV;
			
			this.showInnerLines = asset.showInnerLines;
			this.dedicatedMesh = asset.dedicatedMesh;
			
			this.size = asset.size;
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
