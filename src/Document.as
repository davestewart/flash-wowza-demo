package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import app.controllers.App;
	import dev.WebCam;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Document extends Sprite 
	{
		
		public function Document():void 
		{
			MonsterDebugger.initialize(this);
			

			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align				= "TL";
			stage.scaleMode			= "noScale";
			
			new App(this);
		}
		
	}
	
}