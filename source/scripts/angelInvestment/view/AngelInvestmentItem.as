package angelInvestment.view
{
   import angelInvestment.data.AngelInvestmentItemData;
   import bagAndInfo.cell.BaseCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AngelInvestmentItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _priceBg:Bitmap;
      
      private var _info:AngelInvestmentItemData;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _number:NumberImage;
      
      private var _dayText:FilterFrameText;
      
      private var _tips:Component;
      
      private var _cell:BaseCell;
      
      public function AngelInvestmentItem(param1:AngelInvestmentItemData)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.angelInvestment.item" + this._info.ID);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.buy");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.get");
         this._priceBg = ComponentFactory.Instance.creatBitmap("asset.angelInvestment.price");
         this._number = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.number");
         this._dayText = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.dayText");
         this._dayText.text = LanguageMgr.GetTranslation("ddt.angelInvestment.notBuy");
         this._buyBtn.addEventListener("click",this.__onBuy);
         this._getBtn.addEventListener("click",this.__onGet);
         this._tips = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.itemTips");
         this._tips.graphics.beginFill(0,0);
         this._tips.graphics.drawRect(0,0,69,69);
         this._tips.graphics.endFill();
         addChild(this._bg);
         addChild(this._buyBtn);
         addChild(this._getBtn);
         addChild(this._priceBg);
         addChild(this._number);
         addChild(this._dayText);
         addChild(this._tips);
         this._number.count = this._info.Money;
         this._priceBg.x = this._number.x + this._number.width;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,35,35);
         _loc2_.graphics.endFill();
         this._cell = this.creatItemCell();
         this._cell.buttonMode = true;
         this._cell.width = 35;
         this._cell.height = 35;
         this._cell.info = ItemManager.Instance.getTemplateById(this._info.GoodID);
         this._cell.buttonMode = true;
         PositionUtils.setPos(this._cell,"angelInvestment.itemCellPos");
         _loc1_ = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.left.giftNumberShowTxt");
         _loc1_.text = this._info.Count.toString();
         this._cell.addChild(_loc1_);
         addChild(this._cell);
         this._tips.tipData = LanguageMgr.GetTranslation("ddt.angelInvestment.itmeTips",this._info.Count,this._cell.info.Name);
      }
      
      protected function creatItemCell() : BaseCell
      {
         var _loc1_:BaseCell = null;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,30,30);
         _loc2_.graphics.endFill();
         _loc1_ = new BaseCell(_loc2_,null,true,true);
         _loc1_.tipDirctions = "7,6,2,1,5,4,0,3,6";
         _loc1_.tipGapV = 10;
         _loc1_.tipGapH = 10;
         _loc1_.tipStyle = "core.GoodsTip";
         return _loc1_;
      }
      
      public function updateInfo(param1:int, param2:Boolean) : void
      {
         if(param1 >= 0)
         {
            this._dayText.text = LanguageMgr.GetTranslation("ddt.angelInvestment.dayTips",param1);
            this._dayText.x = 188;
            this._dayText.y = 38;
            this._getBtn.enable = !param2;
            this._buyBtn.enable = false;
         }
      }
      
      private function __onBuy(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.angelInvestment.buyAlter",this._info.Money),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _loc2_.addEventListener("response",this.__onBuyResponse);
      }
      
      private function __onBuyResponse(param1:FrameEvent) : void
      {
         var e:FrameEvent = param1;
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener("response",this.__onBuyResponse);
         if(e.responseCode == 3 || e.responseCode == 2)
         {
            CheckMoneyUtils.instance.checkMoney(false,this._info.Money,function():void
            {
               _buyBtn.enable = false;
               SocketManager.Instance.out.sendAngelInvestmentBuyOne(_info.ID);
            });
         }
         frame.dispose();
      }
      
      private function __onGet(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._getBtn.enable = false;
         SocketManager.Instance.out.sendAngelInvestmentGainOne(this._info.ID);
      }
      
      public function get canGetGoods() : Boolean
      {
         return this._getBtn.enable;
      }
      
      public function get canBuyGoods() : Boolean
      {
         return this._buyBtn.enable;
      }
      
      public function dispose() : void
      {
         this._buyBtn.removeEventListener("click",this.__onBuy);
         this._getBtn.removeEventListener("click",this.__onGet);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._buyBtn = null;
         this._getBtn = null;
         this._priceBg = null;
         this._number = null;
         this._dayText = null;
         this._cell = null;
         this._info = null;
         this._tips = null;
      }
   }
}

