package wonderfulActivity.newActivity.returnActivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   import wonderfulActivity.data.SendGiftInfo;
   import wonderfulActivity.items.PrizeListItem;
   
   public class ReturnListItem extends Sprite implements Disposeable
   {
      
      private var _back:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _prizeHBox:HBox;
      
      private var _btn:SimpleBitmapButton;
      
      private var _btnTxt:FilterFrameText;
      
      private var _tipsBtn:Bitmap;
      
      private var type:int;
      
      private var actId:String;
      
      private var giftInfo:GiftBagInfo;
      
      private var condition:int;
      
      public function ReturnListItem(param1:int, param2:String)
      {
         super();
         this.type = param1;
         this.actId = param2;
         this.initView();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("wonderfulactivity.listItem");
         addChild(this._back);
         if(this.type == 0)
         {
            this._back.gotoAndStop(1);
         }
         else
         {
            this._back.gotoAndStop(2);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.returnItem.nameTxt");
         addChild(this._nameTxt);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         this._prizeHBox = ComponentFactory.Instance.creatComponentByStylename("wonderful.returnActivity.Hbox");
         addChild(this._prizeHBox);
      }
      
      public function setData(param1:String, param2:GiftBagInfo) : void
      {
         var _loc3_:GiftRewardInfo = null;
         var _loc4_:PrizeListItem = null;
         this.giftInfo = param2;
         this.condition = this.giftInfo.giftConditionArr[0].conditionValue;
         this._nameTxt.text = param1.replace(/{\d+}/g,this.condition);
         this._nameTxt.y = this._back.height / 2 - this._nameTxt.height / 2;
         var _loc5_:Vector.<GiftRewardInfo> = this.giftInfo.giftRewardArr;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc5_.length - 1)
         {
            _loc3_ = _loc5_[_loc6_];
            _loc4_ = new PrizeListItem();
            _loc4_.initView(_loc6_);
            _loc4_.setCellData(_loc3_);
            this._prizeHBox.addChild(_loc4_);
            _loc6_++;
         }
      }
      
      public function setStatus(param1:int, param2:Dictionary) : void
      {
         var _loc3_:int = 0;
         this.clearBtn();
         var _loc4_:int = (param2[this.giftInfo.giftbagId] as GiftCurInfo).times;
         var _loc5_:int = this.giftInfo.giftConditionArr[2].conditionValue;
         if(_loc5_ == 0)
         {
            _loc3_ = int(Math.floor(param1 / this.condition)) - _loc4_;
            if(_loc3_ > 0)
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.smallGetBtn");
               addChild(this._btn);
               this._btnTxt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.right.btnTxt");
               this._btnTxt.text = "(" + _loc3_ + ")";
               this._btn.addChild(this._btnTxt);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._btn.addChild(this._tipsBtn);
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClicks);
            }
            else
            {
               this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
               addChild(this._btn);
               this._tipsBtn = ComponentFactory.Instance.creat("wonderfulactivity.can.repeat");
               this._tipsBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._btn.addChild(this._tipsBtn);
               this._btn.enable = false;
            }
         }
         else if(_loc4_ == 0)
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.bigGetBtn");
            addChild(this._btn);
            this._btn.enable = false;
            if(param1 >= this.condition)
            {
               this._btn.enable = true;
               this._btn.addEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
            }
         }
         else
         {
            this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
            this._btn.enable = false;
            addChild(this._btn);
         }
      }
      
      protected function getRewardBtnClicks(param1:MouseEvent) : void
      {
         var _loc2_:SendGiftInfo = new SendGiftInfo();
         _loc2_.activityId = this.actId;
         var _loc3_:Array = [];
         _loc3_.push(this.giftInfo.giftbagId);
         _loc2_.giftIdArr = _loc3_;
         var _loc4_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         _loc4_.push(_loc2_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc4_);
         this._btn.enable = false;
      }
      
      protected function getRewardBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:SendGiftInfo = new SendGiftInfo();
         _loc2_.activityId = this.actId;
         var _loc3_:Array = [];
         _loc3_.push(this.giftInfo.giftbagId);
         _loc2_.giftIdArr = _loc3_;
         var _loc4_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         _loc4_.push(_loc2_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc4_);
         if(Boolean(this._btn))
         {
            ObjectUtils.disposeObject(this._btn);
            this._btn = null;
         }
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.overBtn");
         this._btn.enable = false;
         addChild(this._btn);
      }
      
      private function clearBtn() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btn))
         {
            this._btn.removeEventListener(MouseEvent.CLICK,this.getRewardBtnClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._prizeHBox);
         this._prizeHBox = null;
         ObjectUtils.disposeObject(this._btn);
         this._btn = null;
         ObjectUtils.disposeObject(this._btnTxt);
         this._btnTxt = null;
         ObjectUtils.disposeObject(this._tipsBtn);
         this._tipsBtn = null;
      }
   }
}

