package rank.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import rank.RankManager;
   import rank.data.RankAwardInfo;
   import rank.data.RankLayouInfo;
   
   public class RankInfoFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var rankTitleNameList:Array;
      
      private var type:int;
      
      private var titleBox:Sprite;
      
      private var itemBox:Sprite;
      
      private var _lastRefreshInfo:FilterFrameText;
      
      public function RankInfoFrame()
      {
         super();
         this.type = RankManager.instance.model.currentInfo.activityChildType;
         this.initView();
         this.initData();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.rankInfo.bg");
         addToContent(this._bg);
         this.titleBox = new Sprite();
         addToContent(this.titleBox);
         this.itemBox = new Sprite();
         addToContent(this.itemBox);
         addEventListener("response",this._responseHandle);
         this._lastRefreshInfo = ComponentFactory.Instance.creatComponentByStylename("rankInfo.lastRefreshText");
         addToContent(this._lastRefreshInfo);
         this._lastRefreshInfo.text = LanguageMgr.GetTranslation("ddt.rankFrame.lastRefresh",RankManager.instance.lastUpdateTime);
      }
      
      private function initData() : void
      {
         var _loc8_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         this.rankTitleNameList = LanguageMgr.GetTranslation("ddt.rankInfoFrame.rankTitle" + String(this.type)).split("|");
         var _loc7_:RankLayouInfo = ComponentFactory.Instance.creatCustomObject("rankInfo.posTitle" + String(this.type));
         _loc7_.TitleTextString = this.rankTitleNameList;
         for each(_loc8_ in _loc7_.TitleHLinePoint)
         {
            _loc1_ = ComponentFactory.Instance.creatBitmap("asset.rankInfo.titleLine");
            PositionUtils.setPos(_loc1_,_loc8_);
            this.titleBox.addChild(_loc1_);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc7_.TitleTextPoint.length)
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("rankInfo.titleText");
            PositionUtils.setPos(_loc3_,_loc7_.TitleTextPoint[_loc2_]);
            _loc3_.text = _loc7_.TitleTextString[_loc2_];
            this.titleBox.addChild(_loc3_);
            _loc2_++;
         }
         var _loc9_:int = 1;
         _loc4_ = 0;
         while(_loc4_ < RankManager.instance.reweadDataList.length)
         {
            _loc5_ = RankManager.instance.reweadDataList[_loc4_] as RankAwardInfo;
            if(_loc5_.subType == this.type && _loc5_.rank == _loc9_)
            {
               _loc6_ = new RankInfoItem(this.type,_loc5_);
               _loc6_.x = -18;
               _loc6_.y = 43 + 35 * (_loc9_ - 1);
               this.itemBox.addChild(_loc6_);
               _loc9_++;
            }
            _loc4_++;
         }
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
         super.dispose();
         removeEventListener("response",this._responseHandle);
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import ddt.manager.ItemManager;
import ddt.utils.PositionUtils;
import flash.display.Sprite;
import rank.data.RankAwardInfo;
import rank.data.RankLayouInfo;
import totem.TotemManager;

class RankInfoItem extends Sprite
{
   
   public function RankInfoItem(param1:int, param2:RankAwardInfo)
   {
      var _loc11_:* = undefined;
      var _loc3_:* = null;
      var _loc4_:int = 0;
      var _loc5_:* = null;
      var _loc6_:* = null;
      var _loc7_:* = null;
      var _loc8_:* = null;
      var _loc9_:int = 0;
      super();
      var _loc10_:RankLayouInfo = ComponentFactory.Instance.creatCustomObject("rankInfo.posInfo" + String(param1));
      for each(_loc11_ in _loc10_.TitleHLinePoint)
      {
         _loc3_ = ComponentFactory.Instance.creatBitmap("asset.rankInfo.infoLine");
         PositionUtils.setPos(_loc3_,_loc11_);
         addChild(_loc3_);
      }
      _loc4_ = 0;
      while(_loc4_ < _loc10_.TitleTextPoint.length)
      {
         _loc5_ = ComponentFactory.Instance.creatComponentByStylename("rankInfo.infoText");
         PositionUtils.setPos(_loc5_,_loc10_.TitleTextPoint[_loc4_]);
         _loc5_.width = _loc10_.InfoTextWidth[_loc4_];
         loop2:
         switch(int(param1) - 1)
         {
            case 0:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                  case 2:
                     break;
                  case 3:
                     _loc5_.text = param2.nickName;
               }
               break;
            case 1:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc5_.text = ItemManager.Instance.getTemplateById(parseInt(param2.activeParam1)).Name;
                     break;
                  case 3:
                     _loc5_.text = param2.activeValue;
               }
               break;
            case 2:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc5_.text = param2.itemName;
                     break;
                  case 3:
                     _loc5_.text = param2.activeValue;
               }
               break;
            case 3:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc5_.text = param2.activeValue;
               }
               break;
            case 4:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc5_.text = param2.activeValue;
               }
               break;
            case 5:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc9_ = TotemManager.instance.getTotemPointLevel(parseInt(param2.activeValue));
                     _loc5_.text = String(TotemManager.instance.getCurrentLv(_loc9_));
               }
               break;
            case 6:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break;
                  case 2:
                     _loc5_.text = param2.activeValue;
               }
               break;
            case 7:
               switch(int(_loc4_))
               {
                  case 0:
                     _loc5_.text = String(param2.rank);
                     break loop2;
                  case 1:
                     _loc5_.text = param2.nickName;
                     break loop2;
                  case 2:
                     _loc5_.text = param2.activeValue;
                     break loop2;
                  default:
                     break loop2;
               }
         }
         addChild(_loc5_);
         _loc4_++;
      }
   }
}
