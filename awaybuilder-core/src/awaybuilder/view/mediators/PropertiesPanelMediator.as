package awaybuilder.view.mediators
{
    import away3d.entities.Mesh;
    
    import awaybuilder.controller.document.events.ImportTextureEvent;
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.AssetsModel;
    import awaybuilder.model.DocumentModel;
    import awaybuilder.model.vo.scene.AssetVO;
    import awaybuilder.model.vo.scene.ContainerVO;
    import awaybuilder.model.vo.scene.CubeTextureVO;
    import awaybuilder.model.vo.scene.EffectMethodVO;
    import awaybuilder.model.vo.scene.GeometryVO;
    import awaybuilder.model.vo.scene.LightPickerVO;
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ShadingMethodVO;
    import awaybuilder.model.vo.scene.ShadowMapperVO;
    import awaybuilder.model.vo.scene.ShadowMethodVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.model.vo.scene.TextureVO;
    import awaybuilder.utils.AssetUtil;
    import awaybuilder.view.components.PropertiesPanel;
    import awaybuilder.view.components.editors.events.PropertyEditorEvent;
    
    import flash.utils.getTimer;
    
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
			addContextListener(SceneEvent.CHANGE_GLOBAL_OPTIONS, context_simpleUpdateHandler);
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_addNewMaterialToSubmeshHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHTPICKER, eventDispatcher_addNewLightpickerToMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHT, eventDispatcher_addNewLightToLightpickerHandler);
			addContextListener(SceneEvent.ADD_NEW_SHADOW_METHOD, eventDispatcher_addNewMethodHandler);
			addContextListener(SceneEvent.ADD_NEW_EFFECT_METHOD, eventDispatcher_addNewMethodHandler);
			
			addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, context_documentUpdatedHandler);

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
			
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_CHANGE, view_shadingmethodChangeHandler );
			addViewListener( PropertyEditorEvent.SHADINGMETHOD_STEPPER_CHANGE, view_shadingmethodChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.SHADOWMAPPER_CHANGE, view_shadowmapperChangeHandler );
			addViewListener( PropertyEditorEvent.SHADOWMAPPER_STEPPER_CHANGE, view_shadowmapperChangeStepperHandler );
			
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_CHANGE, view_effectmethodChangeHandler );
			addViewListener( PropertyEditorEvent.EFFECTMETHOD_STEPPER_CHANGE, view_effectmethodChangeStepperHandler );
			
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
		
		private function view_effectmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_EFFECT_METHOD,[view.data], event.data));
		}
		private function view_effectmethodChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_EFFECT_METHOD,[view.data], event.data, true));
		}
		
		private function view_shadowmapperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_MAPPER,[view.data], event.data));
		}
		private function view_shadowmapperChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_MAPPER,[view.data], event.data, true));
		}
		
		private function view_shadowmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_METHOD,[view.data], event.data));
		}
		private function view_shadowmethodChangeStepperHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADOW_METHOD,[view.data], event.data, true));
		}
		private function view_shadingmethodChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_SHADING_METHOD,[view.data], event.data));
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
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_REPLACE,[event.data]));
		}
		private function view_replaceCubeTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_REPLACE,[view.data],event.data));
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
		
		
        //----------------------------------------------------------------------
        //
        //	context handlers
        //
        //----------------------------------------------------------------------

		
		private function context_simpleUpdateHandler(event:SceneEvent):void
		{
			view.SetData( event.items[0] );
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

		private function context_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			var nullItem:AssetVO = new AssetVO();
			nullItem.name = "Null";
			nullItem.isNull = true;
			var nullTextureItem:TextureVO = new TextureVO();
			nullTextureItem.name = "Null";
			nullTextureItem.isNull = true;
			var asset:AssetVO;
			var lights:ArrayCollection = new ArrayCollection();
			var pickers:ArrayCollection = new ArrayCollection();
			pickers.addItem( nullItem );
			for each( asset in document.lights )
			{
				if( asset is LightPickerVO ) pickers.addItem( asset );
				if( asset is LightVO ) 
				{
					if( LightVO(asset).castsShadows ) lights.addItem( asset );
				}
			}
			view.lightPickers = pickers;
			view.lights = lights;
			
			var textures:ArrayCollection = new ArrayCollection();
			textures.addItem( nullTextureItem );
			
			var cubeTextures:ArrayCollection = new ArrayCollection();
			cubeTextures.addItem( nullTextureItem );
			
			textures.addItemAt( assets.GetDefaultTexture(), 1 );
			cubeTextures.addItemAt( assets.GetDefaultCubeTexture(), 1 );
			
			for each( asset in document.textures )
			{
				if( asset is TextureVO ) 
				{
					textures.addItem( asset );
				}
				if( asset in CubeTextureVO )
				{
					cubeTextures.addItem( asset );
				}
					
			}
			view.textures = textures;
			view.cubeTextures = cubeTextures;
			
			var materials:ArrayCollection = new ArrayCollection( document.materials.source.concat() );
			materials.addItemAt( assets.GetDefaultMaterial(), 0 );
			view.materials = materials;
		}
    }
}