package dev {
	
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
	
	public class WebCam extends ControlsAsset
	{
		
		// ----------------------------------------------------------------------------------------------------------
		// { region : Variables
		
			// variables
				protected var connection				:NetConnection;
				
				protected var nsPublish					:NetStream;        
				protected var nsPlay					:NetStream;
				
				protected var camera					:Camera;
				protected var microphone				:Microphone;
				
				protected var serverName				:String;
				protected var streamName				:String;
				
				protected var sizes						:Array;
				protected var size						:Array;
				
			
		// ----------------------------------------------------------------------------------------------------------
		// { region : Instantiation
		
			public function WebCam():void
			{
				// setup
					setupServer();
					setupUI();
					setupCamera();
					
				// connect
					connect();
			}
			
		// ----------------------------------------------------------------------------------------------------------
		// { region : UI
		
			protected function setupServer():void
			{
				// new settings for wowza live
					var port		:int			= 1935;
					var user		:String			= 'mixoff';
					var pass		:String			= '20mixoff14';
				
					/*
					serverName						= 'http://54.asda77.120.150/:1935';
					serverName						= 'http://mixoff:20mixoff14@54.77.120.150/:1935';
					serverName						= 'http://54.77.120.150/';
					*/
					
					serverName						= "rtmp://localhost/webcamrecording";
					streamName						= "recording1";
			}

			protected function setupUI():void 
			{
				// text fields
					tfStream.text				= streamName;
					tfServer.text				= serverName;

				// sizes
					sizes = 
					[
						[640, 360],
						[854, 480],
						[960, 540],
						[1024, 576],
						[1280, 720]
					];
					size = sizes[0];
					
				// setup sizes dropdown
					for (var i:int = 0; i < sizes.length; i++) 
					{
						comboSizes.addItem( { label:sizes[i][0] +  ' × ' + sizes[i][1], value:sizes[i]});
					}
					comboSizes.addEventListener(Event.CHANGE, onSizeSelect);
					
				// quality
					stpQuality.addEventListener(Event.CHANGE, onQualityChange);
					
				// text fields
					tfServer.addEventListener(Event.CHANGE, onServerNameChange);
					tfStream.addEventListener(Event.CHANGE, onStreamNameChange);
				
				// event handlers
					btnRecord.addEventListener(MouseEvent.CLICK, onRecordClick);
					btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
					btnConnect.addEventListener(MouseEvent.CLICK, onConnectClick);
					
				// prepare video
					flipVideo(videoCamera);
					flipVideo(videoRemote);
					
				// disable play controls
					enablePlayControls(false);
			}
			
			private function onServerNameChange(event:Event):void 
			{
				serverName = tfServer.text;
			}

			private function onStreamNameChange(event:Event):void 
			{
				streamName = tfStream.text;
			}

			private function onSizeSelect(event:Event):void 
			{
				size = sizes[comboSizes.selectedIndex];
				updateCamera();
			}
			
			private function onQualityChange(e:Event):void 
			{
				updateCamera();
			}
			
			
		// ----------------------------------------------------------------------------------------------------------
		// { region : Video
		
			protected function enablePlayControls(isEnable:Boolean):void
			{
				btnRecord.enabled		= isEnable;
				btnPlay.enabled	= isEnable;
				tfStream.enabled		= isEnable;
				cbAppend.enabled		= isEnable;
			}
			
			protected function flipVideo(video:Video):void
			{
				if (video.scaleX > 0)
				{
					video.scaleX	= -video.scaleX;
					video.x			+= video.width;
				}
			}
			

			// ----------------------------------------------------------------------------------------------------------
		// { region : Camera
			
			protected function setupCamera():void
			{	
				// get the default Flash camera and microphone
					camera = Camera.getCamera();

				// here are all the quality and performance settings
					if(camera != null)
					{
						updateCamera();
					}
					else
					{
						trace('Could not get camera');
						sourceVideoLabel.text = "No Camera Found\n";
					}
					
					
				// set up the mic
					microphone		= Microphone.getMicrophone();
					if( microphone != null)
					{
						microphone.rate = 11;
						microphone.setSilenceLevel(0, -1); 
					}
					else
					{
						sourceVideoLabel.text += "No Microphone Found\n";
					}
			}

			protected function updateCamera():void
			{
				if (camera)
				{
					// variables
						var width	:int	= size[0];
						var height	:int	= size[1];
						var rate	:int	= width * height;
						var quality	:int	= stpQuality.value;
						var fps		:int	= 25;
						
					// set camera properties
						camera.setMode(width, height, fps, true);
						
					// keyframes
						camera.setKeyFrameInterval(15);
						
					// quality
						// @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Camera.html#setQuality()
						//camera.setQuality(90000, 90); // new
						camera.setQuality(rate, quality); // new
						camera.setQuality(0, quality); // new
						
						
					// debug
						trace(width, height, rate)
						trace('rate:' + rate)
					
					// update stream name
						tfStream.text = 'recording ' + width + 'x' + height + ' at ' + quality;
						onStreamNameChange(null);
				}
			}
				
			

		// ----------------------------------------------------------------------------------------------------------
		// { region : Connection
		
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
			
			protected function connect():void 
			{
				// create a connection to the wowza media server
					connection = new NetConnection();
					connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					connection.connect(serverName);
							
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
				connection.close();
			}
			
			protected function cleanup():void 
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
					connection					= null;
					
				// controls
					enablePlayControls(false);

				// ui
					btnPlay.label			= 'Play';
					btnRecord.label			= 'Record';
					btnConnect.label			= "Connect";
					tfPrompt.text				= "";
			}
			
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
					
					case 'NetConnection.Connect.Closed':
						cleanup();
					break;
				}				
			}
			
			// function to monitor the frame rate and buffer length
			protected function onStreamInterval():void
			{
				if (nsPlay != null)
				{
					tfFps.text = (Math.round(nsPlay.currentFPS*1000)/1000)+" fps";
					tfBufferLength.text = (Math.round(nsPlay.bufferLength*1000)/1000)+" secs";
				}
				else
				{
					tfFps.text = "";
					tfBufferLength.text = "";
				}
			}

			

		// ----------------------------------------------------------------------------------------------------------
		// { region : Recording		

			protected function onRecordClick(event:MouseEvent = null):void
			{
				if (btnRecord.label == 'Record')
					startRecording();
				else
					stopRecording();
			}

			// Start recording video to the server
			protected function startRecording():void
			{
				
				// stop video playback
					stopPlaying();
				
				// create a new NetStream object for publishing
					nsPublish = new NetStream(connection);
				
				// add h264 settings
					var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
					h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
					nsPublish.videoStreamSettings = h264Settings;

				// update camera settings
					var index		:int		= comboSizes.selectedIndex;
					var size		:Array		= sizes[index];
					camera.setMode(size[0], size[1], 25, true);

					var nsPublishClient:Object = new Object();
					nsPublish.client = nsPublishClient;

				// trace the NetStream status information
					nsPublish.addEventListener(NetStatusEvent.NET_STATUS, onStreamPublishStatus);
				
				// publish the stream by name
					var mode:String = cbAppend.selected ? "append" : "record";
					nsPublish.publish(streamName + '.f4v', mode);
				
				// do the live streaming
				//nsPublish.publish('mp4:' + streamName, 'live');
					nsPublish.publish('mp4:' + streamName, mode);
				
				//nsPublish.publish("mp4:webCamX.f4v", "live");
				
				// add custom metadata to the header of the .flv file
					var metaData:Object = new Object();
					metaData["description"] = "Recorded using WebcamRecording example."
					nsPublish.send("@setDataFrame", "onMetaData", metaData);

				// attach the camera and microphone to the server
					nsPublish.attachCamera(camera);
					nsPublish.attachAudio(microphone);
				
				// set the buffer time to 20 seconds to buffer 20 seconds of video
				// data for better performance and higher quality video
					nsPublish.bufferTime = 20;

					btnRecord.label = 'Stop';
			}

			protected function stopRecording():void
			{
				// variables
					var intervalId:Number;
				
				// this function gets called every 250 ms to monitor the progress of flushing the video buffer.
				// Once the video buffer is empty we close publishing stream
					function onCheckBufferInterval():void
					{
						trace('VideoRecorder: Waiting for buffer to empty');
						if (nsPublish.bufferLength == 0)
						{
							trace('VideoRecorder: Buffer is empty!');
							clearInterval(intervalId);
							finishRecording();
						}
					}

				// stop streaming video and audio to the publishing NetStream object
					nsPublish.attachCamera(null);
					
				// disabled audio so that mp4 will record
					nsPublish.attachAudio(null); 

				// After stopping the publishing we need to check if there is video content in the NetStream buffer. 
				// If there is data we are going to monitor the video upload progress by calling flushVideoBuffer every 250ms.
					if (nsPublish.bufferLength > 0)
					{
						// update UI
							btnRecord.label	= 'Wait...';
							
						// monitor buffer length
							intervalId		= setInterval(onCheckBufferInterval, 250);
					}
					
				// If the buffer length is 0  we close the recording immediately.
					else
					{
						// debug
							trace("nsPublish.publish(null)");
							
						// finish
							finishRecording();		
					}
			}
			
			protected function finishRecording():void
			{
				// debug
					trace('> finished recording')
					
				// after we have hit "Stop" recording, and after the buffered video data has been
				// sent to the Wowza Media Server, close the publishing stream
					nsPublish.publish("null");
					nsPublish.close();
					
				// update UI
					btnRecord.label = 'Record';
			}

			protected function onStreamPublishStatus(event:NetStatusEvent):void
			{
				// debug
					trace("nsPublish: "+event.info.code+" ("+event.info.description+")");
				
				// After calling nsPublish.publish(false); we wait for a status event of "NetStream.Unpublish.Success" 
				// which tells us all the video and audio data has been written to the flv file. 
				// It is at this time  that we can start playing the video we just recorded.
					if (event.info.code == "NetStream.Unpublish.Success")
					{	
						trace('> unpublished')
						//nsPublish.close();
						trace('> closed')
						//startPlaying();
					}

					if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
					{
						tfPrompt.text = event.info.description;
					}
			}



		// ----------------------------------------------------------------------------------------------------------
		// { region : Playback
		
			protected function onPlayClick(event:MouseEvent):void
			{
				if (btnPlay.label == 'Play')
					startPlaying();
				else
					stopPlaying();
			}
			

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
					nsPlay.play(streamName);
				
					btnPlay.label = 'Stop';
			}

			protected function stopPlaying():void
			{
				// when you hit stop disconnect from the NetStream object and clear the video player
					videoRemote.attachNetStream(null);
					videoRemote.clear();
					
					if (nsPlay != null)
						nsPlay.close();
					nsPlay = null;
					
					btnPlay.label = 'Play';
			}

			protected function onStreamPlayStatus(event:NetStatusEvent):void
			{
				trace("nsPlay: onStatus: "+event.info.code+" ("+event.info.description+")");
				if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
				{
					tfPrompt.text = event.info.description;
				}
			}
			
			
				
	}

}