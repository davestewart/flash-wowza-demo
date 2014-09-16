package data.settings
{
	import events.ValueEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public dynamic class Settings
	{
		protected var _data			:Object;
		
		public function Settings() 
		{
			_data = { };
		}
		
		public function set(name:String, value:*):void 
		{
			_data[name] = value;
			//dispatchEvent(new ValueEvent(name, value));
		}
		
		public function getData():Object
		{
			return _data;
		}
		
		public function toString():String
		{
			var arr:Array = [];
			for (var name:String in _data)
			{
				arr.push(name + '="' +_data[name]+ '"');
			}
			return '[object Settings ' +arr.join(' ')+ ']';
		}
			
	}

}