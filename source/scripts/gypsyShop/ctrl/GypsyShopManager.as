package gypsyShop.ctrl
{
   import AvatarCollection.AvatarCollectionManager;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import gypsyShop.model.GypsyNPCModel;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.model.GypsyShopModel;
   import gypsyShop.npcBehavior.GypsyNPCAdapter;
   import gypsyShop.npcBehavior.IGypsyNPCBehavior;
   import gypsyShop.ui.ConfirmFrameHonourNeeded;
   import gypsyShop.view.GypsyShopMainFrame;
   import gypsyShop.view.GypsyUILoader;
   
   public class GypsyShopManager
   {
      
      private static var instance:GypsyShopManager;
      
      private var _mainFrameGypsy:GypsyShopMainFrame;
      
      private var _npcBehavior:IGypsyNPCBehavior;
      
      private var _modelShop:GypsyShopModel;
      
      private var _gypsyShopFrameIsShowing:Boolean;
      
      private var _id:int;
      
      public function GypsyShopManager(param1:inner)
      {
         super();
         this._npcBehavior = new GypsyNPCAdapter(null);
      }
      
      public static function getInstance() : GypsyShopManager
      {
         if(!instance)
         {
            instance = new GypsyShopManager(new inner());
         }
         return instance;
      }
      
      public function init() : void
      {
         GypsyNPCModel.getInstance().init();
         this._modelShop = GypsyShopModel.getInstance();
      }
      
      public function showMainFrame() : void
      {
         new GypsyUILoader().loadUIModule("gypsy",[UIModuleTypes.GYPSYSHOP,UIModuleTypes.WORSHIP_THE_MOON],this.onLoaded);
      }
      
      private function onLoaded() : void
      {
         this._mainFrameGypsy = ComponentFactory.Instance.creatComponentByStylename("gypsy.mainframe");
         this._mainFrameGypsy.setModel(this._modelShop);
         this._gypsyShopFrameIsShowing = true;
         LayerManager.Instance.addToLayer(this._mainFrameGypsy,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._modelShop.init();
         this._modelShop.requestRareList();
         this._modelShop.requestRefreshList();
      }
      
      public function hideMainFrame() : void
      {
         this._gypsyShopFrameIsShowing = false;
         if(this._mainFrameGypsy != null)
         {
            ObjectUtils.disposeObject(this._mainFrameGypsy);
            this._mainFrameGypsy = null;
            this._modelShop.dispose();
         }
      }
      
      public function refreshNPC() : void
      {
         GypsyNPCModel.getInstance().refreshNPCState();
      }
      
      public function showNPC() : void
      {
         this._npcBehavior.show();
      }
      
      public function hideNPC() : void
      {
         this._npcBehavior.hide();
      }
      
      public function disposeNPC() : void
      {
         GypsyNPCModel.getInstance().dispose();
         this._npcBehavior.dispose();
      }
      
      public function newRareItemsUpdate() : void
      {
         this._mainFrameGypsy.updateRareItemsList();
      }
      
      public function newItemListUpdate() : void
      {
         this._mainFrameGypsy.updateNewItemList();
      }
      
      public function updateBuyResult() : void
      {
         this._mainFrameGypsy.updateBuyResult();
      }
      
      public function itemBuyBtnClicked(param1:int) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = GypsyPurchaseModel.getInstance().getRmbTicketNeeded(param1);
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.game.GameView.gypsyRMBTicketConfirm",_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _loc3_.moveEnable = false;
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
         this.setID(param1);
      }
      
      public function setID(param1:int) : void
      {
         this._id = param1;
      }
      
      private function comfirmHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.confirmToBuy(this._id);
         }
      }
      
      public function confirmToBuy(param1:int) : void
      {
         this._modelShop.requestBuyItem(param1);
      }
      
      public function refreshBtnClicked() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!GypsyPurchaseModel.getInstance().isHonourEnough())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
         }
         else if(GypsyPurchaseModel.getInstance().isShowHonourRefreshAgain())
         {
            new ConfirmFrameHonourNeeded().alert();
         }
         else
         {
            this.confirmToRefresh();
         }
      }
      
      public function confirmToRefresh() : void
      {
         this._modelShop.requestManualRefreshList();
      }
      
      public function dispose() : void
      {
         this._modelShop && this._modelShop.dispose();
         GypsyNPCModel.getInstance().dispose();
         this._npcBehavior.dispose();
      }
      
      public function set npcBehavior(param1:IGypsyNPCBehavior) : void
      {
         this._npcBehavior = param1;
      }
      
      public function get npcBehavior() : IGypsyNPCBehavior
      {
         return this._npcBehavior;
      }
      
      public function get gypsyShopFrameIsShowing() : Boolean
      {
         return this._gypsyShopFrameIsShowing;
      }
      
      public function isAvatarActivated(param1:int) : Boolean
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:Array = AvatarCollectionManager.instance.maleUnitList;
         var _loc3_:Array = AvatarCollectionManager.instance.femaleUnitList;
         var _loc4_:Array = AvatarCollectionManager.instance.weaponUnitList;
         loop0:
         for each(_loc5_ in _loc2_)
         {
            var _loc13_:int = 0;
            var _loc14_:* = _loc5_.totalItemList;
            do
            {
               for each(_loc8_ in _loc14_)
               {
               }
               continue loop0;
            }
            while(_loc8_.itemInfo.TemplateID != param1);
            return _loc8_.isActivity;
         }
         loop2:
         for each(_loc6_ in _loc3_)
         {
            _loc13_ = 0;
            _loc14_ = _loc6_.totalItemList;
            do
            {
               for each(_loc9_ in _loc14_)
               {
               }
               continue loop2;
            }
            while(_loc9_.itemInfo.TemplateID != param1);
            return _loc9_.isActivity;
         }
         loop4:
         for each(_loc7_ in _loc4_)
         {
            _loc13_ = 0;
            _loc14_ = _loc7_.totalItemList;
            do
            {
               for each(_loc10_ in _loc14_)
               {
               }
               continue loop4;
            }
            while(_loc10_.itemInfo.TemplateID != param1);
            return _loc10_.isActivity;
         }
         return false;
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
