package cc.varga.api.jukebox.services
{
  import cc.varga.api.jukebox.*;
  internal class BlipRepliesService extends Resource
	{
		public function BlipRepliesService(vo:JukeboxAPIVO)
		{
      vo.type = JukeboxAPIVO.BLIP_REPLIES_TYPE;
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
