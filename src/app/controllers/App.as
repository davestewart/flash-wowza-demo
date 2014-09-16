package app.controllers 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.utils.setInterval;
	
	import core.media.video.VideoPlayer;
	import core.media.video.VideoRecorder;
	import core.media.video.VideoSettings;
	
	import app.display.views.Controls;
	
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
				protected var player			:VideoPlayer;
				protected var recorder			:VideoRecorder;
				
			
			// connection
				protected var connection		:NetConnection;
				protected var settings			:VideoSettings;
				 
			// server credentials
				
			// variables
				protected var env				:String;
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function App(stage:DisplayObjectContainer) 
			{
				this.stage = stage;
				initialize();
				build()
				connect();
			}
			
			protected function initialize():void
			{
				// settings
					settings						= new VideoSettings();
					settings.stream				= 'video';
				
				// new settings for wowza live
					var port			:int			= 1935;
				
					
					env = '';
					
				// switch settings based on environment
					switch(env)
					{
						case 's3':
							settings.username				= 'mixoff';
							settings.password				= '20mixoff14';
							settings.server				= 'rtmp://54.asda77.120.150/:1935';
							settings.server				= 'rtmp://mixoff:20mixoff14@54.77.120.150/:1935';
							settings.server				= 'rtmp://54.77.120.150:1935/mixoff';
							break;
							
						case 'live':
							settings.username				= 'mixoff';
							settings.password				= 'mixoff';
							settings.server				= 'rtmp://mixoff:mixoff@localhost/live';
							settings.server				= 'rtmp://localhost/live';
							break;
							
						case 'webcam':
							settings.server				= "rtmp://localhost/webcamrecording";
							settings.stream				= "recording1";
							break;
							
						case 'demo':
							settings.server				= 'rtmp://localhost/demo';
							break;
							
						default:
							settings.server				= "rtmp://localhost/mixoff";
					}                           
					
				// debug
					trace(settings);
			}

			protected function build():void 
			{
				// controls
					controls		= new Controls(settings);
					controls.enablePlayControls(false);
					stage.addChild(controls);

				// event handlers
					controls.btnConnect.addEventListener(MouseEvent.CLICK, onConnectClick);
					controls.btnRecord.addEventListener(MouseEvent.CLICK, onRecordClick);
					controls.btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
					controls.btnSettings.addEventListener(MouseEvent.CLICK, onSettingsClick);
					
				// recorder
					recorder		= new VideoRecorder();
					recorder.x		= controls.videoRecord.x;
					recorder.y		= controls.videoRecord.y;
					recorder.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					stage.addChild(recorder);
					
				// player
					player			= new VideoPlayer();
					player.x		= controls.videoPlay.x;
					player.y		= controls.videoPlay.y;
					player.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					stage.addChild(player);
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function connect():void 
			{
				// create a connection to the wowza media server
					connection				= new NetConnection();
					connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					connection.connect(settings.server);
				
				// connect cameras
					player.connection		= connection;
					recorder.connection		= connection;
							
				// monitor frame rate and buffer length
					setInterval(onStreamInterval, 500);
			}
			
			protected function disconnect():void 
			{
				// camera record
					recorder.close();
					player.close();
					
				// connection close
					connection.close();
					connection = null;
					
				// controls
					controls.reset();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: interface handlers
		
			protected function onConnectClick(event:MouseEvent):void
			{
				connection == null
					? connect()
					: disconnect();
			}
			
			protected function onRecordClick(event:MouseEvent = null):void
			{
				! recorder.active
					? recorder.record(settings.stream)
					: recorder.stop();
			}


			protected function onPlayClick(event:MouseEvent = null):void
			{
				! player.active
					? player.play(settings.stream)
					: player.stop();
			}
			
			protected function onSettingsClick(event:MouseEvent):void 
			{
				trace(settings);
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: connection handlers
		
			protected function onConnectionStatus(event:NetStatusEvent):void
			{
				// debug
					log(event);
						
				// action
					switch(event.info.code)
					{
						case 'NetConnection.Connect.Success':
							controls.btnConnect.label = "Disconnect";
							controls.enablePlayControls(true);
							recorder.setup();
							break;
						
						case 'NetConnection.Connect.Failed':
							controls.tfPrompt.text = "Connection failed: Try rtmp://[server ip]/[app name]";
							break;
						
						case 'NetConnection.Connect.Rejected':
							controls.tfPrompt.text = event.info.description;
							break;
					}				
			}
			
			protected function onNetStatus(event:NetStatusEvent):void 
			{
				// debug
					log(event);
				
				// action
					// @see http://help.adobe.com/en_US/as3/dev/WS901d38e593cd1bac-3d11a09612fffaf8447-8000.html
					switch(event.info.code)
					{
						// error events
							case 'NetStream.Play.StreamNotFound':
							case 'NetStream.Play.Failed':
								controls.btnPlay.label = 'Play';
								break;
							
						// play events
							case 'NetStream.Play.Start':
								controls.btnPlay.label = 'Stop';
								break;
							
							case 'NetStream.Play.Stop':
								// this gets called when the 
								break;
							
							// this gets called when the stream has completed playing
							case 'NetStream.Play.Complete':
								controls.btnPlay.label = 'Play';
								player.replay();
								break;
								
								
							case 'NetStream.Play.MetaData':
								for (var name:String in event.info)
								{
									trace('	> ' +name + ' = ' + event.info[name]);
								}
								break;
								
							
						// seek events
							case 'NetStream.SeekStart.Notify':
								
								break;
							
							case 'NetStream.Seek.Notify':
								
								break;
							
							case 'NetStream.Unpause.Notify':
								
								break;
							
							case 'NetStream.Unpause.Notify':
								
								break;
							
						// publish events
							case 'NetStream.Publish.Start':
								player.stop();
								break;
							
							case 'NetStream.Unpublish.Success':
								trace('Published! Now playing...');
								onPlayClick();
								break;
							
						// record events
							case 'NetStream.Record.Start':
								controls.btnRecord.label = 'Stop';
								break;
							
							case 'NetStream.Record.Stop':
								controls.btnRecord.label = 'Record';
								break;
							
						// buffer events
							case 'NetStream.Buffer.Full':
								
								break;
							
							case 'NetStream.Buffer.Flush':
								
								break;
							
							case 'NetStream.Buffer.Empty':
								
								break;
							
							default:
							
					}
			}
			
			// function to monitor the frame rate and buffer length
			protected function onStreamInterval():void
			{
				if (player.stream)
				{
					controls.tfFps.text = (Math.round(player.stream.currentFPS * 1000) / 1000) + " fps";
					controls.tfBufferLength.text = (Math.round(player.stream.bufferLength * 1000) / 1000) + " secs";
				}
				else
				{
					controls.tfFps.text = "";
					controls.tfBufferLength.text = "";
				}
			}
			

		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function log(event:NetStatusEvent):void
			{
				trace('STATUS: ' + event.info.code+' (' + event.info.description + ')');
			}
		
	}

}