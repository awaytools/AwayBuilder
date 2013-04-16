package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.ShadowMapMethodBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.utils.AssetFactory;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ShadowMethodVO extends AssetVO
	{
		public function ShadowMethodVO( name:String, object:ShadowMapMethodBase )
		{
			super( name, object );
			this.epsilon = object.epsilon;
			this.alpha = object.alpha;
			this.light = AssetFactory.GetAsset( object.castingLight ) as LightVO;
			this.type = getClass( object );
		}
		private static function getClass(obj:Object):Class 
		{
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		public var light:LightVO;
		
		public var epsilon:Number = .002;
		public var alpha:Number = 1;
		
		public var type:Class;
		
		override public function apply():void
		{
			var method:ShadowMapMethodBase = linkedObject as ShadowMapMethodBase;
			method.epsilon = epsilon;
			method.alpha = alpha;
		}
		public function clone():ShadowMethodVO
		{
			var vo:ShadowMethodVO = new ShadowMethodVO( this.name, this.linkedObject as ShadowMapMethodBase );
			vo.name = this.name;
			vo.id = this.id;
			return vo;
		}
		
	}
}
