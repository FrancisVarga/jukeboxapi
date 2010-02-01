package cc.varga.api.jukebox.services
{
	internal class SearchService extends AbstractService
	{
		public function SearchService(vo:JukeboxAPIVO)
		{
      vo.type = JukeboxAPIVO.SEARCH_TYPE;
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
