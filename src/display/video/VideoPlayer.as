package display.video {

	import display.video.NetStreamVideo;
	
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
	 * Instantiates a basic NetStreamVideo, then manages playback
	 * 
	 * @author Dave Stewart
	 */
	public class VideoPlayer extends NetStreamVideo 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
			
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoPlayer(width:int = 320, height:int = 240, connection:NetConnection = null)
			{
				super(width, height, connection);
			}
		
			override protected function initialize():void 
			{
				
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			protected function startPlaying():void
			{
				// debug
					trace("doPlayStart");
				
				// each time we play a video create a new NetStream object
					stream = new NetStream(connection);
					stream.addEventListener(NetStatusEvent.NET_STATUS, onStreamPlayStatus);
					
				// client
					stream.client = this;

				// set the buffer time to 2 seconds
					stream.bufferTime = 2;

				// attach the NetStream object to the right most video object
					video.attachNetStream(stream);
				
				// play the movie you just recorded
					stream.play(settings.streamName);
				
				// UI
					btnSubscribe.label = 'Stop';
			}

			protected function stopPlaying():void
			{
				// when you hit stop disconnect from the NetStream object and clear the video player
					video.attachNetStream(null);
					video.clear();
					
					if (stream != null)
						stream.close();
					stream = null;
					
					btnSubscribe.label = 'Play';
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		

			protected function onStreamPlayStatus(event:NetStatusEvent):void
			{
				trace("stream: onStatus: "+event.info.code+" ("+event.info.description+")");
				if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
				{
					tfPrompt.text = event.info.description;
				}
			}
					
			protected function onPlayStatus(event:Object):void
			{
				trace("stream: onPlayStatus: "+event.code+" ("+event.description+")");
				if (event.code == "NetStream.Play.Complete")
				{
					stopPlaying();
				}
			}

			protected function onMetaData(event:Object) :void
			{
				trace("onMetaData");
				
				// print debug information about the metaData
				for (var propName:String in event)
				{
					trace("  "+propName + " = " + event[propName]);
				}
			}						
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}