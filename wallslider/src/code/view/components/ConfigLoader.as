package code.view.components 
{
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class ConfigLoader extends MovieClip
	{
		public function ConfigLoader()
		{}
		/**
		 * xml data
		 */ 
		public var data:String = "";
		
		/**
		 * loader
		 */ 
		private var xmlLoader:URLLoader = new URLLoader();
		
		
		/**
		 * load file by url
		 */ 
		public function loadData(url:String ):void
		{
			try
			{
				var request:URLRequest = new URLRequest(url);
				xmlLoader.addEventListener(Event.COMPLETE, onLoadComplete);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, showError);
				xmlLoader.load(request);
			}
			catch(e:*)
			{
				showError(e);
			}
		}
		/**
		 * on loading complete
		 */ 
		private function onLoadComplete(e:Event):void
		{
			try
			{
				xmlLoader.removeEventListener(Event.COMPLETE, onLoadComplete);
				data = e.target.data.toString();
				xmlLoader.close();
				var event:Event = new Event(Event.COMPLETE,true);
				dispatchEvent(event);
			}
			catch(e:*)
			{
				showError(e);
			}
		}
		
		/**
		 * on error
		 */ 
		private function showError(e:*):void
		{
			trace(e);
			var event:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, true);
			dispatchEvent(event);
		}
		
	}
}