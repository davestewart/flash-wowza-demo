package display.video {
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class NetstreamVideo extends Sprite 
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
		
			public function NetstreamVideo(width:int = 320, height:int = 240, connection:NetConnection = null) 
			{
				super();
				build(width, height);
				if (connection)
				{
					connect(connection);
				};
			}
		
			protected function initialize():void 
			{
				
			}
		
			protected function build(width:int = 320, height:int = 240):void 
			{
				video = new Video(width, height);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function connect(connection:NetConnection):void 
			{
				_connection = connection;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
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
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}