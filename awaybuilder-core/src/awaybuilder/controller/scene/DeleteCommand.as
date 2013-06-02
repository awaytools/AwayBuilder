package awaybuilder.controller.scene
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.TextureProjector;
	import away3d.lights.LightBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.MultiPassMaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.primitives.SkyBox;
	import away3d.textures.Texture2DBase;
	
	import awaybuilder.controller.events.DocumentModelEvent;
	import awaybuilder.controller.history.HistoryCommandBase;
	import awaybuilder.controller.scene.events.SceneEvent;
	import awaybuilder.model.AssetsModel;
	import awaybuilder.model.vo.DeleteStateVO;
	import awaybuilder.model.vo.scene.AnimationNodeVO;
	import awaybuilder.model.vo.scene.AnimationSetVO;
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.CameraVO;
	import awaybuilder.model.vo.scene.ContainerVO;
	import awaybuilder.model.vo.scene.CubeTextureVO;
	import awaybuilder.model.vo.scene.EffectMethodVO;
	import awaybuilder.model.vo.scene.GeometryVO;
	import awaybuilder.model.vo.scene.LightPickerVO;
	import awaybuilder.model.vo.scene.LightVO;
	import awaybuilder.model.vo.scene.MaterialVO;
	import awaybuilder.model.vo.scene.MeshVO;
	import awaybuilder.model.vo.scene.ObjectVO;
	import awaybuilder.model.vo.scene.ShadowMethodVO;
	import awaybuilder.model.vo.scene.SkeletonVO;
	import awaybuilder.model.vo.scene.SkyBoxVO;
	import awaybuilder.model.vo.scene.TextureProjectorVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.utils.scene.Scene3DManager;
	
	import mx.collections.ArrayCollection;

	public class DeleteCommand extends HistoryCommandBase
	{
		[Inject]
		public var event:SceneEvent;
		
		[Inject]
		public var assets:AssetsModel;
		
		override public function execute():void
		{
			if( event.isUndoAction )
			{
				undo( event.oldValue as Vector.<DeleteStateVO> ); 
				return;
			}
			
			for each( var state:DeleteStateVO in event.newValue as Vector.<DeleteStateVO> ) {
				if( state.owner )
				{
					removeItemFromHolder( state.owner, state.asset );
				}
				else
				{
					var obj:ObjectVO = state.asset as ObjectVO;
					if( obj )
					{
						removeObjectFromScene( obj );
					}
					var library:ArrayCollection = document.getLibraryByAsset(state.asset);
					removeAsset( library, state.asset );
					
					var light:LightVO = state.asset as LightVO;
					if( light ) 
					{
						removeAsset( document.lights, state.asset );
					}
					
				}
			}
			
			commitHistoryEvent( event );
		}
		
		private function undo( states:Vector.<DeleteStateVO> ):void
		{
			for each( var state:DeleteStateVO in states ) {
				if( state.owner )
				{
					addItemToHolder( state.owner, state.asset );
				}
				else
				{
					
					var obj:ObjectVO = state.asset as ObjectVO;
					if( obj )
					{
						addObjectToScene( obj );
					}
					var library:ArrayCollection = document.getLibraryByAsset(state.asset);
					library.addItemAt( state.asset, state.index );
					
					var light:LightVO = state.asset as LightVO;
					if( light ) 
					{
						document.lights.addItemAt( state.asset, state.index );
					}
				}
			}
			
			commitHistoryEvent( event );
		}
		
		private function removeItemFromHolder( holder:AssetVO, asset:AssetVO ):void
		{
			var container:ContainerVO = holder as ContainerVO;
			if( container )
			{
				removeAsset( container.children, asset );
				var obj:ObjectContainer3D = assets.GetObject( container ) as ObjectContainer3D;
				obj.removeChild( assets.GetObject( asset ) as ObjectContainer3D );
			}
			var lightVO:LightVO = holder as LightVO;
			if( lightVO )
			{
				removeAsset( lightVO.shadowMethods, asset );
				
			}
			var lightPickerVO:LightPickerVO = holder as LightPickerVO;
			if( lightPickerVO )
			{
				removeAsset( lightPickerVO.lights, asset );
				applyLightPicker( lightPickerVO );
			}
			var materialVO:MaterialVO = holder as MaterialVO;
			if( materialVO )
			{
				if( asset is LightVO )
				{
					materialVO.light = null;
				}
				else if( asset is ShadowMethodVO )
				{
					materialVO.shadowMethod = null;
				}
			}
		}
		
		private function addItemToHolder( holder:AssetVO, asset:AssetVO, index:uint = 0 ):void
		{
			var container:ContainerVO = holder as ContainerVO;
			if( container )
			{
				container.children.addItemAt( asset, index );
				var obj:ObjectContainer3D = assets.GetObject( container ) as ObjectContainer3D;
				obj.addChild( assets.GetObject( asset ) as ObjectContainer3D );
			}
			var lightVO:LightVO = holder as LightVO;
			if( lightVO )
			{
				lightVO.shadowMethods.addItemAt( asset, index );
			}
			var lightPickerVO:LightPickerVO = holder as LightPickerVO;
			if( lightPickerVO )
			{
				lightPickerVO.lights.addItemAt( asset, index );
				applyLightPicker( lightPickerVO );
			}
			var materialVO:MaterialVO = holder as MaterialVO;
			if( materialVO )
			{
				if( asset is LightVO )
				{
					materialVO.light = asset as LightVO;
				}
				else if( asset is ShadowMethodVO )
				{
					materialVO.shadowMethod = asset as ShadowMethodVO;
				}
			}
		}
		
		public function removeAsset( source:ArrayCollection, oddItem:AssetVO ):void
		{
			for (var i:int = 0; i < source.length; i++) 
			{
				if( source[i].id == oddItem.id )
				{
					source.removeItemAt( i );
					i--;
				}
			}
		}
		
		private function addObjectToScene( asset:ObjectVO ):void
		{
			if( asset is MeshVO ) 
			{
				Scene3DManager.addObject( assets.GetObject(asset) as Mesh );
			}
			else if( asset is TextureProjectorVO ) 
			{
				Scene3DManager.addTextureProjector( assets.GetObject(asset) as TextureProjector );
			}
			else if( asset is ContainerVO ) 
			{
				Scene3DManager.addObject( assets.GetObject(asset) as ObjectContainer3D );
			}
			else if( asset is LightVO ) 
			{
				Scene3DManager.addLight( assets.GetObject(asset) as LightBase );
			}
			else if( asset is SkyBoxVO ) 
			{
				Scene3DManager.addSkybox( assets.GetObject(asset) as SkyBox );
			}
			else if( asset is CameraVO ) 
			{
				Scene3DManager.addCamera( assets.GetObject(asset) as Camera3D );
			}
		}
		
		private function removeObjectFromScene( asset:ObjectVO ):void
		{
			if( asset is MeshVO ) 
			{
				Scene3DManager.removeMesh( assets.GetObject(asset) as Mesh );
			}
			else if( asset is TextureProjectorVO ) 
			{
				Scene3DManager.removeTextureProjector( assets.GetObject(asset) as TextureProjector );
			}
			else if( asset is ContainerVO ) 
			{
				Scene3DManager.removeContainer( assets.GetObject(asset) as ObjectContainer3D );
			}
			else if( asset is LightVO ) 
			{
				try 
				{
					Scene3DManager.removeLight( assets.GetObject(asset) as LightBase );
				}
				catch ( e:Error )
				{
					trace( e.message );
				}
			}
			else if( asset is SkyBoxVO ) 
			{
				Scene3DManager.removeSkyBox( assets.GetObject(asset) as SkyBox );
			}
			else if( asset is CameraVO ) 
			{
				Scene3DManager.removeCamera( assets.GetObject(asset) as Camera3D );
			}

		}
		
		// Copied from CoreEditorMediator
		// TODO: Separate code
		
		private function applyLightPicker( asset:LightPickerVO ):void
		{
			var picker:StaticLightPicker = assets.GetObject( asset ) as StaticLightPicker;
			var lights:Array = [];
			for each( var light:LightVO in asset.lights )
			{
				lights.push( assets.GetObject(light) );
			}
			picker.lights = lights;
		}
		private function applyMaterial( asset:MaterialVO ):void
		{
			var m:MaterialBase = MaterialBase( assets.GetObject(asset) );
			var classType:Class;
			
			m.alphaPremultiplied = asset.alphaPremultiplied;
			m.repeat = asset.repeat;
			m.bothSides = asset.bothSides;
			m.extra = asset.extra;
			
			m.lightPicker = assets.GetObject(asset.lightPicker) as LightPickerBase;
			m.mipmap = asset.mipmap;
			m.smooth = asset.smooth;
			m.blendMode = asset.blendMode;
			
			var effect:EffectMethodVO;
			var singlePassMaterialBase:SinglePassMaterialBase = m as SinglePassMaterialBase;
			if( singlePassMaterialBase ) 
			{
				singlePassMaterialBase.diffuseMethod = assets.GetObject(asset.diffuseMethod) as BasicDiffuseMethod;
				singlePassMaterialBase.ambientMethod = assets.GetObject(asset.ambientMethod) as BasicAmbientMethod;
				singlePassMaterialBase.normalMethod = assets.GetObject(asset.normalMethod) as BasicNormalMethod;
				singlePassMaterialBase.specularMethod = assets.GetObject(asset.specularMethod) as BasicSpecularMethod;
				
				if( m is ColorMaterial )
				{
					var colorMaterial:ColorMaterial = m as ColorMaterial;
					colorMaterial.color = asset.diffuseColor;
					colorMaterial.alpha = asset.alpha;
					colorMaterial.shadowMethod = assets.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
					colorMaterial.normalMap = assets.GetObject(asset.normalTexture) as Texture2DBase;
					colorMaterial.specularMap = assets.GetObject(asset.specularTexture) as Texture2DBase;
					//					colorMaterial.ambientTexture = assets.GetObject(asset.ambientTexture) as Texture2DBase;
					colorMaterial.ambient = asset.ambientLevel;
					colorMaterial.ambientColor = asset.ambientColor;
					colorMaterial.specular = asset.specularLevel;
					colorMaterial.specularColor = asset.specularColor;
					colorMaterial.gloss = asset.specularGloss;
				}
				else if( m is TextureMaterial )
				{
					var textureMaterial:TextureMaterial = m as TextureMaterial;
					textureMaterial.shadowMethod = assets.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
					textureMaterial.texture = assets.GetObject(asset.diffuseTexture) as Texture2DBase;
					textureMaterial.alpha = asset.alpha;
					textureMaterial.normalMap = assets.GetObject(asset.normalTexture) as Texture2DBase;
					textureMaterial.specularMap = assets.GetObject(asset.specularTexture) as Texture2DBase;
					textureMaterial.ambientTexture = assets.GetObject(asset.ambientTexture) as Texture2DBase;
					textureMaterial.ambient = asset.ambientLevel;
					textureMaterial.ambientColor = asset.ambientColor;
					textureMaterial.specular = asset.specularLevel;
					textureMaterial.specularColor = asset.specularColor;
					textureMaterial.gloss = asset.specularGloss;
				}
				
				var i:int;
				singlePassMaterialBase.alphaThreshold = asset.alphaThreshold;
				while( singlePassMaterialBase.numMethods )
				{
					singlePassMaterialBase.removeMethod(singlePassMaterialBase.getMethodAt(0));
				}
				for each( effect in asset.effectMethods )
				{
					singlePassMaterialBase.addMethod(assets.GetObject( effect ) as EffectMethodBase);
				}
				
			}
			var multiPassMaterialBase:MultiPassMaterialBase = m as MultiPassMaterialBase;
			if( multiPassMaterialBase ) 
			{
				multiPassMaterialBase.diffuseMethod = assets.GetObject(asset.diffuseMethod) as BasicDiffuseMethod;
				multiPassMaterialBase.ambientMethod = assets.GetObject(asset.ambientMethod) as BasicAmbientMethod;
				multiPassMaterialBase.normalMethod = assets.GetObject(asset.normalMethod) as BasicNormalMethod;
				multiPassMaterialBase.specularMethod = assets.GetObject(asset.specularMethod) as BasicSpecularMethod;
				
				if( m is ColorMultiPassMaterial )
				{
					var colorMultiPassMaterial:ColorMultiPassMaterial = m as ColorMultiPassMaterial;
					colorMultiPassMaterial.color = asset.diffuseColor;
					colorMultiPassMaterial.shadowMethod = assets.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
					colorMultiPassMaterial.normalMap = assets.GetObject(asset.normalTexture) as Texture2DBase;
					colorMultiPassMaterial.specularMap = assets.GetObject(asset.specularTexture) as Texture2DBase;
					//					colorMultiPassMaterial.ambientTexture = assets.GetObject(asset.ambientTexture) as Texture2DBase;
					colorMultiPassMaterial.ambient = asset.ambientLevel;
					colorMultiPassMaterial.ambientColor = asset.ambientColor;
					colorMultiPassMaterial.specular = asset.specularLevel;
					colorMultiPassMaterial.specularColor = asset.specularColor;
					colorMultiPassMaterial.gloss = asset.specularGloss;
					
				}
				else if( m is TextureMultiPassMaterial )
				{
					var textureMultiPassMaterial:TextureMultiPassMaterial = m as TextureMultiPassMaterial;
					
					textureMultiPassMaterial.shadowMethod = assets.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
					textureMultiPassMaterial.texture = assets.GetObject(asset.diffuseTexture) as Texture2DBase;
					
					//					textureMultiPassMaterial.alpha = asset.alpha;
					textureMultiPassMaterial.normalMap = assets.GetObject(asset.normalTexture) as Texture2DBase;
					textureMultiPassMaterial.specularMap = assets.GetObject(asset.specularTexture) as Texture2DBase;
					textureMultiPassMaterial.ambientTexture = assets.GetObject(asset.ambientTexture) as Texture2DBase;
					textureMultiPassMaterial.ambient = asset.ambientLevel;
					textureMultiPassMaterial.ambientColor = asset.ambientColor;
					textureMultiPassMaterial.specular = asset.specularLevel;
					textureMultiPassMaterial.specularColor = asset.specularColor;
					textureMultiPassMaterial.gloss = asset.specularGloss;
				}
				
				multiPassMaterialBase.alphaThreshold = asset.alphaThreshold;
				while( multiPassMaterialBase.numMethods )
				{
					multiPassMaterialBase.removeMethod(multiPassMaterialBase.getMethodAt(0));
				}
				for each( effect in asset.effectMethods )
				{
					multiPassMaterialBase.addMethod(assets.GetObject( effect ) as EffectMethodBase);
				}
				
			}
			
			
		}
	}
}