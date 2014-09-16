package 
{
	import dev.WebCam;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
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