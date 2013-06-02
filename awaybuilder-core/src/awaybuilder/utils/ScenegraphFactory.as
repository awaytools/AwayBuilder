package awaybuilder.utils
{
	import awaybuilder.model.vo.LibraryItemVO;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AnimatorVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CameraVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LensVO;
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
		
		public static function CreateBranch( objects:ArrayCollection, parent:LibraryItemVO ):ArrayCollection 
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				children.addItem( CreateScenegraphChild( asset, parent ) );
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
					children.addItem( CreateScenegraphChild( asset, null ) );
				}
				else
				{
					children.addItem( CreateScenegraphChild( asset, null ) );
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
					children.addItem( CreateScenegraphChild( light, null ) );
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
		
		public static function CreateScenegraphChild( asset:AssetVO, parent:LibraryItemVO ):LibraryItemVO
		{
			var item:LibraryItemVO;
			switch( true )
			{
				case( asset is MeshVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.MESH );
					item.children = CreateBranch( MeshVO(asset).children, item );
					return item;
					
				case( asset is SkyBoxVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.SKY_BOX );
					return item;
					
				case( asset is ContainerVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.CONTAINER );
					item.children = CreateBranch( ContainerVO(asset).children, item );
					return item;
					
				case( asset is MaterialVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.MATERIAL );
					item.children = new ArrayCollection();
					item.children.addItem( new LibraryItemVO( MaterialVO(asset).ambientMethod.type, MaterialVO(asset).ambientMethod, item ) );
					item.children.addItem( new LibraryItemVO( MaterialVO(asset).diffuseMethod.type, MaterialVO(asset).diffuseMethod, item ) );
					item.children.addItem( new LibraryItemVO( MaterialVO(asset).specularMethod.type, MaterialVO(asset).specularMethod, item ) );
					item.children.addItem( new LibraryItemVO( MaterialVO(asset).normalMethod.type, MaterialVO(asset).normalMethod, item ) );
					return item;
					
				case( asset is TextureVO ):
					return new LibraryItemVO( "Texture (" + asset.name.split("/").pop() +")", asset, parent, LibraryItemVO.TEXTURE );
					
				case( asset is LightVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.LIGHT );
					item.children = CreateBranch( LightVO(asset).shadowMethods, item );
					return item;
				
				case( asset is AnimatorVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.ANIMATOR );
					
				case( asset is AnimationNodeVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.ANIMATION_NODE );
					
				case( asset is AnimationSetVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.ANIMATION_SET );
					item.children = CreateBranch( AnimationSetVO(asset).animations, item );
					for each( var node:LibraryItemVO in item.children )
					{
						node.isLinkToSharedObject = true;
					}
					item.children.addAll(CreateBranch( AnimationSetVO(asset).animators, item ));
					return item;
					
				case( asset is SkeletonVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.SKELETON );
					
				case( asset is GeometryVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.GEOMETRY );
					
				case( asset is ShadowMethodVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.SHADOW );
					
				case( asset is EffectMethodVO ):
					return new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.EFFECT );
					
				case( asset is CameraVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.CAMERA );
					item.children = new ArrayCollection();
					item.children.addItem( new LibraryItemVO( CameraVO(asset).lens.type, CameraVO(asset).lens, item, LibraryItemVO.LENS ) );
					return item;
					
				case( asset is LightPickerVO ):
					item = new LibraryItemVO( asset.name, asset, parent, LibraryItemVO.LIGHTPICKER );
					item.children = CreateBranch( LightPickerVO(asset).lights, item );
					for each( var light:LibraryItemVO in item.children )
					{
						light.isLinkToSharedObject = true;
					}
					return item;
					
				default:
					return new LibraryItemVO( asset.name, asset, parent );
			}
		}
		
	}
}