package
{
	import flash.display.Bitmap;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.BitmapAsset;
	import mx.core.SpriteAsset;
	import mx.logging.Log;
	
	public class SplashScreen extends NativeWindow
	{
		[Embed("/assets/Logo_AwayBuilder_240.png")]
		private const Logo:Class;
		
		public function SplashScreen()
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.resizable = false;
			initOptions.maximizable = false;
			initOptions.minimizable = false;
			initOptions.transparent = true;
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.type = NativeWindowType.LIGHTWEIGHT;
			
			super(initOptions);
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.alwaysInFront = true;
			this.activate();
			this.width = 480;
			this.height = 310;
			this.x = (Capabilities.screenResolutionX-this.width)/2;
			this.y = (Capabilities.screenResolutionY-this.height)/2;
			
			var image:Sprite = new Sprite();
			this.stage.addChild( image );
			
			image.graphics.beginFill(0x323232);
			image.graphics.lineStyle(0, 0xDDDDDD);
			image.graphics.drawRect(0,0,this.width-1,this.height-1);
			
			var asset:BitmapAsset = new Logo();
			image.addChild( asset );
			asset.x = Math.round( (this.width - asset.width)/2 );
			asset.y = Math.round( (this.height - asset.height)/2 );
			
			var defaultTextFormat:TextFormat = new TextFormat("_sans", 10, 0xDDDDDD); 
			var text:TextField = new TextField();
			text.defaultTextFormat = defaultTextFormat;
			text.text = "©2013 The Away Foundation";
			text.width = text.textWidth+8;
			image.addChild( text );
			text.x = this.width - text.width - 10;
			text.y = this.height-23;
		}
		
	}
}