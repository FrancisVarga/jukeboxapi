package cc.varga.api.jukebox {
  public class Resource extends EventDispatcher {

    public static function create(object:Object, klass:String) : void {
      createHTTPService(klass+".json", createComplete, JSON.encode(object), "POST");  
    }

    private function createComplete(event : Event) : void {
      JSON.decode(event.currentTarget.data);
    }

    public function save() : Boolean {
    }

    public function destroy() : Boolean {
    }

    public function reload() : Boolean {
    }


    private function onFault(event:FaultEvent) : void {
    }

    private function onIOError(event : IOErrorEvent) : void {
    }

    private function createHTTPService(url:String, resultFunction:Function, params:* = null, method:String = "GET"):void{
      Logger.log("Create URLOADER with params: " + params, "");
      var basicService : URLLoader = new URLLoader();	
      basicService.data = params;
      basicService.addEventListener(Event.COMPLETE, resultFunction);
      basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      var request : URLRequest = new URLRequest(HOST + url);
      request.method = method;
      basicService.load(request);
    }

		private function decodeJSON(result:*):*
		{ 			
			return JSON.decode(result) as Object;

			//var arrayList : Array = new Array();
			//for(var i:uint=0; i < resultObj.length; i++){
			//	arrayList.push(new JukeboxAPIObject(resultObj[i]));
			//}
			//
			//return arrayList;
		}

    private function dispatchJukeEvent(type:String, result:* = null, fault:* = null):void
    {
      var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(type);

      if(result) jukeEvent.result = result;
      else jukeEvent.fault = fault;

      dispatchEvent(jukeEvent);
    }
  }

}
