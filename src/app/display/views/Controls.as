package app.display.views 
{
	import flash.events.Event;
	import assets.ControlsAsset;
	import core.media.video.VideoSettings;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Controls extends ControlsAsset 
	{
		
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: variables
		
			// constants
				
			
			// properties
				protected var settings					:VideoSettings;
				protected var sizes						:Array;
				protected var size						:Array;
				
			// variables
				
			
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: instantiation
		
			public function Controls(settings:VideoSettings = null) 
			{
				super();
				this.settings = settings || new VideoSettings();
				initialize();
			}
		
			protected function initialize():void 
			{
				// text fields
					tfStream.text			= settings.stream;
					tfServer.text			= settings.server;

				// sizes
					sizes = 
					[
						[320, 180],
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
				btnRecord.enabled		= isEnable;
				btnPlay.enabled			= isEnable;
				tfStream.enabled		= isEnable;
				cbAppend.enabled		= isEnable;
			}
			
			public function reset():void 
			{
				enablePlayControls(false);
				btnPlay.label				= 'Play';
				btnRecord.label				= 'Record';
				btnConnect.label			= "Connect";
				tfPrompt.text				= "";
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: accessors
		

		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: protected methods
		
			protected function updateStreamName():void 
			{
				tfStream.text = 'recording ' + settings.width + 'x' + settings.height + ' at ' + settings.quality;
				onStreamNameChange()
			}
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: handlers
		
			private function onServerNameChange(event:Event = null):void 
			{
				settings.server			= tfServer.text;
			}

			private function onStreamNameChange(event:Event = null):void 
			{
				settings.stream			= tfStream.text;
			}

			private function onSizeSelect(event:Event):void 
			{
				size					= sizes[comboSizes.selectedIndex];
				settings.width			= size[0];
				settings.height			= size[1];
				updateStreamName();
			}
			
			private function onQualityChange(event:Event):void 
			{
				settings.quality		= stpQuality.value;
				updateStreamName();
			}
			
		
		// ---------------------------------------------------------------------------------------------------------------------
		// { region: utilities
		
			
	}

}