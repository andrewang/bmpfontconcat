package {

import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class Main extends Sprite {
        public function Main() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.quality = StageQuality.LOW;
			stage.color = 0x111111;
			addEventListener(Event.ADDED_TO_STAGE, _init);
			
		}

		private function _init(ev:Event=null):void {

			StarlingMain.start(stage);

        }
    }
}

