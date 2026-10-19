package angelInvestment.view
{
   import angelInvestment.AngelInvestmentManager;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   
   public class AngelInvestmentMainView extends Frame
   {
      
      private const COUNT:int = 7;
      
      private var _itemList:Vector.<AngelInvestmentItem>;
      
      private var _helpText:FilterFrameText;
      
      private var _buyAllBtn:SimpleBitmapButton;
      
      private var _getAllBtn:SimpleBitmapButton;
      
      private var _day:NumberImage;
      
      private var _price:NumberImage;
      
      private var _textBg:Bitmap;
      
      private var _clickTime:Number;
      
      public function AngelInvestmentMainView()
      {
         super();
      }
      
      public function show() : void
      {
         SocketManager.Instance.out.sendAngelInvestmentUpdate();
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      override protected function init() : void
      {
         this._textBg = ComponentFactory.Instance.creatBitmap("asset.angelInvestment.textBg");
         this._helpText = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.helpText");
         this._helpText.htmlText = LanguageMgr.GetTranslation("ddt.angelInvestment.help");
         this._buyAllBtn = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.buyAll");
         this._buyAllBtn.addEventListener("click",this.__onClickBuyAll);
         this._getAllBtn = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.getAll");
         this._getAllBtn.addEventListener("click",this.__onClickGetAll);
         this._price = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.priceNumber");
         this._day = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.priceNumber");
         PositionUtils.setPos(this._price,"angelInvestment.framePricePos");
         PositionUtils.setPos(this._day,"angelInvestment.frameDayPos");
         this._day.count = ServerConfigManager.instance.angelInvestmentDay;
         this._price.count = ServerConfigManager.instance.angelInvestmentAllPrice;
         this.initItem();
         super.init();
         this.initEvent();
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:int = 0;
         super.addChildren();
         if(Boolean(this._buyAllBtn))
         {
            addToContent(this._buyAllBtn);
         }
         if(Boolean(this._getAllBtn))
         {
            addToContent(this._getAllBtn);
         }
         if(Boolean(this._helpText))
         {
            addToContent(this._helpText);
         }
         if(Boolean(this._textBg))
         {
            addToContent(this._textBg);
         }
         if(Boolean(this._price))
         {
            addToContent(this._price);
         }
         if(Boolean(this._day))
         {
            addToContent(this._day);
         }
         if(Boolean(this._itemList) && Boolean(this._itemList.length))
         {
            _loc1_ = 0;
            while(_loc1_ < 7)
            {
               addToContent(this._itemList[_loc1_]);
               _loc1_++;
            }
         }
      }
      
      private function __onClickBuyAll(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this.isAllBuy())
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.angelInvestment.buyAllAlter",ServerConfigManager.instance.angelInvestmentAllPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
            _loc2_.addEventListener("response",this.__onBuyAllResponse);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.angelInvestment.notAllBuy"));
         }
      }
      
      private function __onBuyAllResponse(param1:FrameEvent) : void
      {
         var e:FrameEvent = param1;
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener("response",this.__onBuyAllResponse);
         if(e.responseCode == 3 || e.responseCode == 2)
         {
            CheckMoneyUtils.instance.checkMoney(false,ServerConfigManager.instance.angelInvestmentAllPrice,function():void
            {
               SocketManager.Instance.out.sendAngelInvestmentBuyAll();
            });
         }
         frame.dispose();
      }
      
      private function __onClickGetAll(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(getTimer() - this._clickTime < 3000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
            return;
         }
         this._clickTime = getTimer();
         if(!this.isAllGet())
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            SocketManager.Instance.out.sendAngelInvestmentGainAll();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.angelInvestment.notAllGet"));
         }
      }
      
      private function isAllGet() : Boolean
      {
         var _loc1_:int = 0;
         if(Boolean(this._itemList) && Boolean(this._itemList.length))
         {
            _loc1_ = 0;
            while(_loc1_ < 7)
            {
               if(this._itemList[_loc1_].canGetGoods)
               {
                  return false;
               }
               _loc1_++;
            }
         }
         return true;
      }
      
      private function isAllBuy() : Boolean
      {
         var _loc1_:int = 0;
         if(Boolean(this._itemList) && Boolean(this._itemList.length))
         {
            _loc1_ = 0;
            while(_loc1_ < 7)
            {
               if(this._itemList[_loc1_].canBuyGoods)
               {
                  return false;
               }
               _loc1_++;
            }
         }
         return true;
      }
      
      private function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._itemList = new Vector.<AngelInvestmentItem>(7);
         _loc1_ = 1;
         while(_loc1_ <= 7)
         {
            _loc2_ = new AngelInvestmentItem(AngelInvestmentManager.instance.model.data[_loc1_]);
            PositionUtils.setPos(_loc2_,"angelInvestment.itemPos" + _loc1_);
            this._itemList[_loc1_ - 1] = _loc2_;
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ANGEL_INVESTMENT,this.onUpdateItems);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ANGEL_INVESTMENT,this.onUpdateItems);
      }
      
      protected function onUpdateItems(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = _loc2_.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc4_ = _loc2_.readInt();
            _loc5_ = _loc2_.readInt();
            _loc6_ = _loc2_.readBoolean();
            this._itemList[_loc4_ - 1].updateInfo(_loc5_,_loc6_);
            _loc3_++;
         }
         this._buyAllBtn.visible = !this.isAllBuy();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._itemList.splice(0,this._itemList.length);
         super.dispose();
         this._itemList = null;
         this._helpText = null;
         this._buyAllBtn = null;
         this._getAllBtn = null;
         this._price = null;
         this._textBg = null;
         this._day = null;
      }
   }
}

