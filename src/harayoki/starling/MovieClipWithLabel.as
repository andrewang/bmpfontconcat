package harayoki.starling
{
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class MovieClipWithLabel extends MovieClip
	{
		private static var _mcCnt:uint;
		
		private var _labels:Vector.<LabelInfo>;
		private var _firstPlaying:Boolean = true;
		private var _currentInfo:LabelInfo;
		private var _id:uint;
		
		public function MovieClipWithLabel(defaultTextures:Vector.<Texture>,fps:Number=12,defaultLabelName:String=null)
		{
			super(defaultTextures, fps);
			if(defaultLabelName)
			{
				addLabel(defaultLabelName,defaultTextures);
			}
			_id = ++_mcCnt;
		}
		
		public function toString():String
		{
			return "[MovieClipWithLabel#"+_id+"]";
		}
		
		public override function dispose():void
		{
			for each(var info:LabelInfo in _labels)
			{
				info.dispose();
			}
			_labels = null;
			super.dispose();
		}
		
		public function addLabel(labelName:String,textures:Vector.<Texture>):void
		{
			if(!_labels)
			{
				_labels = new Vector.<LabelInfo>();
			}
			var info:LabelInfo = _findLabelInfoByName(labelName);
			if(info)
			{
				info.labelName = labelName;
				info.textures = textures;
			}
			else
			{
				info = new LabelInfo(labelName,textures);
				_labels.push(info);
			}
		}
		
		public function gotoAndPlay(labelName:String):void
		{
			var info:LabelInfo = _findLabelInfoByName(labelName);
			if(!info)
			{
				trace(this," no label such as "+labelName);
				//trace(_labels);
				return;
			}
			
			if(info != _currentInfo)
			{
				_currentInfo = info;
				_updateLabelFrames(_currentInfo);
				currentFrame = 0;
				play();
			}
			else
			{
				currentFrame = 0;
				play();
			}
		}
		
		public function gotoAndStop(labelName:String):void
		{
			gotoAndPlay(labelName);
			pause();
		}
		
		public function getLabelNames(returnVector:Vector.<String>=null):Vector.<String>
		{
			if(!returnVector)
			{
				returnVector = new Vector.<String>();
			}
			for(var i:int=0,len:int=_labels.length;i<len;i++)
			{
				returnVector.push(_labels[i].labelName);
			}
			return returnVector;
		}
		
		private function _updateLabelFrames(info:LabelInfo):void
		{
			//addFrame,removeFrameは計算量が多いので、できる限りnumFramesを使う
			for(var i:int=0;i<info.textures.length;i++)
			{
				if(i<numFrames)
				{
					setFrameTexture(i,info.textures[i]);
				}
				else
				{
					addFrame(info.textures[i]);
				}
			}
			while(info.textures.length<numFrames)
			{
				removeFrameAt(numFrames-1);
			}
		}
		
		private function _findLabelInfoByName(name:String):LabelInfo
		{
			for each(var info:LabelInfo in _labels)
			{
				if(info.labelName == name)
				{
					return info;
				}
			}
			return null;
		}
		
	}
}
import starling.textures.Texture;

internal class LabelInfo
{
	public var labelName:String;
	public var textures:Vector.<Texture>;
	public function LabelInfo(labelName:String,textures:Vector.<Texture>)
	{
		this.labelName = labelName;
		this.textures = textures;
	}
	public function toString():String
	{
		return "[LabelInfo:"+labelName+"]";
	}
	public function dispose():void
	{
		textures = null;
	}
}