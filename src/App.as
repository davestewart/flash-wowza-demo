package  
{
	import display.video.NetStreamVideo;
	import display.video.VideoPlayer;
	import display.video.VideoRecorder;
	import display.views.SettingsView;
	import display.views.WebCam;
	import flash.display.DisplayObjectContainer;
	import flash.media.Camera;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.net.NetConnection;
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