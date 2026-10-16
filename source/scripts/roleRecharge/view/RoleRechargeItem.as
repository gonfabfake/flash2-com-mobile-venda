package roleRecharge.view
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
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import roleRecharge.RoleRechargeMgr;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class RoleRechargeItem extends Sprite
   {
      
      private var _btn:BaseButton;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _moneyTxt:FilterFrameText;
      
      private var giftInfo:GiftBagInfo;
      
      private var _getIcon:Bitmap;
      
      private var _money:int;
      
      private var _index:int;
      
      private var condition:int;
      
      public function RoleRechargeItem(param1:int, param2:int)
      {
         super();
         this._money = param1;
         this._index = param2;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeItem.moneyTxt");
         this._moneyTxt.text = LanguageMgr.GetTranslation("RoleRechargeItem.moneyL",this._money);
         addChild(this._moneyTxt);
         this._getIcon = ComponentFactory.Instance.creatBitmap("roleRecharge.get");
         addChild(this._getIcon);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener("click",this.getRewardBtnClick);
         }
      }
      
      public function setGetBtnEnalbe(param1:*) : void
      {
         this._btn.enable = param1;
      }
      
      public function setGoods(param1:GiftBagInfo) : void
      {
         var _loc10_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         this.giftInfo = param1;
         this.condition = this._money;
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = new Sprite();
         this._goodItemContainerAll.x = 128;
         this._goodItemContainerAll.y = -18;
         var _loc9_:int = 0;
         for each(_loc10_ in this.giftInfo.giftRewardArr)
         {
            _loc2_ = _loc10_.property.split(",");
            _loc3_ = ComponentFactory.Instance.creatBitmap("roleRecharge.item");
            _loc4_ = _loc3_.width + 5;
            _loc4_ *= int(_loc9_ % 5);
            _loc3_.x = _loc4_;
            _loc3_.y = 20;
            _loc5_ = ItemManager.Instance.getTemplateById(_loc10_.templateId) as ItemTemplateInfo;
            _loc6_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc6_,_loc5_);
            _loc6_.StrengthenLevel = _loc2_[0];
            _loc6_.AttackCompose = _loc2_[1];
            _loc6_.DefendCompose = _loc2_[2];
            _loc6_.AgilityCompose = _loc2_[3];
            _loc6_.LuckCompose = _loc2_[4];
            _loc6_.ValidDate = _loc10_.validDate;
            _loc6_.IsBinds = _loc10_.isBind;
            _loc6_.Count = _loc10_.count;
            _loc7_ = new BagCell(0,_loc6_,false);
            if(_loc6_.MaxCount == 1 && _loc6_.Count > _loc6_.MaxCount)
            {
               _loc8_ = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
               _loc8_.text = String(_loc6_.Count);
               _loc8_.x = 34;
               _loc8_.y = 31;
               _loc7_.addChild(_loc8_);
            }
            _loc7_.x = _loc4_ + 2;
            _loc7_.y = 23;
            _loc7_.setBgVisible(false);
            this._goodItemContainerAll.addChild(_loc3_);
            this._goodItemContainerAll.addChild(_loc7_);
            _loc9_++;
         }
         addChild(this._goodItemContainerAll);
      }
      
      public function setStatus(param1:Array, param2:Dictionary) : void
      {
         var _loc6_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.clearBtn();
         var _loc5_:int = (param2[this.giftInfo.giftbagId] as GiftCurInfo).times;
         for each(_loc6_ in param1)
         {
            if(_loc6_.statusID == this.condition)
            {
               _loc3_ = _loc6_.statusValue - _loc5_;
            }
         }
         if(_loc5_ == 0)
         {
            this._btn = ComponentFactory.Instance.creat("RoleRechargeItem.getBtn");
            addChild(this._btn);
            this._btn.enable = false;
            if(_loc3_ > 0)
            {
               this._btn.enable = true;
               this._btn.addEventListener("click",this.getRewardBtnClick);
            }
            this._getIcon.visible = false;
         }
         else
         {
            this._getIcon.visible = true;
         }
      }
      
      private function getRewardBtnClick(param1:MouseEvent) : void
      {
         var _loc3_:SendGiftInfo = null;
         var _loc2_:int = 0;
         _loc3_ = new SendGiftInfo();
         _loc3_.activityId = RoleRechargeMgr.instance.model.actId;
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
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._btn = null;
         this._getIcon = null;
      }
   }
}

