package levelFund.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import levelFund.LevelFundManager;
   
   public class LevelFundViewItem extends Sprite implements Disposeable
   {
      
      private var _itemBg:Bitmap;
      
      private var _itemLine:Bitmap;
      
      private var _moneyIcon:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _buyMultipleTxt:FilterFrameText;
      
      private var _getAwardBtn:TextButton;
      
      private var _info:Object;
      
      private var _index:int;
      
      public function LevelFundViewItem(param1:int = 0)
      {
         this._index = param1;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         if(this._index % 2 == 0)
         {
            this._itemBg = ComponentFactory.Instance.creatBitmap("levelFund.levelFundViewItem.bg");
            addChild(this._itemBg);
         }
         if(this._index != 0)
         {
            this._itemLine = ComponentFactory.Instance.creatBitmap("levelFund.levelFundViewItem.line");
            addChild(this._itemLine);
         }
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("asset.ddtshop.PayTypeLabelTicket");
         PositionUtils.setPos(this._moneyIcon,"levelFund.levelFundViewItem.moneyPos");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundViewItem.levelTxt");
         this._buyMultipleTxt = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundViewItem.buyMultipleTxt");
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundViewItem.getAwardBtn");
         this._getAwardBtn.text = LanguageMgr.GetTranslation("levelFund.levelFundViewItem.getAwardBtnTxt");
         addChild(this._moneyIcon);
         addChild(this._levelTxt);
         addChild(this._buyMultipleTxt);
         addChild(this._getAwardBtn);
      }
      
      public function updateView(param1:Object, param2:int) : void
      {
         this._info = param1;
         this._levelTxt.text = LanguageMgr.GetTranslation("levelFund.levelFundViewItem.levelTxt",this._info.level);
         if(param2 == 0)
         {
            this._buyMultipleTxt.text = param1.money + "";
         }
         else
         {
            this._buyMultipleTxt.text = LanguageMgr.GetTranslation("levelFund.levelFundViewItem.buyMultipleTxt",param1.money,param2);
         }
         if(param1.state == 0)
         {
            this._getAwardBtn.enable = true;
         }
         else
         {
            this._getAwardBtn.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         this._getAwardBtn.addEventListener("click",this.__getAwardBtnClickHandler);
      }
      
      private function __getAwardBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(LevelFundManager.instance.model.buyType == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.buyLevelFund.buyLevelMsg"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < this._info.level)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.buyLevelFund.buyLevelLimitMsg"));
            return;
         }
         this._getAwardBtn.enable = false;
         SocketManager.Instance.out.sendGetLevelFundAward(this._info.level);
      }
      
      private function removeEvent() : void
      {
         this._getAwardBtn.removeEventListener("click",this.__getAwardBtnClickHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._itemLine);
         this._itemLine = null;
         ObjectUtils.disposeObject(this._moneyIcon);
         this._moneyIcon = null;
         ObjectUtils.disposeObject(this._levelTxt);
         this._levelTxt = null;
         ObjectUtils.disposeObject(this._buyMultipleTxt);
         this._buyMultipleTxt = null;
         ObjectUtils.disposeObject(this._getAwardBtn);
         this._getAwardBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

