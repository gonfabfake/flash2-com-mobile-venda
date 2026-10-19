package condiscount.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import condiscount.CondiscountManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class CondiscountFrame extends Frame
   {
      
      private var _timeTxt:FilterFrameText;
      
      private var _2dis:Bitmap;
      
      private var _3dis:Bitmap;
      
      private var _4dis:Bitmap;
      
      private var _5dis:Bitmap;
      
      private var itemList:Array;
      
      private var box:Sprite;
      
      private var _helpBtn:BaseButton;
      
      private var _dis1:int;
      
      private var _dis2:int;
      
      private var _dis3:int;
      
      private var _dis4:int;
      
      private var _pcBitmap1:Bitmap;
      
      private var _pcBitmap2:Bitmap;
      
      private var _pcBitmap3:Bitmap;
      
      private var _pcBitmap4:Bitmap;
      
      private var _disNumber1:NumberImage;
      
      private var _disNumber2:NumberImage;
      
      private var _disNumber3:NumberImage;
      
      private var _disNumber4:NumberImage;
      
      public function CondiscountFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc5_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("condiscount.view.timeText");
         addToContent(this._timeTxt);
         this._timeTxt.text = LanguageMgr.GetTranslation("ddt.condiscount.view.time",CondiscountManager.instance.model.beginTime,CondiscountManager.instance.model.endTime);
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"condiscount.view.helpbtn",{
            "x":743,
            "y":50
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"condiscount.content.help",438,520);
         this._2dis = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.bg");
         this._3dis = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.bg");
         this._4dis = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.bg");
         this._5dis = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.bg");
         PositionUtils.setPos(this._2dis,"condiscount.view.discount.bg.pos1");
         PositionUtils.setPos(this._3dis,"condiscount.view.discount.bg.pos2");
         PositionUtils.setPos(this._4dis,"condiscount.view.discount.bg.pos3");
         PositionUtils.setPos(this._5dis,"condiscount.view.discount.bg.pos4");
         addToContent(this._2dis);
         addToContent(this._3dis);
         addToContent(this._4dis);
         addToContent(this._5dis);
         this._pcBitmap1 = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.p");
         this._pcBitmap2 = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.p");
         this._pcBitmap3 = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.p");
         this._pcBitmap4 = ComponentFactory.Instance.creatBitmap("condiscount.view.discount.p");
         PositionUtils.setPos(this._pcBitmap1,"condiscount.view.discount.pc.pos1");
         PositionUtils.setPos(this._pcBitmap2,"condiscount.view.discount.pc.pos2");
         PositionUtils.setPos(this._pcBitmap3,"condiscount.view.discount.pc.pos3");
         PositionUtils.setPos(this._pcBitmap4,"condiscount.view.discount.pc.pos4");
         addToContent(this._pcBitmap1);
         addToContent(this._pcBitmap2);
         addToContent(this._pcBitmap3);
         addToContent(this._pcBitmap4);
         this._disNumber1 = ComponentFactory.Instance.creatComponentByStylename("condiscount.number");
         this._disNumber2 = ComponentFactory.Instance.creatComponentByStylename("condiscount.number");
         this._disNumber3 = ComponentFactory.Instance.creatComponentByStylename("condiscount.number");
         this._disNumber4 = ComponentFactory.Instance.creatComponentByStylename("condiscount.number");
         PositionUtils.setPos(this._disNumber1,"condiscount.view.discount.number.pos1");
         PositionUtils.setPos(this._disNumber2,"condiscount.view.discount.number.pos2");
         PositionUtils.setPos(this._disNumber3,"condiscount.view.discount.number.pos3");
         PositionUtils.setPos(this._disNumber4,"condiscount.view.discount.number.pos4");
         addToContent(this._disNumber1);
         addToContent(this._disNumber2);
         addToContent(this._disNumber3);
         addToContent(this._disNumber4);
         this.itemList = [];
         this.box = new Sprite();
         addToContent(this.box);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.itemList[_loc1_] = [];
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc3_ = new CondiscountItem();
               this.box.addChild(_loc3_);
               for each(_loc5_ in CondiscountManager.instance.model.giftbagArray)
               {
                  if(!(_loc5_.rewardMark == _loc1_ && _loc5_.giftbagOrder == _loc2_))
                  {
                     continue;
                  }
                  _loc3_.setInfo(_loc5_);
                  if(_loc5_.rewardMark != _loc5_.giftbagOrder)
                  {
                     continue;
                  }
                  _loc4_ = 100 - int(_loc5_.giftConditionArr[0].remain2.split("|")[1]) * 10;
                  switch(int(_loc1_))
                  {
                     case 0:
                        this._disNumber1.count = _loc4_;
                        break;
                     case 1:
                        this._disNumber2.count = _loc4_;
                        break;
                     case 2:
                        this._disNumber3.count = _loc4_;
                        break;
                     case 3:
                        this._disNumber4.count = _loc4_;
                  }
               }
               this.itemList[_loc1_].push(_loc3_);
               _loc3_.x = _loc1_ * 171 + 112;
               _loc3_.y = _loc2_ * 109 + 112;
               _loc2_++;
            }
            _loc1_++;
         }
         this.setItemData();
      }
      
      private function setItemData() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               _loc3_ = this.itemList[_loc1_][_loc2_];
               if(WonderfulActivityManager.Instance.activityInitData[_loc3_.info.activityId].giftInfoDic[_loc3_.info.giftbagId].times == 1)
               {
                  _loc3_.changeData(0);
               }
               else if(_loc2_ == 0)
               {
                  _loc3_.changeData(2);
               }
               else
               {
                  for each(_loc4_ in CondiscountManager.instance.model.giftbagArray)
                  {
                     if(_loc4_.rewardMark == _loc1_ && _loc4_.giftbagOrder == _loc2_ - 1)
                     {
                        if(WonderfulActivityManager.Instance.activityInitData[_loc4_.activityId].giftInfoDic[_loc4_.giftbagId].times == 1)
                        {
                           _loc3_.changeData(2);
                        }
                        else
                        {
                           _loc3_.changeData(1);
                        }
                     }
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this._responseHandle);
         WonderfulActivityManager.Instance.removeEventListener("refresh",this.refreshActivity);
      }
      
      private function addEvent() : void
      {
         addEventListener("response",this._responseHandle);
         WonderfulActivityManager.Instance.addEventListener("refresh",this.refreshActivity);
      }
      
      private function refreshActivity(param1:WonderfulActivityEvent = null) : void
      {
         this.setItemData();
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
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._5dis);
         this._5dis = null;
         ObjectUtils.disposeObject(this._4dis);
         this._4dis = null;
         ObjectUtils.disposeObject(this._3dis);
         this._3dis = null;
         ObjectUtils.disposeObject(this._2dis);
         this._2dis = null;
         ObjectUtils.disposeObject(this.box);
         this.box = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         this.itemList = null;
      }
   }
}

