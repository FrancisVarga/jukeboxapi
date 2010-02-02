package cc.varga.api.jukebox.services
{
  import cc.varga.api.jukebox.*;
  internal class BlipTimelineService extends Resource
	{
		public function BlipTimelineService(vo:JukeboxAPIVO)
		{
      vo.type = JukeboxAPIVO.BLIP_TIMELINE_TYPE;
			super(vo);
		}
		
//		override public function get() : void{
//			
//		}
		
//		public function get_request_from_timeline(vo:JukeBoxAPIVO):void{
//			
//		}
		
	}
}
