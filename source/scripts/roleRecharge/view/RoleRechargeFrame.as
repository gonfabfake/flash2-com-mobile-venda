package roleRecharge.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import roleRecharge.RoleRechargeMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class RoleRechargeFrame extends Frame
   {
      
      private var _Bg:Bitmap;
      
      private var _activeTimeTxt:FilterFrameText;
      
      private var _promptTxt:FilterFrameText;
      
      private var _giftbagArray:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _itemList:Vector.<RoleRechargeItem>;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _payBtn:BaseButton;
      
      private var _selectBtn:SelectedCheckButton;
      
      private var actId:String;
      
      private var _xmlData:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var _statusArr:Array;
      
      public function RoleRechargeFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
         this.initGoods();
      }
      
      private function initView() : void
      {
         this._Bg = ComponentFactory.Instance.creatBitmap("roleRecharge.bg");
         this._activeTimeTxt = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.activeTimeTxt");
         this._activeTimeTxt.text = RoleRechargeMgr.instance.model.beginTime + " -- " + RoleRechargeMgr.instance.model.endTime;
         this._promptTxt = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.promptTxt");
         this._promptTxt.text = LanguageMgr.GetTranslation("RoleRechargeFrame.promptTxtL");
         addToContent(this._Bg);
         addToContent(this._activeTimeTxt);
         addToContent(this._promptTxt);
         this._giftbagArray = RoleRechargeMgr.instance.model.giftbagArray;
         this._list = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.GiftBagArrayContainer");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.scrollpanel");
         this._panel.width = 545;
         this._panel.height = 260;
         addToContent(this._panel);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.btnBg");
         addToContent(this._btnBg);
         this._payBtn = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.payBtn");
         addToContent(this._payBtn);
         this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("RoleRechargeFrame.checkBtn");
         this._selectBtn.text = LanguageMgr.GetTranslation("dayNotTips");
         this._selectBtn.selected = SharedManager.Instance.roleRechargeOpenDay == TimeManager.Instance.Now().date;
         this._selectBtn.visible = false;
         addToContent(this._selectBtn);
      }
      
      private function initData() : void
      {
         this._itemList = new Vector.<RoleRechargeItem>();
         this.actId = RoleRechargeMgr.instance.model.actId;
         this._xmlData = WonderfulActivityManager.Instance.getActivityDataById(this.actId);
         this._giftInfoDic = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).giftInfoDic;
         this._statusArr = WonderfulActivityManager.Instance.getActivityInitDataById(this.actId).statusArr;
      }
      
      private function initGoods() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(!this._xmlData)
         {
            return;
         }
         var _loc4_:Array = this._xmlData.giftbagArray;
         _loc1_ = 1;
         while(_loc1_ < 4)
         {
            _loc3_ = int(this._giftbagArray[_loc1_].giftConditionArr[0].conditionValue);
            _loc2_ = ComponentFactory.Instance.creatCustomObject("RoleRechargeFrame.RoleRechargeItem",[_loc3_,_loc1_]);
            _loc2_.setGoods(_loc4_[_loc1_]);
            this._itemList.push(_loc2_);
            this._list.addChild(_loc2_);
            _loc1_++;
         }
         this._panel.setView(this._list);
         this._panel.invalidateViewport();
         this.refresh();
      }
      
      public function refresh() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ <= this._itemList.length - 1)
         {
            (this._itemList[_loc1_] as RoleRechargeItem).setStatus(this._statusArr,this._giftInfoDic);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._payBtn.addEventListener("click",this.__onClickPay);
         this._selectBtn.addEventListener("click",this.__onClickSelectedBtn);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._payBtn.removeEventListener("click",this.__onClickPay);
         this._selectBtn.removeEventListener("click",this.__onClickSelectedBtn);
      }
      
      private function __onClickSelectedBtn(param1:MouseEvent) : void
      {
         if(this._selectBtn.selected)
         {
            SharedManager.Instance.roleRechargeOpenDay = TimeManager.Instance.Now().date;
         }
         else
         {
            SharedManager.Instance.roleRechargeOpenDay = 0;
         }
         SharedManager.Instance.save();
      }
      
      private function __onClickPay(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LeavePageManager.leaveToFillPath();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._payBtn = null;
         this._btnBg = null;
         this._selectBtn = null;
      }
   }
}

