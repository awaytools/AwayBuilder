package awaybuilder.view.mediators
{
    import away3d.containers.ObjectContainer3D;
    import away3d.core.base.Geometry;
    import away3d.core.base.Object3D;
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.library.assets.NamedAssetBase;
    import away3d.lights.DirectionalLight;
    import away3d.lights.LightBase;
    import away3d.lights.PointLight;
    import away3d.lights.shadowmaps.CascadeShadowMapper;
    import away3d.lights.shadowmaps.CubeMapShadowMapper;
    import away3d.lights.shadowmaps.DirectionalShadowMapper;
    import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
    import away3d.lights.shadowmaps.ShadowMapperBase;
    import away3d.materials.ColorMaterial;
    import away3d.materials.ColorMultiPassMaterial;
    import away3d.materials.MaterialBase;
    import away3d.materials.MultiPassMaterialBase;
    import away3d.materials.SinglePassMaterialBase;
    import away3d.materials.SkyBoxMaterial;
    import away3d.materials.TextureMaterial;
    import away3d.materials.TextureMultiPassMaterial;
    import away3d.materials.lightpickers.LightPickerBase;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.AlphaMaskMethod;
    import away3d.materials.methods.BasicAmbientMethod;
    import away3d.materials.methods.BasicDiffuseMethod;
    import away3d.materials.methods.BasicNormalMethod;
    import away3d.materials.methods.BasicSpecularMethod;
    import away3d.materials.methods.CascadeShadowMapMethod;
    import away3d.materials.methods.CelDiffuseMethod;
    import away3d.materials.methods.CelSpecularMethod;
    import away3d.materials.methods.ColorMatrixMethod;
    import away3d.materials.methods.ColorTransformMethod;
    import away3d.materials.methods.DitheredShadowMapMethod;
    import away3d.materials.methods.EffectMethodBase;
    import away3d.materials.methods.EnvMapAmbientMethod;
    import away3d.materials.methods.EnvMapMethod;
    import away3d.materials.methods.FilteredShadowMapMethod;
    import away3d.materials.methods.FogMethod;
    import away3d.materials.methods.FresnelEnvMapMethod;
    import away3d.materials.methods.FresnelSpecularMethod;
    import away3d.materials.methods.GradientDiffuseMethod;
    import away3d.materials.methods.HardShadowMapMethod;
    import away3d.materials.methods.HeightMapNormalMethod;
    import away3d.materials.methods.LightMapDiffuseMethod;
    import away3d.materials.methods.LightMapMethod;
    import away3d.materials.methods.NearShadowMapMethod;
    import away3d.materials.methods.OutlineMethod;
    import away3d.materials.methods.ProjectiveTextureMethod;
    import away3d.materials.methods.RefractionEnvMapMethod;
    import away3d.materials.methods.RimLightMethod;
    import away3d.materials.methods.ShadingMethodBase;
    import away3d.materials.methods.ShadowMapMethodBase;
    import away3d.materials.methods.SimpleShadowMapMethodBase;
    import away3d.materials.methods.SimpleWaterNormalMethod;
    import away3d.materials.methods.SoftShadowMapMethod;
    import away3d.materials.methods.SubsurfaceScatteringDiffuseMethod;
    import away3d.materials.methods.WrapDiffuseMethod;
    import away3d.primitives.CubeGeometry;
    import away3d.primitives.SkyBox;
    import away3d.primitives.SphereGeometry;
    import away3d.textures.BitmapCubeTexture;
    import away3d.textures.BitmapTexture;
    import away3d.textures.CubeTextureBase;
    import away3d.textures.Texture2DBase;
    
    import awaybuilder.controller.events.SceneReadyEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.AssetsModel;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.ScenegraphGroupItemVO;
    import awaybuilder.model.vo.ScenegraphItemVO;
    import awaybuilder.model.vo.scene.AssetVO;
    import awaybuilder.model.vo.scene.ContainerVO;
    import awaybuilder.model.vo.scene.CubeTextureVO;
    import awaybuilder.model.vo.scene.EffectMethodVO;
    import awaybuilder.model.vo.scene.ExtraItemVO;
    import awaybuilder.model.vo.scene.GeometryVO;
    import awaybuilder.model.vo.scene.LightPickerVO;
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ObjectVO;
    import awaybuilder.model.vo.scene.ShadingMethodVO;
    import awaybuilder.model.vo.scene.ShadowMapperVO;
    import awaybuilder.model.vo.scene.ShadowMethodVO;
    import awaybuilder.model.vo.scene.SkyBoxVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.model.vo.scene.TextureVO;
    import awaybuilder.utils.scene.CameraManager;
    import awaybuilder.utils.scene.Scene3DManager;
    import awaybuilder.utils.scene.modes.CameraMode;
    import awaybuilder.utils.scene.modes.GizmoMode;
    import awaybuilder.view.components.CoreEditor;
    import awaybuilder.view.components.events.CoreEditorEvent;
    import awaybuilder.view.scene.controls.ContainerGizmo3D;
    import awaybuilder.view.scene.controls.LightGizmo3D;
    import awaybuilder.view.scene.events.Scene3DManagerEvent;
    
    import flash.display.BitmapData;
    import flash.display3D.textures.Texture;
    import flash.display3D.textures.TextureBase;
    import flash.events.ErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.controls.Text;
    import mx.core.FlexGlobals;
    
    import org.robotlegs.mvcs.Mediator;
    
    import spark.collections.Sort;

    public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var assets:AssetsModel;
		
		[Inject]
		public var document:DocumentModel;
		
		private var _scenegraphSort:Sort = new Sort();
		private var _scenegraph:ArrayCollection;
		private var _scenegraphSelected:Vector.<Object>;
		
		override public function onRegister():void
		{
			FlexGlobals.topLevelApplication.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			
			addContextListener(SceneEvent.TRANSLATE_OBJECT, eventDispatcher_translateHandler);
			addContextListener(SceneEvent.SCALE_OBJECT, eventDispatcher_translateHandler);
			addContextListener(SceneEvent.ROTATE_OBJECT, eventDispatcher_translateHandler);
			addContextListener(SceneEvent.CHANGE_MESH, eventDispatcher_changeMeshHandler);
			addContextListener(SceneEvent.CHANGE_LIGHT, eventDispatcher_changeLightHandler);
			addContextListener(SceneEvent.CHANGE_MATERIAL, eventDispatcher_changeMaterialHandler);
			addContextListener(SceneEvent.CHANGE_LIGHTPICKER, eventDispatcher_changeLightPickerHandler);
			addContextListener(SceneEvent.CHANGE_CONTAINER, eventDispatcher_changeContainerHandler);
			addContextListener(SceneEvent.CHANGE_SHADOW_METHOD, eventDispatcher_changeShadowMethodHandler);
			addContextListener(SceneEvent.CHANGE_SHADING_METHOD, eventDispatcher_changeShadingMethodHandler);
			addContextListener(SceneEvent.CHANGE_EFFECT_METHOD, eventDispatcher_changeEffectMethodHandler);
			addContextListener(SceneEvent.CHANGE_SHADOW_MAPPER, eventDispatcher_changeShadowMapperHandler);
			addContextListener(SceneEvent.CHANGE_CUBE_TEXTURE, eventDispatcher_changeCubeTextureHandler);
			addContextListener(SceneEvent.CHANGE_TEXTURE, eventDispatcher_changeTextureHandler);
			addContextListener(SceneEvent.CHANGE_GEOMETRY, eventDispatcher_changeGeometryHandler);
			addContextListener(SceneEvent.CHANGE_SKYBOX, eventDispatcher_changeSkyboxHandler);
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_CUBE_TEXTURE, eventDispatcher_addNewCubeTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_addNewMaterialToSubmeshHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHTPICKER, eventDispatcher_addNewLightpickerToMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_SHADOW_METHOD, eventDispatcher_addNewShadowMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_EFFECT_METHOD, eventDispatcher_addNewEffectMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHT, eventDispatcher_addNewLightHandler);
			
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.READY, scene_readyHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.MESH_SELECTED, scene_meshSelectedHandler);
            Scene3DManager.instance.addEventListener(Scene3DManagerEvent.MESH_SELECTED_FROM_VIEW, scene_meshSelectedFromViewHandler);
            Scene3DManager.instance.addEventListener(Scene3DManagerEvent.TRANSFORM, scene_transformHandler);
            Scene3DManager.instance.addEventListener(Scene3DManagerEvent.TRANSFORM_RELEASE, scene_transformReleaseHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.ZOOM_DISTANCE_DELTA, eventDispatcher_zoomDistanceDeltaHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.ZOOM_TO_DISTANCE, eventDispatcher_zoomToDistanceHandler);
			Scene3DManager.init( view.viewScope );
			
            addContextListener(SceneEvent.SELECT, eventDispatcher_itemsSelectHandler);
            addContextListener(SceneEvent.FOCUS_SELECTION, eventDispatcher_itemsFocusHandler);

			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			view.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);	
		}
		
		//----------------------------------------------------------------------
		//
		//	view handlers
		//
		//----------------------------------------------------------------------
		
		private function view_treeChangeHandler(event:CoreEditorEvent):void
		{
			var items:Array = [];
			var selectedItems:Vector.<Object> = event.data as Vector.<Object>;
			for (var i:int=0;i<selectedItems.length;i++)
			{
                var groupItem:ScenegraphGroupItemVO = selectedItems[i] as ScenegraphGroupItemVO;
                if( groupItem ) {
                     continue;
                }
				items.push(ScenegraphItemVO(selectedItems[i]).item);
			}

			this.dispatch(new SceneEvent(SceneEvent.SELECT,items));
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ALTERNATE) CameraManager.panning = true;		
			
			switch (e.keyCode) 
			{
                case Keyboard.W:
                case Keyboard.UP:
					CameraManager.moveForward(CameraManager.speed);
					e.stopImmediatePropagation();
					break;
                case Keyboard.S:
				case Keyboard.DOWN: 
					CameraManager.moveBackward(CameraManager.speed);
					e.stopImmediatePropagation();
					break;
                case Keyboard.A:
				case Keyboard.LEFT: 
					CameraManager.moveLeft(CameraManager.speed);
					e.stopImmediatePropagation();
					break;
                case Keyboard.D:
				case Keyboard.RIGHT: 
					CameraManager.moveRight(CameraManager.speed);
					e.stopImmediatePropagation();
					break;
				case Keyboard.SHIFT: 
					CameraManager.running = true;
					e.stopImmediatePropagation();
					break;
				case Keyboard.F: 
					if (Scene3DManager.selectedObject != null) 
					{
						CameraManager.focusTarget(Scene3DManager.selectedObject);
					}
					e.stopImmediatePropagation();
					break;
				case Keyboard.CONTROL:
					Scene3DManager.multiSelection = true;
					e.stopImmediatePropagation();
					break;	
				
			}				
		}
		
		private function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ALTERNATE) CameraManager.panning = false;
			
			switch (e.keyCode) 
			{
                case Keyboard.W:
                case Keyboard.S:
				case Keyboard.UP: 
				case Keyboard.DOWN: 
					CameraManager.moveForward(0);
					e.stopImmediatePropagation();
					break;
                case Keyboard.A:
                case Keyboard.D:
				case Keyboard.LEFT: 
				case Keyboard.RIGHT: 
					CameraManager.moveLeft(0);
					e.stopImmediatePropagation();
					break;
				case Keyboard.SHIFT: 
					CameraManager.running = false;
					e.stopImmediatePropagation();
					break;
				case Keyboard.CONTROL:
					Scene3DManager.multiSelection = false;
					e.stopImmediatePropagation();
					break;
			}				
			
		}	
		
		private function getBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var o:AssetVO in objects )
			{
				children.addItem( new ScenegraphItemVO( o.name, o ) );
			}
			return children;
		}
		private function getTextureBranchCildren( objects:ArrayCollection ):ArrayCollection
		{
			var children:ArrayCollection = new ArrayCollection();
			for each( var o:AssetVO in objects )
			{
				children.addItem( new ScenegraphItemVO( "Texture (" + o.name.split("/").pop() +")", o ) );
			}
			return children;
		}
		
		private function compareGroupItems( a:Object, b:Object, fields:Array=null ):int
		{
			var group1:ScenegraphGroupItemVO = a as ScenegraphGroupItemVO;
			var group2:ScenegraphGroupItemVO = b as ScenegraphGroupItemVO;
			if (group1 == null && group2 == null) return 0;
			if (group1 == null)	return 1;
			if (group2 == null)	return -1;
			if (group1.weight < group2.weight) return -1;
			if (group1.weight > group2.weight) return 1;
			return 0;
		}
		
		//----------------------------------------------------------------------
		//
		//	context handlers
		//
		//----------------------------------------------------------------------
		
		private function eventDispatcher_translateHandler(event:SceneEvent):void
		{
			var object:ObjectVO = event.items[0] as ObjectVO;
			if( object ) 
			{
				applyObject( object );
			}
			
			Scene3DManager.updateDefaultCameraFarPlane();
		}
		
		private function applySkyBox( asset:SkyBoxVO ):void
		{
			var obj:SkyBox = assets.GetObject( asset ) as SkyBox;
			SkyBoxMaterial(obj.material).cubeMap = assets.GetObject(asset.cubeMap) as CubeTextureBase;
			obj.name = asset.name;
		}
		private function applyEffectMethod( asset:EffectMethodVO ):void
		{
			var obj:EffectMethodBase = assets.GetObject( asset ) as EffectMethodBase;
			applyName( obj, asset );
			if( obj is ColorMatrixMethod )
			{
				var colorMatrixMethod:ColorMatrixMethod = obj as ColorMatrixMethod;
				colorMatrixMethod.colorMatrix = [ asset.r, asset.g, asset.b, asset.a, asset.rO, asset.rG, asset.gG, asset.bG, asset.aG, asset.gO,  asset.rB, asset.gB, asset.bB, asset.aB, asset.bO, asset.rA, asset.gA, asset.bA, asset.aA, asset.aO,];
			}
			else if( obj is FogMethod )
			{
				var fogMethod:FogMethod = obj as FogMethod;
				fogMethod.fogColor = asset.color;
				fogMethod.minDistance = asset.minDistance;
				fogMethod.maxDistance = asset.maxDistance;
			}
			else if( obj is AlphaMaskMethod )
			{
				var alphaMaskMethod:AlphaMaskMethod = obj as AlphaMaskMethod;
				alphaMaskMethod.texture = assets.GetObject( asset.texture ) as Texture2DBase;
				alphaMaskMethod.useSecondaryUV = asset.useSecondaryUV;
			}
			else if( obj is ColorTransformMethod )
			{
				var colorTransformMethod:ColorTransformMethod = obj as ColorTransformMethod;
				colorTransformMethod.colorTransform = new ColorTransform( asset.r, asset.g, asset.b, asset.a, asset.rO, asset.gO, asset.bO, asset.aO );
			}
			else if( obj is EnvMapMethod )
			{
				var envMapMethod:EnvMapMethod = obj as EnvMapMethod;
				envMapMethod.mask = assets.GetObject( asset.texture ) as Texture2DBase;
				envMapMethod.alpha = asset.alpha;
				envMapMethod.envMap = assets.GetObject( asset.cubeTexture ) as CubeTextureBase;
			}
			else if( obj is FresnelEnvMapMethod )
			{
				var fresnelEnvMapMethod:FresnelEnvMapMethod = obj as FresnelEnvMapMethod;
				fresnelEnvMapMethod.envMap = assets.GetObject( asset.cubeTexture ) as CubeTextureBase;
				fresnelEnvMapMethod.alpha = asset.alpha;
			}
			else if( obj is LightMapMethod )
			{
				var lightMapMethod:LightMapMethod = obj as LightMapMethod;
				lightMapMethod.texture = assets.GetObject( asset.texture ) as Texture2DBase;
//				lightMapMethod.useSecondaryUV = assets.useSecondaryUV;
				lightMapMethod.blendMode = asset.mode;
			}
			else if( obj is OutlineMethod )
			{
				var outlineMethod:OutlineMethod = obj as OutlineMethod;
				outlineMethod.outlineColor = asset.color;
				outlineMethod.showInnerLines = asset.showInnerLines;
				outlineMethod.outlineSize = asset.size;
//				outlineMethod.dedicatedMeshes
			}
			else if( obj is ProjectiveTextureMethod )
			{
				var projectiveTextureMethod:ProjectiveTextureMethod = obj as ProjectiveTextureMethod;
			}
			else if( obj is RefractionEnvMapMethod )
			{
				var refractionEnvMapMethod:RefractionEnvMapMethod = obj as RefractionEnvMapMethod;
				refractionEnvMapMethod.envMap = assets.GetObject( asset.cubeTexture ) as CubeTextureBase;
				refractionEnvMapMethod.dispersionR = asset.r;
				refractionEnvMapMethod.dispersionG = asset.g;
				refractionEnvMapMethod.dispersionB = asset.b;
				refractionEnvMapMethod.refractionIndex = asset.refraction;
				refractionEnvMapMethod.alpha = asset.alpha;
			}
			else if( obj is RimLightMethod )
			{
				var rimLightMethod:RimLightMethod = obj as RimLightMethod;
				rimLightMethod.color = asset.color;
				rimLightMethod.power = asset.power;
				rimLightMethod.strength = asset.strength;
			}
		}
		
		private function applyShadingMethod( asset:ShadingMethodVO ):void
		{
			var obj:ShadingMethodBase = assets.GetObject( asset ) as ShadingMethodBase;
			switch( true ) 
			{	
				case(obj is EnvMapAmbientMethod):
				{
					var envMapAmbientMethod:EnvMapAmbientMethod = obj as EnvMapAmbientMethod;
					envMapAmbientMethod.envMap = assets.GetObject( asset.envMap ) as CubeTextureBase;
					break;
				}
				case(obj is GradientDiffuseMethod):
				{
					var gradientDiffuseMethod:GradientDiffuseMethod = obj as GradientDiffuseMethod;
					gradientDiffuseMethod.texture = assets.GetObject( asset.texture ) as Texture2DBase;
					break;
				}
				case(obj is WrapDiffuseMethod):
				{
					var wrapDiffuseMethod:WrapDiffuseMethod = obj as WrapDiffuseMethod;
					wrapDiffuseMethod.wrapFactor = asset.value;
					break;
				}
				case(obj is LightMapDiffuseMethod):
				{
					var lightMapDiffuseMethod:LightMapDiffuseMethod = obj as LightMapDiffuseMethod;
					lightMapDiffuseMethod.blendMode = asset.blendMode;
					lightMapDiffuseMethod.lightMapTexture = assets.GetObject( asset.texture ) as Texture2DBase;
					lightMapDiffuseMethod.baseMethod = assets.GetObject( asset.baseMethod ) as BasicDiffuseMethod;
					break;
				}
				case(obj is CelDiffuseMethod):
				{
					var celDiffuseMethod:CelDiffuseMethod = obj as CelDiffuseMethod;
					celDiffuseMethod.levels = asset.value;
					celDiffuseMethod.smoothness = asset.smoothness;
					celDiffuseMethod.baseMethod = assets.GetObject( asset.baseMethod ) as BasicDiffuseMethod;
					break;
				}
				case(obj is SubsurfaceScatteringDiffuseMethod):
				{
					var subsurfaceScatterDiffuseMethod:SubsurfaceScatteringDiffuseMethod = obj as SubsurfaceScatteringDiffuseMethod;
					subsurfaceScatterDiffuseMethod.scattering = asset.scattering;
					subsurfaceScatterDiffuseMethod.translucency = asset.translucency;
					subsurfaceScatterDiffuseMethod.baseMethod = assets.GetObject( asset.baseMethod ) as BasicDiffuseMethod;
					break;
				}
				case(obj is CelSpecularMethod):
				{
					var celSpecularMethod:CelSpecularMethod = obj as CelSpecularMethod;
					celSpecularMethod.specularCutOff = asset.value;
					celSpecularMethod.smoothness = asset.smoothness;
					celSpecularMethod.baseMethod = assets.GetObject( asset.baseMethod ) as BasicSpecularMethod;
					break;
				}
				case(obj is FresnelSpecularMethod):
				{
					var fresnelSpecularMethod:FresnelSpecularMethod = obj as FresnelSpecularMethod;
					fresnelSpecularMethod.basedOnSurface = asset.basedOnSurface;
					fresnelSpecularMethod.fresnelPower = asset.value;
					fresnelSpecularMethod.baseMethod = assets.GetObject( asset.baseMethod ) as BasicSpecularMethod;
					break;
				}
				case(obj is HeightMapNormalMethod):
				{
					var heightMapNormalMethod:HeightMapNormalMethod = obj as HeightMapNormalMethod;
					break;
				}
				case(obj is SimpleWaterNormalMethod):
				{
					var simpleWaterNormalMethod:SimpleWaterNormalMethod = obj as SimpleWaterNormalMethod;
					simpleWaterNormalMethod.normalMap = assets.GetObject( asset.texture ) as Texture2DBase;
					break;
				}
			}
		}
		private function applyShadowMethod( asset:ShadowMethodVO ):void
		{
			var obj:ShadowMapMethodBase = assets.GetObject( asset ) as ShadowMapMethodBase;
			applyName( obj, asset );
			if( obj is HardShadowMapMethod )
			{
				var hardShadowMapMethod:HardShadowMapMethod = obj as HardShadowMapMethod;
				hardShadowMapMethod.alpha = asset.alpha;
				hardShadowMapMethod.epsilon = asset.epsilon;
			}
			else if( obj is FilteredShadowMapMethod )
			{
				var filteredShadowMapMethod:FilteredShadowMapMethod = obj as FilteredShadowMapMethod;
				filteredShadowMapMethod.alpha = asset.alpha;
				filteredShadowMapMethod.epsilon = asset.epsilon;
			}
			else if( obj is SoftShadowMapMethod )
			{
				var softShadowMapMethod:SoftShadowMapMethod = obj as SoftShadowMapMethod;
				softShadowMapMethod.numSamples = asset.samples;
				softShadowMapMethod.range = asset.range;
				softShadowMapMethod.alpha = asset.alpha;
				softShadowMapMethod.epsilon = asset.epsilon;
			}
			else if( obj is DitheredShadowMapMethod )
			{
				var ditheredShadowMapMethod:DitheredShadowMapMethod = obj as DitheredShadowMapMethod;
				ditheredShadowMapMethod.numSamples = asset.samples;
				ditheredShadowMapMethod.range = asset.range;
				ditheredShadowMapMethod.alpha = asset.alpha;
				ditheredShadowMapMethod.epsilon = asset.epsilon;
			}
			else if( obj is CascadeShadowMapMethod )
			{
				var cascadeShadowMapMethod:CascadeShadowMapMethod = obj as CascadeShadowMapMethod;
				cascadeShadowMapMethod.baseMethod = assets.GetObject( asset.baseMethod ) as SimpleShadowMapMethodBase;
			}
			else if( obj is NearShadowMapMethod )
			{
				var nearShadowMapMethod:NearShadowMapMethod = obj as NearShadowMapMethod;
				nearShadowMapMethod.baseMethod = assets.GetObject( asset.baseMethod ) as SimpleShadowMapMethodBase;
			}
		}
		private function applyContainer( asset:ContainerVO ):void
		{
			var obj:ObjectContainer3D = assets.GetObject( asset ) as ObjectContainer3D;
			applyName( obj, asset );
			obj.pivotPoint = new Vector3D( asset.pivotX, asset.pivotY, asset.pivotZ );
			
			obj.extra = new Object();
			
			for each( var extra:ExtraItemVO in asset.extras )
			{
				obj.extra[extra.name] = extra.value;
			}
		}
		private function applyObject( asset:ObjectVO ):void
		{
			var o:Object3D = Object3D( assets.GetObject(asset) );
			o.name = asset.name;
			
			o.x = asset.x;
			o.y = asset.y;
			o.z = asset.z;
			
			o.scaleX = asset.scaleX;
			o.scaleY = asset.scaleY;
			o.scaleZ = asset.scaleZ;
			
			o.rotationX = asset.rotationX;
			o.rotationY = asset.rotationY;
			o.rotationZ = asset.rotationZ;
		}
		
		private function applyLight( asset:LightVO ):void
		{
			var light:LightBase = assets.GetObject( asset ) as LightBase;
			light.ambient = asset.ambient;
			light.ambientColor = asset.ambientColor;
			light.diffuse = asset.diffuse;
			light.color = asset.color;
			light.specular = asset.specular;
			
			if(  asset.shadowMapper )
			{
				light.shadowMapper = assets.GetObject( asset.shadowMapper ) as ShadowMapperBase;
			}
			
			applyObject( asset );
			if( asset.type == LightVO.DIRECTIONAL ) 
			{
				var dl:DirectionalLight = light as DirectionalLight;
				var y:Number = -Math.sin( asset.elevationAngle*Math.PI/180);
				var x:Number =  Math.sin(Math.PI/2 - asset.elevationAngle*Math.PI/180)*Math.sin( asset.azimuthAngle*Math.PI/180);
				var z:Number =  Math.sin(Math.PI/2 - asset.elevationAngle*Math.PI/180)*Math.cos( asset.azimuthAngle*Math.PI/180);
				dl.direction = new Vector3D( x, y, z);
			}
			else if( asset.type == LightVO.POINT ) 
			{
				var pointLight:PointLight = light as PointLight;
				pointLight.radius = asset.radius;
				pointLight.fallOff = asset.fallOff;
			}
			
		}
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
		
		private function applySubMesh( asset:SubMeshVO ):void
		{
			var submesh:SubMesh = SubMesh( assets.GetObject(asset) );
			submesh.material = MaterialBase( assets.GetObject(asset.material) );
		}
		private function applyMaterial( asset:MaterialVO ):void
		{
			var m:MaterialBase = MaterialBase( assets.GetObject(asset) );
			var classType:Class;
			var oldMaterial:MaterialBase;
			if( asset.diffuseTexture ) 
			{
				if( asset.type == MaterialVO.SINGLEPASS ) 
				{
					classType = TextureMaterial;
				}
				else
				{
					classType = TextureMultiPassMaterial;
				}
			}
			else 
			{
				if( asset.type == MaterialVO.SINGLEPASS ) 
				{
					classType = ColorMaterial;
				}
				else
				{
					classType = ColorMultiPassMaterial;
				}
			}
			if( !(m is classType) )
			{
				oldMaterial = m;
				m = new classType();
			}
			
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
//					colorMultiPassMaterial.alpha = asset.alpha;
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
			
			if( oldMaterial ) 
			{
				assets.ReplaceObject( oldMaterial, m );
				
				// TODO use document, not assets
				var subMeshes:Vector.<Object> = assets.GetObjectsByType( SubMesh, "material", oldMaterial ) as Vector.<Object>;
				for each(var obj:SubMesh in subMeshes)
				{
					obj.material = m;
					var vo:SubMeshVO = assets.GetAsset( obj ) as SubMeshVO;
					vo.material = assets.GetAsset( m ) as MaterialVO;
				}
			}
			
		}
		private function eventDispatcher_changeLightHandler(event:SceneEvent):void
		{
			for each( var asset:LightVO in event.items )
			{
				applyLight( asset );
			}
		}
		private function eventDispatcher_changeLightPickerHandler(event:SceneEvent):void
		{
			for each( var asset:LightPickerVO in event.items )
			{
				applyLightPicker( asset );
			}
		}
		
		private function eventDispatcher_changeMeshHandler(event:SceneEvent):void
		{
			for each( var item:MeshVO in event.items )
			{
				var obj:Mesh = assets.GetObject( item ) as Mesh;
				applyContainer( item );
				obj.castsShadows = item.castsShadows;
				obj.geometry = assets.GetObject( item.geometry ) as Geometry;
				
				for( var i:int = 0; i < obj.subMeshes.length; i++ )
				{
					assets.ReplaceObject( assets.GetObject( item.subMeshes.getItemAt(i) as AssetVO ), obj.subMeshes[i] );
				}
				for each( var sub:SubMeshVO in item.subMeshes )
				{
					applySubMesh( sub );
				}
			}
		}
		
		private function eventDispatcher_addNewLightHandler(event:SceneEvent):void
		{
			for each( var asset:LightPickerVO in event.items )
			{
				applyLightPicker( asset );
			}
		}
		private function eventDispatcher_addNewLightpickerToMaterialHandler(event:SceneEvent):void
		{
			for each( var asset:MaterialVO in event.items )
			{
				applyMaterial( asset );
			}
		}
		
		private function eventDispatcher_addNewShadowMethodHandler(event:SceneEvent):void
		{
			var asset:MaterialVO = event.items[0] as MaterialVO;
			if( asset ) 
			{
				applyMaterial( asset );
			}
		}
		private function eventDispatcher_addNewEffectMethodHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length ) {
				var asset:MaterialVO = event.items[0] as MaterialVO;
				if( asset ) 
				{
					applyMaterial( asset );
				}
			}
			
		}
		private function eventDispatcher_addNewMaterialToSubmeshHandler(event:SceneEvent):void
		{
			var asset:SubMeshVO = event.items[0] as SubMeshVO;
			if( asset ) 
			{
				applySubMesh( asset );
			}
		}
		
		private function eventDispatcher_addNewTextureHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length ) {
				if( event.items[0] is MaterialVO ) 
				{
					applyMaterial( event.items[0] as MaterialVO );
				}
				if( event.items[0] is EffectMethodVO ) 
				{
					applyEffectMethod( event.items[0] as EffectMethodVO );
				}
			}
		}
		private function eventDispatcher_addNewCubeTextureHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length ) {
				if( event.items[0] is EffectMethodVO ) 
				{
					applyEffectMethod( event.items[0] as EffectMethodVO );
				}
				else if( event.items[0] is ShadingMethodVO ) 
				{
					applyShadingMethod( event.items[0] as ShadingMethodVO );
				}
				else if( event.items[0] is SkyBoxVO ) 
				{
					applySkyBox( event.items[0] as SkyBoxVO );
				}
			}
		}
		
		private function eventDispatcher_changeContainerHandler(event:SceneEvent):void
		{
			var asset:ContainerVO = event.items[0] as ContainerVO;
			if( asset ) 
			{
				applyContainer( asset );
			}
		}
		
		private function eventDispatcher_changeEffectMethodHandler(event:SceneEvent):void
		{
			var asset:EffectMethodVO = event.items[0] as EffectMethodVO;
			if( asset ) 
			{
				applyEffectMethod( asset );
			}
		}
		
		private function eventDispatcher_changeSkyboxHandler(event:SceneEvent):void
		{
			var asset:SkyBoxVO = event.items[0] as SkyBoxVO;
			if( asset ) 
			{
				applySkyBox( asset );
			}
		}
		private function eventDispatcher_changeGeometryHandler(event:SceneEvent):void
		{
			var asset:GeometryVO = event.items[0] as GeometryVO;
			if( asset ) 
			{
				var obj:Geometry = assets.GetObject( asset ) as Geometry;
				obj.name = asset.name;
				if( obj is CubeGeometry )
				{
					var cubeGeometry:CubeGeometry = obj as CubeGeometry;
					cubeGeometry.width = asset.width;
					cubeGeometry.height = asset.height;
					cubeGeometry.depth = asset.depth;
					cubeGeometry.tile6 = asset.tile6;
					cubeGeometry.segmentsD = asset.segmentsD;
					cubeGeometry.segmentsH = asset.segmentsH;
					cubeGeometry.segmentsW = asset.segmentsW;
				}
				else if( obj is SphereGeometry )
				{
					var sphereGeometry:SphereGeometry = obj as SphereGeometry;
					sphereGeometry.radius = asset.radius;
					sphereGeometry.yUp = asset.yUp;
					sphereGeometry.segmentsW = asset.segmentsW;
					sphereGeometry.segmentsH = asset.segmentsH;
				}
			}
		}
		private function eventDispatcher_changeTextureHandler(event:SceneEvent):void
		{
			var asset:TextureVO = event.items[0] as TextureVO;
			if( asset ) 
			{
				var obj:BitmapTexture = assets.GetObject( asset ) as BitmapTexture;
				obj.name = asset.name;
				obj.bitmapData = asset.bitmapData;
			}
		}
		private function eventDispatcher_changeCubeTextureHandler(event:SceneEvent):void
		{
			var asset:CubeTextureVO = event.items[0] as CubeTextureVO;
			if( asset ) 
			{
				var obj:BitmapCubeTexture = assets.GetObject( asset ) as BitmapCubeTexture;
				
				var maxValue:Number = Math.max(asset.positiveX.width,Math.max(asset.negativeX.width,
																Math.max(asset.positiveY.width,
																Math.max(asset.negativeY.width,
																	Math.max(asset.positiveZ.width,asset.negativeZ.width)))));
				var matrix:Matrix = new Matrix ();
				var data:BitmapData;
				var k:Number
				
				k = maxValue/asset.positiveX.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.positiveX, matrix);
				obj.positiveX = data;
				
				k = maxValue/asset.negativeX.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.negativeX, matrix);
				obj.negativeX = data;
				
				k = maxValue/asset.positiveY.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.positiveY, matrix);
				obj.positiveY = data;
				
				k = maxValue/asset.negativeY.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.negativeY, matrix);
				obj.negativeY = data;
				
				k = maxValue/asset.positiveZ.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.positiveZ, matrix);
				obj.positiveZ = data;
				
				k = maxValue/asset.negativeZ.width;
				matrix = new Matrix();
				matrix.scale(k, k);
				data = new BitmapData(maxValue, maxValue);
				data.draw(asset.negativeZ, matrix);
				obj.negativeZ = data;
			}
		}
		private function eventDispatcher_changeShadowMapperHandler(event:SceneEvent):void
		{
			var asset:ShadowMapperVO = event.items[0] as ShadowMapperVO;
			if( asset ) 
			{
				var obj:ShadowMapperBase = assets.GetObject( asset ) as ShadowMapperBase;
				obj.depthMapSize = asset.depthMapSize;
				if( obj is NearDirectionalShadowMapper )
				{
					var nearDirectionalShadowMapper:NearDirectionalShadowMapper = obj as NearDirectionalShadowMapper;
					nearDirectionalShadowMapper.coverageRatio = asset.coverage;
				}
				else if( obj is CascadeShadowMapper )
				{
					var cascadeShadowMapper:CascadeShadowMapper = obj as CascadeShadowMapper;
					cascadeShadowMapper.numCascades = asset.numCascades;
				}
			}
		}
		private function eventDispatcher_changeShadingMethodHandler(event:SceneEvent):void
		{
			var asset:ShadingMethodVO = event.items[0] as ShadingMethodVO;
			if( asset ) 
			{
				applyShadingMethod( asset );
			}
		}
		private function eventDispatcher_changeShadowMethodHandler(event:SceneEvent):void
		{
			var asset:ShadowMethodVO = event.items[0] as ShadowMethodVO;
			if( asset ) 
			{
				applyShadowMethod( asset );
			}
		}
		
		private function eventDispatcher_changeMaterialHandler(event:SceneEvent):void
		{
			var material:MaterialVO = event.items[0] as MaterialVO;
			if( material ) 
			{
				applyMaterial( material );
			}
		}
		
		private function applyName( obj:Object, asset:AssetVO ):void 
		{
			var namedAssetBase:NamedAssetBase = obj as NamedAssetBase;
			if( namedAssetBase )
			{
				namedAssetBase.name = asset.name;
			}
		}
		private function eventDispatcher_itemsSelectHandler(event:SceneEvent):void
		{
			if( event.items.length )
			{
				if( event.items.length == 1 )
				{
					if( event.items[0] is MeshVO )
					{
						var mesh:MeshVO = event.items[0] as MeshVO;
						selectObjectsScene( assets.GetObject( mesh ) as Object3D );
					}
					else if( event.items[0] is ContainerVO)
					{
						var container:ContainerVO = event.items[0] as ContainerVO;
						selectContainersScene( assets.GetObject( container ) as ObjectContainer3D );
					}
					else if( event.items[0] is LightVO )
					{
						var light:LightVO = event.items[0] as LightVO;
						selectLightsScene( assets.GetObject( light ) as LightBase );
					}
					else {
                        Scene3DManager.unselectAll();
					}
				}
				else
				{
                    Scene3DManager.unselectAll();
				}
			}
			else
			{
                Scene3DManager.unselectAll();
			}
			
		}
		private function selectObjectsScene( o:Object3D ):void
		{
			for each( var object:Object3D in Scene3DManager.selectedObjects.source )
			{
				if( object == o )
				{
					return;
				}
			}
			Scene3DManager.selectObject(o.name);
			
		}
		private function selectContainersScene( c:ObjectContainer3D ):void
		{
			for each( var containerGizmo:ContainerGizmo3D in Scene3DManager.containerGizmos )
			{
				if( containerGizmo.container == c )
				{
					selectObjectsScene(containerGizmo.containerGizmo);
					return;
				}
			}
		}
		private function selectLightsScene( l:LightBase ):void
		{
			for each( var lightGizmo:LightGizmo3D in Scene3DManager.lightGizmos )
			{
				if( lightGizmo.light == l )
				{
					selectObjectsScene(lightGizmo.cone);
					return;
				}
			}
		}
        private function eventDispatcher_itemsFocusHandler(event:SceneEvent):void
        {
			if( CameraManager.mode == CameraMode.FREE )
			{
				this.dispatch(new SceneEvent(SceneEvent.SWITCH_CAMERA_TO_TARGET));
			}
            CameraManager.focusTarget( Scene3DManager.selectedObject );
        }
		
		private function eventDispatcher_zoomDistanceDeltaHandler(event:Scene3DManagerEvent):void
        {
            this.dispatch( new Scene3DManagerEvent( Scene3DManagerEvent.ZOOM_DISTANCE_DELTA, "", null, event.currentValue ) );
        }

		private function eventDispatcher_zoomToDistanceHandler(event:Scene3DManagerEvent):void
        {
            this.dispatch( new Scene3DManagerEvent( Scene3DManagerEvent.ZOOM_TO_DISTANCE, "", null, event.currentValue ) );
        }

		//----------------------------------------------------------------------
		//
		//	scene handlers
		//
		//----------------------------------------------------------------------
		
		
		private function scene_readyHandler(event:Scene3DManagerEvent):void
		{
			this.dispatch(new SceneReadyEvent(SceneReadyEvent.READY));
		}	
		
		private function scene_meshSelectedHandler(event:Scene3DManagerEvent):void
		{
			var selected:Array = [];
			var mesh:Mesh;
			var asset:AssetVO;
			var isLight:LightGizmo3D;
			var isContainer:ContainerGizmo3D;
				
			for each( var item:Object in Scene3DManager.selectedObjects.source )
			{
				mesh = item as Mesh;
				if( mesh ) 
				{
					if ((isLight = (mesh.parent as LightGizmo3D)))
						asset = assets.GetAsset(isLight.light);
					else if ((isContainer = (mesh.parent as ContainerGizmo3D)))
						asset = assets.GetAsset(isContainer.parent);
					else
						asset = assets.GetAsset(mesh);
					selected.push(asset);
				}
			} 
			trace( "select" );
			this.dispatch(new SceneEvent(SceneEvent.SELECT,selected));
		}

		private function scene_meshSelectedFromViewHandler(event:Scene3DManagerEvent) : void {
			if (Scene3DManager.mouseSelection) {
				var asset:AssetVO;
				if (Scene3DManager.mouseSelection.parent is ContainerGizmo3D)
					asset = assets.GetAsset( (Scene3DManager.mouseSelection.parent as ContainerGizmo3D).container );
				else 
					asset = assets.GetAsset( Scene3DManager.mouseSelection );
				this.dispatch(new SceneEvent(SceneEvent.SELECT, [ asset ]));
			}
		}

        private function scene_transformHandler(event:Scene3DManagerEvent):void
        {
			var m:Mesh = event.object as Mesh;
			var vo:ObjectVO;
			if (m.parent is LightGizmo3D) 
				vo = assets.GetAsset( (m.parent as LightGizmo3D).light ) as ObjectVO;
			else if (m.parent is ContainerGizmo3D) 
				vo = assets.GetAsset( (m.parent as ContainerGizmo3D).container ) as ObjectVO;
            else 
				vo = assets.GetAsset( event.object ) as ObjectVO;

			vo = vo.clone() as ObjectVO;
            switch( event.gizmoMode ) 
			{
                case GizmoMode.TRANSLATE:
					vo.x = event.endValue.x;
					vo.y = event.endValue.y;
					vo.z = event.endValue.z;
                    break;
                case GizmoMode.ROTATE:
					vo.rotationX = event.endValue.x;
					vo.rotationY = event.endValue.y;
					vo.rotationZ = event.endValue.z;
                    break;
                default:
					vo.scaleX = event.endValue.x;
					vo.scaleY = event.endValue.y;
					vo.scaleZ = event.endValue.z;
                    break;
            }

            this.dispatch(new SceneEvent(SceneEvent.CHANGING,[vo]));
        }

        private function scene_transformReleaseHandler(event:Scene3DManagerEvent):void
        {
			var m:Mesh = event.object as Mesh;
			var vo:ObjectVO;
			if (m.parent is LightGizmo3D)
				vo = assets.GetAsset( (m.parent as LightGizmo3D).light ) as ObjectVO;
			else if (m.parent is ContainerGizmo3D)
				vo = assets.GetAsset( (m.parent as ContainerGizmo3D).container ) as ObjectVO;
            else
            	vo = assets.GetAsset( event.object ) as ObjectVO;

            switch( event.gizmoMode ) 
			{
                case GizmoMode.TRANSLATE:
                    this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[vo], event.endValue));
                    break;
                case GizmoMode.ROTATE:
                    this.dispatch(new SceneEvent(SceneEvent.ROTATE_OBJECT,[vo],event.endValue));
                    break;
                default:
                    this.dispatch(new SceneEvent(SceneEvent.SCALE_OBJECT,[vo],event.endValue));
                    break;
            }
        }

        //----------------------------------------------------------------------
		//
		//	uncaught Error Handler
		//
		//----------------------------------------------------------------------
		
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			event.preventDefault();
			if (event.error is Error)
			{
				var error:Error = event.error as Error;
				Alert.show( error.message, error.name );
			}
			else if (event.error is ErrorEvent)
			{
				var errorEvent:ErrorEvent = event.error as ErrorEvent;
				Alert.show( errorEvent.text, errorEvent.type );
			}
			else
			{
				Alert.show( event.text, event.type );
			}
		}
		
	}
}