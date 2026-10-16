package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.PathInfo;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class LeavePageManager
   {
      
      public function LeavePageManager()
      {
         super();
      }
      
      public static function leaveToLoginPurely() : void
      {
         var _loc1_:String = null;
         if(ExternalInterface.available)
         {
            _loc1_ = "function redict () {top.location.href=\"" + PathManager.solveLogin() + "\"}";
            ExternalInterface.call(_loc1_);
         }
      }
      
      public static function leaveToLoginPath() : void
      {
         var _loc1_:String = null;
         if(DesktopManager.Instance.isDesktop)
         {
            DesktopManager.Instance.backToLogin();
         }
         else if(PathInfo.ISTOPDERIICT && ExternalInterface.available)
         {
            _loc1_ = "function redict () {top.location.href=\"" + PathManager.solveLogin() + "\"}";
            ExternalInterface.call(_loc1_);
         }
         else
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("setFlashCall");
            }
            navigateToURL(new URLRequest(PathManager.solveLogin()),"_self");
         }
      }
      
      public static function forcedToLoginPath(param1:String) : void
      {
         if(DesktopManager.Instance.isDesktop)
         {
            DesktopManager.Instance.backToLogin();
            return;
         }
         PageInterfaceManager.askForFavorite();
         if(ExternalInterface.available)
         {
            ExternalInterface.call("game_interruption",PathManager.solveLogin(),param1);
         }
      }
      
      public static function showFirstFillFrame() : BaseAlerFrame
      {
         var _loc1_:BaseAlerFrame = null;
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("firstrecharge.mainframe.gotoFirstFill"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         _loc1_.addEventListener(FrameEvent.RESPONSE,__onResponse);
         return _loc1_;
      }
      
      public static function showFillFrame() : BaseAlerFrame
      {
         var _loc1_:BaseAlerFrame = null;
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
         _loc1_.addEventListener(FrameEvent.RESPONSE,__onResponse);
         return _loc1_;
      }
      
      private static function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            leaveToFillPath();
         }
      }
      
      public static function leaveToFillPath() : void
      {
         SoundManager.instance.play("008");
         ExternalInterface.call("game_pay");
      }
      
      private static function sinaWeiBoFill() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         if(ExternalInterface.available && PathManager.CommnuntyMicroBlog() && PathManager.CommnuntySinaSecondMicroBlog() && PathManager.solveFillJSCommandEnable())
         {
            _loc4_ = true;
            _loc1_ = PathManager.solveFillJSCommandValue();
            _loc2_ = _loc1_.substr(0,_loc1_.indexOf("("));
            _loc3_ = _loc1_.substring(_loc1_.indexOf("(") + 1,_loc1_.indexOf(")")).split(",");
            ExternalInterface.call(_loc2_,PlayerManager.Instance.Self.LoginName,_loc3_[1].substring(1,_loc3_[1].length - 1),_loc3_[2].substring(1,_loc3_[2].length - 1),_loc3_[3].substring(1,_loc3_[3].length - 1));
         }
         return _loc4_;
      }
      
      public static function setFavorite(param1:Boolean) : void
      {
         if(ExternalInterface.available)
         {
            if(DesktopManager.Instance.isDesktop)
            {
               return;
            }
            if(!PathManager.solveAllowPopupFavorite())
            {
               return;
            }
            if(param1)
            {
               ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"3");
            }
            else
            {
               ExternalInterface.call("setFavorite",PathManager.solveLogin(),StatisticManager.siteName,"2");
            }
         }
      }
   }
}

