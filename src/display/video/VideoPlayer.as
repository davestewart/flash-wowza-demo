package display.video {

	import display.video.NetStreamVideo;
	
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
			
				initialize();
			}
		
			protected function initialize():void 
			{
				
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			protected function startPlaying():void
			{
				trace("doPlayStart");
				
				// each time we play a video create a new NetStream object
					nsPlay = new NetStream(connection);
					nsPlay.addEventListener(NetStatusEvent.NET_STATUS, onStreamPlayStatus);
					
					var nsPlayClient:Object = new Object();
					nsPlay.client = nsPlayClient;

				// trace the NetStream play status information
					nsPlayClient.onPlayStatus = function(infoObject:Object):void
					{
						trace("nsPlay: onPlayStatus: "+infoObject.code+" ("+infoObject.description+")");
						if (infoObject.code == "NetStream.Play.Complete")
						{
							stopPlaying();
						}
					}

					nsPlayClient.onMetaData = function(infoObject:Object) :void
					{
						trace("onMetaData");
						
						// print debug information about the metaData
						for (var propName:String in infoObject)
						{
							trace("  "+propName + " = " + infoObject[propName]);
						}
					};		

				// set the buffer time to 2 seconds
					nsPlay.bufferTime = 2;

				// attach the NetStream object to the right most video object
					videoRemote.attachNetStream(nsPlay);
				
				// play the movie you just recorded
					nsPlay.play(settings.streamName);
				
					btnSubscribe.label = 'Stop';
			}

			protected function stopPlaying():void
			{
				// when you hit stop disconnect from the NetStream object and clear the video player
					videoRemote.attachNetStream(null);
					videoRemote.clear();
					
					if (nsPlay != null)
						nsPlay.close();
					nsPlay = null;
					
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
				trace("nsPlay: onStatus: "+event.info.code+" ("+event.info.description+")");
				if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
				{
					tfPrompt.text = event.info.description;
				}
			}
					
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}