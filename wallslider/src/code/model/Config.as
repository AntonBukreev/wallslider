package code.model
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.core.UIComponent;
	import code.view.components.ConfigLoader;

	public class Config extends UIComponent
	{
		
		private function get file():File
		{
			return File.applicationStorageDirectory.resolvePath("config.xml");
		}
		
		public function Config()
		{
		}
		
		public function checkConfig(handleComplete:Function, handleError:Function):void
		{
			var loader:ConfigLoader = new ConfigLoader();
			loader.addEventListener(Event.COMPLETE, 
				function(e:Event):void 
				{
					//callLater(function(e:*=null):void
					//{
						handleComplete(loader.data);
					//});
				});
			
			loader.addEventListener(ErrorEvent.ERROR, 
				function(e:Event):void 
				{
					//callLater(function(e:*=null):void
					//{
						handleError();
					//});
				});
			
			loader.loadData(file.nativePath);
		}
		
		public function save(img:String, period:String, dir:String, search:String):void
		{
			deleteFile();
			createFile(new XML("<config><img>" + img + "</img><period>" + period + "</period><dir>"+dir+"</dir><search>"+search+"</search></config>"));
		}
		
		private function deleteFile():void
		{
			try
			{
				trace("delete", file.nativePath);
				file.deleteFile();
			}
			
			catch(e:*)
			{
				trace("error", e);
			}
		}
		
		private function createFile(data:XML):void
		{
			try
			{
				trace("create", file.nativePath);
				
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.WRITE);
				stream.writeUTFBytes(data);
				stream.close();
			}
			
			catch(e:*)
			{
				trace("error", e);
			}
		}
	}
}