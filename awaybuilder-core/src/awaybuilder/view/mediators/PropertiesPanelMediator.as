package awaybuilder.view.mediators
{
    import away3d.core.base.Geometry;
    import away3d.entities.Mesh;
    
    import awaybuilder.controller.document.events.ImportTextureEvent;
    import awaybuilder.controller.events.DocumentModelEvent;
    import awaybuilder.controller.scene.events.SceneEvent;
    import awaybuilder.model.IDocumentModel;
    import awaybuilder.model.vo.BitmapTextureVO;
    import awaybuilder.model.vo.ContainerVO;
    import awaybuilder.model.vo.MaterialVO;
    import awaybuilder.model.vo.MeshVO;
    import awaybuilder.model.vo.SubMeshVO;
    import awaybuilder.utils.scene.SceneUtils;
    import awaybuilder.view.components.PropertiesPanel;
    import awaybuilder.view.components.propertyEditors.PropertyEditorEvent;
    
    import org.robotlegs.mvcs.Mediator;

    public class PropertiesPanelMediator extends Mediator
    {
        [Inject]
        public var view:PropertiesPanel;

        [Inject]
        public var document:IDocumentModel;

        override public function onRegister():void
        {
            addContextListener(DocumentModelEvent.DOCUMENT_UPDATED, eventDispatcher_documentUpdatedHandler);
            addContextListener(SceneEvent.SELECT, eventDispatcher_itemsSelectHandler);
            addContextListener(SceneEvent.CHANGING, eventDispatcher_changingHandler);
            addContextListener(SceneEvent.TRANSLATE_OBJECT, eventDispatcher_changeMeshHandler);
            addContextListener(SceneEvent.SCALE_OBJECT, eventDispatcher_changeMeshHandler);
            addContextListener(SceneEvent.ROTATE_OBJECT, eventDispatcher_changeMeshHandler);
            addContextListener(SceneEvent.CHANGE_MESH, eventDispatcher_changeMeshHandler);
			addContextListener(SceneEvent.ADD_NEW_MATERIAL, eventDispatcher_changeMeshHandler);
            addContextListener(SceneEvent.CHANGE_MATERIAL, eventDispatcher_changeMaterialHandler);
			addContextListener(SceneEvent.ADD_NEW_TEXTURE, eventDispatcher_addNewTextureToMaterialHandler);

            addViewListener( PropertyEditorEvent.TRANSLATE, view_translateHandler );
            addViewListener( PropertyEditorEvent.ROTATE, view_rotateHandler );
            addViewListener( PropertyEditorEvent.SCALE, view_scaleHandler );
            addViewListener( PropertyEditorEvent.MESH_CHANGE, view_meshChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_NAME_CHANGE, view_meshNameChangeHandler );
            addViewListener( PropertyEditorEvent.MESH_SUBMESH_CHANGE, view_meshSubmeshChangeHandler );
			addViewListener( PropertyEditorEvent.MESH_SUBMESH_ADD_NEW_MATERIAL, view_submeshAddNewMaterialHandler );
            addViewListener( PropertyEditorEvent.MATERIAL_CHANGE, view_materialChangeHandler );
            addViewListener( PropertyEditorEvent.MATERIAL_NAME_CHANGE, view_materialNameChangeHandler );
            addViewListener( PropertyEditorEvent.SHOW_MATERIAL_PROPERTIES, view_showMaterialPropertiesHandler );
            addViewListener( PropertyEditorEvent.SHOW_TEXTURE_PROPERTIES, view_showTexturePropertiesHandler );
			addViewListener( PropertyEditorEvent.MATERIAL_ADD_NEW_TEXTURE, view_materialAddNewTextureHandler );
			addViewListener( PropertyEditorEvent.REPLACE_TEXTURE, view_replaceTextureHandler );
			
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
            var newValue:MeshVO = new MeshVO( vo.linkedObject as Mesh );
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

        private function view_showMaterialPropertiesHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.SELECT,[event.data]));

        }
        private function view_showTexturePropertiesHandler(event:PropertyEditorEvent):void
        {
            this.dispatch(new SceneEvent(SceneEvent.SELECT,[event.data]));
        }
		
		private function view_materialAddNewTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_ADD,[event.data]));
		}
		private function view_submeshAddNewMaterialHandler(event:PropertyEditorEvent):void
		{
			var vo:MeshVO = view.data as MeshVO;
			var newValue:SubMeshVO =  SubMeshVO(event.data);
			
			newValue.material = SceneUtils.GetMaterialCopy( newValue.material );
			
			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MATERIAL,[view.data], newValue));
//			this.dispatch(new SceneEvent(SceneEvent.ADD_NEW_MATERIAL,[event.data],vo.material));
		}
		private function view_replaceTextureHandler(event:PropertyEditorEvent):void
		{
			this.dispatch(new ImportTextureEvent(ImportTextureEvent.IMPORT_AND_REPLACE,[event.data]));
		}
        //----------------------------------------------------------------------
        //
        //	context handlers
        //
        //----------------------------------------------------------------------

        private function eventDispatcher_documentUpdatedHandler(event:DocumentModelEvent):void
        {

        }

        private function eventDispatcher_changeMeshHandler(event:SceneEvent):void
        {
            var mesh:MeshVO = MeshVO( event.items[0] ).clone();

            for each( var subMesh:SubMeshVO in  mesh.subMeshes )
            {
                subMesh.linkedMaterials = document.materials;
            }

            view.data = mesh;
        }
		
		private function eventDispatcher_addNewTextureToMaterialHandler(event:SceneEvent):void
		{
			var material:MaterialVO = MaterialVO(event.items[0]).clone();
			material.linkedTextures = document.textures;
			view.data = material;
		}
        private function eventDispatcher_changeMaterialHandler(event:SceneEvent):void
        {
			var material:MaterialVO = MaterialVO(event.items[0]).clone();
			material.linkedTextures = document.textures;
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
				view.currentState = "empty";
                return;
            }
            if( event.items.length )
            {
                if( event.items.length == 1 )
                {
                    if( event.items[0] is MeshVO )
                    {
                        var mesh:MeshVO = MeshVO( event.items[0] ).clone();
                        for each( var subMesh:SubMeshVO in  mesh.subMeshes )
                        {
                            subMesh.linkedMaterials = document.materials;
                        }
                        view.data = mesh;
                        view.currentState = "mesh";
						view.collapsed = false;
                    }
                    else if( event.items[0] is ContainerVO )
                    {
                        view.currentState = "container";
                       // view.data = new MeshItemVO( event.items[0] );
                    }
                    else if( event.items[0] is MaterialVO )
                    {
                        var material:MaterialVO = MaterialVO( event.items[0] ).clone();
						material.linkedTextures = document.textures;
                        view.data = material;
                        view.currentState = "material";
						view.collapsed = false;
                    }
                    else if( event.items[0] is BitmapTextureVO )
                    {
                        view.currentState = "texture";
                        view.data = BitmapTextureVO( event.items[0] ).clone();
						view.collapsed = false;
                    }
                    else if( event.items[0] is Geometry )
                    {
                        view.currentState = "geometry";
                    }
                    else
                    {
						view.currentState = "empty";
                    }
                }
                else
                {
                    view.currentState = "group";
                }
				view.validateNow();
            }
            else
            {
				view.currentState = "empty";
            }

        }

    }
}