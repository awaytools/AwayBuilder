package awaybuilder.utils
{
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	
	import mx.collections.ArrayCollection;

	public class ScenegraphFactory
	{
		
		public static function CreateBranch( objects:ArrayCollection):ArrayCollection 
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				children.addItem( createScenegraphCild ( asset ) );
			}
			return children;
		}
		
		private static function createScenegraphCild( asset:AssetVO ):ScenegraphItemVO
		{
			var item:ScenegraphItemVO;
			switch( true )
			{
				case( asset is MeshVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.MESH );
					item.children = CreateBranch( MeshVO(asset).children );
					return item;
				case( asset is ContainerVO ):
					item = new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.CONTAINER );
					item.children = CreateBranch( ContainerVO(asset).children );
					return item;
				case( asset is MaterialVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.MATERIAL );
				case( asset is TextureVO ):
					return new ScenegraphItemVO( "Texture (" + asset.name.split("/").pop() +")", asset, ScenegraphItemVO.TEXTURE );
				case( asset is LightVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.LIGHT );
				case( asset is AnimationNodeVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.ANIMATION_NODE );
				case( asset is SkeletonVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.SKELETON );
				case( asset is GeometryVO ):
					return new ScenegraphItemVO( asset.name, asset, ScenegraphItemVO.GEOMETRY );
					
				default:
					return new ScenegraphItemVO( asset.name, asset );
			}
		}
		
	}
}