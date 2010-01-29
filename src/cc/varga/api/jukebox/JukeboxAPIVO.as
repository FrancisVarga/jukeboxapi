package cc.varga.api.jukebox
{
	import mx.utils.ObjectProxy;
	
	public class JukeboxAPIVO extends ObjectProxy
	{
		
		public static const COLLECTION_TYPE : String = "collection";
		public static const SEARCH_TYPE : String = "search";
		public static const BLIP_TYPE : String = "blip";
		public static const BLIP_TIMELINE_TYPE:String = "blip_timeline";
		
		public var url : String;
		public var type : String;
		public var params : Object;
		
		public function JukeboxAPIVO(item:Object=null, uid:String=null, proxyDepth:int=-1)
		{
			super(item, uid, proxyDepth);
		}
	}
}