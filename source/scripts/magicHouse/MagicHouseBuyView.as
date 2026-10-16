package magicHouse
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.DoubleSelectedItem;
   import flash.events.Event;
   
   public class MagicHouseBuyView extends BaseAlerFrame
   {
      
      private var _selecedItem:DoubleSelectedItem;
      
      private var _txt:FilterFrameText;
      
      public var autoClose:Boolean = true;
      
      private var _depotCount:int;
      
      private var _itemCount:int;
      
      private var _cost:int;
      
      private var _buyPos:int;
      
      public function MagicHouseBuyView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function set DepotCount(param1:int) : *
      {
         this._depotCount = param1;
      }
      
      public function set ItemCount(param1:int) : *
      {
         this._itemCount = param1;
      }
      
      public function set Cost(param1:int) : *
      {
         this._cost = param1;
      }
      
      public function set BuyPos(param1:int) : *
      {
         this._buyPos = param1;
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = _loc1_;
         this._selecedItem = new DoubleSelectedItem();
         this._selecedItem.x = 193;
         this._selecedItem.y = 137;
         addToContent(this._selecedItem);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("core.alert.txt");
         PositionUtils.setPos(this._txt,"memoryGame.buyViewTextPos");
         addToContent(this._txt);
         this.onMoneyChange(null);
      }
      
      private function initEvents() : void
      {
         addEventListener("response",this.responseHander);
         this._selecedItem.addEventListener("change",this.onMoneyChange);
      }
      
      public function onMoneyChange(param1:Event) : void
      {
         var _loc2_:String = LanguageMgr.GetTranslation(this._selecedItem.isBind ? "ddtMoney" : "money");
         this._txt.text = LanguageMgr.GetTranslation("magichouse.treasureView.openDepotTitle3",this._itemCount,this._cost,_loc2_,this._depotCount);
      }
      
      private function removeEvnets() : void
      {
         removeEventListener("response",this.responseHander);
         this._selecedItem.removeEventListener("change",this.onMoneyChange);
      }
      
      private function responseHander(param1:FrameEvent) : void
      {
         var moneyNeed:Number = NaN;
         var e:FrameEvent = param1;
         SoundManager.instance.playButtonSound();
         if(e.responseCode == 3 || e.responseCode == 2)
         {
            moneyNeed = 100;
            CheckMoneyUtils.instance.checkMoney(this._selecedItem.isBind,moneyNeed,function():void
            {
               SocketManager.Instance.out.magicOpenDepot(_buyPos,CheckMoneyUtils.instance.isBind);
               if(autoClose)
               {
                  dispose();
               }
            });
         }
         else if(e.responseCode == 0 || e.responseCode == 1 || e.responseCode == 4)
         {
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      public function get isBind() : Boolean
      {
         return this._selecedItem.isBind;
      }
      
      override public function dispose() : void
      {
         this.removeEvnets();
         if(Boolean(this._selecedItem))
         {
            ObjectUtils.disposeObject(this._selecedItem);
         }
         super.dispose();
         this._selecedItem = null;
      }
   }
}

