package lotteryTicket.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import lotteryTicket.LotteryManager;
   
   public class LotteryPrizeView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _firstInfoTxt:FilterFrameText;
      
      private var _secondInfoTxt:FilterFrameText;
      
      private var _thirdInfoTxt:FilterFrameText;
      
      private var _fourthInfoTxt:FilterFrameText;
      
      private var scrollPanel:ScrollPanel;
      
      public function LotteryPrizeView()
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.bg1");
         addToContent(this._bg);
         this._firstInfoTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeList.txt");
         addToContent(this._firstInfoTxt);
         this._firstInfoTxt.htmlText = LanguageMgr.GetTranslation("asset.lotteryTicket.prizeInfo",LotteryManager.instance.model.firstCount,LotteryManager.instance.model.firstMoney);
         PositionUtils.setPos(this._firstInfoTxt,"asset.lotteryTicket.prizeInfo.pos1");
         this._secondInfoTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeList.txt");
         addToContent(this._secondInfoTxt);
         this._secondInfoTxt.htmlText = LanguageMgr.GetTranslation("asset.lotteryTicket.prizeInfo",LotteryManager.instance.model.secondCount,LotteryManager.instance.model.secondMoney);
         PositionUtils.setPos(this._secondInfoTxt,"asset.lotteryTicket.prizeInfo.pos2");
         this._thirdInfoTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeList.txt");
         addToContent(this._thirdInfoTxt);
         this._thirdInfoTxt.htmlText = LanguageMgr.GetTranslation("asset.lotteryTicket.prizeInfo",LotteryManager.instance.model.thirdCount,LotteryManager.instance.model.thirdMoney);
         PositionUtils.setPos(this._thirdInfoTxt,"asset.lotteryTicket.prizeInfo.pos3");
         this._fourthInfoTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeList.txt");
         addToContent(this._fourthInfoTxt);
         this._fourthInfoTxt.htmlText = LanguageMgr.GetTranslation("asset.lotteryTicket.prizeInfo",LotteryManager.instance.model.fourthCount,LotteryManager.instance.model.fourthMoney);
         PositionUtils.setPos(this._fourthInfoTxt,"asset.lotteryTicket.prizeInfo.pos4");
         var _loc3_:Sprite = new Sprite();
         _loc1_ = 0;
         while(_loc1_ < LotteryManager.instance.model.firstPlayerInfo.length)
         {
            _loc2_ = new PrizeItem(_loc1_);
            _loc3_.addChild(_loc2_);
            _loc2_.y = _loc1_ * 37;
            _loc1_++;
         }
         this.scrollPanel = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.prizeList");
         this.scrollPanel.setView(_loc3_);
         addToContent(this.scrollPanel);
         addEventListener("response",this._responseHandle);
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
               this.dispose();
               break;
            case 1:
               this.dispose();
               break;
            case 4:
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener("response",this._responseHandle);
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._firstInfoTxt))
         {
            ObjectUtils.disposeObject(this._firstInfoTxt);
         }
         this._firstInfoTxt = null;
         if(Boolean(this._secondInfoTxt))
         {
            ObjectUtils.disposeObject(this._secondInfoTxt);
         }
         this._secondInfoTxt = null;
         if(Boolean(this._thirdInfoTxt))
         {
            ObjectUtils.disposeObject(this._thirdInfoTxt);
         }
         this._thirdInfoTxt = null;
         if(Boolean(this._fourthInfoTxt))
         {
            ObjectUtils.disposeObject(this._fourthInfoTxt);
         }
         this._fourthInfoTxt = null;
         if(Boolean(this.scrollPanel))
         {
            ObjectUtils.disposeObject(this.scrollPanel);
         }
         this.scrollPanel = null;
         super.dispose();
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.utils.PositionUtils;
import ddt.view.common.LevelIcon;
import flash.display.Bitmap;
import flash.display.Sprite;
import lotteryTicket.LotteryManager;

class PrizeItem extends Sprite
{
   
   private var bg:Bitmap;
   
   private var _zoneTxt:FilterFrameText;
   
   private var _nameTxt:FilterFrameText;
   
   private var level:LevelIcon;
   
   public function PrizeItem(param1:int)
   {
      super();
      if(param1 % 2 == 0)
      {
         this.bg = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.list1");
      }
      else
      {
         this.bg = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.list2");
      }
      addChild(this.bg);
      this._zoneTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeListInfo.txt");
      addChild(this._zoneTxt);
      this._zoneTxt.width = 110;
      this._zoneTxt.text = LotteryManager.instance.model.firstPlayerInfo[param1].split("-")[0];
      PositionUtils.setPos(this._zoneTxt,"asset.lotteryTicket.prizeZone.pos");
      this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.prizeListInfo.txt");
      addChild(this._nameTxt);
      this._nameTxt.width = 183;
      this._nameTxt.text = LotteryManager.instance.model.firstPlayerInfo[param1].split("-")[1];
      PositionUtils.setPos(this._nameTxt,"asset.lotteryTicket.prizeName.pos");
      this.level = new LevelIcon();
      PositionUtils.setPos(this.level,"asset.lotteryTicket.levelIcon.pos");
      this.level.setInfo(parseInt(LotteryManager.instance.model.firstPlayerInfo[param1].split("-")[2]),0,0,0,0,0,false,false);
      addChild(this.level);
   }
}
