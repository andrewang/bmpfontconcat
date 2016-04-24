package {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.BitmapChar;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;

	public class StarlingMain extends Sprite {

		private static const CONTENTS_SIZE:Rectangle = new flash.geom.Rectangle(0, 0, 640, 480);

		public static function start(nativeStage:Stage):void {
			trace("Staaling version", Starling.VERSION);
			var starling:Starling = new Starling(
				StarlingMain,
				nativeStage,
				new Rectangle(0, 0, nativeStage.stageWidth, nativeStage.stageHeight)
			);
			starling.skipUnchangedFrames = true;
			starling.showStats = true;
			starling.start();
			nativeStage.addEventListener(Event.RESIZE,_updateViewPort);
			_updateViewPort();
		}
		private static function _updateViewPort(ev:*=null):void {
			var starling:Starling = Starling.current;
			var w:int = starling.nativeStage.stageWidth;
			var h:int = starling.nativeStage.stageHeight;
			starling.viewPort = RectangleUtil.fit(
				CONTENTS_SIZE,
				new flash.geom.Rectangle(0, 0, w, h)
			);
			starling.showStatsAt(Align.LEFT, Align.TOP);
		}

		private var _assetManager:AssetManager;
		public function StarlingMain() {

			_assetManager = new AssetManager();
			_assetManager.verbose = true;

			_assetManager.enqueueWithName('app:/assets/atlas.png');
			_assetManager.enqueueWithName('app:/assets/atlas.xml');
			_assetManager.enqueueWithName('app:/assets/nums1.fnt');
			_assetManager.enqueueWithName('app:/assets/nums2.fnt');
			_assetManager.loadQueue(function(ratio:Number) {
			    if(ratio == 1) {
					_start();
				}
			});
		}

		private function _start():void {

			_addtext('00001111','nums1', 30, 30);
			_addtext('22223333','nums2', 30, 50);
			_addtext('44445555','nums1', 30, 70);
			_addtext('66667777','nums2', 30, 90);

			var image:Image = new Image(_assetManager.getTexture('pappey'));
			image.x = 10;
			image.y = 110;
			image.scaleX = image.scaleY = 0.5;
			addChild(image);

		}

		private function _addtext(txt:String, fontName:String, x:int, y:int, scale:Number=0.5):void {
			var fmt:TextFormat = new TextFormat(fontName, 32, 0xffffff);
			var sp:DisplayObject;
			sp = TextField.getBitmapFont(fontName).createSprite(200, 32, txt, fmt); // こちらで作らないとドローコールが減らない

			//var tf:TextField = new TextField(200,32);
			//tf.autoScale = TextFieldAutoSize.VERTICAL;
			//tf.format = fmt;
			//tf.text = txt;
			//sp = tf;

			sp.x = x;
			sp.y = y;
			sp.scale = scale;
			addChild(sp);

			var char:BitmapChar = TextField.getBitmapFont(fontName).getChar(48); // '0'を取得
			var image:Image = char.createImage();
			var texture:Texture = char.texture;
			image.x = x + 100;
			image.y = y;
			addChild(image);
			trace(image.texture);

		}

	}
}