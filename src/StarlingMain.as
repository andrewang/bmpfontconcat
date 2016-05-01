package {
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;

	import harayoki.starling.MyStats;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.text.TextOptions;
	import starling.textures.TextureSmoothing;
	import starling.utils.Align;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class StarlingMain extends Sprite {

		private static const CONTENTS_SIZE:Rectangle = new flash.geom.Rectangle(0, 0, 320, 224);
		// private static const ASPECT_RATIO:Number = 0.9;
		// private static const CONTENTS_SIZE2:Rectangle = new flash.geom.Rectangle(0, 0, 320 * ASPECT_RATIO, 224);

		// msx:256 famicom:256 pc80:320 PCEngine:256,320,336,512
		// msx:212(192) famicom:224 pc80:200 PCEngine:240(実質224)

		public static function start(nativeStage:Stage):void {
			trace("Staaling version", Starling.VERSION);

			var starling:Starling = new Starling(
				StarlingMain,
				nativeStage,
				CONTENTS_SIZE
			);
			starling.skipUnchangedFrames = true;
			starling.antiAliasing = 0;
			starling.start();
			starling.stage.color = 0x111111;
			nativeStage.addEventListener(Event.RESIZE,_updateViewPort);
			_updateViewPort();
		}
		private static function _updateViewPort(ev:*=null):void {
			var starling:Starling = Starling.current;
			var w:int = starling.nativeStage.stageWidth;
			var h:int = starling.nativeStage.stageHeight;
			var scale:Number = Math.min(w/CONTENTS_SIZE.width,h/CONTENTS_SIZE.height);
			if(scale > 1.0) scale = Math.floor(scale); //0になるとエラー
			trace('scale to', scale);
			starling.viewPort = RectangleUtil.fit(
				CONTENTS_SIZE,
				new Rectangle((w - CONTENTS_SIZE.width*scale)>>1, (h - CONTENTS_SIZE.height*scale)>>1, CONTENTS_SIZE.width*scale,CONTENTS_SIZE.height*scale),
				ScaleMode.SHOW_ALL
			);

			starling.showStats = true;
			starling.showStatsAt(Align.RIGHT, Align.BOTTOM);

		}

		private var _assetManager:AssetManager;
		public function StarlingMain() {

			_assetManager = new AssetManager();
			_assetManager.verbose = true;

			_assetManager.enqueueWithName('app:/assets/atlas.png');
			_assetManager.enqueueWithName('app:/assets/atlas.xml');
			_assetManager.enqueueWithName('app:/assets/nums1.fnt');
			_assetManager.enqueueWithName('app:/assets/nums2.fnt');
			_assetManager.enqueueWithName('app:/assets/testFont.fnt');
			_assetManager.enqueueWithName('app:/assets/testAIUEO.fnt');
			_assetManager.loadQueue(function(ratio:Number):void {
			    if(ratio == 1) {
					_start();
				}
			});
		}

		private function _start():void {

			_addtext('あいうえおうおい','testAIUEO', 10, 10, 28);
			_addtext('00001111','nums1', 10, 30);
			_addtext('22223333','nums2', 10, 50);
			_addtext('44445555','nums1', 10, 70);
			_addtext('66667777','testFont', 10, 90, 28);

			var image:Image = new Image(_assetManager.getTexture('pappey'));
			image.x = 200;
			image.y = 10;
			image.scaleX = image.scaleY = 1;
			image.textureSmoothing = TextureSmoothing.NONE;
			addChild(image);

			var myStats:MyStats = new MyStats('testFont', TextureSmoothing.NONE);
			myStats.x = 200;
			myStats.y = 10;
			myStats.scale = 2.0;
			addChild(myStats);


		}

		private function _addtext(txt:String, fontName:String, x:int, y:int, size:int=32, scale:Number=0.5):void {
			var fmt:TextFormat = new TextFormat(fontName, size, 0xffffff);
			fmt.horizontalAlign = TextFormatAlign.LEFT;
			var opt:TextOptions = new TextOptions(true, false);
			var sp:Sprite;
			sp = TextField.getBitmapFont(fontName).createSprite(200, size, txt, fmt, opt); // こちらで作らないとドローコールが減らない
			var i:int = sp.numChildren;
			while(i--) {
				if(sp.getChildAt(i) is Image) {
					Image(sp.getChildAt(i)).textureSmoothing =TextureSmoothing.NONE;
				}
			}

			//var tf:TextField = new TextField(200,32);
			//tf.autoScale = TextFieldAutoSize.VERTICAL;
			//tf.format = fmt;
			//tf.text = txt;
			//tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			//sp = tf;

			sp.x = x;
			sp.y = y;
			sp.scale = scale;
			addChild(sp);

			//var char:BitmapChar = TextField.getBitmapFont(fontName).getChar(48); // '0'を取得
			//var image:Image = char.createImage();
			//var texture:Texture = char.texture;
			//image.x = x + 100;
			//image.y = y;
			//addChild(image);

		}

	}
}