package anotherDimension.view
{
   import anotherDimension.controller.AnotherDimensionManager;
   import anotherDimension.model.AnotherDimensionResourceInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   
   public class AnotherDimensionOtherTip extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _chanchuTitleTxt:FilterFrameText;
      
      private var _chanliangTitleTxt:FilterFrameText;
      
      private var _canLueduoTitleTxt:FilterFrameText;
      
      private var _chanchuText:FilterFrameText;
      
      private var _chanliangText:FilterFrameText;
      
      private var _canLueduoText:FilterFrameText;
      
      private var _line2:ScaleBitmapImage;
      
      private var _haveItemText:FilterFrameText;
      
      private var _info:AnotherDimensionResourceInfo;
      
      private var hourTime:Number = 3600000;
      
      private var minuteTime:Number = 60000;
      
      public function AnotherDimensionOtherTip(param1:AnotherDimensionResourceInfo)
      {
         super();
         this._info = param1;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._bg.width = 210;
         this._bg.height = 120;
         addChild(this._bg);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 190;
         this._line.x = 4;
         this._line.y = 36;
         addChild(this._line);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.titleText");
         addChild(this._titleTxt);
         this._chanchuTitleTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.chanchuTitleTxt");
         addChild(this._chanchuTitleTxt);
         this._chanchuTitleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.chanchuTitleTxt");
         this._chanliangTitleTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.chanliangTitleTxt");
         addChild(this._chanliangTitleTxt);
         this._chanliangTitleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.chanliangTitleTxt");
         this._canLueduoTitleTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.canLueduoTitleTxt");
         addChild(this._canLueduoTitleTxt);
         this._chanchuText = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.chanchuText");
         addChild(this._chanchuText);
         var _loc2_:int = param1.itemId;
         var _loc3_:String = ItemManager.Instance.getTemplateById(_loc2_).Name;
         this._chanchuText.text = _loc3_;
         this._chanliangText = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.chanliangText");
         addChild(this._chanliangText);
         this._chanliangText.text = LanguageMgr.GetTranslation("anotherDimension.itemCountTxt",param1.itemCountPerHour);
         this._canLueduoText = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.canLueduoText");
         addChild(this._canLueduoText);
         this._haveItemText = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemTip.haveItemText");
         addChild(this._haveItemText);
         this._haveItemText.visible = false;
      }
      
      public function setSelfTipStyle(param1:AnotherDimensionResourceInfo) : void
      {
         this._bg.height = 150;
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line2.width = 190;
         this._line2.x = 4;
         this._line2.y = 116;
         addChild(this._line2);
         this._haveItemText.visible = true;
         var _loc2_:int = this.getItemCountByTime2(param1);
         this._haveItemText.text = LanguageMgr.GetTranslation("anotherDimensionitemCountTxt.alreadGetTxt",_loc2_);
      }
      
      private function getItemCountByTime(param1:AnotherDimensionResourceInfo) : int
      {
         var _loc2_:Date = null;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         _loc2_ = param1.haveResourceTime;
         if(_loc2_ == null)
         {
            return 0;
         }
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:Number = _loc2_.getTime();
         var _loc5_:Number = _loc3_.getTime();
         var _loc6_:Number = _loc5_ - _loc4_;
         _loc7_ = Math.floor(_loc6_ / this.minuteTime);
         if(_loc7_ >= param1.lastMaxMunites)
         {
            _loc7_ = param1.lastMaxMunites;
         }
         var _loc8_:int = Math.floor(param1.itemCountPerHour * _loc7_ / 120);
         _loc9_ = Math.floor(_loc8_ / 3);
         if(_loc9_ <= 0)
         {
            _loc9_ = 1;
         }
         return _loc9_;
      }
      
      private function getItemCountByTime2(param1:AnotherDimensionResourceInfo) : int
      {
         var _loc2_:Date = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = param1.haveResourceTime;
         if(_loc2_ == null)
         {
            return 0;
         }
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:Number = _loc2_.getTime();
         var _loc5_:Number = _loc3_.getTime();
         var _loc6_:Number = _loc5_ - _loc4_;
         _loc7_ = Math.floor(_loc6_ / this.minuteTime);
         if(_loc7_ >= param1.lastMaxMunites)
         {
            _loc7_ = param1.lastMaxMunites;
         }
         _loc8_ = Math.floor(param1.itemCountPerHour * _loc7_ / 120);
         if(_loc8_ <= 0)
         {
            _loc8_ = 1;
         }
         return _loc8_;
      }
      
      public function refreshView(param1:AnotherDimensionResourceInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1.monsterId == 0)
         {
            this._titleTxt.text = param1.resourcePlayerInfo.NickName;
            this._canLueduoTitleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.canlueduotxt");
            this._canLueduoText.htmlText = this.getItemCountByTime(param1) + LanguageMgr.GetTranslation("anotherDimensionitemCountTxt.txt");
         }
         else
         {
            this._canLueduoTitleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.canzhanlingtxt");
            _loc2_ = param1.haveResourceLast / 60;
            if(_loc2_ == 0)
            {
               _loc2_ = 2;
            }
            if(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv == 0)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc3_ = int(this.getTimeControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[2]);
            }
            this._canLueduoText.htmlText = LanguageMgr.GetTranslation("anotherDimensionitemCountTxt.hourtxt",_loc2_,_loc3_);
            if(param1.resourceLevel == 1)
            {
               this._titleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.downLevel");
            }
            else if(param1.resourceLevel == 2)
            {
               this._titleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.middleLevel");
            }
            else if(param1.resourceLevel == 3)
            {
               this._titleTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionOtherItemTip.topLevel");
            }
         }
      }
      
      private function getTimeControlExpBylv(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getTimeControl();
         _loc3_ = _loc2_[param1 - 1];
         return _loc3_.split(",");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._titleTxt = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

