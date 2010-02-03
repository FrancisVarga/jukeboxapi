package cc.varga.api.jukebox
{
	import mx.utils.ObjectProxy;

	public dynamic class JukeboxAPIVO extends ObjectProxy
	{
		
		public static const COLLECTION_TYPE : String = "collections";
		public static const SEARCH_TYPE : String = "search";
		public static const BLIP_TYPE : String = "blip";
		public static const BLIP_TIMELINE_TYPE:String = "blip/timeline";
		public static const BLIP_REPLIES_TYPE:String = "blip/replies";

		private var _serverConfig:JukeboxAPIConfig;
		private var _data: *;

              //public var crypto:                Boolean;
              //public var path:                Array;
              //public var type:                String;
              //public var data:                Object;

		public function JukeboxAPIVO(serverConfig : JukeboxAPIConfig, item:Object = null) {
			super(item, null, -1);
			this._serverConfig = serverConfig;
		}
		
		public function set data(value : *) : void{
			_data = value;
		}
		
		public function get data():*{
			return _data;
		}
		
		public function get serverConfig():JukeboxAPIConfig{
			return _serverConfig;
		}
		
	}
}
