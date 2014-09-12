package data.settings
{
	import events.ValueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class Settings extends EventDispatcher 
	{
		protected var formatter:Event;
		
		public function Settings() 
		{
			formatter = new Event();
		}
		
		public function addEventListener(callback)
		{
			
		}
		
		public function removeEventListener(callback)
		{
			
		}
	
		public function set(name:String, value:*):void 
		{
			this['_' + name] = value;
			dispatchEvent(new ValueEvent(name, value));
		}
		
		protected function format(className:String, ...rest):String
		{
			return formatter.formatToString(className, rest);
		}
			
	}

}