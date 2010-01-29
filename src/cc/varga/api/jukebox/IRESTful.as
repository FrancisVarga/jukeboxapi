package cc.varga.api.jukebox
{
	public interface IRESTful
	{
		function get(vo:JukeboxAPIVO):void{}
		function post(vo:JukeboxAPIVO):void{}
		function delete(vo:JukeboxAPIVO):void{}
		function put(vo:JukeboxAPIVO):void{}
	}
}