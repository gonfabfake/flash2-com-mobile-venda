package conRecharge.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import flash.display.Sprite;
   
   public class ConRechargeRightItem extends Sprite implements Disposeable
   {
      
      private var _vbox:VBox;
      
      public function ConRechargeRightItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.rightItem.vbox");
         addChild(this._vbox);
         _loc1_ = 0;
         while(_loc1_ < ConRechargeManager.instance.dayGiftbagArray.length)
         {
            _loc2_ = new DayItem(ConRechargeManager.instance.dayGiftbagArray[_loc1_]);
            this._vbox.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
      }
   }
}

import bagAndInfo.cell.BagCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.controls.BaseButton;
import com.pickgliss.ui.controls.container.HBox;
import com.pickgliss.ui.core.Component;
import com.pickgliss.utils.ObjectUtils;
import conRecharge.ConRechargeManager;
import ddt.data.goods.InventoryItemInfo;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.SocketManager;
import ddt.utils.PositionUtils;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import wonderfulActivity.WonderfulActivityManager;
import wonderfulActivity.data.GiftBagInfo;
import wonderfulActivity.data.SendGiftInfo;

class DayItem extends Component
{
   
   private var _bg:Bitmap;
   
   private var _btn:BaseButton;
   
   private var _hbox:HBox;
   
   private var _info:GiftBagInfo;
   
   private var _statusArr:Array;
   
   private var _num:*;
   
   public function DayItem(param1:GiftBagInfo)
   {
      var _loc2_:* = null;
      var _loc3_:int = 0;
      var _loc4_:* = null;
      var _loc5_:* = null;
      var _loc6_:* = null;
      var _loc7_:* = null;
      var _loc8_:* = null;
      super();
      this._info = param1;
      this._bg = ComponentFactory.Instance.creatBitmap("asset.conRecharge.rightItem.bg");
      addChild(this._bg);
      this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).statusArr;
      this._statusArr.sortOn("statusID",16);
      if(WonderfulActivityManager.Instance.getActivityInitDataById(ConRechargeManager.instance.actId).giftInfoDic[param1.giftbagId].times != 0)
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.havaReceived.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
         this._btn.enable = false;
      }
      else if(param1.giftConditionArr[0].conditionValue > this._statusArr[0].statusValue)
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.canReceive.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
         this._btn.enable = false;
      }
      else
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.canReceive.btn");
         addChild(this._btn);
         this._btn.addEventListener("click",this.clickHandler);
      }
      this._num = this.creatNumberSprite(param1.giftConditionArr[0].conditionValue,"asset.conRecharge.red");
      addChild(this._num);
      PositionUtils.setPos(this._num,"asset.conRecharge.red.pos");
      this._hbox = ComponentFactory.Instance.creatComponentByStylename("conRecharge.rightItem.hbox");
      addChild(this._hbox);
      _loc3_ = 0;
      while(_loc3_ < param1.giftRewardArr.length)
      {
         _loc4_ = param1.giftRewardArr[_loc3_].property.split(",");
         _loc5_ = ItemManager.Instance.getTemplateById(param1.giftRewardArr[_loc3_].templateId) as ItemTemplateInfo;
         _loc6_ = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc6_,_loc5_);
         _loc6_.StrengthenLevel = _loc4_[0];
         _loc6_.AttackCompose = _loc4_[1];
         _loc6_.DefendCompose = _loc4_[2];
         _loc6_.AgilityCompose = _loc4_[3];
         _loc6_.LuckCompose = _loc4_[4];
         _loc6_.ValidDate = param1.giftRewardArr[_loc3_].validDate;
         _loc6_.IsBinds = param1.giftRewardArr[_loc3_].isBind;
         _loc6_.Count = param1.giftRewardArr[_loc3_].count;
         _loc7_ = ComponentFactory.Instance.creatBitmap("asset.conRecharge.goodsBG");
         _loc8_ = new BagCell(0,_loc6_,false,_loc7_);
         this._hbox.addChild(_loc8_);
         _loc3_++;
      }
   }
   
   private function creatNumberSprite(param1:int, param2:String, param3:int = 0) : Sprite
   {
      var _loc4_:int = 0;
      var _loc5_:* = null;
      var _loc6_:Sprite = new Sprite();
      var _loc7_:String = String(param1);
      _loc4_ = 0;
      while(_loc4_ < _loc7_.length)
      {
         _loc5_ = ComponentFactory.Instance.creatBitmap(param2 + _loc7_.substr(_loc4_,1));
         _loc6_.addChild(_loc5_);
         _loc5_.x = (_loc5_.width + param3) * _loc4_;
         _loc4_++;
      }
      return _loc6_;
   }
   
   private function clickHandler(param1:MouseEvent) : void
   {
      var _loc2_:SendGiftInfo = new SendGiftInfo();
      _loc2_.activityId = ConRechargeManager.instance.actId;
      _loc2_.giftIdArr = [this._info.giftbagId];
      var _loc3_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
      _loc3_.push(_loc2_);
      SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc3_);
      ObjectUtils.disposeObject(this._btn);
      this._btn.removeEventListener("click",this.clickHandler);
      this._btn = ComponentFactory.Instance.creatComponentByStylename("conRecharge.havaReceived.btn");
      addChild(this._btn);
      this._btn.enable = false;
   }
   
   override public function dispose() : void
   {
      super.dispose();
      this._btn.removeEventListener("click",this.clickHandler);
      ObjectUtils.disposeObject(this._bg);
      this._bg = null;
      ObjectUtils.disposeObject(this._btn);
      this._btn = null;
      ObjectUtils.disposeObject(this._hbox);
      this._hbox = null;
      ObjectUtils.disposeObject(this._num);
      this._num = null;
   }
}
