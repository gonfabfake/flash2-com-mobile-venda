package signActivity.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import signActivity.SignActivityMgr;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class SignActivityItem extends Sprite
   {
      
      public static var length:int = 1;
      
      public static var btnIndex:int = 1;
      
      public static var btnBigIndex:int = 1;
      
      public static var continuousGoodsIndex:int = 1;
      
      private var giftInfo:GiftBagInfo;
      
      private var _smallBtn:BaseButton;
      
      private var _goodEveryDayItemContainerAll:Sprite;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _tag:Bitmap;
      
      private var _day:int;
      
      private var _money:int;
      
      private var _index:int;
      
      private var condition:int;
      
      private var tagIndex:int;
      
      private var leftIndex:int;
      
      private var dayArray:Array = [3,7,14];
      
      private var _desText:FilterFrameText;
      
      public function SignActivityItem(param1:int, param2:int)
      {
         super();
         this._day = param1;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._smallBtn))
         {
            this._smallBtn.removeEventListener("click",this.getRewardBtnClick);
         }
         if(this._day == this.dayArray[2] && Boolean(this._goodEveryDayItemContainerAll))
         {
            this._goodEveryDayItemContainerAll.removeEventListener("rollOver",this.__onOver);
            this._goodEveryDayItemContainerAll.removeEventListener("rollOut",this.__onOut);
         }
      }
      
      private function getRewardBtnClick(param1:MouseEvent) : void
      {
         var _loc3_:SendGiftInfo = null;
         var _loc2_:int = 0;
         _loc3_ = new SendGiftInfo();
         _loc3_.activityId = SignActivityMgr.instance.model.actId;
         var _loc4_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < this.giftInfo.giftRewardArr.length)
         {
            _loc4_[_loc2_] = this.giftInfo.giftbagId;
            _loc2_++;
         }
         _loc3_.giftIdArr = _loc4_;
         var _loc5_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         _loc5_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc5_);
         this.setGetBtnEnalbe(false);
      }
      
      public function setGetBtnEnalbe(param1:*) : void
      {
         if(Boolean(this._smallBtn))
         {
            ObjectUtils.disposeObject(this._smallBtn);
            this._smallBtn = null;
         }
         if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this._tag = ComponentFactory.Instance.creatBitmap("asset.signactivity.tag");
            PositionUtils.setPos(this._tag,"asset.signactivity.tag.pos." + this._day + "." + (this.tagIndex + 1));
            addChild(this._tag);
         }
         else
         {
            this.createBigBtn(this.leftIndex + 1,false);
            addChild(this._smallBtn);
            this._smallBtn.enable = param1;
            ++this.leftIndex;
         }
      }
      
      public function setGoods(param1:GiftBagInfo) : void
      {
         this.giftInfo = param1;
         this.condition = this._money;
         if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this.everyDayGoods();
         }
         else
         {
            this.continuousGoods();
         }
      }
      
      private function everyDayGoods() : void
      {
         var _loc6_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(Boolean(this._goodEveryDayItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodEveryDayItemContainerAll);
            this._goodEveryDayItemContainerAll = null;
         }
         this._goodEveryDayItemContainerAll = new Sprite();
         for each(_loc6_ in this.giftInfo.giftRewardArr)
         {
            _loc1_ = _loc6_.property.split(",");
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.signactivity.goodsBG");
            _loc3_ = ItemManager.Instance.getTemplateById(_loc6_.templateId) as ItemTemplateInfo;
            _loc4_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc4_,_loc3_);
            _loc4_.StrengthenLevel = _loc1_[0];
            _loc4_.AttackCompose = _loc1_[1];
            _loc4_.DefendCompose = _loc1_[2];
            _loc4_.AgilityCompose = _loc1_[3];
            _loc4_.LuckCompose = _loc1_[4];
            _loc4_.ValidDate = _loc6_.validDate;
            _loc4_.IsBinds = _loc6_.isBind;
            _loc4_.Count = _loc6_.count;
            _loc5_ = new BagCell(0,_loc4_,false);
            _loc5_.setBgVisible(false);
            _loc5_.setCount(_loc4_.Count);
            this._goodEveryDayItemContainerAll.addChild(_loc2_);
            this._goodEveryDayItemContainerAll.addChild(_loc5_);
         }
         addChild(this._goodEveryDayItemContainerAll);
         PositionUtils.setPos(this._goodEveryDayItemContainerAll,"everyDayGoods." + this._day + "." + length);
         ++length;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         if(this._day == this.dayArray[2])
         {
            this.addEventListener("mouseOver",this.__onOver);
            this.addEventListener("mouseOut",this.__onOut);
         }
      }
      
      private function __onOver(param1:MouseEvent) : void
      {
         if(Boolean(this._smallBtn))
         {
            this._smallBtn.visible = true;
         }
      }
      
      private function __onOut(param1:MouseEvent) : void
      {
         if(Boolean(this._smallBtn))
         {
            this._smallBtn.visible = false;
         }
      }
      
      private function continuousGoods() : void
      {
         var _loc7_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = new Sprite();
         var _loc6_:int = 0;
         for each(_loc7_ in this.giftInfo.giftRewardArr)
         {
            _loc1_ = _loc7_.property.split(",");
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.signactivity.goodsBG");
            _loc3_ = ItemManager.Instance.getTemplateById(_loc7_.templateId) as ItemTemplateInfo;
            _loc4_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc4_,_loc3_);
            _loc4_.StrengthenLevel = _loc1_[0];
            _loc4_.AttackCompose = _loc1_[1];
            _loc4_.DefendCompose = _loc1_[2];
            _loc4_.AgilityCompose = _loc1_[3];
            _loc4_.LuckCompose = _loc1_[4];
            _loc4_.ValidDate = _loc7_.validDate;
            _loc4_.IsBinds = _loc7_.isBind;
            _loc4_.Count = _loc7_.count;
            _loc5_ = new BagCell(0,_loc4_,false);
            if(this._day == this.dayArray[2])
            {
               _loc5_.width = 42;
               _loc5_.height = 42;
               _loc2_.width = _loc2_.height = 45;
               _loc2_.x = _loc6_ * (_loc2_.width + 2);
               _loc5_.x = _loc2_.x + 5;
            }
            else
            {
               _loc2_.x = _loc6_ * (_loc2_.width + 2);
               _loc5_.x = _loc2_.x + 5;
            }
            _loc2_.y = 20;
            _loc5_.y = 25;
            _loc5_.setBgVisible(false);
            _loc5_.setCount(_loc4_.Count);
            this._goodItemContainerAll.addChild(_loc2_);
            this._goodItemContainerAll.addChild(_loc5_);
            _loc6_++;
         }
         addChild(this._goodItemContainerAll);
         PositionUtils.setPos(this._goodItemContainerAll,this._day == 14 ? "continuousGoods.14" : "continuousGoods." + this._day + "." + continuousGoodsIndex);
         ++continuousGoodsIndex;
         if(this._day == 14)
         {
            this._desText = ComponentFactory.Instance.creatComponentByStylename("signActivityFrame.desTxt");
            addChild(this._desText);
            this._desText.text = LanguageMgr.GetTranslation("tank.signActivity.dexTxt",this.giftInfo.giftConditionArr[0].conditionValue);
         }
      }
      
      public function setStatus(param1:Array, param2:Dictionary, param3:int) : void
      {
         var _loc6_:int = 0;
         var _loc4_:* = null;
         this.clearBtn();
         this.tagIndex = param3;
         var _loc5_:PlayerCurInfo = param1[param3] as PlayerCurInfo;
         _loc6_ = (param2[this.giftInfo.giftbagId] as GiftCurInfo).times;
         if(_loc6_ == 0)
         {
            if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtn");
               PositionUtils.setPos(this._smallBtn,"signActivityItem.getBtn." + this._day + "." + btnIndex);
               this.leftIndex = btnIndex;
               ++btnIndex;
               if(this._day == this.dayArray[2])
               {
                  this._smallBtn.visible = false;
               }
            }
            else if(this.giftInfo.giftConditionArr[0].conditionIndex == 2)
            {
               this.createBigBtn(btnBigIndex);
               ++btnBigIndex;
            }
            addChild(this._smallBtn);
            this._smallBtn.enable = false;
            if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
            {
               if(Boolean(_loc5_))
               {
                  if(_loc5_.statusValue == 1)
                  {
                     this._smallBtn.enable = true;
                     this._smallBtn.addEventListener("click",this.getRewardBtnClick);
                  }
                  else if(_loc5_.statusValue == 2)
                  {
                     this.createTag(param3);
                  }
               }
            }
            else if(this.giftInfo.giftConditionArr[0].conditionIndex == 2)
            {
               if(Boolean(_loc5_) && _loc5_.statusValue == 1)
               {
                  this._smallBtn.enable = true;
                  this._smallBtn.addEventListener("click",this.getRewardBtnClick);
               }
            }
         }
         else if(this.giftInfo.giftConditionArr[0].conditionIndex == 1)
         {
            this.createTag(param3);
            ++btnIndex;
         }
         else
         {
            this.createBigBtn(btnBigIndex,false);
            ++btnBigIndex;
            this._smallBtn.enable = false;
            addChild(this._smallBtn);
         }
      }
      
      private function createBigBtn(param1:int, param2:Boolean = true) : void
      {
         if(param2)
         {
            if(this._day != this.dayArray[0])
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig2");
            }
            else
            {
               this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig");
            }
         }
         else if(this._day != this.dayArray[0])
         {
            this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig3");
         }
         else
         {
            this._smallBtn = ComponentFactory.Instance.creat("signActivityItem.getBtnBig4");
         }
         PositionUtils.setPos(this._smallBtn,this._day == 14 ? "signActivityItem.getBtnBig.14" : "signActivityItem.getBtnBig." + this._day + "." + param1);
      }
      
      private function createTag(param1:int) : void
      {
         if(Boolean(this._smallBtn))
         {
            ObjectUtils.disposeObject(this._smallBtn);
            this._smallBtn = null;
         }
         this._tag = ComponentFactory.Instance.creatBitmap("asset.signactivity.tag");
         PositionUtils.setPos(this._tag,"asset.signactivity.tag.pos." + this._day + "." + (param1 + 1));
         addChild(this._tag);
      }
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._smallBtn);
         this._smallBtn = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._desText))
         {
            ObjectUtils.disposeObject(this._desText);
            this._desText = null;
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._smallBtn);
         this._smallBtn = null;
      }
   }
}

