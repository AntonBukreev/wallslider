package code.view.components 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import spark.components.Label;
	
	
	public class BitmapLoader1 extends EventDispatcher
	{
		public function BitmapLoader1()
		{}
		/**
		 * xml data
		 */ 
		public var data:BitmapData;
		
		public var label:StatusLabel;
		
		/**
		 * loader
		 */ 
		private var loader:Loader = new Loader();
		
		
		/**
		 * load file by url
		 */ 
		private var _completeHandler:Function;
		public function loadData(url:String , completeHanlder:Function):void
		{
			_completeHandler = completeHanlder;
			try
			{
				var request:URLRequest = new URLRequest(url);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, showError);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,updateInfo);
				loader.load(request);
			}
			catch(e:*)
			{
				showError("wtf!" + e.toString());
			}
		}
		/**
		 * on loading complete
		 */ 
		private function onLoadComplete(e:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			try
			{
				label.value("loading complete", StatusLabel.TYPE_SUCCESS);
				data = (loader.content as Bitmap).bitmapData;
				
				
				//data = new BitmapData(loader.width,loader.height, true, 0x00FFFFFF);
				//data.draw(loader);
				
				
				//loader.close();
				_completeHandler(data);
			}
			catch(e:*)
			{
				showError(e);
			}
			//loader.close();
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
		
		private function updateInfo(e:*):void
		{
			e.bytesLoaded/e.bytesTotal
			
				trace(Number (e.bytesLoaded/e.bytesTotal));
				label.value("Loading: "+Number (e.bytesLoaded/e.bytesTotal)+"%", StatusLabel.TYPE_SUCCESS);
		}
		
	}
}