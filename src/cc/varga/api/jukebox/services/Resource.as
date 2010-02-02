package cc.varga.api.jukebox.services
{
  import flash.net.URLLoader;
  import flash.net.URLRequestMethod;
  import flash.net.URLRequest;

  import com.adobe.serialization.json.JSON;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import mx.rpc.events.FaultEvent;

	import cc.varga.api.jukebox.*;
  import cc.varga.utils.Logger;

  internal class Resource extends EventDispatcher implements IRESTful
  {
    protected var _vo : JukeboxAPIVO;
    protected var _faultCallback : Function;
    protected var _completeCallback : Function;

    public function Resource(vo:JukeboxAPIVO)
    {
      _vo = vo;
    }

    public function fetch():void
    {
      request(URLRequestMethod.GET, onFetchComplete);
    }

    public function post():void
    {
      request(URLRequestMethod.POST, onPostComplete, JSON.encode(_vo.data));
    }

    public function destroy():void
    {
      request("DELETE", onDestroyComplete);
    }

    public function put():void
    {
      request("PUT", onPutComplete, JSON.encode(_vo.data));
    }

    public function set faultCallback(callback : Function) : void {
      _faultCallback = callback;
    }

    public function set completeCallback(callback : Function) : void {
      _completeCallback = callback;
    }

    protected function get url():String{
      var path:Array = [_vo.type];

      if (_vo.path && _vo.path.length > 0) {
        path = path.concat(_vo.path);
      }

      return (_vo.crypto ? "https" : "http")+"://"+_vo.host+"/"+path.join("/")+".json";
    }

    protected function request(method:String, resultFunction:Function = null, data:* = null):URLLoader {
      var basicService : URLLoader = new URLLoader();	
      var request : URLRequest = new URLRequest(url);

      basicService.data = data;
      basicService.addEventListener(Event.COMPLETE, resultFunction);
      basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      request.method = method;
      Logger.log(request.method+"-Request to "+url,"Resource")
      basicService.load(request);

      return basicService;
    }

    protected function onFetchComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      onCompleteCallback(data);
    }
    
    protected function onPostComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      onCompleteCallback(data);
    }

    protected function onDestroyComplete(event : Event):void {
      onCompleteCallback();
    }

    protected function onPutComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      onCompleteCallback(data);
    }

		protected function onIOError(event : IOErrorEvent) : void { _faultCallback(_vo); }

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

    private function decodeJSON(result:*):*
    { 			
      var resultObj : Object = JSON.decode(result);
      var arryList : Array = new Array();

      for(var i:uint=0; i < resultObj.length; i++){
        Logger.log("Producing JukeboxAPIObject from JSON-Result","Resource");
        arryList.push(new JukeboxAPIObject(resultObj[i]));
      }

      return arryList;
    }

  }
}
