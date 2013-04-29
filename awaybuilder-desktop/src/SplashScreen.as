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
	
	import mx.core.BitmapAsset;
	import mx.core.SpriteAsset;
	import mx.logging.Log;
	
	public class SplashScreen extends NativeWindow
	{
		[Embed("/assets/Logo.jpg")]
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
			
			this.activate();
			this.width = 500;
			this.height = 250;
			this.x = (Capabilities.screenResolutionX-this.width)/2;
			this.y = (Capabilities.screenResolutionY-this.height)/2;
			
			var image:Sprite = new Sprite();
			this.stage.addChild( image );
			
			image.graphics.beginFill(0x999999);
			image.graphics.drawRect(0,0,500,250);
			
			
//			var asset:BitmapAsset = new Logo();
//			image.addChild( asset );
			
		}
		
	}
}