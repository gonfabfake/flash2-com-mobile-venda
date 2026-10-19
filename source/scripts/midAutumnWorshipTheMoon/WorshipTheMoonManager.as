package midAutumnWorshipTheMoon
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.WorshipTheMoonEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonAwardsBoxInfo;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonModel;
   import midAutumnWorshipTheMoon.view.WorshipTheMoonEnterButton;
   import midAutumnWorshipTheMoon.view.WorshipTheMoonMainFrame;
   
   public class WorshipTheMoonManager
   {
      
      private static var instance:WorshipTheMoonManager;
      
      private var _mainFrameMidAutumn:WorshipTheMoonMainFrame;
      
      private var _showFrameBtn:WorshipTheMoonEnterButton;
      
      private var _hall:HallStateView;
      
      public var _isOpen:Boolean = false;
      
      public function WorshipTheMoonManager(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : WorshipTheMoonManager
      {
         if(!instance)
         {
            instance = new WorshipTheMoonManager(new inner());
         }
         return instance;
      }
      
      public function init(param1:HallStateView = null) : void
      {
         this._hall = param1;
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.IS_ACTIVITY_OPEN,this.onResultIsActivityOpen);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.AWARDS_LIST,this.onResultAwardsList);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.FREE_COUNT,this.onResultFreeCounts);
         SocketManager.Instance.addEventListener(WorshipTheMoonEvent.WORSHIP_THE_MOON,this.onResultWorshipTheMoon);
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.IS_ACTIVITY_OPEN,this.onResultIsActivityOpen);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.AWARDS_LIST,this.onResultAwardsList);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.FREE_COUNT,this.onResultFreeCounts);
         SocketManager.Instance.removeEventListener(WorshipTheMoonEvent.WORSHIP_THE_MOON,this.onResultWorshipTheMoon);
      }
      
      protected function onResultIsActivityOpen(param1:WorshipTheMoonEvent) : void
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this._isOpen = _loc3_;
         WorshipTheMoonModel.getInstance().updateIsOpen(_loc3_);
         this.worshipTheMoonIcon(this._isOpen);
         if(_loc3_)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("worshipTheMoon.chatMsg.open"));
         }
         else if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("worshipTheMoon.chatMsg.close"));
         }
      }
      
      public function worshipTheMoonIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.WORSHIPTHEMOON,param1);
      }
      
      public function showFrame() : void
      {
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",15));
            return;
         }
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WORSHIP_THE_MOON);
      }
      
      protected function _loaderCompleteHandle(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.WORSHIP_THE_MOON)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
            UIModuleSmallLoading.Instance.hide();
            this._mainFrameMidAutumn = ComponentFactory.Instance.creatComponentByStylename("worship.mainframe");
            this._mainFrameMidAutumn.model = WorshipTheMoonModel.getInstance();
            WorshipTheMoonModel.getInstance().init(this._mainFrameMidAutumn);
            LayerManager.Instance.addToLayer(this._mainFrameMidAutumn,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.requireAwardsList();
            this.requireFreeCount();
         }
      }
      
      protected function _loaderErrorHandle(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loadingCloseHandle(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this._loaderErrorHandle);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this._loaderProgressHandle);
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loaderProgressHandle(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      protected function onResultAwardsList(param1:WorshipTheMoonEvent) : void
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Vector.<int> = new Vector.<int>();
         while(Boolean(_loc2_.bytesAvailable))
         {
            _loc5_.push(_loc2_.readInt());
         }
         WorshipTheMoonModel.getInstance().update200TimesGain(_loc3_);
         WorshipTheMoonModel.getInstance().updateItemsCanGainsIDList(_loc5_);
      }
      
      protected function onResultFreeCounts(param1:WorshipTheMoonEvent) : void
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         WorshipTheMoonModel.getInstance().updateFreeCounts(_loc3_);
         WorshipTheMoonModel.getInstance().updateWorshipedCounts(_loc4_);
         WorshipTheMoonModel.getInstance().update200State(_loc5_);
         WorshipTheMoonModel.getInstance().updatePrice(_loc6_);
      }
      
      protected function onResultWorshipTheMoon(param1:WorshipTheMoonEvent) : void
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:Vector.<WorshipTheMoonAwardsBoxInfo> = new Vector.<WorshipTheMoonAwardsBoxInfo>();
         _loc2_.readInt();
         while(Boolean(_loc2_.bytesAvailable))
         {
            _loc3_.push(new WorshipTheMoonAwardsBoxInfo(_loc2_.readInt(),_loc2_.readInt()));
         }
         WorshipTheMoonModel.getInstance().updateAwardsBoxInfoList(_loc3_);
      }
      
      public function requireFreeCount() : void
      {
         GameInSocketOut.sendWorshipTheMoonFreeCount();
      }
      
      public function requireAwardsList() : void
      {
         GameInSocketOut.sendWorshipTheMoonAwardsList();
      }
      
      public function requireWorshipTheMoon(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(param1 == 1)
         {
            _loc2_ = WorshipTheMoonModel.getInstance().getIsOnceBtnUseBindMoney();
         }
         else
         {
            _loc2_ = WorshipTheMoonModel.getInstance().getIsTensBtnUseBindMoney();
         }
         GameInSocketOut.sendWorshipTheMoon(param1,_loc2_);
      }
      
      public function requireWorship200AwardBox() : void
      {
         GameInSocketOut.sendGainThe200timesAwardBox();
      }
      
      public function hide() : void
      {
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
         if(this._showFrameBtn != null)
         {
            ObjectUtils.disposeObject(this._showFrameBtn);
            this._showFrameBtn = null;
         }
         WorshipTheMoonModel.getInstance().dispose();
      }
      
      public function disposeMainFrame() : void
      {
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
      }
      
      public function dispose() : void
      {
         this._hall = null;
         if(this._mainFrameMidAutumn != null)
         {
            ObjectUtils.disposeObject(this._mainFrameMidAutumn);
            this._mainFrameMidAutumn = null;
         }
         if(this._showFrameBtn != null)
         {
            ObjectUtils.disposeObject(this._showFrameBtn);
            this._showFrameBtn = null;
         }
         WorshipTheMoonModel.getInstance().dispose();
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
