package dev
{
	import dev.WebCam;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Document extends Sprite 
	{
		
		public function Document():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align				= "TL";
			stage.scaleMode			= "noScale";
			
			var webcam:WebCam = new WebCam();
			addChild(webcam);
		}
		
	}
	
}