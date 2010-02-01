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

  internal class AbstractService extends EventDispatcher implements IRESTful
  {

//    protected var serviceURL : String;
    protected var _vo : JukeboxAPIVO;

    public function AbstractService(vo:JukeboxAPIVO)
    {
      _vo = vo;
    }

    public function fetch():void
    {
      request(URLRequestMethod.GET, onFetchComplete);
    }

    public function post():void
    {
//      request(URLRequestMethod::POST);
    }

    public function destroy():void
    {
    }

    public function put():void
    {
    }

    protected function get url():String{
      return (_vo.crypto ? "https" : "http")+"://"+_vo.host+"/"+[_vo.type].concat(_vo.path).join("/")+".json";
    }

    protected function request(method:String, resultFunction:Function = null, data:String = null):URLLoader{
      var basicService : URLLoader = new URLLoader();	
      var request : URLRequest = new URLRequest(url);

      basicService.data = data;
      basicService.addEventListener(Event.COMPLETE, resultFunction);
      basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      request.method = method;
      Logger.log(method+"-Request to "+url,"AbstractService")
      basicService.load(request);

      return basicService;
    }

    protected function onFetchComplete(event : Event):void {
      dispatchJukeEvent(JukeboxAPIEvent.FETCH_COMPLETE,event.currentTarget.data);
    }

		protected function onIOError(event : IOErrorEvent):void{dispatchJukeEvent(JukeboxAPIEvent.FAULT, null, event); }

    private function dispatchJukeEvent(type:String, result:* = null, fault:* = null):void
    {
      var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(type);

      if(result) {
        _vo.data = decodeJSON(result);
        jukeEvent.result = _vo;
      }
      else {
        jukeEvent.fault = {"message":fault.toString()};
      }

      dispatchEvent(jukeEvent);
    }

    private function decodeJSON(result:*):*
    { 			
      var resultObj : Object = JSON.decode(result);
      var arryList : Array = new Array();

      for(var i:uint=0; i < resultObj.length; i++){
        Logger.log("Producing JukeboxAPIObject from JSON-Result","AbstractService");
        arryList.push(new JukeboxAPIObject(resultObj[i]));
      }

      return arryList;
    }

  }
}
