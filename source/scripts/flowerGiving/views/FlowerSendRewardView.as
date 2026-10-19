package flowerGiving.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.components.FlowerSendRewardItem;
   import flowerGiving.events.FlowerGivingEvent;
   import road7th.comm.PackageIn;
   
   public class FlowerSendRewardView extends Sprite implements Disposeable
   {
      
      private var _back:Bitmap;
      
      private var _titleTxt1:FilterFrameText;
      
      private var _titleTxt2:FilterFrameText;
      
      private var _titleTxt3:FilterFrameText;
      
      private var _myFlowerTitleTxt:FilterFrameText;
      
      private var _myFlowerNumTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _listItem:Vector.<FlowerSendRewardItem>;
      
      private var dataArr:Array;
      
      public function FlowerSendRewardView()
      {
         super();
         this.initData();
         this.initView();
         this.addEvents();
      }
      
      private function initData() : void
      {
         this._listItem = new Vector.<FlowerSendRewardItem>();
         this.dataArr = FlowerGivingManager.instance.getDataByRewardMark(6);
         SocketManager.Instance.out.getFlowerRewardStatus();
      }
      
      private function initView() : void
      {
         var _loc1_:FlowerSendRewardItem = null;
         this._back = ComponentFactory.Instance.creat("flowerGiving.accumuGivingBack");
         addChild(this._back);
         this._titleTxt1 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt1);
         PositionUtils.setPos(this._titleTxt1,"flowerGiving.sendView.title1Pos");
         this._titleTxt1.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title1Txt");
         this._titleTxt2 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt2);
         PositionUtils.setPos(this._titleTxt2,"flowerGiving.sendView.title2Pos");
         this._titleTxt2.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title2Txt");
         this._titleTxt3 = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         addChild(this._titleTxt3);
         PositionUtils.setPos(this._titleTxt3,"flowerGiving.sendView.title3Pos");
         this._titleTxt3.text = LanguageMgr.GetTranslation("flowerGiving.sendView.title3Txt");
         this._myFlowerTitleTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerTitleTxt");
         addChild(this._myFlowerTitleTxt);
         PositionUtils.setPos(this._myFlowerTitleTxt,"flowerGiving.sendView.myFlowerTitlePos");
         this._myFlowerTitleTxt.text = LanguageMgr.GetTranslation("flowerGiving.sendView.myFlowerTitle");
         this._myFlowerNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerNumTxt");
         addChild(this._myFlowerNumTxt);
         PositionUtils.setPos(this._myFlowerNumTxt,"flowerGiving.sendView.myFlowerNumPos");
         this._myFlowerNumTxt.text = "999";
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.vBox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.scrollpanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         var _loc2_:int = 0;
         while(_loc2_ <= this.dataArr.length - 1)
         {
            _loc1_ = new FlowerSendRewardItem(_loc2_);
            _loc1_.info = this.dataArr[_loc2_];
            this._listItem.push(_loc1_);
            this._vbox.addChild(_loc1_);
            _loc2_++;
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
      }
      
      protected function __getRewardSuccess(param1:FlowerGivingEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            SocketManager.Instance.out.getFlowerRewardStatus();
         }
      }
      
      protected function __updateRewardStatus(param1:FlowerGivingEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = 0;
         while(_loc7_ <= this._listItem.length - 1)
         {
            if(_loc6_ >= (this._listItem[_loc7_] as FlowerSendRewardItem).num)
            {
               (this._listItem[_loc7_] as FlowerSendRewardItem).setBtnEnable(1);
               if((_loc5_ & 1 << _loc7_) != 0)
               {
                  (this._listItem[_loc7_] as FlowerSendRewardItem).setBtnEnable(2);
               }
            }
            else
            {
               (this._listItem[_loc7_] as FlowerSendRewardItem).setBtnEnable(0);
            }
            _loc7_++;
         }
         this._myFlowerNumTxt.text = _loc6_.toString();
      }
      
      private function updateView() : void
      {
         var _loc1_:FlowerSendRewardItem = null;
         var _loc2_:int = 0;
         while(_loc2_ <= this.dataArr.length - 1)
         {
            _loc1_ = new FlowerSendRewardItem(_loc2_);
            this._listItem.push(_loc1_);
            this._vbox.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
      }
      
      public function dispose() : void
      {
         var _loc1_:FlowerSendRewardItem = null;
         this.removeEvents();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._titleTxt1))
         {
            ObjectUtils.disposeObject(this._titleTxt1);
         }
         this._titleTxt1 = null;
         if(Boolean(this._titleTxt2))
         {
            ObjectUtils.disposeObject(this._titleTxt2);
         }
         this._titleTxt2 = null;
         if(Boolean(this._titleTxt3))
         {
            ObjectUtils.disposeObject(this._titleTxt3);
         }
         this._titleTxt3 = null;
         if(Boolean(this._myFlowerTitleTxt))
         {
            ObjectUtils.disposeObject(this._myFlowerTitleTxt);
         }
         this._myFlowerTitleTxt = null;
         if(Boolean(this._myFlowerNumTxt))
         {
            ObjectUtils.disposeObject(this._myFlowerNumTxt);
         }
         this._myFlowerNumTxt = null;
         for each(_loc1_ in this._listItem)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._listItem = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(Boolean(parent))
         {
            ObjectUtils.disposeObject(this);
         }
      }
   }
}

