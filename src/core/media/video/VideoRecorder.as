package core.media.video 
{
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Instantiates a basic NetStreamVideo, then manages camera and publish locations
	 * 
	 * @author Dave Stewart
	 */
	public class VideoRecorder extends VideoPlayer 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var camera					:Camera;
				protected var microphone				:Microphone;
				
			// camera variables
				protected var _size						:Array;
				protected var _quality					:int;
				protected var _fps						:int;
			
			// recording variables
				protected var _format					:String;
				protected var _append					:Boolean;
				
			// stream variables
				protected var _bandwidth				:int;
				protected var _keyframeInterval			:int;
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function VideoRecorder(width:int = 320, height:int = 180, connection:NetConnection = null)
			{
				super(width, height, connection);
				_size = [width, height];
			}
		
			override protected function initialize():void 
			{
				fps					= 25;
				quality				= 90;
				bandwidth			= 0;
				keyframeInterval	= 15;
				bufferTime			= 20;
				format				= 'mp4';
				flipped				= true;
			}

			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: camera methods
		
			public function setup():void 
			{
				video.clear();
				setupCamera();
			}
			
			protected function setupCamera():void
			{	
				// get the default Flash camera and microphone
					camera = Camera.getCamera();
					
				// here are all the quality and performance settings
					if(camera != null)
					{
						// attach video
							video.attachCamera(camera);
							
						// update camera
							updateCamera();
					}
					else
					{
						throw new Error('No Camera Found');
					}
					
				// set up the mic
					microphone = Microphone.getMicrophone();
					if( microphone != null)
					{
						microphone.rate = 11;
						microphone.setSilenceLevel(0, -1); 
					}
					else
					{
						log('No Microphone Found', 'error');
					}
			}

			protected function updateCamera():void
			{
				if (camera)
				{
					// variables
						var width	:int	= _size[0];
						var height	:int	= _size[1];
						var rate	:int	= width * height; // alternative bandwidth
						
					// set camera properties
						camera.setMode(width, height, fps);
						
					// keyframes
						camera.setKeyFrameInterval(keyframeInterval);
						
					// quality
						camera.setQuality(bandwidth, quality);
						
					// debug
						//trace('props:', width, height, bandwidth, quality, keyframeInterval);
						//trace('rate:', rate)
				}
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			// Start recording video to the server
			public function record(streamName:String = null):void
			{
				// debug
					log('Recording...');
					
				// set active
					_active = true;
					
				// setup stream
					setupStream();
					
				// add h264 settings
					if (format == 'mp4')
					{
						var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
						h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
						stream.videoStreamSettings = h264Settings;
					}

				// publish the stream by name
					var mode:String = _append ? "append" : "record"; // can also have "live" and "default", but "record" has NetStream events we can bind to
					stream.publish(format + ':' + streamName, mode);
					
				// add custom metadata to the header of the .flv file
					var metaData:Object	= 
					{
						description : 'Recorded using WebcamRecording example.'
					};
					stream.send('@setDataFrame', 'onMetaData', metaData);
					
				// attach the camera and microphone to the server
					stream.attachCamera(camera);
					stream.attachAudio(microphone);
			}

			override public function stop():void
			{
				// debug
					//trace('stopping recording...')
				
				// set active
					_active = false;

				// variables
					var intervalId:Number;
				
				// this function gets called every 250 ms to monitor the progress of flushing the video buffer.
				// Once the video buffer is empty we close publishing stream
					function onBufferFlush():void
					{
						log('Waiting for buffer to empty...');
						if (stream.bufferLength == 0)
						{
							log('Buffer emptied!');
							clearInterval(intervalId);
							onRecordComplete();
						}
					}

				// stop streaming video and audio to the publishing NetStream object
					stream.attachCamera(null);
					
				// disabled audio so that mp4 will record
					stream.attachAudio(null); 

				// After stopping the publishing we need to check if there is video content in the NetStream buffer. 
				// If there is data we are going to monitor the video upload progress by calling flushVideoBuffer every 250ms.
					stream.bufferLength > 0
						? intervalId = setInterval(onBufferFlush, 250)
						: onRecordComplete();		
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			public function get format():String { return _format; }
			public function set format(value:String):void 
			{
				if (/^(flv|mp4)$/.test(value))
				{
					_format = value;
				}
				else
				{
					throw new Error('Invalid video format "' +value+ '"');
				}
			}
		
			public function get quality():int { return _quality; }
			public function set quality(value:int):void 
			{
				_quality = value;
				updateCamera();
			}
			
			public function get size():Array { return _size; }
			public function set size(value:Array):void 
			{
				_size = value;
				updateCamera();
			}
			
			public function get fps():int { return _fps; }
			public function set fps(value:int):void 
			{
				_fps = value;
				updateCamera();
			}
			
			public function get bandwidth():int { return _bandwidth; }
			public function set bandwidth(value:int):void 
			{
				_bandwidth = value;
				updateCamera();
			}
			
			public function get keyframeInterval():int { return _keyframeInterval; }
			public function set keyframeInterval(value:int):void 
			{
				_keyframeInterval = value;
				updateCamera();
			}
			
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			protected function onRecordComplete():void
			{
				// debug
					log('Finished recording!')
					
				// after we have hit "Stop" recording, and after the buffered video data has been
				// sent to the Wowza Media Server, close the publishing stream
					stream.publish('null');
					stream.close();
			}


		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			protected function log(message:String, status:String = 'status'):void
			{
				dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, message, status));
			}
		
	}

}

