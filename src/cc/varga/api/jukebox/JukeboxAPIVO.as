package cc.varga.api.jukebox
{
	import mx.utils.ObjectProxy;
  import mx.collections.ArrayCollection;
	
  public dynamic class JukeboxAPIVO extends ObjectProxy
	{
		
		public static const COLLECTION_TYPE : String = "collections";
		public static const SEARCH_TYPE : String = "search";
		public static const BLIP_TYPE : String = "blip";
		public static const BLIP_TIMELINE_TYPE:String = "blip/timeline";
		public static const BLIP_REPLIES_TYPE:String = "blip/replies";
		
		public var host : String;
 //   public var crypto : Boolean;
 //   public var path : Array;
 // 	public var type : String;
 //   public var data : Object;
		
		public function JukeboxAPIVO(item:Object=null, host:String = "localhost")
		{
			super(item, null, -1);
      this.host = host;
		}
	}
}
