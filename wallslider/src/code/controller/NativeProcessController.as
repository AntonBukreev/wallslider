package code.controller
{
	import code.ActionEvent;
	import code.model.Local;
	
	import code.view.components.StatusLabel;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import spark.components.Label;
	


	public class NativeProcessController extends EventDispatcher
	{
		private var _process:NativeProcess;
		private var _label:StatusLabel;
		private var _rewriteFlag:Boolean = false;
		
		public function NativeProcessController(label:StatusLabel)
		{
			_label = label;
		}
		
		public function start(img:String):void
		{
			img = img.replace(new RegExp('\\\\', "gi"),"//");
			try
			{
				_label.value("rewiting...", StatusLabel.TYPE_SUCCESS);
				var file:File = File.applicationDirectory.resolvePath("exe/changer.exe");
				
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = file;
				var args:Vector.<String> = new Vector.<String>;
				args.push(img); 
				nativeProcessStartupInfo.arguments = args;
				_process = new NativeProcess();
				_process.start(nativeProcessStartupInfo);
				
				_process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, stdoutHandler);
				_process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,errorHandler);
			} 
			catch(error:Error) 
			{
				_label.value(Local.CODE3 + " " + error.toString(), StatusLabel.TYPE_ERROR);
			}
			
		}
		
		private function stdoutHandler(event:ProgressEvent):void
		{
			var process:NativeProcess = event.target as NativeProcess;
			var data:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			if (_label)
			{
				_label.value(data, StatusLabel.TYPE_SUCCESS);
			}			
			process.exit(true);
			
			//костыль для особо упорных случаев
			if (data.toLocaleLowerCase().indexOf("error") >=0 )
			{
				if (!_rewriteFlag)
				{
					var e:ActionEvent = new ActionEvent(ActionEvent.REWRITE_IMAGE,true);
					dispatchEvent(e);
				}
				_rewriteFlag = true;
			}
			else
			{
				_rewriteFlag = false;
			}
		}
		
		private function errorHandler(event:ProgressEvent):void
		{
			var process:NativeProcess = event.target as NativeProcess;
			var data:String = process.standardError.readUTFBytes(process.standardError.bytesAvailable);
			if (_label)
			{
				_label.value(Local.CODE4 + " " + data, StatusLabel.TYPE_ERROR);
			}
			process.exit(true);
		}
	}
}


