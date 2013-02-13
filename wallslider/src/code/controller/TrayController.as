package code.controller
{
	import code.ActionEvent;
	
	import flash.desktop.DockIcon;
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.controls.FlexNativeMenu;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.events.FlexNativeMenuEvent;
	
	
	
	public class TrayController extends EventDispatcher
	{
		
		
		private var _icon:BitmapData;
		private var _trayTimer:Timer;
		private var _isActive:Boolean = true;
		private var _isPlay:Boolean = false;
		
		public function TrayController()
		{
			if(NativeApplication.supportsDockIcon)
			{
				var dockIcon:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, undock);
			} 
			else 
			{
				if (NativeApplication.supportsSystemTrayIcon)
				{
					var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
					sysTrayIcon.tooltip = "WallSlider";
					sysTrayIcon.addEventListener(MouseEvent.CLICK, undock);
					sysTrayIcon.addEventListener(MouseEvent.DOUBLE_CLICK, undock);
				}
			}
			initMenue(getMenuProvider());
			
			
			FlexGlobals.topLevelApplication.stage.addEventListener(MouseEvent.CLICK,stopAutoTray);
			FlexGlobals.topLevelApplication.stage.addEventListener(MouseEvent.MOUSE_OVER,stopAutoTray);
			//FlexGlobals.topLevelApplication.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			//FlexGlobals.topLevelApplication.stage.addEventListener(Event.ACTIVATE, onActivate);
			FlexGlobals.topLevelApplication.stage.addEventListener(Event.CLOSING, minToTray);
			getIcon();
		}
		
		private function onActivate(e:Event):void
		{
			_isActive = true;
			initMenue(getMenuProvider());
			trace("activate");
		}
		private function onDeactivate(e:Event):void
		{
			_isActive = false;
			initMenue(getMenuProvider());
			trace("deactivate");
		}
		
		private function minToTray(event:Event):void
		{
			event.preventDefault();
			dock();
		}
		
		private function getMenuProvider():XML
		{
			var data:String = "";
			
			if (_isActive)
				data += "<menuitem label='Hide' />";
			else
				data += "<menuitem label='Show' />";
			
			if (_isPlay)
				data += "<menuitem label='Stop' />";
			else
				data += "<menuitem label='Start' />";
			data += "<menuitem label='Exit' />";
			
			var xml:XML = new XML("<root>"+data+"</root>");
			return xml;
		}
		private function initMenue(data:*):void
		{
			var trayMenu:FlexNativeMenu = new FlexNativeMenu();
			trayMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK, handleMenuItemClick);
			trayMenu.dataProvider = data;
			trayMenu.labelField = "@label";
			trayMenu.showRoot = false;
			FlexGlobals.topLevelApplication.systemTrayIconMenu = trayMenu;
		}
		
		private function handleMenuItemClick(e:FlexNativeMenuEvent):void 
		{ 
			switch(e.label)
			{
				case "Exit":
				{
					FlexGlobals.topLevelApplication.exit();
					break;
				}
				case "Start":
				{
					dispatchEvent(new ActionEvent(ActionEvent.CLICK_START, true));
					break;
				}	
				case "Stop":
				{
					dispatchEvent(new ActionEvent(ActionEvent.CLICK_STOP, true));
					break;
				}	
				case "Show":
				{
					undock();
					break;
				}
					
				case "Hide":
				{
					dock();
					break;
				}
			}
			
		}
		
		public function dock(event:* = null):void
		{
			_isActive = false;
			FlexGlobals.topLevelApplication.stage.nativeWindow.visible = false;
			NativeApplication.nativeApplication.icon.bitmaps = [_icon];
			//NativeApplication.nativeApplication.activate();
			initMenue(getMenuProvider());
		}	
		
		public function undock(event:Event = null):void
		{
			_isActive = true;
			FlexGlobals.topLevelApplication.stage.nativeWindow.visible = true;
			FlexGlobals.topLevelApplication.stage.nativeWindow.orderToFront();
			//NativeApplication.nativeApplication.icon.bitmaps = [];
			//	NativeApplication.nativeApplication.activate(NativeApplication.nativeApplication.openedWindows[0]);
			//FlexGlobals.topLevelApplication.stage.nativeWindow.active = true;
			FlexGlobals.topLevelApplication.stage.nativeWindow.activate();
			initMenue(getMenuProvider());
			
		}
		
		protected function getIcon():void
		{
			var file:File = File.applicationDirectory.resolvePath("ico/ico_16.png");
			var icon:Loader = new Loader();
			icon.contentLoaderInfo.addEventListener(Event.COMPLETE, setIcon);
			icon.load(new URLRequest(file.nativePath));
		}
		
		
		public function setIcon(event:* = null):void
		{
			_icon = event.target.content.bitmapData;
			NativeApplication.nativeApplication.icon.bitmaps = [_icon];
		}	
		
		public function setStart():void
		{
			_isPlay = false;
			initMenue(getMenuProvider());
		}
		
		public function setStop():void
		{
			_isPlay = true;
			initMenue(getMenuProvider());
		}
		
		//--------------------------------------------------------------------------------
		//--onsecond start
		//--------------------------------------------------------------------------------
		
		public function initTrayTimer():void
		{
			_trayTimer = new Timer(3000);
			_trayTimer.addEventListener(TimerEvent.TIMER, onHideTotray);
			_trayTimer.start();
		}
		
		public function stopAutoTray(event:MouseEvent):void
		{
			if (_trayTimer)
			{
				FlexGlobals.topLevelApplication.stage.removeEventListener(MouseEvent.CLICK,stopAutoTray);
				FlexGlobals.topLevelApplication.stage.removeEventListener(MouseEvent.MOUSE_OVER,stopAutoTray);
				
				_trayTimer.stop();
				_trayTimer.removeEventListener(TimerEvent.TIMER,onHideTotray);
				_trayTimer = null;
			}
		}
		
		protected function onHideTotray(event:TimerEvent):void
		{
			
			_trayTimer.removeEventListener(TimerEvent.TIMER,onHideTotray);
			_trayTimer.stop();	
			//onDeactivate();
			_trayTimer = null;
			dock();
			
		}
	}
}