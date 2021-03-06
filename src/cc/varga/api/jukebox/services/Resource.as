package cc.varga.api.jukebox.services
{
	import cc.varga.api.jukebox.*;
	import cc.varga.utils.*;
  import cc.lmaa.yajl.Yajl;
	
	import com.adobe.net.*;
	import com.adobe.serialization.json.*;
	
	import flash.events.*;
	import flash.net.URLRequestMethod;
	import flash.utils.*;
	
	import org.httpclient.*;
	import org.httpclient.events.*;
	
	internal class Resource extends EventDispatcher implements IRESTful
	{
		protected var _vo : JukeboxAPIVO;
		protected var _faultCallback : Function;
		protected var _completeCallback : Function;
		private var restfulClient : HTTPClient;
    private var _format : String = ".json";
    private var _chunks : Array = [];
    private var _decoderId : int;
    private var _resumeDecodeOnData : Boolean = false;
		
		public function Resource(vo:JukeboxAPIVO){
			_vo = vo;
		}
		
		public function fetch():void {
			request(URLRequestMethod.GET, onFetchComplete).fetch(new URI(url));
		}
		
		public function post() : void {
			Logger.log("POST: " + _vo.data.toString(), "RESSOURCE");
			request(URLRequestMethod.POST, onPostComplete, {}).post(new URI(url), generateData(JSON.encode(_vo.data))) ; 
		}
		
		public function destroy() : void { 
			request("DELETE", onDestroyComplete).del(new URI(url)); 
		}
		
		public function put() : void {
			request("PUT", onPutComplete, {}).put(new URI(url), generateData(JSON.encode(_vo.data))) ;
		}
		
		public function set faultCallback(callback : Function) : void {
			_faultCallback = callback;
		}


    private function get format() : String {
      if(_vo.format != null) {
        return _vo.format;
      }
      else {
        return _format;
      }
    }
		
		public function set completeCallback(callback : Function) : void {
			_completeCallback = callback;
		}
		
		protected function get url() : String {
      // FIXME: Should use corelib's URI class for URLs
      //var uri:URI = new URI(proto+"://"+_vo.serverConfig.host);

      var proto:String = (_vo.crypto ? "https" : "http");
      var host:String = _vo.serverConfig.host;
			var urlString : String;
			if(_vo.path){
				urlString = proto+"://"+host+"/"+[_vo.type].concat(_vo.path).join("/")+format;
			} else {
				urlString = proto+"://"+host+"/"+[_vo.type]+format;
			}
			
			Logger.log("URL Service: " + urlString, "Resource");
			return urlString;
		}
		
		protected function request(method : String, resultFunction : Function = null, data : * = null) : HTTPClient {
			
			/*var basicService : URLLoader = new URLLoader();	
			var request : URLRequest = new URLRequest(url);
			
			basicService.data = data;
			basicService.addEventListener(Event.COMPLETE, resultFunction);
			basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			request.method = method;
			Logger.log(method+"-Request to "+url,"Resource")
			basicService.load(request);
			
			return basicService;*/
			
			var listener : HTTPListener = new HTTPListener();
			listener.onConnect = function(data:*):void{
				Logger.log("onConnect", "Ressource");
			}
				
			listener.onRequest = function(data:*):void{
				Logger.log("onRequest", "Ressource");
			}
      listener.onStatus = onStatusHandler;
				
			listener.onData = resultFunction;
				
			listener.onError = function(data:*):void{
				Logger.log("onError", "Ressource");
			}
			
			var restfulClient : HTTPClient = new HTTPClient();
			restfulClient.listener = listener;
			
			return restfulClient;
			
		}
		
		private function generateData(value:String):ByteArray{
			Logger.log("Data to send: " + value, "Ressource");
			var data : ByteArray = new ByteArray();
			data.writeUTFBytes(value);
			return data;
		}
		
		// This function convert ByteArray to JSON
		private function invokeCallbackFunction(data:*) : void {
      var response : String = ByteArray(data.bytes).readUTFBytes(ByteArray(data.bytes).length);
      if(!_decoderId) {
        _decoderId = Yajl.setupStreamDecoder();
        decodeJSONChunk(response);
      }
      else {
        if(_resumeDecodeOnData) {
          decodeJSONChunk(response);
          _resumeDecodeOnData = false;
        }
        else {
          _chunks.push(response);
        }
      }
//			onCompleteCallback(decodeJSON());
		}
		
		protected function onFetchComplete(response : *):void {
			Logger.log("onFetchComplete", "Ressource");
			invokeCallbackFunction(response);
		}
		
		protected function onPostComplete(response : *):void {			
			Logger.log("onPostComplete", "Ressource");
			invokeCallbackFunction(response);
		}
		
		protected function onDestroyComplete(event : Event):void {
			Logger.log("onDestroyComplete", "Ressource");
			onCompleteCallback();
		}
		
		protected function onPutComplete(response : *):void {
			invokeCallbackFunction(response);
		}

    /* This Method has to stop invocations of complete Handlers for the client
     * if we get a non-success response status (e.g. 4xx or 5xx)
     */
    protected function onStatusHandler(statusEvent: org.httpclient.events.HTTPStatusEvent) : void {
      if (statusEvent.response.isClientError || statusEvent.response.isServerError) {
        Logger.log("The Request encountered an Error "+statusEvent.response.message,"HTTP Error");
        statusEvent.currentTarget.listener.onData = null;
      }
      
    }
		
		protected function onIOError(event : *) : void { _faultCallback(_vo); }
		
		private function onCompleteCallback(data:* = null):void
		{
			// Omitting result AND fault resets _vo.data to null
			if(data) {
				Logger.log("Adding ValueObject to result", "JukeEventDispatch");
				_vo.data = data;
			}
			else {
				Logger.log("Adding ValueObject to result with nullified Data", "JukeEventDispatch");
				_vo.data = null;
			}
			
			_completeCallback(_vo);
		}

    private function getMoreChunks(result : *) : void {
      if(result == undefined) {
        if(_chunks.length > 0) {
          decodeJSONChunk(_chunks.shift());
        }
        else {
          _resumeDecodeOnData = true;
        }
      }
      else {
        if(result.error != null) {
          Logger.log("Error encountered","Resource::Yajl");
          throw new Error(result.error);
        }
        else {
          Logger.log("Parsing seems complete","Resource::Yajl");
          onCompleteCallback(result.result);
        }
      }
    }

    private function decodeJSONChunk(chunk : String) : void {
      Yajl.decodeStreamAsync(getMoreChunks,_decoderId, chunk);
    }

    private function decodeJSON(result:*):*
    { 			
      var resultObj : Object = JSON.decode(result);
      var arryList : Array = new Array();

      for(var i:uint=0; i < resultObj.length; i++){
        arryList.push(new JukeboxAPIObject(resultObj[i]));
      }

      return arryList;
    }

  }
}
