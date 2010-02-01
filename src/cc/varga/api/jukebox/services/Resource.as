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

//    protected var serviceURL : String;
    protected var _vo : JukeboxAPIVO;

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

    protected function get url():String{
      return (_vo.crypto ? "https" : "http")+"://"+_vo.host+"/"+[_vo.type].concat(_vo.path).join("/")+".json";
    }

    protected function request(method:String, resultFunction:Function = null, data:* = null):URLLoader{
      var basicService : URLLoader = new URLLoader();	
      var request : URLRequest = new URLRequest(url);

      basicService.data = data;
      basicService.addEventListener(Event.COMPLETE, resultFunction);
      basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      request.method = method;
      Logger.log(method+"-Request to "+url,"Resource")
      basicService.load(request);

      return basicService;
    }

    protected function onFetchComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      dispatchJukeEvent(JukeboxAPIEvent.FETCH_COMPLETE,data);
    }
    
    protected function onPostComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      dispatchJukeEvent(JukeboxAPIEvent.POST_COMPLETE,data);
    }

    protected function onDestroyComplete(event : Event):void {
      dispatchJukeEvent(JukeboxAPIEvent.DESTROY_COMPLETE);
    }

    protected function onPutComplete(event : Event):void {
      var data:Object = decodeJSON(event.currentTarget.data);
      dispatchJukeEvent(JukeboxAPIEvent.PUT_COMPLETE,data);
    }

		protected function onIOError(event : IOErrorEvent):void{dispatchJukeEvent(JukeboxAPIEvent.FAULT, null, event); }

    private function dispatchJukeEvent(type:String, result:* = null, fault:* = null):void
    {
      var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(type);


      // Omitting result AND fault resets _vo.data to null
      if(result) {
        Logger.log("Adding ValueObject to result", "JukeEventDispatch");
        _vo.data = result;
        jukeEvent.result = _vo;
      }
      else if (fault) {
        jukeEvent.fault = {"message":fault.toString()};
      }
      else {
        Logger.log("Adding ValueObject to result with nullified Data", "JukeEventDispatch");
        _vo.data = null;
        jukeEvent.result = _vo;
      }

      dispatchEvent(jukeEvent);
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
