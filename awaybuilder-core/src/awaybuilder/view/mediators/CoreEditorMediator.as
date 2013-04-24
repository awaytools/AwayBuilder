package awaybuilder.view.mediators
{
    import away3d.containers.ObjectContainer3D;
    import away3d.core.base.Object3D;
    import away3d.core.base.SubMesh;
    import away3d.entities.Mesh;
    import away3d.library.assets.NamedAssetBase;
    import away3d.lights.DirectionalLight;
    import away3d.lights.LightBase;
    import away3d.materials.ColorMaterial;
    import away3d.materials.ColorMultiPassMaterial;
    import away3d.materials.MaterialBase;
    import away3d.materials.SinglePassMaterialBase;
    import away3d.materials.TextureMaterial;
    import away3d.materials.TextureMultiPassMaterial;
    import away3d.materials.lightpickers.LightPickerBase;
    import away3d.materials.lightpickers.StaticLightPicker;
    import away3d.materials.methods.ShadowMapMethodBase;
    import away3d.textures.Texture2DBase;
    
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
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
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.utils.AssetFactory;
    import awaybuilder.utils.scene.CameraManager;
    import awaybuilder.utils.scene.Scene3DManager;
    import awaybuilder.utils.scene.modes.GizmoMode;
    import awaybuilder.view.components.CoreEditor;
    import awaybuilder.view.components.events.CoreEditorEvent;
    import awaybuilder.view.scene.events.Scene3DManagerEvent;
    
    import flash.events.ErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.core.FlexGlobals;
    import mx.rpc.events.AbstractEvent;
    
    import org.robotlegs.mvcs.Mediator;
    
    import spark.collections.Sort;

    public class CoreEditorMediator extends Mediator
	{
		[Inject]
		public var view:CoreEditor;
		
		[Inject]
		public var document:IDocumentModel;
		
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
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_addNewMaterialToSubmeshHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHTPICKER, eventDispatcher_addNewLightpickerToMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_SHADOW_METHOD, eventDispatcher_addNewMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_EFFECT_METHOD, eventDispatcher_addNewMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHT, eventDispatcher_addNewLightHandler);
			
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.READY, scene_readyHandler);
			Scene3DManager.instance.addEventListener(Scene3DManagerEvent.MESH_SELECTED, scene_meshSelectedHandler);
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
		
		private function applyContainer( asset:ContainerVO ):void
		{
			var obj:ObjectContainer3D = AssetFactory.GetObject( asset ) as ObjectContainer3D;
			applyName( obj, asset );
			obj.pivotPoint = new Vector3D( asset.pivotX, asset.pivotY, asset.pivotZ );
		}
		private function applyObject( asset:ObjectVO ):void
		{
			var o:Object3D = Object3D( AssetFactory.GetObject(asset) );
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
			var light:LightBase = AssetFactory.GetObject( asset ) as LightBase;
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
			var picker:StaticLightPicker = AssetFactory.GetObject( asset ) as StaticLightPicker;
			var lights:Array = [];
			for each( var light:LightVO in asset.lights )
			{
				lights.push( AssetFactory.GetObject(light) );
			}
			picker.lights = lights;
		}
		
		private function applySubMesh( asset:SubMeshVO ):void
		{
			var submesh:SubMesh = SubMesh( AssetFactory.GetObject(asset) );
			submesh.material = MaterialBase( AssetFactory.GetObject(asset.material) );
		}
		private function applyMaterial( asset:MaterialVO ):void
		{
			var m:MaterialBase = MaterialBase( AssetFactory.GetObject(asset) );
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
			
			m.lightPicker = AssetFactory.GetObject(asset.lightPicker) as LightPickerBase;
			
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
				
				tm.shadowMethod = AssetFactory.GetObject(asset.shadowMethod) as ShadowMapMethodBase;
				
				tm.texture = AssetFactory.GetObject(asset.diffuseTexture) as Texture2DBase;
				
				tm.alpha = asset.alpha;
				
				tm.normalMap = AssetFactory.GetObject(asset.normalTexture) as Texture2DBase;
				tm.specularMap = AssetFactory.GetObject(asset.specularTexture) as Texture2DBase;
				tm.ambientTexture = AssetFactory.GetObject(asset.ambientTexture) as Texture2DBase;
					
//				tm.diffuseMethod.diffuseAlpha = diffuseAlpha;
//				tm.diffuseMethod.diffuseColor = diffuseColor;
				
//				if( specularMap )
//					tm.specularMethod.texture = specularMap.linkedObject as Texture2DBase;
				
//				if( ambientTexture )
//					tm.ambientMethod.texture = ambientTexture.linkedObject as Texture2DBase;
			}
			var material:SinglePassMaterialBase = m as SinglePassMaterialBase;
			if( material ) 
			{
				var i:int;
//				for (i = 0; i < material.numMethods; i++) 
//				{
//					if( (i < effectMethods.length) && material.getMethodAt( i ) != material.getMethodAt( i ) ) 
//					{
//						material.removeMethod( material.getMethodAt( i ) );
//						i--;
//					}
//				}
//				for (i = 0; i < effectMethods.length; i++) 
//				{
//					if( (i < material.numMethods) && effectMethods.getItemAt( i ) != material.getMethodAt( i ) ) 
//					{
//						material.addMethodAt( effectMethods.getItemAt( i ) as 
//					}
//				}
//				for (i = 0; i < material.numMethods; i++) 
//				{
//					material.removeMethod( material.getMethodAt(i) );
//					i--;
//				}
//				for (i = 0; i < asset.effectMethods.length; i++) 
//				{
//					material.addMethod( EffectMethodVO(effectMethods.getItemAt(i)).linkedObject as EffectMethodBase );
//				}
				
			}
			
			var len:uint = 0;
			
			if( oldMaterial ) 
			{
				delete AssetFactory.assets[oldMaterial];
				for (var item:Object in AssetFactory.assets)
				{
					var subMesh:SubMesh = item as SubMesh;
					if( subMesh ) 
					{
						if( subMesh.material == oldMaterial ) {
							subMesh.material = m;
						}
					}
					len++;
				}
				AssetFactory.assets[m] = asset;
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
				var obj:Mesh = AssetFactory.GetObject( item ) as Mesh;
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
		
		private function eventDispatcher_addNewMethodHandler(event:SceneEvent):void
		{
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
						selectObjectsScene( AssetFactory.GetObject( mesh ) as Object3D );
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
        private function eventDispatcher_itemsFocusHandler(event:SceneEvent):void
        {
            CameraManager.focusTarget( Scene3DManager.selectedObject );
        }
		
		private function eventDispatcher_zoomToDistanceHandler(event:Scene3DManagerEvent):void
        {
            this.dispatch( new Scene3DManagerEvent( Scene3DManagerEvent.ZOOM_TO_DISTANCE ) );
        }

		//----------------------------------------------------------------------
		//
		//	scene handlers
		//
		//----------------------------------------------------------------------
		
		
		private function scene_readyHandler(event:Scene3DManagerEvent):void
		{
			
		}	
		
		private function scene_meshSelectedHandler(event:Scene3DManagerEvent):void
		{
			var selected:Array = [];
			for each( var item:Object in Scene3DManager.selectedObjects.source )
			{
				var mesh:Mesh = item as Mesh;
				if( mesh ) 
				{
					var asset:AssetVO = AssetFactory.GetAsset(item);
					
					if( asset ) 
					{
						selected.push(asset);
					}
					
				}
			} 
			this.dispatch(new SceneEvent(SceneEvent.SELECT,selected));
		}

        private function scene_transformHandler(event:Scene3DManagerEvent):void
        {
            var vo:ObjectVO = AssetFactory.GetAsset( event.object ) as ObjectVO;
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
			var vo:ObjectVO = AssetFactory.GetAsset( event.object ) as ObjectVO;
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