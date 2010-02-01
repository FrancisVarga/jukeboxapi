package cc.varga.api.jukebox.services
{
	
	import cc.varga.api.jukebox.*;
	import cc.varga.api.jukebox.IRESTful;
  import cc.varga.api.jukebox.services.*;
  import cc.varga.utils.Logger;
	
	public class JukeboxService
	{
			
		public function JukeboxService()
		{
		}
		
		public static function createService(vo:JukeboxAPIVO):IRESTful{
			var service : IRESTful;
			
			switch(vo.type){
				case JukeboxAPIVO.BLIP_TIMELINE_TYPE:
          Logger.log("Producing BlipTimelineService","JukeboxService");
					break;
				case JukeboxAPIVO.BLIP_TYPE:
          Logger.log("Producing BlipService","JukeboxService");
          service = new BlipService(vo);
					break;
				case JukeboxAPIVO.COLLECTION_TYPE:
          Logger.log("Producing CollectionService","JukeboxService");
					break;
				case JukeboxAPIVO.SEARCH_TYPE:
          Logger.log("Producing SearchService","JukeboxService");
          break;
				default : 
          Logger.log("Producing Generic Resource","JukeboxService");
          service = new Resource(vo);
					break;
			}
			
			return service;
		}
	}
}
