package code
{
	import flash.events.Event;
	
	public class ActionEvent extends Event
	{
		
		public static var REWRITE_IMAGE:String = "REWRITE_IMAGE";
		
		//view
		
		public static var SELECT_FOLDER:String = "SELECT_FOLDER";
		public static var SELECT_IMAGE:String = "SELECT_IMAGE";
		public static var CLICK_STOP:String = "CLICK_STOP";
		public static var CLICK_START:String = "CLICK_START";
		
		public static var ACTION:String = "ACTION";
		
		public var action:String;
		
		public function ActionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			action = type;
			super(ACTION, bubbles, cancelable);
		}
	}
}