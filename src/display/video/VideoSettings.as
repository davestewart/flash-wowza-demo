package display.video 
{
	import data.settings.Settings;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class VideoSettings extends Settings
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: properties
		
			protected var _serverName		:String;
			protected var _streamName		:String;
			protected var _width			:Number;
			protected var _height			:Number;
			protected var _quality			:String;
			protected var _fps				:int;
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoSettings(serverName:String = '', streamName:String = '', width:Number = 320, height:Number = 240, quality:int = 90, fps:int = 25) 
			{
				_serverName		= serverName;
				_streamName		= streamName;
				_width			= width;
				_height			= height;
				_quality		= quality;
				_fps			= fps;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
		
			public function get serverName():String { return _serverName; }
			public function set serverName(value:String):void 
			{
				set('serverName', value);
			}

			public function get streamName():String { return _streamName; }
			public function set streamName(value:String):void 
			{
				set('streamName', value);
			}

			public function get width():Number { return _width; }
			public function set width(value:Number):void 
			{
				set('width', value);
			}

			public function get height():Number { return _height; }
			public function set height(value:Number):void 
			{
				set('height', value);
			}

			public function get quality():String { return _quality; }
			public function set quality(value:String):void 
			{
				set('quality', value);
			}

			public function get fps():int { return _fps; }
			public function set fps(value:int):void 
			{
				set('fps', value);
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function toString():void 
			{
				return format('VideoSettings', 'serverName', 'streamName', 'width', 'height', 'quality', 'fps');
			}
		
	}

}