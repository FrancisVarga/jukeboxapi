package cc.varga.api.jukebox
{
	import cc.varga.utils.Logger;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	public class JukeboxAPIConfig extends EventDispatcher
	{
		
		private var _host : String;
		
		public function loadConfig():void{
			Logger.log("Load JSON Config File", "Config");
			var service : HTTPService = new HTTPService();
			service.addEventListener(FaultEvent.FAULT, onFault);
			service.addEventListener(ResultEvent.RESULT, onResult);
			service.url = "serverConfig.json";
			service.send();
		}
		
		private function onFault(event : FaultEvent):void{
			Logger.log("onFault", "Config");
		}
		
		private function onResult(event : ResultEvent):void{
			
			var serverConfig : * = JSON.decode(event.result as String);
			_host = serverConfig.server.url;
			Logger.log("ServerConfig loaded: " + _host, "Config");
			dispatchEvent(new Event(Event.COMPLETE));
		
		}
		
		public function get host():String{
			return _host;
		}		
		
	}
}