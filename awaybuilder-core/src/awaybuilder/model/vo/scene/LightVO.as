package awaybuilder.model.vo.scene
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.lights.shadowmaps.ShadowMapperBase;
	
	import flash.geom.Vector3D;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class LightVO extends ObjectVO
	{
		
		public var type:String;
		
		public var color:uint = 0xffffff;
		
		public var ambientColor:uint = 0xffffff;
		public var ambient:Number = 0;
		
		public var specular:Number = 1;
		public var diffuse:Number = 1;
		
		public var radius:Number = 1;
		public var fallOff:Number = 1;
		
//		public var directionX:Number;
//		public var directionY:Number;
//		public var directionZ:Number;
		
		public var castsShadows:Boolean;
		
		public var shadowMapper:String;
		
		public var shadowMethods:ArrayCollection = new ArrayCollection();
		
//		public var zeroAzimuthAngle:Number = 0; // azimuth angle if light elevation = 90 or -90
		
		public var azimuthAngle:Number = 0;
		public var elevationAngle:Number = 0;
		
//		override public function apply():void
//		{
//			super.apply();
//			var lightBase:LightBase = LightBase( linkedObject );
//			
//			lightBase.diffuse = diffuse;
//			lightBase.specular = specular;
//			lightBase.ambient = ambient;
//			lightBase.color = color;
//			lightBase.ambientColor = ambientColor;
//			
//			
//			if( castsShadows && shadowMapper ) 
//			{
//				lightBase.shadowMapper = shadowMapper;
//			}
//			lightBase.castsShadows = castsShadows;
//			
//			if( type == DIRECTIONAL )
//			{
//				var dl:DirectionalLight = DirectionalLight(linkedObject);
//				dl.direction = new Vector3D(directionX,directionY,directionZ);
//			}
//			else if( type == POINT )
//			{
//				var pl:PointLight = PointLight(linkedObject);
//				pl.radius = radius;
//				pl.fallOff = fallOff;
//			}
//		}
		override public function clone():ObjectVO
		{
			var vo:LightVO = new LightVO();
			vo.fillFromObject( this );
			vo.type = this.type;
			
			vo.color = this.color;
			vo.ambientColor = this.ambientColor;
			vo.ambient = this.ambient;
			vo.diffuse = this.diffuse;
			
			vo.castsShadows = this.castsShadows;
			
			vo.shadowMapper = this.shadowMapper;
			
			vo.shadowMethods = new ArrayCollection(this.shadowMethods.source);
			
			vo.azimuthAngle = this.azimuthAngle;
			vo.elevationAngle = this.elevationAngle;
			vo.diffuse = this.diffuse;
			vo.specular = this.specular;
			
			vo.radius = this.radius;
			vo.fallOff = this.fallOff;
			
			return vo;
		}
		
		public static const DIRECTIONAL:String = "directionalType";
		public static const POINT:String = "pointType";
		
	}
}