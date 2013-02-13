package code.controller
{
	
	
	
	
	import code.model.Local;
	import code.view.components.BitmapLoader1;
	import code.view.components.StatusLabel;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.graphics.codec.JPEGEncoder;
	
	import spark.components.Label;
	
	
	public class ImageController
	{
		
		private var _currentImage:String;
		private var _label:StatusLabel;	
		private var _callBack:Function;
		private var _loader:BitmapLoader1;
		
		private const DIR:String = "DIRECTORY";
		private const IMAGE:String = "IMAGE";
		
		public function ImageController(label:StatusLabel)
		{
			_label = label;
		}
		
		
		/**
		 * copy image to temp folder
		 */ 
		public function saveWallpaper(src:String, callBackHandler:Function):void
		{
			_currentImage = src;
			_callBack = callBackHandler;
			callBackHandler(src);
			/*
			try
			{
				var fon:File = File.documentsDirectory.resolvePath("wall/" + "fon.bmp");
				fon.deleteFile();
				
			}
			catch(e:*)
			{
				fon.cancel();
				fon = File.documentsDirectory.resolvePath("wall/" + "fon.bmp");
				if (fon.exists)
					fon.moveToTrash();
				fon.cancel();
				if (_label)
				{
					_label.value(Local.CODE1 + " " + e.toString(),StatusLabel.TYPE_ERROR);
				}
			}
			
			try
			{
				if (src.length > 0)
				{
					var file:File = new File(src);
					var fon1:File = File.documentsDirectory.resolvePath("wall/" + "fon.bmp");
					
					var str:String = fon1.nativePath;
					file.copyTo(fon1, true);
					file.cancel();
					fon1.cancel();
					_label.value("CopyTo was finished.",StatusLabel.TYPE_SUCCESS);
					callBackHandler(str);
				}
			}
			catch(e:*)
			{
				if (_label)
				{
					_label.value(Local.CODE1 + " " + e.toString(),StatusLabel.TYPE_ERROR);
				}
			}
			*/
		}
		
		
		
		/**
		 * download and encode image
		 */ 
		public function saveWallpaperWithEncoder( callBackHandler:Function):void
		{
			if (_currentImage.length > 0)
			{
				_callBack = callBackHandler;
				_label.value("loading...", StatusLabel.TYPE_SUCCESS);
				_loader = new BitmapLoader1();
				_loader.label = _label;
				_loader.loadData(_currentImage,createFile);
			}
		}
		
		/**
		 * creating new file by bitmap
		 */ 
		private function createFile(data:BitmapData):void
		{
			try
			{
				_label.value("saving...", StatusLabel.TYPE_SUCCESS);
				
				var fon:File = File.documentsDirectory.resolvePath("wall/" + "fon.jpg");
				var stream:FileStream = new FileStream();
				stream.open(fon, FileMode.WRITE);
				
				var encoder:JPEGEncoder = new JPEGEncoder(90);
				var ba:ByteArray = encoder.encode(data);
				
				//var ba:ByteArray = PNGEncoder.encode(loader.data as BitmapData);
				stream.writeBytes(ba,0, ba.length );
				
				stream.close();
				_callBack(fon.nativePath);
				
				
			}
			
			catch(e:*)
			{
				_label.value(Local.CODE5 + " " + e.toString(),StatusLabel.TYPE_ERROR);
			}
		}
		
		
		/**
		 * on select folder, show all images in folder
		 */ 
		public function searchFilesInFolder(selectedPath:String):ArrayCollection
		{
			
			var file:File = new File(selectedPath);
			var arr:ArrayCollection = new ArrayCollection();
			if (getType(file) == DIR)
			{
				var list:Array = file.getDirectoryListing();
				for each (var item:* in list)
				{
					var type:String = getType(item);
					if (type == IMAGE)
					{
						arr.addItem({src:(item as File).nativePath});
					}
				}	
				
			}
			
			
			return arr;
			
		}
		
		private function getType(file:File):String
		{
			
			if (file.isDirectory) return DIR;
			if ((file.name.toLowerCase()).indexOf(".jpg")>0) return IMAGE;
			if ((file.name.toLowerCase()).indexOf(".jpeg")>0) return IMAGE;
			if ((file.name.toLowerCase()).indexOf(".png")>0) return IMAGE;
			if ((file.name.toLowerCase()).indexOf(".bmp")>0) return IMAGE;
			
			return null;
		}
		
		public function isImage(src:String):Boolean
		{
			var file:File = new File(src);
			return getType(file) == IMAGE;
		}
		
		
	}
}
