package cc.varga.api.jukebox
{
	import cc.varga.utils.Logger;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.*;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	[ Event( name="artistlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="search_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="blip_feed_result", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="albumlist_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="fault", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="album_tracks_complete", type="cc.varga.api.jukebox.JukeboxAPIEvent") ]
	[ Event( name="collection_create", type="cc.varga.api.jukebox.JukeboxAPIEvent") ] 
	internal class JukeboxAPI extends EventDispatcher
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
		public function search(query:Object):void{ createHTTPService("search.json", onSearchResult, query, "POST"); }
		private function onSearchResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.SEARCH_RESULT, event.result, null); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtist(artistID:String):void{ createHTTPService("artists.json", onArtistResult); }
		private function onArtistResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ARTIST_COMPLETE, event.result, null); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getArtistList():void{ createHTTPService("artists.json", onArtistsListResult); }
		private function onArtistsListResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ARTISTLIST_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function loadBlipFMFeed(nickName : String):void{ createHTTPService("blip/" + nickName + ".json", onBlipFMResult); }
		private function onBlipFMResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.BLIP_FEED_RESULT, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getAlbumsList():void{ createHTTPService("albums.json", onAlbumListResult); }		
		private function onAlbumListResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUMLIST_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getAlbumByID(id:String):void{ createHTTPService("albums/" + id + "/tracks.json", onGetAlbumByIDResult); }
		private function onGetAlbumByIDResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUM_TRACKS_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function createCollection(paramObj:Object):void{ createHTTPService("collections.json", onCreateCollection, JSON.encode(paramObj), "POST"); }
		private function onCreateCollection(event : Event):void{ dispatchJukeEvent(JukeboxAPIEvent.COLLECTION_SAVED, event.toString()); }
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function saveCollection(collecObj : Object):void{ createHTTPService("collections", onSavedCollection, collecObj, "POST"); }
		private function onSavedCollection(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.COLLECTION_SAVED, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function updateCollection(collecObj : Object):void{ createHTTPService("collections/" + collecObj["_id"], onUpdateConllectionResult, collecObj, "PUT"); }
		private function onUpdateConllectionResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.UPDATE_COLLECTION_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function getCollectionByID(collectionID:String):void{ createHTTPService("collections/"+collectionID+"/tracks.json", onGetCollectionByIDResult); }
		private function onGetCollectionByIDResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.ALBUM_TRACKS_COMPLETE, event.result); }
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		// Default Fault/IOError Event
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		private function onFault(event : FaultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.FAULT, null, event); }
		private function onIOError(event : IOErrorEvent):void{}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//donwloadObj : jsonObject -> doc only the json object
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		public function download(downloadObj:Object):void{ createHTTPService("downloader/", onDownloadResult, downloadObj, "POST");	}
		private function onDownloadResult(event : ResultEvent):void{ dispatchJukeEvent(JukeboxAPIEvent.DOWNLAD_COMPLETE, event.result); }
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		private function createHTTPService(url:String, resultFunction:Function, params:* = null, method:String = "GET"):void{
			
			Logger.log("Create HTTPService:" + method + " || params: " + params, "");
			
			var service : HTTPService = new HTTPService();
			service.url = HOST + url;
			service.addEventListener(FaultEvent.FAULT, onFault);
			service.addEventListener(ResultEvent.RESULT, resultFunction);
			service.method = method;
			
			if(params is Object){
				Logger.log("Create HTTPService with params", "");
				service.send(params);
			} else if( params is String){
				Logger.log("Create URLOADER with params: " + params, "");
				var basicService : URLLoader = new URLLoader();	
				basicService.data = params;
				basicService.addEventListener(Event.COMPLETE, resultFunction);
				basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				var request : URLRequest = new URLRequest(HOST + url);
				request.method = method;
				basicService.load(request);
			} else {
				Logger.log("Create HTTPService without params", "");
				service.send();
			}
			
			/*else if (bodyObj) {
				Logger.log("Create URLOADER with params: " + bodyObj, "");
				var basicService : URLLoader = new URLLoader();	
				basicService.data = bodyObj;
				basicService.addEventListener(Event.COMPLETE, resultFunction);
				basicService.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				var request : URLRequest = new URLRequest(HOST + url);
				request.method = method;
				basicService.load(request);*/
			
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
		
		private static const SEARCH_URL : String = "search";
		private static const DOWNLOAD_URL : String = "download";
		
		private function generateURL(urlType:String):String{
			switch(urlType){
				case SEARCH_URL :
					break;
					return "";
				case DOWNLOAD_URL : 
					break;
					return "";
				default : 
					return "";
					break;
			};
			return "";
		}
		
		private function dispatchJukeEvent(type:String, result:* = null, fault:* = null):void
		{
			var jukeEvent : JukeboxAPIEvent = new JukeboxAPIEvent(type);
			
			if(result) jukeEvent.result = decodeJSON(result);
			else jukeEvent.fault = fault;
				
			dispatchEvent(jukeEvent);
		}
	}
}