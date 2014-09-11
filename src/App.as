package  
{
	import display.video.NetStreamVideo;
	import flash.display.DisplayObjectContainer;
	
	
	import display.video.VideoPlayer;
	import display.video.VideoRecorder;
	import display.views.SettingsView;
	import display.views.WebCam;
	
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
	public class App 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// elements
				protected var stage				:DisplayObjectContainer;
				protected var settings			:SettingsView;
				protected var player			:NetStreamVideo;
				protected var recorder			:NetStreamVideo;
				
			
			// connection
				protected var connection		:NetConnection;
				 
			// server credentials
				protected var serverName		:String;
				protected var streamName		:String;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function App(stage:DisplayObjectContainer) 
			{
				this.stage = stage;
				build();
				initialize();
			}
			
			protected function initialize():void 
			{
				var webcam:WebCam = new WebCam();
				stage.addChild(webcam);

				/*
				settings	= new SettingsView();
				stage.addChild(settings);
				
				player		= new VideoPlayer();
				stage.addChild(player);
				
				recorder	= new VideoRecorder();
				stage.addChild(recorder);
				*/
				
			}
			
			protected function build():void 
			{
				
			}
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}