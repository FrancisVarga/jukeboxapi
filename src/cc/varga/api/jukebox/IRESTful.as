package cc.varga.api.jukebox
{
  import flash.events.IEventDispatcher;

	public interface IRESTful extends IEventDispatcher
	{
		function fetch():void
		function post():void
		function destroy():void
		function put():void

    function set faultCallback(callback : Function) : void;
    function set completeCallback(callback : Function) : void;
	}
}
