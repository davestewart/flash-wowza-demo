package  
{
	import display.video.NetStreamVideo;
	import display.video.VideoSettings;
	import flash.display.DisplayObjectContainer;
	
	
	import display.video.VideoPlayer;
	import display.video.VideoRecorder;
	import display.views.Controls;
	import dev.WebCam;
	
	import assets.ControlsAsset;
	
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
	public class App 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var stage				:DisplayObjectContainer;
				protected var controls			:Controls;
				protected var player			:NetStreamVideo;
				protected var recorder			:NetStreamVideo;
				
			
			// connection
				protected var connection		:NetConnection;
				protected var settings			:VideoSettings;
				 
			// server credentials
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function App(stage:DisplayObjectContainer) 
			{
				this.stage = stage;
				initialize();
				build()
			}
			
			protected function initialize():void
			{
				// settings
					settings						= new VideoSettings();
				
				// new settings for wowza live
					var port		:int			= 1935;
					var user		:String			= 'mixoff';
					var pass		:String			= '20mixoff14';
				
					/*
					settings.serverName				= 'http://54.asda77.120.150/:1935';
					settings.serverName				= 'http://mixoff:20mixoff14@54.77.120.150/:1935';
					settings.serverName				= 'http://54.77.120.150/';
					*/
					
					settings.serverName				= "rtmp://localhost/webcamrecording";
					settings.streamName				= "recording1";
			}

			protected function build():void 
			{
				// controls
					controls = new Controls(settings);
					stage.addChild(controls);

				// event handlers
					controls.btnConnect.addEventListener(MouseEvent.CLICK, onConnectClick);
					controls.btnRecord.addEventListener(MouseEvent.CLICK, onRecordClick);
					controls.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
					
				// players
					player		= new VideoPlayer();
					stage.addChild(player);
					
					recorder	= new VideoRecorder();
					stage.addChild(recorder);
					
				// disable play controls
					enablePlayControls(false);
			}
			
			protected function build():void 
			{
				/*
				settings	= new SettingsView();
				stage.addChild(settings);
				
				*/
				
			}
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			protected function connect():void 
			{
				// create a connection to the wowza media server
					connection = new NetConnection();
					connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					connection.connect(settings.serverName);
							
				// ui
					btnConnect.label = "Disconnect";
				
				// monitor frame rate and buffer length
					setInterval(onStreamInterval, 500);
				
				// clear camera
					videoCamera.clear();
					videoCamera.attachCamera(camera);
				
			}
			
			protected function disconnect():void 
			{
				// camera record
					nsPublish					= null;
					videoCamera.attachNetStream(null);
					videoCamera.clear();
					
				// camera play
					nsPlay						= null;
					videoRemote.attachNetStream(null);
					videoRemote.clear();
					
				// connection close
					connection.close();
					connection					= null;
					
				// controls
					enablePlayControls(false);

				// ui
					btnSubscribe.label			= 'Play';
					btnPublish.label			= 'Record';
					btnConnect.label			= "Connect";
					tfPrompt.text				= "";
			}
			
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: interface handlers
		
			protected function onConnectClick(event:MouseEvent):void
			{
				// connect to the Wowza Media Server
				if (connection == null)
				{
					connect();
				}
				else
				{
					disconnect();
				}
			}
			
			protected function onRecordClick(event:MouseEvent = null):void
			{
				if (btnPublish.label == 'Record')
					startRecording();
				else
					stopRecording();
			}


			protected function onPlayClick(event:MouseEvent):void
			{
				if (btnSubscribe.label == 'Play')
					startPlaying();
				else
					stopPlaying();
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: connection handlers
		
			protected function onConnectionStatus(event:NetStatusEvent):void
			{
				var code:String = event.info.code;
				
				trace("nc: " + code+" (" + event.info.description + ")");
								
				switch(code)
				{
					case 'NetConnection.Connect.Success':
						enablePlayControls(true);
					break;
					
					case 'NetConnection.Connect.Failed':
						tfPrompt.text = "Connection failed: Try rtmp://[server-ip-address]/webcamrecording";
					break;
					
					case 'NetConnection.Connect.Rejected':
						tfPrompt.text = event.info.description;
					break;
				}				
			}
			
			// function to monitor the frame rate and buffer length
			protected function onStreamInterval():void
			{
				if (nsPlay != null)
				{
					tfFps.text = (Math.round(nsPlay.currentFPS * 1000) / 1000) + " fps";
					tfBufferLength.text = (Math.round(nsPlay.bufferLength * 1000) / 1000) + " secs";
				}
				else
				{
					tfFps.text = "";
					tfBufferLength.text = "";
				}
			}

			protected function onNetStatus(event:Event):void 
			{
				// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
				switch(event.type)
				{
					case 'NetStream.Play.Start':
						
					break;
					
					case 'NetStream.Play.Stop':
						
					break;
					
					case 'NetStream.Play.Complete':
						
					break;
					
					case 'NetStream.SeekStart.Notify':
						
					break;
					
					case 'NetStream.Seek.Notify':
						
					break;
					
					case 'NetStream.Unpause.Notify':
						
					break;
					
					case 'NetStream.Unpause.Notify':
						
					break;
					
					case 'NetStream.Buffer.Full':
						
					break;
					
					case 'NetStream.Buffer.Flush':
						
					break;
					
					case 'NetStream.Buffer.Empty':
						
					break;
					
					default:
						
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}