package cc.varga.api.jukebox
{
  import flash.events.IEventDispatcher;

	public interface IRESTful extends IEventDispatcher
	{
		function fetch():void
		function post():void
		function destroy():void
		function put():void
	}
}
