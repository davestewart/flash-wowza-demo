package display.video 
{
	import flash.net.NetConnection;
	
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
	 * Instantiates a basic NetStreamVideo, then manages camera and publish locations
	 * 
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends NetStreamVideo 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var camera					:Camera;
				protected var microphone				:Microphone;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 240, connection:NetConnection = null)
			{
				super(width, height, connection);
			
				initialize();
			}
		
			protected function initialize():void 
			{
				
			}
			
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
				
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
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
					nsPublish.publish(settings.streamName + '.f4v', mode);
				
				// do the live streaming
				//nsPublish.publish('mp4:' + settings.streamName, 'live');
					nsPublish.publish('mp4:' + settings.streamName, mode);
				
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
							btnPublish.label	= 'Wait...';
							
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
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		

			
			protected function finishRecording():void
			{
				// debug
					trace('> finished recording')
					
				// after we have hit "Stop" recording, and after the buffered video data has been
				// sent to the Wowza Media Server, close the publishing stream
					nsPublish.publish("null");
					nsPublish.close();
					
				// update UI
					btnPublish.label = 'Record';
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

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}