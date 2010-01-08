package cc.varga.api.jukebox
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import flash.events.EventDispatcher;
	import mx.rpc.http.mxml.HTTPService;
	import com.adobe.serialization.json.JSON;

	[ Event( name="artistlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="search_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="blip_feed_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="albumlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="fault", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="album_tracks_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ] 
	public class JukeboxAPI extends EventDispatcher
	{
		
		private var _currentHost:String;	
		//default HOST this MUST be set at the beginning of the application
		public static var HOST:String;
	
		public function JukeboxAPI(host:String = null){
		
			if(host) this._currentHost = host;
			else this._currentHost = HOST;
		
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//queryObject -> query:SearchString
		//
		//example: {query:SearchString}
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function search(query:Object):void{ createHTTPService("web/search.json", onSearchResult, query, "POST"); }
		private function onSearchResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.SEARCH_RESULT, event.result, null); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtist(artistID:String):void{ createHTTPService("web/artists.json", onArtistResult); }
		private function onArtistResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ARTIST_COMPLETE, event.result, null); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtistList():void{ createHTTPService("web/artists.json", onArtistsListResult); }
		private function onArtistsListResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ARTISTLIST_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function loadBlipFMFeed(nickName : String):void{ createHTTPService("web/blip/" + nickName + ".json", onBlipFMResult); }
		private function onBlipFMResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.BLIP_FEED_RESULT, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getAlbumsList():void{ createHTTPService("web/albums.json", onAlbumListResult); }		
		private function onAlbumListResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUMLIST_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getAlbumByID(id:String):void{ createHTTPService("web/albums/" + id + "/tracks.json", onGetAlbumByIDResult); }
		private function onGetAlbumByIDResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUM_TRACKS_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function saveCollection(collecObj : Object):void{ createHTTPService("web/collections", onSavedCollection, collecObj, "POST"); }
		private function onSavedCollection(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.COLLECTION_SAVED, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function updateCollection(collecObj : Object):void{ createHTTPService("web/collections/" + collecObj["_id"], onUpdateConllectionResult, collecObj, "PUT"); }
		private function onUpdateConllectionResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.UPDATE_COLLECTION_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getCollectionByID(collectionID:String):void{ createHTTPService("web/collections/"+collectionID+"/tracks.json", onGetCollectionByIDResult); }
		private function onGetCollectionByIDResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUM_TRACKS_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		// Default Fault Event
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		private function onFault(event : FaultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.FAULT, null, event); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//donwloadObj : jsonObject -> doc only the json object
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function download(downloadObj:Object):void{ createHTTPService("web/downloader/", onDownloadResult, downloadObj, "POST");	}
		private function onDownloadResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.DOWNLAD_COMPLETE, event.result); }
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		private function createHTTPService(url:String, resultFunction:Function, params:Object = null, method:String = "GET"){
			
			var service : HTTPService = new HTTPService();
			service.url = HOST + url;
			service.addEventListener(FaultEvent.FAULT, onFault);
			service.addEventListener(ResultEvent.RESULT, resultFunction);
			service.method = method;
			
			if(params) service.send(params);
			else service.send();
			
		}
		
		private function decodeJSON(result:*):Object{ return JSON.decode(result); }
		
		private function dispatchJukeEvent(type:String, result:* = null, fault:* = null):void{
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(type);
			
			if(result) jukeEvent.result = decodeJSON(result);
			else jukeEvent.fault = fault;
				
			dispatchEvent(jukeEvent);
		}
	}
}