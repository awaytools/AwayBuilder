package awaybuilder.utils
{
	import awaybuilder.model.vo.ScenegraphItemVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.BitmapTextureVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	
	import mx.collections.ArrayCollection;

	public class ScenegraphFactory
	{
		public function ScenegraphFactory()
		{
		}
		
		public static function CreateBranch( objects:ArrayCollection):ArrayCollection 
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in objects )
			{
				children.addItem( createScenegraphCild ( asset ) );
			}
			return children;
		}
		
		private static function createScenegraphCild( item:AssetVO ):ScenegraphItemVO{
			switch( true )
			{
				case( item is MeshVO ):
					if(item.name.toUpperCase().indexOf("BEAR")>=0)
					{
						return new ScenegraphItemVO( item.name, item, ScenegraphItemVO.BEAR );
					}
					return new ScenegraphItemVO( item.name, item, ScenegraphItemVO.MESH );
				case( item is MaterialVO ):
					return new ScenegraphItemVO( item.name, item, ScenegraphItemVO.MATERIAL );
				case( item is ContainerVO ):
					return new ScenegraphItemVO( item.name, item, ScenegraphItemVO.CONTAINER );
				case( item is BitmapTextureVO ):
					return new ScenegraphItemVO( "Texture (" + item.name.split("/").pop() +")", item, ScenegraphItemVO.TEXTURE );
				case( item is LightVO ):
					return new ScenegraphItemVO( item.name, item, ScenegraphItemVO.LIGHT );
				case( item is MeshVO ):
					return new ScenegraphItemVO( item.name, item );
				default:
					return new ScenegraphItemVO( item.name, item );
			}
		}
		
	}
}