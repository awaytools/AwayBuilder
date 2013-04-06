package awaybuilder.utils
{
	import away3d.animators.AnimationSetBase;
	import away3d.animators.data.Skeleton;
	import away3d.animators.data.SkeletonPose;
	import away3d.animators.nodes.AnimationNodeBase;
	import away3d.animators.states.AnimationStateBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.ISubGeometry;
	import away3d.core.base.SkinnedSubGeometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubGeometryBase;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;
	
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SubGeometryVO;
	import awaybuilder.model.vo.scene.TextureVO;

	public class AssetFactory
	{
		public static function CreateAsset( item:Object, itemType:String=null ):AssetVO
		{
			if( !item ) return null;
			switch( true ) 
			{
				case( item is Mesh ):
					return new MeshVO( item as Mesh );
					
				case( item is Entity ):
					return new ContainerVO( item as ObjectContainer3D );
					
				case( item is ObjectContainer3D ):
					return new ContainerVO( item as ObjectContainer3D );
					
				case( item is TextureMaterial ):
					return new MaterialVO( item as SinglePassMaterialBase );
				
				case( item is ColorMaterial ):
					return new MaterialVO( item as SinglePassMaterialBase );
					
				case( item is BitmapTexture ):
					return new TextureVO( item as BitmapTexture );
					
				case( item is Geometry ):
					return new GeometryVO( item as Geometry );
					
				case( item is AnimationNodeBase ):
					return new AnimationNodeVO( item as AnimationNodeBase );
				
				case( item is AnimationSetBase ):
					return new AssetVO( "Animation Set (" + item.name +")",item );
					
				case( item is AnimationStateBase ):
					return new AssetVO( "Animation State" ,item );
					
				case( item is SkeletonPose ):
					return new AssetVO( "Skeleton Pose (" + item.name +")", item );
					
				case( item is Skeleton ):
					return new SkeletonVO( item as Skeleton );
			}
			trace( item +" " + itemType + " has no VO" );
			return new AssetVO( item.name, item );
		}
	}
}