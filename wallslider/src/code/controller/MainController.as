package code.controller
{
	
	
	import code.ActionEvent;
	import code.model.Config;
	import code.model.Local;
	import code.view.View;
	import code.view.components.StatusLabel;
	
	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import spark.events.ListEvent;
	
	public class MainController
	{
		private var _view:View;
		private var _nativeController:NativeProcessController; 
		private var _imageController:ImageController; 
		private var _config:Config;
		private var _trayController:TrayController;
		
		
		private var timer:Timer;
		

		
		/**
		 * MainController
		 */ 
		public function MainController(view:View)
		{
			_view = view;
			_view.addEventListener(ActionEvent.ACTION, onAction);
			init();
		}
		
		/**
		 * on action
		 */ 
		private function onAction(e:ActionEvent):void
		{
			switch(e.action)
			{
				case ActionEvent.SELECT_FOLDER:
				{
					onSelectFolder();
					break;
				}
					
				case ActionEvent.SELECT_IMAGE:
				{
					stop();
					var src:String = _view.preview.selectedItem.src;
					setWall(src);
					break;
				}
					
				case ActionEvent.CLICK_START:
				{
					start();
					break;
				}
					
				case ActionEvent.CLICK_STOP:
				{
					stop();
					break;
				}
					
				case ActionEvent.REWRITE_IMAGE:
				{
					_imageController.saveWallpaperWithEncoder(function (src:String):void
					{
						_nativeController.start(src);
					});
					break;
				}
			}
		}
		
		
		/**
		 * init
		 */ 
		public function init():void
		{
			_view.setStartState();
			//native processes
			_nativeController = new NativeProcessController(_view.statusLabel);
			_nativeController.addEventListener(ActionEvent.ACTION, onAction);
			//images
			_imageController = new ImageController(_view.statusLabel);
			//config
			_config = new Config();
			_config.checkConfig(onLoadConfig, _view.setDefoltTree);
			//tray ico
			_trayController = new TrayController();
			_trayController.addEventListener(ActionEvent.ACTION, onAction);
			
		}
	
		/**
		 * config success loading
		 */ 
		private function onLoadConfig(data:String):void
		{
			try
			{
				var conf:XML = new XML(data); 
				
				_view.delayNS.value = int(conf.period.toString());
				if (conf.dir.toString().length > 0 )
				{
					_view.fileList.openPaths = [conf.dir.toString()];
					_view.fileList.selectedPath = conf.dir.toString();
					onSelectFolder();
				}
				
				
				if  (conf.search.toString() == "true")
					start(false);
				else
					setWall(conf.img.toString(),false);
				
				_trayController.initTrayTimer();
			}
			catch(e:*)
			{
				trace(e);
			}
		}
			
		/**
		 * change wallpaper
		 */ 
		private function setWall(src:String, saveConfig:Boolean = true):void
		{
			if (saveConfig)
				_config.save(src, _view.delayNS.value.toString(), _view.fileList.selectedPath, _view.currentState == "WorkState"? "true" : "false");
			
			
			_imageController.saveWallpaper(src, function (src:String):void
			{
				_nativeController.start(src);
			});
		}
		
		/**
		 * on select folder - searching all amages in folder
		 */ 
		public function onSelectFolder():void
		{
			var src:String = _view.fileList.selectedPath;
			if (_imageController.isImage(src))
			{
				_view.stateSelectImage(src);
				setWall(src);
			}
			else
			{
				_view.stateSelectFolder(_imageController.searchFilesInFolder(src));
			}
			
		}
		
		
		//------------------------------------------------------------------------------
		//--timer---------------------------------------------------------------
		//------------------------------------------------------------------------------
		/**
		 * start timer
		 */ 
		protected function start(doOnFirstTact:Boolean = true):void
		{
			
			if (_view.previewDP.length > 0)
			{
				_trayController.setStop();
				_view.setWorckState();
				timer = new Timer(_view.delayNS.value * 1000);
				timer.addEventListener(TimerEvent.TIMER, onTime);
				timer.start();
				if (doOnFirstTact)
					onTime(null);
			}
			
		}
		
		/**
		 * change image by timer tick
		 */ 
		private function onTime(event:TimerEvent):void
		{
			setWall(_view.previewDP[Math.random() * _view.previewDP.length].src);
		}
		
		/**
		 * stop timer
		 */ 
		protected function stop():void
		{
			if (timer)
			{
				_trayController.setStart();
				_view.setStartState();
				timer.removeEventListener(TimerEvent.TIMER, onTime);
				timer.stop();
				timer = null;
			}
		}
	}
}
