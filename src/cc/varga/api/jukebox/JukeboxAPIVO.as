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
		
		public var host : String;
 //   public var crypto : Boolean;
 //   public var path : Array;
 // 	public var type : String;
 	   private var _data : *;
		
		public function JukeboxAPIVO(item:Object=null, host:String = "localhost")
		{
			super(item, null, -1);
      		this.host = host;
		}
		
		public function set data(value : *) : void{
			_data = value;
		}
		
		public function get data():*{
			return _data;
		}
		
	}
}
