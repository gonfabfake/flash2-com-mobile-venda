package homeTemple
{
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class HomeTempleManager extends CoreManager
   {
      
      private static var instance:HomeTempleManager;
      
      public static const SHOW:String = "ht_show";
      
      public static const HIDE:String = "ht_hide";
      
      private var _con:DisplayObjectContainer;
      
      public function HomeTempleManager(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : HomeTempleManager
      {
         if(!instance)
         {
            instance = new HomeTempleManager(new inner());
         }
         return instance;
      }
      
      override protected function start() : void
      {
         dispatchEvent(new CEvent("ht_show"));
      }
      
      public function setContainer(param1:DisplayObjectContainer) : void
      {
         this._con = param1;
      }
      
      public function setView(param1:DisplayObject) : void
      {
         if(Boolean(this._con))
         {
            this._con.addChild(param1);
         }
      }
      
      public function removeView() : void
      {
         this._con = null;
         dispatchEvent(new CEvent("ht_hide"));
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
