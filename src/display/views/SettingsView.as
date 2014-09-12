package display.views
{
	import assets.SettingsAsset;
	
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
	public class SettingsView extends SettingsAsset 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var settings					:Object;
				protected var sizes						:Array;
				protected var size						:Array;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function SettingsView(settings:Object = null) 
			{
				super();
				this.settings = settings || {};
				initialize();
			}
		
			protected function initialize():void 
			{
				// text fields
					tfStream.text			= settings.streamName;
					tfServer.text			= settings.serverName;

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
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: public methods
		
			public function enablePlayControls(isEnable:Boolean):void
			{
				btnPublish.enabled		= isEnable;
				btnSubscribe.enabled	= isEnable;
				tfStream.enabled		= isEnable;
				cbAppend.enabled		= isEnable;
			}
			
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			private function onServerNameChange(event:Event):void 
			{
				settings.serverName		= tfServer.text;
			}

			private function onStreamNameChange(event:Event):void 
			{
				settings.streamName		= tfStream.text;
			}

			private function onSizeSelect(event:Event):void 
			{
				size					= sizes[comboSizes.selectedIndex];
				settings.width			= size[0];
				settings.height			= size[1];
			}
			
			private function onQualityChange(event:Event):void 
			{
				settings.quality		= stpQuality.value;
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}