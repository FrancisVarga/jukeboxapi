package cc.varga.api.jukebox.services
{
	import flash.net.URLLoader;
	
	public class AbstractService implements IRESTful
	{
		
		protected var serviceURL : String;
		
		public function AbstractService()
		{
		}
		
		public function get(vo:JukeboxAPIVO):void
		{
		
		}
		
		public function post(vo:JukeboxAPIVO):void
		{
		}
		
		public function delete(vo:JukeboxAPIVO):void
		{
		}
		
		public function put(vo:JukeboxAPIVO):void
		{
		}
		
		protected function generateURL():String{
			return "";
		}
		
		protected function generateHTTPService():URLLoader{
			
		}
		
	}
}