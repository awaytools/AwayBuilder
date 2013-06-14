package awaybuilder.utils
{
	import awaybuilder.model.vo.AnimationSetLibraryItemModel;
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

	public class LibraryFactory
	{
		
		public static function CreateBranch( objects:ArrayCollection, parent:LibraryItemVO=null ):ArrayCollection 
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				children.addItem( CreateScenegraphChild( asset, parent ) );
			}
			return children;
		}
		
		public static function CreateScenegraphChild( asset:AssetVO, parent:LibraryItemVO ):LibraryItemVO
		{
			var item:LibraryItemVO;
			switch( true )
			{
				case( asset is MeshVO ):
					item = new LibraryItemVO( asset, parent, LibraryItemVO.MESH );
					return item;
					
				case( asset is SkyBoxVO ):
					item = new LibraryItemVO( asset, parent, LibraryItemVO.SKY_BOX );
					return item;
					
				case( asset is ContainerVO ):
					item = new LibraryItemVO( asset, parent, LibraryItemVO.CONTAINER );
					return item;
					
				case( asset is MaterialVO ):
					item = new LibraryItemVO( asset, parent, LibraryItemVO.MATERIAL );
					return item;
					
				case( asset is TextureVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.TEXTURE );
					
				case( asset is LightVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.LIGHT );
				
				case( asset is AnimatorVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.ANIMATOR );
					
				case( asset is AnimationNodeVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.ANIMATION_NODE );
					
				case( asset is AnimationSetVO ):
					return new AnimationSetLibraryItemModel( asset, parent );
					
				case( asset is SkeletonVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.SKELETON );
					
				case( asset is GeometryVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.GEOMETRY );
					
				case( asset is ShadowMethodVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.SHADOW );
					
				case( asset is EffectMethodVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.EFFECT );
					
				case( asset is CameraVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.CAMERA );
					
				case( asset is LightPickerVO ):
					return new LibraryItemVO( asset, parent, LibraryItemVO.LIGHTPICKER );
					
				default:
					return new LibraryItemVO( asset, parent );
			}
		}
		
	}
}