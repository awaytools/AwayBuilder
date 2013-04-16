package awaybuilder.view.components.editors
{
	import awaybuilder.model.vo.scene.AssetVO;
	import awaybuilder.model.vo.scene.TextureVO;
	
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
		
		private var _data:AssetVO;
		[Bindable]
		public function get data():AssetVO
		{
			return _data;
		}
		public function set data(value:AssetVO):void
		{
			if( value ) {
				_data = value;
			}
			validate( _data );
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
		
		protected function validate( asset:AssetVO ):void 
		{
			
		}
		
		public function Update():void 
		{
			validate( _data );
		}
	}
}