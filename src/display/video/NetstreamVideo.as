package display.video 
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import assets.SettingsAsset;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class NetStreamVideo extends Sprite 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var video						:Video;
				
			// properties
				protected var _connection				:NetConnection;             
				protected var _stream					:NetStream;             
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function NetStreamVideo(width:int = 320, height:int = 240, connection:NetConnection = null) 
			{
				super();
				build(width, height);
				if (connection)
				{
					this.connection = connection;
				};
			}
		
			protected function initialize():void 
			{
				
			}
		
			protected function build(width:int = 320, height:int = 240):void 
			{
				video = new Video(width, height);
			}
			
			protected function reset():void 
			{
				
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function set connection(connection:NetConnection):void 
			{
				if (_connection)
				{
					
				}
				
				if(connection == null)
				{
					
				}
				else
				{
					_connection = connection;
				}
			}
			
		
			override public function set width(value:Number):void 
			{
				video.width = value;
			}
			
			override public function set height(value:Number):void 
			{
				video.height = value;
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function flipVideo():void
			{
				if (video.scaleX > 0)
				{
					video.scaleX	= -video.scaleX;
					video.x			+= video.width;
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}