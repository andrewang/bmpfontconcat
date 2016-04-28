package harayoki.starling {
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class MyStats extends Sprite {

		private var _fontName:String;
		private var _active:Boolean = false;
		private var _digits:Vector.<Digit>;
		private var _textureSmoothing:String;

		public function MyStats(fontName:String, textureSmoothing:String) {
			_fontName = fontName;
			_textureSmoothing = textureSmoothing;
			_digits = new <Digit>[];
			_digits.push(_createDigit(0));
			_digits.push(_createDigit(1));
			_digits.push(_createDigit(2));
			addEventListener(Event.ADDED_TO_STAGE, _start);
			addEventListener(Event.REMOVED_FROM_STAGE, _stop);
		}

		public override function dispose():void {
			_stop();
			for each(var d:Digit in _digits) {
				d.dispose();
			}
			_digits = null;
			super.dispose();
		}

		private function _createDigit(index:int): Digit {
			var digit:Digit = new Digit(_fontName, _textureSmoothing);
			digit.mc.x = index * digit.mc.width;
			addChild(digit.mc);
			return digit;
		}

		private function _start(ev:Event=null):void {
			if(_active) {
				return;
			}
			_active = true;
			Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, _update);
		}
		private function _stop(ev:Event=null):void {
			if(!_active) {
				return;
			}
			_active = false;
			Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, _update);
		}
		private function _update(ev:Event):void {
			var drawCount:int = Starling.current.painter.drawCount;
			drawCount = drawCount > 999 ? 999 : drawCount;
			var s:String = '';
			var counts:String = '' + drawCount;
			for(var i:int = 0; i < 3 ; i++) {
				s = counts.charAt(i);
				_digits[i].changeNum(s);
			}
		}

	}
}

import harayoki.starling.MovieClipWithLabel;

import starling.text.BitmapChar;
import starling.text.BitmapFont;

import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

internal class Digit {
	private var _lastLabel:String;
	public var mc:MovieClipWithLabel;
	public function Digit(fontName:String, textureSmoothing:String) {
		for(var i:int=0; i<10; i++) {
			var fnt:BitmapFont = TextField.getBitmapFont(fontName);
			var texture:Texture;
			if(fnt) {
				var char:BitmapChar = fnt.getChar(i + 48);
				if(char) {
					texture = char.texture;
				}
			}
			if(!texture) {
				texture = Texture.empty(1,1);
			}
			if(!mc) {
				mc = new MovieClipWithLabel(new <Texture>[texture], 1, '' + i);
				mc.textureSmoothing = textureSmoothing;
			} else {
				mc.addLabel('' + i, new <Texture>[texture]);
			}
		}
		changeNum(0 + '');
	}
	public function dispose():void {
		if (mc) {
			mc.dispose();
		}
		mc = null;
	}
	public function changeNum(numStr:String = ''):void {
		if(_lastLabel === numStr) {
			return;
		}
		_lastLabel = numStr;
		if(mc) {
			if(_lastLabel.length > 0) {
				mc.visible = true;
				mc.gotoAndPlay('' + _lastLabel);
			} else {
				mc.visible = false;
			}
		}
 	}
}
