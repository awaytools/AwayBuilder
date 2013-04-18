package awaybuilder.model.vo.scene
{
	import away3d.materials.methods.ShadowMapMethodBase;
	
	import awaybuilder.model.vo.scene.interfaces.IDefaultable;
	import awaybuilder.utils.AssetFactory;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

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
			return vo;
		}
		
	}
}
