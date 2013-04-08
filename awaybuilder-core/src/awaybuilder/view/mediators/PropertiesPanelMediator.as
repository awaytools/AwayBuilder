package awaybuilder.view.mediators
{
    import away3d.core.base.Geometry;
    import away3d.entities.Mesh;
    import away3d.materials.SinglePassMaterialBase;
    import away3d.materials.lightpickers.StaticLightPicker;
    
    import awaybuilder.controller.document.events.ImportTextureEvent;
    import awaybuilder.controller.events.DocumentEvent;
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.scene.AssetVO;
    import awaybuilder.model.vo.scene.ContainerVO;
    import awaybuilder.model.vo.scene.LightPickerVO;
    import awaybuilder.model.vo.scene.LightVO;
    import awaybuilder.model.vo.scene.MaterialVO;
    import awaybuilder.model.vo.scene.MeshVO;
    import awaybuilder.model.vo.scene.ObjectVO;
    import awaybuilder.model.vo.scene.SubMeshVO;
    import awaybuilder.model.vo.scene.TextureVO;
    import awaybuilder.utils.scene.SceneUtils;
    import awaybuilder.view.components.PropertiesPanel;
    import awaybuilder.view.components.editors.AddEffectMethodPopup;
    import awaybuilder.view.components.editors.events.PropertyEditorEvent;
    
    import flash.utils.getTimer;
    
    import mx.collections.ArrayCollection;
    import mx.events.CloseEvent;
    
    import org.robotlegs.mvcs.Mediator;

    public class PropertiesPanelMediator extends Mediator
    {
        [Inject]
        public var view:PropertiesPanel;

        [Inject]
        public var document:IDocumentModel;

        override public function onRegister():void
        {
            addContextListener(SceneEvent.SELECT, eventDispatcher_itemsSelectHandler);
            addContextListener(SceneEvent.CHANGING, eventDispatcher_changingHandler);
            addContextListener(SceneEvent.TRANSLATE_OBJECT, eventDispatcher_translateHandler);
            addContextListener(SceneEvent.SCALE_OBJECT, eventDispatcher_translateHandler);
            addContextListener(SceneEvent.ROTATE_OBJECT, eventDispatcher_translateHandler);
            addContextListener(SceneEvent.CHANGE_MESH, eventDispatcher_changeMeshHandler);
			addContextListener(SceneEvent.CHANGE_LIGHT, eventDispatcher_changeLightHandler);
            addContextListener(SceneEvent.CHANGE_MATERIAL, eventDispatcher_changeMaterialHandler);
			addContextListener(SceneEvent.CHANGE_LIGHTPICKER, eventDispatcher_changeLightPickerHandler);
			
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureToMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_addNewMaterialToSubmeshHandler);
			addContextListener(SceneEvent.ADD_NEW_LIGHTPICKER, eventDispatcher_addNewLightpickerToMaterialHandler);
			
			addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, context_documentUpdatedHandler);

            addViewListener( PropertyEditorEvent.TRANSLATE, view_translateHandler );
            addViewListener( PropertyEditorEvent.ROTATE, view_rotateHandler );
            addViewListener( PropertyEditorEvent.SCALE, view_scaleHandler );
            addViewListener( PropertyEditorEvent.MESH_CHANGE, view_meshChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_NAME_CHANGE, view_meshNameChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_SUBMESH_CHANGE, view_meshSubmeshChangeHandler );
			addViewListener( PropertyEditorEvent.MESH_SUBMESH_ADD_NEW_MATERIAL, view_submeshAddNewMaterialHandler );
            addViewListener( PropertyEditorEvent.MATERIAL_CHANGE, view_materialChangeHandler );
            addViewListener( PropertyEditorEvent.MATERIAL_NAME_CHANGE, view_materialNameChangeHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_DIFFUSE_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_NORMAL_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_AMBIENT_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_SPECULAR_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_EFFECT_METHOD, view_materialAddEffectMetodHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_LIGHTPICKER, view_materialAddLightpickerHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_REMOVE_EFFECT_METHOD, view_materialRemoveEffectMetodHandler );
			addViewListener( PropertyEditorEvent.REPLACE_TEXTURE, view_replaceTextureHandler );
			
			addViewListener( PropertyEditorEvent.LIGHT_POSITION_CHANGE, view_lightPositionChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHT_STEPPER_CHANGE, view_lightStepperChangeHandler );
			
			addViewListener( PropertyEditorEvent.LIGHT_CHANGE, view_lightChangeHandler );
			
			addViewListener( PropertyEditorEvent.LIGHTPICKER_CHANGE, view_lightPickerChangeHandler );
			addViewListener( PropertyEditorEvent.LIGHTPICKER_STEPPER_CHANGE, view_lightPickerStepperChangeHandler );
			
			addViewListener( PropertyEditorEvent.SHOW_CHILD_PROPERTIES, view_showChildObjectPropertiesHandler );
			
			addViewListener( PropertyEditorEvent.SHOW_PARENT_MESH_PROPERTIES, view_showParentMeshHandler );
			addViewListener( PropertyEditorEvent.SHOW_PARENT_MATERIAL_PROPERTIES, view_showParentMaterialHandler );
			
			view.currentState = "empty";
        }

        //----------------------------------------------------------------------
        //
        //	view handlers
        //
        //----------------------------------------------------------------------


        private function view_translateHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[document.getSceneObject(view.data.linkedObject)], event.data, true));
        }
        private function view_rotateHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.ROTATE_OBJECT,[document.getSceneObject(view.data.linkedObject)], event.data, true));
        }
        private function view_scaleHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.SCALE_OBJECT,[document.getSceneObject(view.data.linkedObject)], event.data, true));
        }
        private function view_meshChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], event.data));
        }
        private function view_meshNameChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], event.data, true));
        }
        private function view_meshSubmeshChangeHandler(event:PropertyEditorEvent):void
        {
            var vo:MeshVO = view.data as MeshVO;
            var newValue:MeshVO = vo.clone() as MeshVO;
            for each( var subMesh:SubMeshVO in newValue.subMeshes )
            {
                if( subMesh.linkedObject == SubMeshVO(event.data).linkedObject )
                {
                    subMesh.material = SubMeshVO(event.data).material;
                }
            }
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MESH,[view.data], newValue));
        }
        private function view_materialChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], event.data));
        }
        private function view_materialNameChangeHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], event.data, true));
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
		
		
		private function view_materialAddNewTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[event.data]));
		}
		private function view_materialAddLightpickerHandler(event:PropertyEditorEvent):void
		{
			var newValue:MaterialVO = MaterialVO(event.data);
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_LIGHTPICKER,[newValue], new LightPickerVO( new StaticLightPicker([]) )));
		}
		
		private function view_materialAddEffectMetodHandler(event:PropertyEditorEvent):void
		{
			AddEffectMethodPopup.show( addEffectMethodPopup_closeHandler );
		}
		private function view_materialRemoveEffectMetodHandler(event:PropertyEditorEvent):void
		{
			var material:MaterialVO = MaterialVO(view.data).clone();
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
		private function addEffectMethodPopup_closeHandler( event:CloseEvent ):void
		{
			var popup:AddEffectMethodPopup = event.target as AddEffectMethodPopup;
			if( popup.selectedEffect ) 
			{
				var material:MaterialVO = MaterialVO(view.data).clone();
				material.effectMethods.addItem( popup.selectedEffect );
				this.dispatch(new SceneEvent(SceneEvent.CHANGE_MATERIAL,[view.data], material));
			}
		}
		
		
		private function view_submeshAddNewMaterialHandler(event:PropertyEditorEvent):void
		{
			var newValue:SubMeshVO = SubMeshVO(event.data);
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MATERIAL,[newValue], SceneUtils.GetMaterialCopy( newValue.material )));
		}
		private function view_replaceTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_REPLACE,[event.data]));
		}
		
		private function view_lightPositionChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.TRANSLATE_OBJECT,[view.data], event.data, true));
		}
		private function view_lightChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT,[view.data], event.data));
		}
		private function view_lightStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHT, [view.data], event.data, true));
		}
		
		private function view_lightPickerChangeHandler(event:PropertyEditorEvent):void
		{
			trace( "view_lightPickerChangeHandler" );
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHTPICKER,[view.data], event.data));
		}
		private function view_lightPickerStepperChangeHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new SceneEvent(SceneEvent.CHANGE_LIGHTPICKER, [view.data], event.data, true));
		}
		
		
        //----------------------------------------------------------------------
        //
        //	context handlers
        //
        //----------------------------------------------------------------------

		
		private function eventDispatcher_translateHandler(event:SceneEvent):void
		{
			var o:ObjectVO = ObjectVO( event.items[0] ).clone();
			view.data = o;
		}
		
		private function eventDispatcher_changeLightHandler(event:SceneEvent):void
		{
			view.data = LightVO( event.items[0] ).clone();
		}
		private function eventDispatcher_changeLightPickerHandler(event:SceneEvent):void
		{
			view.data = LightPickerVO( event.items[0] ).clone();
		}
		
        private function eventDispatcher_changeMeshHandler(event:SceneEvent):void
        {
            var mesh:MeshVO = MeshVO( event.items[0] ).clone() as MeshVO;

            for each( var subMesh:SubMeshVO in  mesh.subMeshes )
            {
                subMesh.linkedMaterials = document.materials;
            }

            view.data = mesh;
        }
		
		private function eventDispatcher_addNewLightpickerToMaterialHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length )
			{
				var material:MaterialVO = MaterialVO(document.getMaterial(event.items[0].linkedObject)).clone();
				view.textures = document.textures;
				view.data = material;
			}
		}
		private function eventDispatcher_addNewMaterialToSubmeshHandler(event:SceneEvent):void
		{
			var subMesh:SubMeshVO = SubMeshVO( event.items[0] );
			var mesh:MeshVO = subMesh.parentMesh.clone() as MeshVO;
			for each( var o:SubMeshVO in mesh.subMeshes )
			{
				o.linkedMaterials = document.materials;
			}
			
			view.data = mesh;
		}
		
		
		private function eventDispatcher_addNewTextureToMaterialHandler(event:SceneEvent):void
		{
			if( event.items && event.items.length && view.currentState=="material" )
			{
				var material:MaterialVO = MaterialVO(event.items[0]).clone();
				view.textures = document.textures;
				view.data = material;
			}
		}
        private function eventDispatcher_changeMaterialHandler(event:SceneEvent):void
        {
			var material:MaterialVO = MaterialVO(event.items[0]).clone();
			view.textures = document.textures;
			view.data = material;
        }
        private function eventDispatcher_changingHandler(event:SceneEvent):void
        {
            var mesh:Mesh = MeshVO(event.items[0]).linkedObject as Mesh;
            var vo:MeshVO = view.data as MeshVO;
            vo.x = mesh.x;
            vo.y = mesh.y;
            vo.z = mesh.z;

            vo.scaleX = mesh.scaleX;
            vo.scaleY = mesh.scaleY;
            vo.scaleZ = mesh.scaleZ;

            vo.rotationX = mesh.rotationX;
            vo.rotationY = mesh.rotationY;
            vo.rotationZ = mesh.rotationZ;

        }
        private function eventDispatcher_itemsSelectHandler(event:SceneEvent):void
        {
			
            if( !event.items || event.items.length == 0)
            {
				view.showEditor( "empty", event.newValue, event.oldValue );
				view.collapsed = true;
                return;
            }
            if( event.items.length )
            {
                if( event.items.length == 1 )
                {
                    if( event.items[0] is MeshVO )
                    {
						var t:Number = getTimer();
                        var mesh:MeshVO = MeshVO( event.items[0] ).clone() as MeshVO;
                        for each( var subMesh:SubMeshVO in  mesh.subMeshes )
                        {
                            subMesh.linkedMaterials = document.materials;
                        }
                        view.data = mesh;
						view.showEditor( "mesh", event.newValue, event.oldValue );
                    }
                    else if( event.items[0] is ContainerVO )
                    {
						view.showEditor( "container", event.newValue, event.oldValue );
                        view.data = ContainerVO( event.items[0] ).clone();
                    }
                    else if( event.items[0] is MaterialVO )
                    {
                        var material:MaterialVO = MaterialVO( event.items[0] ).clone();
						view.textures = document.textures;
                        view.data = material;
						view.showEditor( "material", event.newValue, event.oldValue );
						
                    }
                    else if( event.items[0] is TextureVO )
                    {
						view.showEditor( "texture", event.newValue, event.oldValue );
                        view.data = TextureVO( event.items[0] ).clone();
                    }
					else if( event.items[0] is LightVO )
					{
						view.showEditor( "light", event.newValue, event.oldValue );
						view.data = LightVO( event.items[0] ).clone();
					}
					else if( event.items[0] is LightPickerVO )
					{
						view.showEditor( "lightPicker", event.newValue, event.oldValue );
						view.data = LightPickerVO( event.items[0] ).clone();
					}
//                    else if( event.items[0] is Geometry )
//                    {
//                        view.currentState = "geometry";
//                    }
                    else
                    {
						view.showEditor( "empty", event.newValue, event.oldValue );
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
				view.showEditor( "empty", event.newValue, event.oldValue );
            }
			//if event.oldValue is true it means that we just back from child
			//if event.newValue is true it means that we select child
			if( !(event.oldValue||event.newValue) && view.prevSelected.length ) {
				view.prevSelected = new ArrayCollection();
			}
        }

		private function context_documentUpdatedHandler(event:DocumentModelEvent):void
		{
			var pickers:ArrayCollection = new ArrayCollection();
			for each( var asset:AssetVO in document.lights )
			{
				if( asset is LightPickerVO ) pickers.addItem( asset );
			}
			view.lightPickers = pickers;
			trace( "view.lightPickers = " + view.lightPickers );
		}
    }
}