package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dave Stewart
	 */
	public class ValueEvent extends Event 
	{
		public var name					:String;
		public var value				:*;
		
		public static const CHANGE		:String		= 'ValueEvent.CHANGE';
		
		public function ValueEvent(name:String, value:*, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(CHANGE, bubbles, cancelable);
			this.value = value;
			this.name = name;
			
		} 
		
		public override function clone():Event 
		{ 
			return new ValueEvent(name, value, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ValueEvent", "name", "value", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}