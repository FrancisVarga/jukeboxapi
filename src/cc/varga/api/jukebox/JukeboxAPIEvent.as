package cc.varga.api.jukebox
{
	import flash.events.Event;
	
	public class JukeboxAPIEvent extends Event
	{
		
		public static const ARTISTLIST_COMPLETE : String = "artistlist_complete";
		public static const ARTIST_COMPLETE : String = "artis_get_complete";
		public static const SEARCH_RESULT : String = "search_result";
		public static const BLIP_FEED_RESULT : String = "blip_feed_result";
		public static const FAULT : String = "fault";
		public static const ALBUMLIST_COMPLETE : String = "albumlist_complete";
		public static const COLLECTION_SAVED : String = "collection_saved";
		public static const ALBUM_TRACKS_COMPLETE : String = "album_tracks_complete";
		public static const UPDATE_COLLECTION_COMPLETE : String = "update_collection_complete";
		public static const DOWNLAD_COMPLETE : String = "donwload_complete";
		public var result : Object;
		public var fault : *;
		
		public function JukeboxAPIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}