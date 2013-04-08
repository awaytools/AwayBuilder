package awaybuilder.model.vo.scene
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	
	import flash.geom.Vector3D;

	[Bindable]
	public class LightVO extends ObjectVO
	{
		
		public function LightVO( light:LightBase )
		{
			if( !light.name || (light.name == "null") ) 
			{
				light.name = GetUniqueName();
			}
			super( light );
			
			this.color = light.color;
			this.ambientColor = light.ambientColor;
			this.ambient = light.ambient;
			this.diffuse = light.diffuse;
			
			this.diffuse = light.diffuse;
			this.specular = light.specular;
			
			if( light is DirectionalLight ) 
			{
				var dl:DirectionalLight = DirectionalLight( light );
				this.directionX = dl.direction.x;
				this.directionY = dl.direction.y;
				this.directionZ = dl.direction.z;
				type = DIRECTIONAL;
			}
			else if( light is PointLight ) 
			{
				var pl:PointLight = PointLight( light );
				type = POINT;
				this.radius = pl.radius;
				this.fallOff = pl.fallOff;
			}
			
		}
		
		public var type:String;
		
		public var color:uint = 0xffffff;
		
		public var ambientColor:uint = 0xffffff;
		public var ambient:Number = 0;
		
		public var specular:Number = 1;
		public var diffuse:Number = 1;
		
		public var radius:Number = 1;
		public var fallOff:Number = 1;
		
		public var directionX:Number;
		public var directionY:Number;
		public var directionZ:Number;
		
		override public function apply():void
		{
			super.apply();
			var lightBase:LightBase = LightBase( linkedObject );
			
			lightBase.diffuse = diffuse;
			lightBase.specular = specular;
			lightBase.ambient = ambient;
			lightBase.color = color;
			lightBase.ambientColor = ambientColor;
			
			if( type == DIRECTIONAL )
			{
				var dl:DirectionalLight = DirectionalLight(linkedObject);
				dl.direction = new Vector3D(directionX,directionY,directionZ);
			}
			else if( type == POINT )
			{
				var pl:PointLight = PointLight(linkedObject);
				pl.radius = radius;
				pl.fallOff = fallOff;
			}
		}
		override public function clone():ObjectVO
		{
			var vo:LightVO = new LightVO( this.linkedObject as LightBase );
			vo.color = this.color;
			vo.ambientColor = this.ambientColor;
			vo.ambient = this.ambient;
			vo.diffuse = this.diffuse;
			
			vo.directionX = this.directionX;
			vo.directionY = this.directionY;
			vo.directionZ = this.directionZ;
			
			vo.x = this.x;
			vo.y = this.y;
			vo.z = this.z;
			
			vo.diffuse = this.diffuse;
			vo.specular = this.specular;
			
			vo.radius = this.radius;
			vo.fallOff = this.fallOff;
			
			vo.id = this.id;
			
			return vo;
		}
		
		
		public static const DIRECTIONAL:String = "directionalType";
		public static const POINT:String = "pointType";
		
		private static var count:int = 0;
		private static function GetUniqueName():String
		{
			count++;
			return "Light " + count;
		}
	}
}