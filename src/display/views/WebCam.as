package display.views {
	import assets.SettingsAsset;
	import flash.events.Event;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.TextInput;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	import flash.media.H264VideoStreamSettings;

	/**
	 * ...
	 * @author Dave Stewart
	 */
	
	public class WebCam extends SettingsAsset
	{
		
		//----------------------------------------------------------------------------------------------------------
		// variables
		
			// variables
				protected var connection				:NetConnection					= null;
				
				protected var nsPublish					:NetStream						= null;             
				protected var nsPlay					:NetStream						= null;
				
				protected var camera					:Camera							= null;
				protected var microphone				:Microphone						= null;
				
				protected var serverName				:String							= "rtmp://localhost/webcamrecording";
				protected var movieName					:String							= "recording1";
				
				protected var flushVideoBufferTimer		:Number							= 0;
				protected var h264Settings				:H264VideoStreamSettings		= new H264VideoStreamSettings();
				
				protected var sizes						:Array;
				protected var size						:Array;
				
			
		//----------------------------------------------------------------------------------------------------------
		// instantiation
		
			public function WebCam():void
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
				
				// video settings
					h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
					
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
					
				// prepare video
					flipVideo(videoCamera);
					flipVideo(videoRemote);
					
				// event handlers
					btnPublish.addEventListener(MouseEvent.CLICK, onRecordClick);
					btnSubscribe.addEventListener(MouseEvent.CLICK, onPlayClick);
					
				// update UI
					tfName.text				= movieName;
					tfServer.text			= serverName;
					cbAppend.selected		= false;
					btnConnect.addEventListener(MouseEvent.CLICK, onConnectClick);
					
				// set play controls to false
					enablePlayControls(false);
					
				// set up camera
					if ( ! camera )
					{
						trace('user has to click...');
						setupCamera();
						updateCamera();
						onConnectClick(null);
					}
			}
			
			
		//----------------------------------------------------------------------------------------------------------
		// instantiation
		
			
			protected function setupCamera():void
			{	
				// get the default Flash camera and microphone
					camera			= Camera.getCamera();

				// here are all the quality and performance settings
					if(camera != null)
					{
						camera.setMode(640, 360, 25, true);
						camera.setQuality(0, 88);
						camera.setKeyFrameInterval(15);
					}
					else
					{
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
					var width	:int	= size[0];
					var height	:int	= size[1];
					var rate	:int	= width * height;
					var quality	:int	= stpQuality.value;
					var fps		:int	= 25;
					
					camera.setMode(width, height, fps, true);
					//camera.setQuality(90000, 90); // new
					
					// @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Camera.html#setQuality()
					camera.setQuality(rate, quality); // new
					camera.setQuality(0, quality); // new
					camera.setKeyFrameInterval(15);
					
					tfName.text = 'recording ' + width + 'x' + height + ' at ' + quality;
					
					trace(width, height, rate)
					trace('rate:' + rate)
					
				}
			}
		

			protected function flipVideo(video:Video):void
			{
				video.scaleX = -video.scaleX;
				video.x += video.width;
			}
			
			protected function enablePlayControls(isEnable:Boolean):void
			{
				btnPublish.enabled = isEnable;
				btnSubscribe.enabled = isEnable;
				tfName.enabled = isEnable;
				cbAppend.enabled = isEnable;
			}
			
			// function to monitor the frame rate and buffer length
			protected function updateStreamValues():void
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


			protected function doPlayStart():void
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
						doPlayStop();
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
				nsPlay.play(tfName.text);
				
				btnSubscribe.label = 'Stop';
			}

			protected function doPlayStop():void
			{
				// when you hit stop disconnect from the NetStream object and clear the video player
				videoRemote.attachNetStream(null);
				videoRemote.clear();
				
				if (nsPlay != null)
					nsPlay.close();
				nsPlay = null;
				
				btnSubscribe.label = 'Play';
			}

			// this function gets called every 250 ms to monitor the
			// progress of flushing the video buffer. Once the video
			// buffer is empty we close publishing stream
			protected function doFlushVideoBuffer():void
			{
				var buffLen:Number = nsPublish.bufferLength;
				if (buffLen == 0)
				{
					clearInterval(flushVideoBufferTimer);
					flushVideoBufferTimer = 0;
					doCloseRecord();
					btnPublish.label = 'Record';
				}
			}

			protected function doCloseRecord():void
			{
				// after we have hit "Stop" recording and after the buffered video data has been
				// sent to the Wowza Media Server close the publishing stream
				nsPublish.publish("null");
			}

			// Start recording video to the server
			protected function doRecordStart():void
			{
				
				
				// stop video playback
				doPlayStop();
				
				// create a new NetStream object for publishing
				nsPublish = new NetStream(connection);
				
				// add h264 settings
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
				nsPublish.publish(tfName.text + '.f4v', mode);
				
				// do the live streaming
				//nsPublish.publish('mp4:' + tfName.text, 'live');
				nsPublish.publish('mp4:' + tfName.text, mode);
				
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

				btnPublish.label = 'Stop';
			}

			protected function doRecordStop():void
			{
				// stop streaming video and audio to the publishing
				// NetStream object
				//nsPublish.attachAudio(null); // disabled audio so that mp4 will record
				nsPublish.attachCamera(null);

				// After stopping the publishing we need to check if there is
				// video content in the NetStream buffer. If there is data
				// we are going to monitor the video upload progress by calling
				// flushVideoBuffer every 250ms.  If the buffer length is 0
				// we close the recording immediately.
				var buffLen:Number = nsPublish.bufferLength;
				if (buffLen > 0)
				{
					flushVideoBufferTimer = setInterval(doFlushVideoBuffer, 250);
					btnPublish.label = 'Wait...';
				}
				else
				{
					trace("nsPublish.publish(null)");
					doCloseRecord();		
					btnPublish.label = 'Record';
				}
			}

			
			protected function connect():void 
			{
				// create a connection to the wowza media server
					connection = new NetConnection();
					connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
					connection.connect(tfServer.text);
							
					btnConnect.label = "Disconnect";
				
				// uncomment this to monitor frame rate and buffer length
					setInterval(updateStreamValues, 500);
				
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
					connection						= null;
					
				// ui
					enablePlayControls(false);

					btnSubscribe.label			= 'Play';
					btnPublish.label			= 'Record';
					cbAppend.selected			= false;
						
					btnConnect.label			= "Connect";
					tfPrompt.text				= "";
			
			}
			
		//----------------------------------------------------------------------------------------------------------
		// handlers
		
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
			
			private function onSizeSelect(event:Event):void 
			{
				size = sizes[comboSizes.selectedIndex];
				updateCamera();
			}
			
			private function onQualityChange(e:Event):void 
			{
				updateCamera();
			}
			
			protected function onRecordClick(event:MouseEvent = null):void
			{
				if (btnPublish.label == 'Record')
					doRecordStart();
				else
					doRecordStop();
			}

			protected function onPlayClick(event:MouseEvent):void
			{
				if (btnSubscribe.label == 'Play')
					doPlayStart();
				else
					doPlayStop();
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
				}				
			}
			

			protected function onStreamPlayStatus(event:NetStatusEvent):void
			{
				trace("nsPlay: onStatus: "+event.info.code+" ("+event.info.description+")");
				if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
					tfPrompt.text = event.info.description;
			}

			protected function onStreamPublishStatus(event:NetStatusEvent):void
			{
				trace("nsPublish: "+event.info.code+" ("+event.info.description+")");
				
				// After calling nsPublish.publish(false); we wait for a status
				// event of "NetStream.Unpublish.Success" which tells us all the video
				// and audio data has been written to the flv file. It is at this time
				// that we can start playing the video we just recorded.
				if (event.info.code == "NetStream.Unpublish.Success")
				{
					doPlayStart();
				}

				if (event.info.code == "NetStream.Play.StreamNotFound" || event.info.code == "NetStream.Play.Failed")
					tfPrompt.text = event.info.description;
			}


				
	}

}