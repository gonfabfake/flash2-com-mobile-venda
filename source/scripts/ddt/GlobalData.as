package ddt
{
   public class GlobalData
   {
      
      public static var isDebug:Boolean;
      
      public static var isRegisterPlayer:Boolean;
      
      public static var registerSelectLevel:Boolean;
      
      public static var user:String;
      
      private static var _key:String;
      
      public static var USEMD5:Boolean;
      
      public static var config:XML;
      
      private static var _instance:GlobalData;
      
      public static var rid:String = "";
      
      public static var site:String = "";
      
      public static var BACKUP_FLASHSITE:String = "";
      
      public static var requestPath:String = "";
      
      public static var flashSite:String = "";
      
      public static var resFlashSite:String = "";
      
      public static var resourceSite:String = "";
      
      public static var language:String = "";
      
      public static var loginPath:String = "";
      
      public function GlobalData()
      {
         super();
      }
      
      public static function get key() : String
      {
         return _key;
      }
      
      public static function set key(param1:String) : void
      {
         _key = param1;
      }
      
      public static function setConfig(param1:XML) : void
      {
         flashSite = param1.FLASHSITE.@value;
         resourceSite = param1.SITE.@value;
         resFlashSite = param1.FLASHSITE.@value;
         requestPath = param1.REQUEST_PATH.@value;
         language = param1.LANGUAGE.@value;
         loginPath = param1.LOGIN_PATH.@value;
         USEMD5 = param1.USE_MD5.@value == "true" ? true : false;
         config = param1;
      }
      
      public static function getPathByRequestPath(param1:String) : String
      {
         return requestPath + param1;
      }
      
      public static function getPathByFlashSite(param1:String) : String
      {
         return flashSite + param1;
      }
      
      public static function getPathByResFlashSite(param1:String) : String
      {
         return resFlashSite + param1;
      }
      
      public static function getSwfPath(param1:*) : String
      {
         return resFlashSite + "ui/" + language + "/swf/" + param1;
      }
      
      public static function get instance() : GlobalData
      {
         if(!_instance)
         {
            _instance = new GlobalData();
         }
         return _instance;
      }
   }
}

