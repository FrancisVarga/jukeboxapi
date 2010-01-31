package cc.varga.api.jukebox {
  public class Playlist extends Resource {
    private static klass:String = "collections";

    public static function create(object:Object, klass:String = null) : void {
      create(object, Playlist.klass);
    }

    private function createComplete(event : Event) : * {
      var playlist = new Playlist(super.createComplete(event));
      dispatch
      return null;
    }



    public function save() : Boolean {
       
    }
  }
}
