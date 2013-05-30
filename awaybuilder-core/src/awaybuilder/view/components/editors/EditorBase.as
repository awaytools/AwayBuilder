package awaybuilder.view.components.editors
{
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.TextureVO;
	import awaybuilder.view.components.editors.events.PropertyEditorEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;
	import spark.layouts.VerticalLayout;

	public class EditorBase extends Group
	{
		public function EditorBase()
		{
			var l:VerticalLayout = new VerticalLayout();
			l.gap = 0;
			l.horizontalAlign = "center";
			layout = l;
			width = 225;
		}
		
		private var _prevSelected:ArrayCollection = new ArrayCollection; 
		[Bindable]
		public function set prevSelected( value:ArrayCollection ): void
		{
			this._prevSelected = value;
		}
		public function get prevSelected():ArrayCollection
		{
			return this._prevSelected;
		}
		
		private var _data:Object;
		[Bindable]
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			if( value ) {
				_data = value;
			}
			validate( _data );
		}
		
		private var _cubeTextures:ArrayCollection;
		[Bindable]
		public function get cubeTextures():ArrayCollection
		{
			return _cubeTextures;
		}
		public function set cubeTextures(value:ArrayCollection):void
		{
			_cubeTextures = value;
		}
		
		private var _textures:ArrayCollection;
		[Bindable]
		public function get textures():ArrayCollection
		{
			return _textures;
		}
		public function set textures(value:ArrayCollection):void
		{
			_textures = value;
		}
		
		private var _geometry:ArrayCollection;
		[Bindable]
		public function get geometry():ArrayCollection
		{
			return _geometry;
		}
		public function set geometry(value:ArrayCollection):void
		{
			_geometry = value;
		}
		
		private var _animators:ArrayCollection;
		[Bindable]
		public function get animators():ArrayCollection
		{
			return _animators;
		}
		public function set animators(value:ArrayCollection):void
		{
			_animators = value;
		}
		
		private var _skeletons:ArrayCollection;
		[Bindable]
		public function get skeletons():ArrayCollection
		{
			return _skeletons;
		}
		public function set skeletons(value:ArrayCollection):void
		{
			_skeletons = value;
		}
		
		
		private var _lightPickers:ArrayCollection;
		[Bindable]
		public function get lightPickers():ArrayCollection
		{
			return _lightPickers;
		}
		public function set lightPickers(value:ArrayCollection):void
		{
			_lightPickers = value;
		}
		
		protected function validate( asset:Object ):void 
		{
			
		}
		
		public function Update():void 
		{
			validate( _data );
		}
		
		protected function editParentObjectButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new PropertyEditorEvent(PropertyEditorEvent.SHOW_PARENT_MESH_PROPERTIES,  prevSelected.removeItemAt(prevSelected.length-1), true));
		}
	}
}