package cc.varga.api.jukebox
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import flash.events.EventDispatcher;
	import mx.rpc.http.mxml.HTTPService;
	import com.adobe.serialization.json.JSON;
	import mx.messaging.channels.StreamingAMFChannel;

	[ Event( name="artistlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="search_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="blip_feed_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="albumlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="fault", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	public class JukeboxAPI extends EventDispatcher
	{
		
		private var _currentHost:String;	
		//default HOST this MUST be set at the beginning of the application
		public static var HOST:String;
	
		public function JukeboxAPI(host:String = null){
		
			if(host){
				this._currentHost = host;
			}else{
				this._currentHost = HOST;
			}
		
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function search(query:Object):void{
		
			var httpService : HTTPService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, onSearchResult);
			httpService.addEventListener(FaultEvent.FAULT, onSearchFault);
			httpService.method = "POST";
			httpService.url = JukeboxAPI.HOST + "web/search.json";
			httpService.send( query );
			
		}
		
		private function onSearchResult(event : ResultEvent):void{
			
			var result : Object = JSON.decode(event.result as String);
			
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.SEARCH_RESULT);
			jukeEvent.result = result;
			
			dispatchEvent(jukeEvent);
			
		}
		
		private function onSearchFault(event : FaultEvent):void{
			
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.FAULT);
			jukeEvent.fault = event;
			
			dispatchEvent(jukeEvent);
		
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtist(artistID:String):void{
			
			var httpService : HTTPService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, onArtistResult);
			httpService.addEventListener(FaultEvent.FAULT, onArtistFault);
			httpService.method = "POST";
			httpService.url = HOST + "web/artists.json";
			httpService.send();
			
		}
		
		private function onArtistResult(event : ResultEvent):void{
			
			var result : Object = JSON.decode(event.result as String);
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.ARTIST_COMPLETE);
			jukeEvent.result = result;
			
			dispatchEvent(jukeEvent);
			
		}
		
		private function onArtistFault(event : FaultEvent):void{
			
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.FAULT);
			jukeEvent.fault = event;
			
			dispatchEvent(jukeEvent);
			
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtistList():void{
			var httpService : HTTPService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, onArtistsListResult);
			httpService.addEventListener(FaultEvent.FAULT, onArtistsListFault);
			httpService.method = "GET";
			httpService.url = HOST + "web/artists.json";
			httpService.send();	
		}
		
		private function onArtistsListResult(event : ResultEvent):void{
			
			var result : Object = JSON.decode(event.result as String);
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.ARTISTLIST_COMPLETE);
			jukeEvent.result = result;
			
			dispatchEvent(jukeEvent);
			
		}
		
		private function onArtistsListFault(event : FaultEvent):void{
		
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.FAULT);
			jukeEvent.fault = event;
			
			dispatchEvent(jukeEvent);
			
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function loadBlipFMFeed(nickName : String):void{
			var httpService : HTTPService = new HTTPService();
			httpService.addEventListener(ResultEvent.RESULT, onBlipFMResult);
			httpService.addEventListener(FaultEvent.FAULT, onBlipFMFault);
			httpService.method = "GET";
			httpService.url = HOST + "web/blip/" + nickName + ".json";
			httpService.send();	
		}
		
		private function onBlipFMResult(event : ResultEvent):void{
			
			var result : Object = JSON.decode(event.result as String);
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.BLIP_FEED_RESULT);
			jukeEvent.result = result;
			dispatchEvent(jukeEvent);
			
		}
		
		private function onBlipFMFault(event : FaultEvent):void{
			
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.FAULT);
			jukeEvent.fault = event;
			dispatchEvent(jukeEvent);
			
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getAlbumsList():void{
			
			var httpService : HTTPService = new HTTPService();
			httpService.url = HOST + "web/albums.json";
			httpService.method = "GET";
			httpService.addEventListener(ResultEvent.RESULT, onAlbumListResult);
			httpService.addEventListener(FaultEvent.FAULT, onAlbumListFault);
			httpService.send();
			
		}
		
		private function onAlbumListResult(event : ResultEvent):void{
			
			var result : Object = JSON.decode(event.result as String);
			var jukeboxEvent:JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.ALBUMLIST_COMPLETE);
			jukeboxEvent.result = result;
			dispatchEvent(jukeboxEvent);
			
		}
		
		private function onAlbumListFault(event : FaultEvent):void{
			var jukeboxEvent:JukeboxAPIEvent = new JukeboxAPIEvent(JukeboxAPIEvent.FAULT);
			jukeboxEvent.fault = event;
			dispatchEvent(jukeboxEvent);
		}
		
	}
}