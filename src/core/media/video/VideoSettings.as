package core.media.video 
{
	import core.data.settings.Settings;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public dynamic class VideoSettings extends Settings
	{
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: properties
		
				
				
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoSettings(serverName:String = '', streamName:String = '', width:Number = 320, height:Number = 240, quality:int = 90, fps:int = 25) 
			{
				super();
				_data.serverName		= serverName;
				_data.streamName		= streamName;
				_data.width				= width;
				_data.height			= height;
				_data.quality			= quality;
				_data.fps				= fps;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
		
			public function get serverName():String { return _data.serverName; }
			public function set serverName(value:String):void 
			{
				set('serverName', value);
			}

			public function get streamName():String { return _data.streamName; }
			public function set streamName(value:String):void 
			{
				set('streamName', value);
			}

			public function get username():String { return _data.username; }
			public function set username(value:String):void 
			{
				set('username', value);
			}

			public function get password():String { return _data.password; }
			public function set password(value:String):void 
			{
				set('password', value);
			}

			public function get width():Number { return _data.width; }
			public function set width(value:Number):void 
			{
				set('width', value);
			}

			public function get height():Number { return _data.height; }
			public function set height(value:Number):void 
			{
				set('height', value);
			}

			public function get quality():int { return _data.quality; }
			public function set quality(value:int):void 
			{
				set('quality', value);
			}

			public function get fps():int { return _data.fps; }
			public function set fps(value:int):void 
			{
				set('fps', value);
			}
			
			public function get format():String { return _data.format; }
			public function set format(value:String):void 
			{
				set('format', value);
			}


		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			override public function toString():String 
			{
				return super.toString().replace('Settings', 'VideoSettings');
			}
		
	}

}