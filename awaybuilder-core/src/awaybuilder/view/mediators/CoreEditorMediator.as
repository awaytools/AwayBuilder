package awaybuilder.view.mediators
{
    import away3d.containers.ObjectContainer3D;
    import away3d.core.base.Object3D;
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.library.assets.NamedAssetBase;
    import away3d.lights.DirectionalLight;
    import away3d.lights.LightBase;
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
    import away3d.materials.TextureMaterial;
    import away3d.materials.TextureMultiPassMaterial;
    import away3d.materials.lightpickers.LightPickerBase;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.AlphaMaskMethod;
    import away3d.materials.methods.CascadeShadowMapMethod;
    import away3d.materials.methods.ColorMatrixMethod;
    import away3d.materials.methods.ColorTransformMethod;
    import away3d.materials.methods.DitheredShadowMapMethod;
    import away3d.materials.methods.EffectMethodBase;
    import away3d.materials.methods.EnvMapMethod;
    import away3d.materials.methods.FilteredShadowMapMethod;
    import away3d.materials.methods.FogMethod;
    import away3d.materials.methods.FresnelEnvMapMethod;
    import away3d.materials.methods.HardShadowMapMethod;
    import away3d.materials.methods.LightMapMethod;
    import away3d.materials.methods.NearShadowMapMethod;
    import away3d.materials.methods.OutlineMethod;
    import away3d.materials.methods.ProjectiveTextureMethod;
    import away3d.materials.methods.RefractionEnvMapMethod;
    import away3d.materials.methods.RimLightMethod;
    import away3d.materials.methods.ShadowMapMethodBase;
    import away3d.materials.methods.SoftShadowMapMethod;
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
    import awaybuilder.model.vo.scene.EffectMethodVO;
    import awaybuilder.model.vo.scene.LightPickerVO;
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ObjectVO;
    import awaybuilder.model.vo.scene.ShadowMapperVO;
    import awaybuilder.model.vo.scene.ShadowMethodVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.utils.scene.CameraManager;
    import awaybuilder.utils.scene.Scene3DManager;
    import awaybuilder.utils.scene.modes.GizmoMode;
    import awaybuilder.view.components.CoreEditor;
    import awaybuilder.view.components.events.CoreEditorEvent;
    import awaybuilder.view.scene.controls.ContainerGizmo3D;
    import awaybuilder.view.scene.controls.LightGizmo3D;
    import awaybuilder.view.scene.events.Scene3DManagerEvent;
    
    import flash.events.ErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.ColorTransform;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
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
			addContextListener(SceneEvent.CHANGE_EFFECT_METHOD, eventDispatcher_changeEffectMethodHandler);
			addContextListener(SceneEvent.CHANGE_SHADOW_MAPPER, eventDispatcher_changeShadowMapperHandler);
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureHandler);
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
			}
			else if( obj is LightMapMethod )
			{
				var lightMapMethod:LightMapMethod = obj as LightMapMethod;
			}
			else if( obj is OutlineMethod )
			{
				var outlineMethod:OutlineMethod = obj as OutlineMethod;
			}
			else if( obj is ProjectiveTextureMethod )
			{
				var projectiveTextureMethod:ProjectiveTextureMethod = obj as ProjectiveTextureMethod;
			}
			else if( obj is RefractionEnvMapMethod )
			{
				var refractionEnvMapMethod:RefractionEnvMapMethod = obj as RefractionEnvMapMethod;
			}
			else if( obj is RimLightMethod )
			{
				var rimLightMethod:RimLightMethod = obj as RimLightMethod;
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
			}
			else if( obj is NearShadowMapMethod )
			{
				var nearShadowMapMethod:NearShadowMapMethod = obj as NearShadowMapMethod;
			}
		}
		private function applyContainer( asset:ContainerVO ):void
		{
			var obj:ObjectContainer3D = assets.GetObject( asset ) as ObjectContainer3D;
			applyName( obj, asset );
			obj.pivotPoint = new Vector3D( asset.pivotX, asset.pivotY, asset.pivotZ );
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
			
			if (asset.shadowMapper)
				light.shadowMapper = assets.GetObject( asset.shadowMapper ) as ShadowMapperBase;
			
			applyObject( asset );
			if( asset.type == LightVO.DIRECTIONAL ) 
			{
				var dl:DirectionalLight = light as DirectionalLight;
				var y:Number = -Math.sin( asset.elevationAngle*Math.PI/180);
				var x:Number =  Math.sin(Math.PI/2 - asset.elevationAngle*Math.PI/180)*Math.sin( asset.azimuthAngle*Math.PI/180);
				var z:Number =  Math.sin(Math.PI/2 - asset.elevationAngle*Math.PI/180)*Math.cos( asset.azimuthAngle*Math.PI/180);
				dl.direction = new Vector3D( x, y, z); // tested
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
			
			// TODO: check why we cannot set null
			
			m.lightPicker = assets.GetObject(asset.lightPicker) as LightPickerBase;
			
			m.mipmap = asset.mipmap;
			m.smooth = asset.smooth;
			m.blendMode = asset.blendMode;
			
			
			
			if( m is ColorMaterial )
			{
				var cm:ColorMaterial = m as ColorMaterial;
				cm.color = asset.diffuseColor;
				cm.alpha = asset.alpha;
				
			}
			else if( m is TextureMaterial )
			{
				var tm:TextureMaterial = m as TextureMaterial;
				
				tm.shadowMethod = assets.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
				
				tm.texture = assets.GetObject(asset.diffuseTexture) as Texture2DBase;
				
				tm.alpha = asset.alpha;
				tm.normalMap = assets.GetObject(asset.normalTexture) as Texture2DBase;
				tm.specularMap = assets.GetObject(asset.specularTexture) as Texture2DBase;
				tm.ambientTexture = assets.GetObject(asset.ambientTexture) as Texture2DBase;
//				tm.diffuseMethod.diffuseAlpha = diffuseAlpha;
//				tm.diffuseMethod.diffuseColor = diffuseColor;
				
//				if( specularMap )
//					tm.specularMethod.texture = specularMap.linkedObject as Texture2DBase;
				
//				if( ambientTexture )
//					tm.ambientMethod.texture = ambientTexture.linkedObject as Texture2DBase;
			}
			var effect:EffectMethodVO;
			var singlePassMaterialBase:SinglePassMaterialBase = m as SinglePassMaterialBase;
			if( singlePassMaterialBase ) 
			{
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
					vo.material = assets.GetAsset( obj ) as MaterialVO;
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
			var asset:MaterialVO = event.items[0] as MaterialVO;
			if( asset ) 
			{
				applyMaterial( asset );
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
			var asset:MaterialVO = event.items[0] as MaterialVO;
			if( asset ) 
			{
				applyMaterial( asset );
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
						var asset:ObjectContainer3D = assets.GetObject( container ) as ObjectContainer3D;
//						if (asset.numChildren == 1)
//							selectObjectsScene( (asset.getChildAt(0) as ContainerGizmo3D).containerGizmo );
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
            CameraManager.focusTarget( Scene3DManager.selectedObject );
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
            var vo:ObjectVO = assets.GetAsset( event.object ) as ObjectVO;
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
			var vo:ObjectVO = assets.GetAsset( event.object ) as ObjectVO;
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