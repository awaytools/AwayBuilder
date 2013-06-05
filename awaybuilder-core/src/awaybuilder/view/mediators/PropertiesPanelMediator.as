package awaybuilder.view.mediators
{
    import away3d.animators.AnimatorBase;
    import away3d.tools.commands.Merge;
    
    import awaybuilder.controller.document.events.ImportTextureEvent;
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.history.UndoRedoEvent;
    import awaybuilder.controller.scene.events.AnimationEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.AssetsModel;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.scene.AnimationNodeVO;
    import awaybuilder.model.vo.scene.AnimationSetVO;
    import awaybuilder.model.vo.scene.AnimatorVO;
    import awaybuilder.model.vo.scene.AssetVO;
    import awaybuilder.model.vo.scene.CameraVO;
    import awaybuilder.model.vo.scene.ContainerVO;
    import awaybuilder.model.vo.scene.CubeTextureVO;
    import awaybuilder.model.vo.scene.EffectMethodVO;
    import awaybuilder.model.vo.scene.GeometryVO;
    import awaybuilder.model.vo.scene.LensVO;
    import awaybuilder.model.vo.scene.LightPickerVO;
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ShadingMethodVO;
    import awaybuilder.model.vo.scene.ShadowMapperVO;
    import awaybuilder.model.vo.scene.ShadowMethodVO;
    import awaybuilder.model.vo.scene.SkeletonVO;
    import awaybuilder.model.vo.scene.SkyBoxVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.model.vo.scene.TextureProjectorVO;
    import awaybuilder.model.vo.scene.TextureVO;
    import awaybuilder.utils.DataMerger;
    import awaybuilder.view.components.PropertiesPanel;
    import awaybuilder.view.components.editors.events.PropertyEditorEvent;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.events.CloseEvent;
    
    import org.robotlegs.mvcs.Mediator;

    public class PropertiesPanelMediator extends Mediator
    {
        [Inject]
        public var view:PropertiesPanel;

		[Inject]
		public var assets:AssetsModel;
		
        [Inject]
        public var document:DocumentModel;

        override public function onRegister():void
        {
            addContextListener(SceneEvent.SELECT, context_itemsSelectHandler);
            addContextListener(SceneEvent.CHANGING, context_simpleUpdateHandler);
            addContextListener(SceneEvent.TRANSLATE_OBJECT, context_simpleUpdateHandler);
            addContextListener(SceneEvent.SCALE_OBJECT, context_simpleUpdateHandler);
            addContextListener(SceneEvent.ROTATE_OBJECT, context_simpleUpdateHandler);
            addContextListener(SceneEvent.CHANGE_MESH, context_changeMeshHandler);
			addContextListener(SceneEvent.CHANGE_CONTAINER, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_GEOMETRY, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_LIGHT, context_simpleUpdateHandler);
            addContextListener(SceneEvent.CHANGE_MATERIAL, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_LIGHTPICKER, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_SHADING_METHOD, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_SHADOW_METHOD, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_SHADOW_MAPPER, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_CUBE_TEXTURE, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_TEXTURE, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_GLOBAL_OPTIONS, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_EFFECT_METHOD, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_SKYBOX, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_TEXTURE_PROJECTOR, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_CAMERA, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_LENS, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_ANIMATOR, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_ANIMATION_SET, context_simpleUpdateHandler);
			addContextListener(SceneEvent.CHANGE_ANIMATION_NODE, context_simpleUpdateHandler);
			addContextListener(SceneEvent.REPARENT_LIGHTS, context_reparentHandler);
			addContextListener(SceneEvent.REPARENT_ANIMATIONS, context_reparentHandler);
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_CUBE_TEXTURE, eventDispatcher_addNewTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_addNewMaterialToSubmeshHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHTPICKER, eventDispatcher_addNewLightpickerToMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHT, eventDispatcher_addNewLightToLightpickerHandler);
			addContextListener(SceneEvent.ADD_NEW_SHADOW_METHOD, eventDispatcher_addNewMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_EFFECT_METHOD, eventDispatcher_addNewMethodHandler);
			
			addContextListener(UndoRedoEvent.UNDO, context_undoHandler);
			addContextListener(SceneEvent.DELETE, context_deleteHandler);
			
			addContextListener(DocumentModelEvent.OBJECTS_UPDATED, context_documentUpdatedHandler, null, false, -1000);
			addContextListener(DocumentModelEvent.DOCUMENT_CREATED, context_documentUpdatedHandler, null, false, -1000);

            addViewListener( PropertyEditorEvent.TRANSLATE, view_translateHandler );
            addViewListener( PropertyEditorEvent.ROTATE, view_rotateHandler );
            addViewListener( PropertyEditorEvent.SCALE, view_scaleHandler );
            addViewListener( PropertyEditorEvent.MESH_CHANGE, view_meshChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_STEPPER_CHANGE, view_meshNameChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_SUBMESH_CHANGE, view_meshSubmeshChangeHandler );
			addViewListener( PropertyEditorEvent.MESH_SUBMESH_ADD_NEW_MATERIAL, view_submeshAddNewMaterialHandler );
			
			addViewListener( PropertyEditorEvent.CONTAINER_CHANGE, view_containerChangeHandler );
			addViewListener( PropertyEditorEvent.CONTAINER_STEPPER_CHANGE, view_containerStepperChangeHandler );
			
			addViewListener( PropertyEditorEvent.GEOMETRY_CHANGE, view_geometryChangeHandler );
			addViewListener( PropertyEditorEvent.GEOMETRY_STEPPER_CHANGE, view_geometryStepperChangeHandler );
			
            addViewListener( PropertyEditorEvent.MATERIAL_CHANGE, view_materialChangeHandler );
            addViewListener( PropertyEditorEvent.MATERIAL_STEPPER_CHANGE, view_materialNameChangeHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_AMBIENT_METHOD_CHANGE, view_materialAmbientMethodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_DIFFUSE_METHOD_CHANGE, view_materialDiffuseMethodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_NORMAL_METHOD_CHANGE, view_materialNormalMethodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_SPECULAR_METHOD_CHANGE, view_materialSpecularMethodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_EFFECT_METHOD, view_materialAddEffectMetodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_LIGHTPICKER, view_materialAddLightpickerHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_REMOVE_EFFECT_METHOD, view_materialRemoveEffectMetodHandler );
			
			addViewListener( PropertyEditorEvent.SHADOWMETHOD_CHANGE, view_shadowmethodChangeHandler );
			addViewListener( PropertyEditorEvent.SHADOWMETHOD_STEPPER_CHANGE, view_shadowmethodChangeStepperHandler );
			addViewListener( PropertyEditorEvent.SHADOWMETHOD_BASE_METHOD_CHANGE, view_shadowmethodBaseMethodChangeHandler );
			
			addViewListener( PropertyEditorEvent.SKYBOX_CHANGE, view_skyboxChangeHandler );
			addViewListener( PropertyEditorEvent.SKYBOX_STEPPER_CHANGE, view_skyboxChangeStepperHandler );
			addViewListener( PropertyEditorEvent.SKYBOX_ADD_CUBE_TEXTURE, view_skyboxAddCubeTextureHandler );
			
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_CHANGE, view_shadingmethodChangeHandler );
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_ADD_TEXTURE, view_shadingmethodAddTextureHandler );
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_ADD_CUBE_TEXTURE, view_shadingmethodAddCubeTextureHandler );
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_BASE_METHOD_CHANGE, view_shadingmethodBaseMethodChangeHandler );
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_STEPPER_CHANGE, view_shadingmethodChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.SHADOWMAPPER_CHANGE, view_shadowmapperChangeHandler );
			addViewListener( PropertyEditorEvent.SHADOWMAPPER_STEPPER_CHANGE, view_shadowmapperChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.TEXTURE_PROJECTOR_CHANGE, view_textureProjectorChangeHandler );
			addViewListener( PropertyEditorEvent.TEXTURE_PROJECTOR_ADD_TEXTURE, view_textureProjectorAddTextureHandler );
			addViewListener( PropertyEditorEvent.TEXTURE_PROJECTOR_STEPPER_CHANGE, view_textureProjectorChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.CAMERA_CHANGE, view_cameraChangeHandler );
			addViewListener( PropertyEditorEvent.CAMERA_LENS_CHANGE, view_cameraLensChangeHandler );
			addViewListener( PropertyEditorEvent.CAMERA_STEPPER_CHANGE, view_cameraChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.LENS_CHANGE, view_lensChangeHandler );
			addViewListener( PropertyEditorEvent.LENS_STEPPER_CHANGE, view_lensChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_CHANGE, view_effectmethodChangeHandler );
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_ADD_TEXTURE, view_effectmethodAddTextureHandler );
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_ADD_CUBE_TEXTURE, view_effectmethodAddCubeTextureHandler );
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_STEPPER_CHANGE, view_effectmethodChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.TEXTURE_STEPPER_CHANGE, view_textureChangeStepperHandler );
			addViewListener( PropertyEditorEvent.CUBETEXTURE_STEPPER_CHANGE, view_cubetextureChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.REPLACE_TEXTURE, view_replaceTextureHandler );
			addViewListener( PropertyEditorEvent.REPLACE_CUBE_TEXTURE, view_replaceCubeTextureHandler );
			
			addViewListener( PropertyEditorEvent.LIGHT_POSITION_CHANGE, view_lightPositionChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHT_STEPPER_CHANGE, view_lightStepperChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHT_CHANGE, view_lightChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHT_MAPPER_CHANGE, view_lightMapperChangeHandler );
			
			addViewListener( PropertyEditorEvent.LIGHT_ADD_FilteredShadowMapMethod, view_lightAddFilteredShadowMapMethodHandler );
			addViewListener( PropertyEditorEvent.LIGHT_ADD_CascadeShadowMapMethod, view_lightAddCascadeShadowMapMethodHandler );
			addViewListener( PropertyEditorEvent.LIGHT_ADD_DitheredShadowMapMethod, view_lightAddDitheredShadowMapHandler );
			addViewListener( PropertyEditorEvent.LIGHT_ADD_HardShadowMapMethod, view_lightAddHardShadowMapMethodHandler );
			addViewListener( PropertyEditorEvent.LIGHT_ADD_NearShadowMapMethod, view_lightAddNearShadowMapMethodHandler );
			addViewListener( PropertyEditorEvent.LIGHT_ADD_SoftShadowMapMethod, view_lightAddSoftShadowMapMethodHandler );
			
			addViewListener( PropertyEditorEvent.LIGHTPICKER_CHANGE, view_lightPickerChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHTPICKER_STEPPER_CHANGE, view_lightPickerStepperChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHTPICKER_ADD_DIRECTIONAL_LIGHT, view_lightPickerAddDirectionalLightHandler );
			addViewListener( PropertyEditorEvent.LIGHTPICKER_ADD_POINT_LIGHT, view_lightPickerAddPointLightHandler );
			
			addViewListener( PropertyEditorEvent.ANIMATOR_CHANGE, view_animatorChangeHandler );
			addViewListener( PropertyEditorEvent.ANIMATOR_STEPPER_CHANGE, view_animatorStepperChangeHandler );
			addViewListener( PropertyEditorEvent.ANIMATOR_PLAY, view_animatorPlayHandler );
			addViewListener( PropertyEditorEvent.ANIMATOR_STOP, view_animatorStopHandler );
			addViewListener( PropertyEditorEvent.ANIMATOR_SEEK, view_animatorSeekHandler );
			addViewListener( PropertyEditorEvent.ANIMATOR_PAUSE, view_animatorPauseHandler );
			
			addViewListener( PropertyEditorEvent.ANIMATRION_SET_CHANGE, view_animationSetChangeHandler );
			addViewListener( PropertyEditorEvent.ANIMATRION_SET_STEPPER_CHANGE, view_animationSetStepperChangeHandler );
			addViewListener( PropertyEditorEvent.ANIMATRION_SET_ADD_ANIMATOR, view_animationAddAnimatorHandler );
			addViewListener( PropertyEditorEvent.ANIMATRION_SET_REMOVE_ANIMATOR, view_animationRemoveAnimatorHandler );
			
			addViewListener( PropertyEditorEvent.SHOW_CHILD_PROPERTIES, view_showChildObjectPropertiesHandler );
			
			addViewListener( PropertyEditorEvent.SHOW_PARENT_MESH_PROPERTIES, view_showParentMeshHandler );
			addViewListener( PropertyEditorEvent.SHOW_PARENT_MATERIAL_PROPERTIES, view_showParentMaterialHandler );
			
			addViewListener( PropertyEditorEvent.GLOBAL_OPTIONS_CHANGE, view_globalOptionsChangeHandler );
			addViewListener( PropertyEditorEvent.GLOBAL_OPTIONS_STEPPER_CHANGE, view_globalOptionsStepperChangeHandler );
			
			view.currentState = "global";
			view.SetData(document.globalOptions);
			
        }

        //----------------------------------------------------------------------
        //
        //	view handlers
        //
        //----------------------------------------------------------------------


        private function view_translateHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[view.data], event.data, true));
        }
        private function view_rotateHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.ROTATE_OBJECT,[view.data], event.data, true));
        }
        private function view_scaleHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.SCALE_OBJECT,[view.data], event.data, true));
        }
		private function view_containerChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CONTAINER,[view.data], event.data));
		}
		private function view_containerStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CONTAINER,[view.data], event.data, true));
		}
		private function view_geometryChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_GEOMETRY,[view.data], event.data));
		}
		private function view_geometryStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_GEOMETRY,[view.data], event.data, true));
		}
		
        private function view_meshChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], event.data));
        }
        private function view_meshNameChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], event.data, true));
        }
		private function view_globalOptionsChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_GLOBAL_OPTIONS,[view.data], event.data));
		}
		private function view_globalOptionsStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_GLOBAL_OPTIONS,[view.data], event.data, true));
		}
        private function view_meshSubmeshChangeHandler(event:PropertyEditorEvent):void
        {
			if( view.data )
			{
				var vo:MeshVO = view.data as MeshVO;
				var newValue:MeshVO = vo.clone() as MeshVO;
				for each( var subMesh:SubMeshVO in newValue.subMeshes )
				{
					if( subMesh.equals( AssetVO(event.data) ) )
					{
						subMesh.material = SubMeshVO(event.data).material;
					}
				}
				this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], newValue));
			}
        }
        private function view_materialChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], event.data));
        }
        private function view_materialNameChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], event.data, true));
        }
		private function view_materialAmbientMethodHandler(event:PropertyEditorEvent):void
		{
			var newMaterial:MaterialVO = MaterialVO(view.data).clone() as MaterialVO;
			var method:ShadingMethodVO = assets.CreateShadingMethod( event.data.toString() );
			newMaterial.ambientMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], newMaterial));
		}
		private function view_materialDiffuseMethodHandler(event:PropertyEditorEvent):void
		{
			var newMaterial:MaterialVO = MaterialVO(view.data).clone() as MaterialVO;
			var method:ShadingMethodVO = assets.CreateShadingMethod( event.data.toString() );
			newMaterial.diffuseMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], newMaterial));
		}
		private function view_materialNormalMethodHandler(event:PropertyEditorEvent):void
		{
			var newMaterial:MaterialVO = MaterialVO(view.data).clone() as MaterialVO;
			var method:ShadingMethodVO = assets.CreateShadingMethod( event.data.toString() );
			newMaterial.normalMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], newMaterial));
		}
		private function view_materialSpecularMethodHandler(event:PropertyEditorEvent):void
		{
			var newMaterial:MaterialVO = MaterialVO(view.data).clone() as MaterialVO;
			var method:ShadingMethodVO = assets.CreateShadingMethod( event.data.toString() );
			newMaterial.specularMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], newMaterial));
		}
		
		private function view_textureProjectorChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_TEXTURE_PROJECTOR,[view.data], event.data));
		}
		private function view_textureProjectorAddTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[view.data],"texture"));
		}
		private function view_textureProjectorChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_TEXTURE_PROJECTOR,[view.data], event.data, true));
		}
		
		private function view_cameraChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CAMERA,[view.data], event.data));
		}
		private function view_cameraChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CAMERA,[view.data], event.data, true));
		}
		private function view_cameraLensChangeHandler(event:PropertyEditorEvent):void
		{
			var newCamera:CameraVO = CameraVO(view.data).clone() as CameraVO;
			var lens:LensVO = assets.CreateLens( event.data.toString() );
			newCamera.lens = lens;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CAMERA,[view.data], newCamera));
		}
		
		private function view_lensChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LENS,[view.data], event.data));
		}
		private function view_lensChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LENS,[view.data], event.data, true));
		}
		
		private function view_effectmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_EFFECT_METHOD,[view.data], event.data));
		}
		private function view_effectmethodAddTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[view.data],"texture"));
		}
		private function view_effectmethodAddCubeTextureHandler(event:PropertyEditorEvent):void
		{
			var e:SceneEvent = new SceneEvent(SceneEvent.ADD_NEW_CUBE_TEXTURE,[view.data],assets.CreateCubeTexture());
			e.options = "cubeTexture";
			this.dispatch(e);
		}
		private function view_effectmethodChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_EFFECT_METHOD,[view.data], event.data, true));
		}
		private function view_textureChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_TEXTURE,[view.data], event.data, true));
		}
		private function view_cubetextureChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_CUBE_TEXTURE,[view.data], event.data, true));
		}
		
		private function view_shadowmapperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_MAPPER,[view.data], event.data));
		}
		private function view_shadowmapperChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_MAPPER,[view.data], event.data, true));
		}
		private function view_skyboxChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SKYBOX,[view.data], event.data));
		}
		private function view_skyboxChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SKYBOX,[view.data], event.data));
		}
		private function view_skyboxAddCubeTextureHandler(event:PropertyEditorEvent):void
		{
			var e:SceneEvent = new SceneEvent(SceneEvent.ADD_NEW_CUBE_TEXTURE,[view.data],assets.CreateCubeTexture());
			e.options = "cubeMap";
			this.dispatch(e);
		}
		private function view_shadowmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_METHOD,[view.data], event.data));
		}
		private function view_shadowmethodChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_METHOD,[view.data], event.data, true));
		}
		private function view_shadowmethodBaseMethodChangeHandler(event:PropertyEditorEvent):void
		{
			var method:ShadowMethodVO;
			var light:LightVO = ShadowMethodVO(view.data).castingLight;
			var newMethod:ShadowMethodVO = ShadowMethodVO(view.data).clone() as ShadowMethodVO;
			switch(event.data)
			{
				case "FilteredShadowMapMethod":
					method = assets.CreateFilteredShadowMapMethod( light );
					break;
				case "DitheredShadowMapMethod":
					method = assets.CreateDitheredShadowMapMethod( light );
					break;
				case "SoftShadowMapMethod":
					method = assets.CreateSoftShadowMapMethod( light );
					break;
				case "HardShadowMapMethod":
					method = assets.CreateHardShadowMapMethod( light );
					break;
					
			}
			newMethod.baseMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_METHOD,[view.data], newMethod));
		}
		
		private function view_shadingmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADING_METHOD,[view.data], event.data));
		}
		private function view_shadingmethodAddTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[view.data],"texture"));
		}
		private function view_shadingmethodAddCubeTextureHandler(event:PropertyEditorEvent):void
		{
			var e:SceneEvent = new SceneEvent(SceneEvent.ADD_NEW_CUBE_TEXTURE,[view.data],assets.CreateCubeTexture());
			e.options = "envMap";
			this.dispatch(e);
		}
		private function view_shadingmethodBaseMethodChangeHandler(event:PropertyEditorEvent):void
		{
			var newMethod:ShadingMethodVO = ShadingMethodVO(view.data).clone() as ShadingMethodVO;
			var method:ShadingMethodVO = assets.CreateShadingMethod( event.data.toString() );
			newMethod.baseMethod = method;
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADING_METHOD,[view.data], newMethod));
		}
		
		private function view_shadingmethodChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADING_METHOD,[view.data], event.data, true));
		}
		
		private function view_showChildObjectPropertiesHandler(event:PropertyEditorEvent):void
		{
			view.prevSelected.addItem(view.data);
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[event.data],true));
		}
		
		private function view_showParentMeshHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[event.data],false,false,true));
		}
		private function view_showParentMaterialHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.SELECT,[event.data],false,false,true));
		}
		
		private function view_materialAddLightpickerHandler(event:PropertyEditorEvent):void
		{
			var asset:LightPickerVO = assets.CreateLightPicker();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHTPICKER,[view.data], asset ));
		}
		
		private function view_materialAddNewTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[view.data],event.data));
		}
		private function view_materialAddEffectMetodHandler(event:PropertyEditorEvent):void
		{
			if( event.data == "ProjectiveTextureMethod" )
			{
				Alert.show( "TextureProjector is missing", "Warning" );
				return;
			}
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_EFFECT_METHOD,[view.data], assets.CreateEffectMethod( event.data as String )));
			
		}
		private function view_materialRemoveEffectMetodHandler(event:PropertyEditorEvent):void
		{
			var material:MaterialVO = MaterialVO(view.data);
			for (var i:int = 0; i < material.effectMethods.length; i++) 
			{
				if( material.effectMethods.getItemAt( i ) == event.data )
				{
					material.effectMethods.removeItemAt(i);
					i--;
				}
			}
			
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], material));
		}
		
		
		private function view_submeshAddNewMaterialHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MATERIAL,[event.data], assets.CreateMaterial()));
		}
		private function view_replaceTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_BITMAP_REPLACE,[view.data],"bitmapData"));
		}
		private function view_replaceCubeTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_BITMAP_REPLACE,[view.data],event.data));
		}
		
		private function view_lightPositionChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[view.data], event.data, true));
		}
		
		private function view_lightChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT,[view.data], event.data));
		}
		
		private var _storedLight:LightVO;
		private function view_lightMapperChangeHandler(event:PropertyEditorEvent):void
		{
			_storedLight = LightVO(view.data).clone() as LightVO;
			var mapper:ShadowMapperVO = assets.CreateShadowMapper( event.data.toString() );
			_storedLight.shadowMapper = mapper;
			if( LightVO(view.data).shadowMethods && LightVO(view.data).shadowMethods.length ) {
				_storedLight.shadowMethods = new ArrayCollection();
				view.callLater( alertCalledLater );
			}
			else
			{
				this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT,[view.data], _storedLight));
			}
			
		}
		private function alertCalledLater():void
		{
			Alert.show( "Assigned ShadowMethods will be removed (this operation cannot be undone)", "Warning", Alert.OK|Alert.CANCEL, null, lightMapperAlert_closeHandler )
		}
		private function lightMapperAlert_closeHandler(event:CloseEvent):void
		{
			if (event.detail == Alert.OK) 
			{
				this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT,[view.data], _storedLight));
			}
		}
		private function view_lightAddFilteredShadowMapMethodHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateFilteredShadowMapMethod(view.data as LightVO)));
		}
		private function view_lightAddCascadeShadowMapMethodHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateCascadeShadowMapMethod(view.data as LightVO)));
		}
		private function view_lightAddDitheredShadowMapHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateDitheredShadowMapMethod(view.data as LightVO)));
		}
		private function view_lightAddHardShadowMapMethodHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateHardShadowMapMethod(view.data as LightVO)));
		}
		private function view_lightAddNearShadowMapMethodHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateNearShadowMapMethod(view.data as LightVO)));
		}
		private function view_lightAddSoftShadowMapMethodHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_SHADOW_METHOD,[view.data], assets.CreateSoftShadowMapMethod(view.data as LightVO)));
		}
		
		private function view_lightStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT, [view.data], event.data, true));
		}
		
		private function view_lightPickerChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHTPICKER,[view.data], event.data));
		}
		private function view_lightPickerStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHTPICKER, [view.data], event.data, true));
		}
		
		private function view_lightPickerAddDirectionalLightHandler(event:PropertyEditorEvent):void
		{
			var asset:LightVO = assets.CreateDirectionalLight();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHT,[view.data],asset));
		}
		private function view_lightPickerAddPointLightHandler(event:PropertyEditorEvent):void
		{
			var asset:LightVO = assets.CreatePointLight();
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHT,[view.data],asset));
		}
		
		private function view_animationSetChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATION_SET,[view.data], event.data));
		}
		private function view_animationSetStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATION_SET, [view.data], event.data, true));
		}
		private function view_animationAddAnimatorHandler(event:PropertyEditorEvent):void
		{
			var newAnimationSet:AnimationSetVO = AnimationSetVO(view.data).clone();
			var animator:AnimatorVO;
			switch( newAnimationSet.type )
			{
				case "VertexAnimationSet":
					animator = assets.CreateAnimator( "VertexAnimator", view.data as AnimationSetVO );
					break;
				case "SkeletonAnimationSet":
					var skeletons:Vector.<SkeletonVO> = new Vector.<SkeletonVO>();
					for each( var asset:AssetVO in document.animations )
					{
						if( asset is SkeletonVO )
						{
							skeletons.push(asset);
						}
					}
					if( !skeletons.length )
					{
						Alert.show( "Skeleton is missing", "Warning" );
						return;
					}
					animator = assets.CreateAnimator( "SkeletonAnimator", view.data as AnimationSetVO, skeletons[0] );
					break;
			}
			newAnimationSet.animators.addItem( animator );
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATION_SET,[view.data], newAnimationSet));
		}
		private function view_animationRemoveAnimatorHandler(event:PropertyEditorEvent):void
		{
			var newAnimationSet:AnimationSetVO = AnimationSetVO(view.data).clone();
			var animator:AnimatorVO = event.data as AnimatorVO;
			for( var i:int = 0; i < newAnimationSet.animators.length; i++ )
			{
				if( animator.equals(newAnimationSet.animators.getItemAt(i) as AnimatorVO) )
					newAnimationSet.animators.removeItemAt( i );
			}
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATION_SET,[view.data], newAnimationSet));
		}
		
		
		private function view_animatorChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATOR,[view.data], event.data));
		}
		private function view_animatorStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_ANIMATOR, [view.data], event.data, true));
		}
		private function view_animatorPlayHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new AnimationEvent(AnimationEvent.PLAY, view.data as AnimatorVO, event.data as AnimationNodeVO ));
		}
		private function view_animatorPauseHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new AnimationEvent(AnimationEvent.PAUSE, view.data as AnimatorVO, event.data as AnimationNodeVO));
		}
		private function view_animatorStopHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new AnimationEvent(AnimationEvent.STOP, view.data as AnimatorVO, event.data as AnimationNodeVO));
		}
		private function view_animatorSeekHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new AnimationEvent(AnimationEvent.SEEK, view.data as AnimatorVO, event.data as AnimationNodeVO));
		}
        //----------------------------------------------------------------------
        //
        //	context handlers
        //
        //----------------------------------------------------------------------

		
		private function context_simpleUpdateHandler(event:SceneEvent):void
		{
			view.SetData( event.items[0] );
		}
		private function context_reparentHandler(event:SceneEvent):void
		{
			view.SetData( view.data );
		}
		
        private function context_changeMeshHandler(event:SceneEvent):void
        {
            var mesh:MeshVO = MeshVO( event.items[0] ) as MeshVO;
            for each( var subMesh:SubMeshVO in  mesh.subMeshes )
            {
                subMesh.linkedMaterials = view.materials;
            }
            view.SetData( mesh );
        }
		
		private function eventDispatcher_addNewLightpickerToMaterialHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length )
			{
				view.SetData(event.items[0]);
			}
		}
		private function eventDispatcher_addNewLightToLightpickerHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length )
			{
				view.SetData(event.items[0]);
			}
		}
		
		private function eventDispatcher_addNewMethodHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length )
			{
				view.SetData(event.items[0]);
			}
		}
		private function eventDispatcher_addNewMaterialToSubmeshHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length )
			{
				var subMesh:SubMeshVO = SubMeshVO( event.items[0] );
				var mesh:MeshVO = subMesh.parentMesh as MeshVO;
				for each( var o:SubMeshVO in mesh.subMeshes )
				{
					subMesh.linkedMaterials = view.materials;
				}
				
				view.SetData(mesh);
			}
		}
		
		private function eventDispatcher_addNewTextureHandler(event:SceneEvent):void
		{
			updateLists();
			if( event.items && event.items.length )
			{
				view.SetData(event.items[0]);
			}
		}
        private function context_itemsSelectHandler(event:SceneEvent):void
        {
            if( !event.items || event.items.length == 0)
            {
				view.showEditor( "global", event.newValue, event.oldValue );
				view.SetData(document.globalOptions);
                return;
            }
            if( event.items.length )
            {
                if( event.items.length == 1 )
                {
                    if( event.items[0] is MeshVO )
                    {
                        var mesh:MeshVO = MeshVO( event.items[0] ) as MeshVO;
                        for each( var subMesh:SubMeshVO in  mesh.subMeshes )
                        {
                            subMesh.linkedMaterials = view.materials; // TODO
                        }
						view.SetData(mesh);
						view.showEditor( "mesh", event.newValue, event.oldValue );
                    }
					else if( event.items[0] is SkyBoxVO )
					{
						view.showEditor( "skyBox", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is TextureProjectorVO )
					{
						view.showEditor( "textureProjector", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
                    else if( event.items[0] is ContainerVO )
                    {
						view.showEditor( "container", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
                    }
                    else if( event.items[0] is MaterialVO )
                    {
						view.SetData(event.items[0]);
						view.showEditor( "material", event.newValue, event.oldValue );
                    }
                    else if( event.items[0] is TextureVO )
                    {
						view.showEditor( "texture", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
                    }
					else if( event.items[0] is LightVO )
					{
						view.showEditor( "light", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is LightPickerVO )
					{
						view.showEditor( "lightPicker", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is ShadowMethodVO )
					{
						view.showEditor( "shadowMethod", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is EffectMethodVO )
					{
						view.showEditor( "effectMethod", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is CubeTextureVO )
					{
						view.showEditor( "cubeTexture", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is ShadowMapperVO )
					{
						view.showEditor( "shadowMapper", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is ShadingMethodVO )
					{
						view.showEditor( "shadingMethod", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is GeometryVO )
					{
						view.showEditor( "geometry", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is AnimationSetVO )
					{
						view.showEditor( "animationSet", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is AnimationNodeVO )
					{
						view.showEditor( "animationNode", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is AnimatorVO )
					{
						view.showEditor( "animator", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is SkeletonVO )
					{
						view.showEditor( "skeleton", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is CameraVO )
					{
						view.showEditor( "camera", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
					else if( event.items[0] is LensVO )
					{
						view.showEditor( "lens", event.newValue, event.oldValue );
						view.SetData(event.items[0]);
					}
                    else
                    {
						view.showEditor( "global", event.newValue, event.oldValue );
						view.SetData(document.globalOptions);
                    }
                }
                else
                {
					view.showEditor( "group", event.newValue, event.oldValue );
                }
				view.validateNow();
            }
            else
            {
				view.showEditor( "global", event.newValue, event.oldValue );
				view.SetData(document.globalOptions);
            }
			//if event.oldValue is true it means that we just back from child
			//if event.newValue is true it means that we select child
			if( !(event.oldValue||event.newValue) && view.prevSelected.length ) {
				view.prevSelected = new ArrayCollection();
			}
        }

		
		private function context_deleteHandler(event:SceneEvent):void
		{
			if( (view.data is AssetVO) && !getCurrentIsPresent( view.data as AssetVO ) ) 
			{
				dispatch( new SceneEvent( SceneEvent.SELECT, [] ) );
			}
		}
		private function context_undoHandler(event:UndoRedoEvent):void
		{
			if( (view.data is AssetVO) && !getCurrentIsPresent( view.data as AssetVO ) ) 
			{
				dispatch( new SceneEvent( SceneEvent.SELECT, [] ) );
			}
		}
		
		private function getCurrentIsPresent( asset:AssetVO ):Boolean
		{
			return getAssetIsInList( asset, document.getAllAssets() );
		}
		private function getAssetIsInList( asset:AssetVO, list:Array ):Boolean
		{
			for each ( var item:AssetVO in list )
			{
				if( item.equals( asset ) ) return true;
				
				var container:ContainerVO = item as ContainerVO;
				if( container && container.children && container.children.length )
				{
					if( getAssetIsInList( asset, container.children.source ) ) return true;
				}
			}
			return false;
		}
		private function context_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			updateLists();
		}
		private function updateLists():void
		{
			var nullItem:AssetVO = new AssetVO();
			nullItem.name = "Null";
			nullItem.isNull = true;
			var nullTextureItem:TextureVO = new TextureVO();
			nullTextureItem.name = "Null";
			nullTextureItem.isNull = true;
			
			var asset:AssetVO;
			var lights:Array = [];
			var pickers:Array = [nullItem];
			for each( asset in document.lights )
			{
				if( asset is LightPickerVO ) pickers.push( asset );
				if( asset is LightVO ) 
				{
					if( LightVO(asset).castsShadows ) lights.push( asset );
				}
			}
			view.lightPickers = new ArrayCollection(pickers);
//			view.lights = new ArrayCollection(lights);
			
			var nullableTextures:Array = [nullTextureItem, assets.defaultTexture];
			var defaultableTextures:Array = [assets.defaultTexture];
			var cubeTextures:Array = [assets.defaultCubeTexture];
			for each( asset in document.textures )
			{
				if( asset is TextureVO ) 
				{
					nullableTextures.push( asset );
					defaultableTextures.push( asset );
				}
				if( asset is CubeTextureVO )
				{
					cubeTextures.push( asset );
				}
			}
			view.nullableTextures = new ArrayCollection(nullableTextures);
			view.defaultableTextures = new ArrayCollection(defaultableTextures);
			view.cubeTextures = new ArrayCollection(cubeTextures);
			
			var geometry:Array = [];
			for each( asset in document.geometry )
			{
				if( asset is GeometryVO ) 
				{
					geometry.push( asset );
				}
			}
			view.geometry = new ArrayCollection(geometry);
			
			var animators:Array = [null];
			var vertexAnimationSets:Array = [];
			var skeletonsAnimationSets:Array = [];
			var skeletons:Array = [];
			for each( asset in document.animations )
			{
				
				if( asset is AnimationSetVO ) 
				{
					if( AnimationSetVO( asset ).type == "SkeletonAnimationSet" )
					{
						skeletonsAnimationSets.push( asset );
					}
					if( AnimationSetVO( asset ).type == "VertexAnimationSet" )
					{
						vertexAnimationSets.push( asset );
					}
					
					for each( var animator:AnimatorVO in AnimationSetVO(asset).animators )
					{
						animators.push( animator );
					}
					
				}
				else if( asset is SkeletonVO ) 
				{
					skeletons.push( asset );
				}
			}
			view.animators = new ArrayCollection(animators);
			
			view.vertexAnimationSets = new ArrayCollection(vertexAnimationSets);
			view.skeletonsAnimationSets = new ArrayCollection(skeletonsAnimationSets);
			view.skeletons = new ArrayCollection(skeletons);
			
			var materials:ArrayCollection = new ArrayCollection( document.materials.source.concat() );
			materials.addItemAt( assets.defaultMaterial, 0 );
			view.materials = materials;
		}
    }
}