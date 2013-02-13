package code.view.components
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class ExternalImage extends MovieClip
	{
		//------------------------------------------
		//------------------------------------------
		//------------------------------------------
		public function ExternalImage()
		{
			super();
		}
		//------------------------------------------
		//------------------------------------------
		//------------------------------------------
		private var _handler:Function;
		public function load(url:String,handler:Function):void
		{       
			_handler = handler;
			try
			{
				var context:LoaderContext = new LoaderContext();
				context.checkPolicyFile = true;
				var imgLoader:Loader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComplete);
				imgLoader.load(new URLRequest(url),context);
			}
			catch(e:*)
			{
				trace("LOAD ERROR");
			}
		}
		//------------------------------------------
		//------------------------------------------
		//------------------------------------------
		public var bitmap:Bitmap;
		//------------------------------------------
		//------------------------------------------
		//------------------------------------------
		private function loadComplete(e:Event):void
		{	
			//--рисунок
			bitmap = e.target.content as Bitmap;
			_handler(bitmap);
		}
		//------------------------------------------
		//------------------------------------------
		//------------------------------------------
	}
}