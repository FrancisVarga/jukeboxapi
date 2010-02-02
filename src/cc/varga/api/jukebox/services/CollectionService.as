package cc.varga.api.jukebox.services
{
  import cc.varga.api.jukebox.*;
	internal class CollectionService extends Resource
	{
		public function CollectionService(vo:JukeboxAPIVO)
		{
      vo.type = JukeboxAPIVO.COLLECTION_TYPE;
			super(vo);
		}
		
//		override public function delete_request(vo:JukeboxAPIVO) : void{
//			
//		}
//		
//		override public function get_request(vo:JukeboxAPIVO) : void{
//			
//		}
//		
//		override public function post_request(vo:JukeboxAPIVO) : void{
//				
//		}
		
	}
}
