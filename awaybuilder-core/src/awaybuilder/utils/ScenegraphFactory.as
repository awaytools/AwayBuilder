package awaybuilder.utils
{
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AnimatorVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
	import mx.collections.ArrayCollection;

	public class ScenegraphFactory
	{
		
		private var _lightsInPicker:Vector.<AssetVO> = new Vector.<AssetVO>();
		
		public static function CreateBranch( objects:ArrayCollection):ArrayCollection 
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				children.addItem( CreateScenegraphChild( asset ) );
			}
			return children;
		}
		
		public static function CreateLightsBranch( objects:ArrayCollection):ArrayCollection 
		{
			var lights:Vector.<LightVO> = new Vector.<LightVO>();
			var pickers:Vector.<LightPickerVO> = new Vector.<LightPickerVO>();
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				if( asset is LightVO ) 
				{
					lights.push(asset);
				}
				else if( asset is LightPickerVO ) 
				{
					pickers.push(asset);
					children.addItem( CreateScenegraphChild( asset ) );
				}
				else
				{
					children.addItem( CreateScenegraphChild( asset ) );
				}
			}
			var lightIsPresent:Boolean;
			for each( var light:LightVO in lights )
			{
//				lightIsPresent = false;
//				for each( var picker:LightPickerVO in pickers )
//				{
//					lightIsPresent = isLightInPicker( picker, light )
//				}
//				if( !lightIsPresent )
//				{
					children.addItem( CreateScenegraphChild( light ) );
//				}
				
			}
			
			return children;
		}
		
		private static function isLightInPicker( picker:LightPickerVO, light:LightVO ):Boolean
		{
			for each( var piclerLight:LightVO in picker.lights )
			{
				if( piclerLight.equals( light ) ) return true;
			}
			return false;
		}
		
		public static function CreateScenegraphChild( asset:AssetVO ):ScenegraphItemVO
		{
			var item:ScenegraphItemVO;
			switch( true )
			{
				case( asset is MeshVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.MESH );
					item.children = CreateBranch( MeshVO(asset).children );
					return item;
					
				case( asset is SkyBoxVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.SKY_BOX );
					return item;
					
				case( asset is ContainerVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.CONTAINER );
					item.children = CreateBranch( ContainerVO(asset).children );
					return item;
					
				case( asset is MaterialVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.MATERIAL );
					item.children = new ArrayCollection();
					item.children.addItem( new ScenegraphItemVO( MaterialVO(asset).ambientMethod.type, MaterialVO(asset).ambientMethod ) );
					item.children.addItem( new ScenegraphItemVO( MaterialVO(asset).diffuseMethod.type, MaterialVO(asset).diffuseMethod ) );
					item.children.addItem( new ScenegraphItemVO( MaterialVO(asset).specularMethod.type, MaterialVO(asset).specularMethod ) );
					item.children.addItem( new ScenegraphItemVO( MaterialVO(asset).normalMethod.type, MaterialVO(asset).normalMethod ) );
					return item;
					
				case( asset is TextureVO ):
					return new ScenegraphItemVO( "Texture (" + asset.name.split("/").pop() +")", asset, ScenegraphItemVO.TEXTURE );
					
				case( asset is LightVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.LIGHT );
					item.children = CreateBranch( LightVO(asset).shadowMethods );
					return item;
				
				case( asset is AnimatorVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.ANIMATOR );
					
				case( asset is AnimationNodeVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.ANIMATION_NODE );
					
				case( asset is AnimationSetVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.ANIMATION_SET );
					item.children = CreateBranch( AnimationSetVO(asset).animations );
					return item;
					
				case( asset is SkeletonVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.SKELETON );
					
				case( asset is GeometryVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.GEOMETRY );
					
				case( asset is ShadowMethodVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.SHADOW );
					
				case( asset is EffectMethodVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.EFFECT );
					
				case( asset is LightPickerVO ):
					item = new ScenegraphItemVO( asset.name, asset );
					item.children = CreateBranch( LightPickerVO(asset).lights );
					return item;
					
				default:
					return new ScenegraphItemVO( asset.name, asset );
			}
		}
		
	}
}