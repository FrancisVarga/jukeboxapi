package cc.varga.utils
{
	import flash.utils.getTimer;

	public class Logger
	{
		public function Logger()
		{
		}
		
		public static function log(message : String, classpath:String):void{
			trace("["+getTimer()+"]["+classpath+"] --> " + message);
		}
		
	}
}