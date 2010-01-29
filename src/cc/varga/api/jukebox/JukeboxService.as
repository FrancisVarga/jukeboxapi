package cc.varga.api.jukebox
{
	
	import cc.varga.api.jukebox.*;
	
	public class JukeboxService
	{
			
		public function JukeboxService()
		{
		}
		
		public static function createService(vo:JukeboxAPIVO):IRESTful{
			
			var service : IRESTful;
			
			switch(vo.type){
				case : JukeboxAPIVO.BLIP_TIMELINE_TYPE
					break;
				case : JukeboxAPIVO.BLIP_TYPE
					break;
				case : JukeboxAPIVO.COLLECTION_TYPE
					break;
				case : JukeboxAPIVO.SEARCH_TYPE
				default : 
					break;
			}
			
			return service;
		}
	}
}