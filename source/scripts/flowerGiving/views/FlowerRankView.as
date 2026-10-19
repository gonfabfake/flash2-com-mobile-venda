package flowerGiving.views
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.components.FlowerRankItem;
   import flowerGiving.data.FlowerRankInfo;
   import flowerGiving.events.FlowerGivingEvent;
   import road7th.comm.PackageIn;
   import wonderfulActivity.data.GiftBagInfo;
   
   public class FlowerRankView extends Sprite implements Disposeable
   {
      
      public static const LIST_LEN:int = 8;
      
      private var _bg:Bitmap;
      
      private var _bottomBg:Bitmap;
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _numTxt:FilterFrameText;
      
      private var _basePrizeTxt:FilterFrameText;
      
      private var _superPrizeTxt:FilterFrameText;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _prevBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _myFlowerLabel:FilterFrameText;
      
      private var _myFlowerNum:FilterFrameText;
      
      private var _myPlace:FilterFrameText;
      
      private var _outOfRank:FilterFrameText;
      
      private var _baseRequestTxt:FilterFrameText;
      
      private var _superRequestTxt:FilterFrameText;
      
      private var _getRewardBtn:SimpleBitmapButton;
      
      private var _vbox:VBox;
      
      private var _itemList:Vector.<FlowerRankItem>;
      
      private var type:int;
      
      private var myFlowerCount:int;
      
      private var myPlace:int;
      
      private var pageCount:int;
      
      private var curPage:int;
      
      private var dataArr:Array;
      
      private var ysdRwardGet:Boolean = false;
      
      private var accRwardGet:Boolean = false;
      
      public function FlowerRankView(param1:int)
      {
         super();
         this.type = param1;
         this.initData();
         this.initView();
         this.addEvents();
      }
      
      private function initData() : void
      {
         this._itemList = new Vector.<FlowerRankItem>();
         switch(this.type)
         {
            case 0:
            case 1:
               this.dataArr = FlowerGivingManager.instance.getDataByRewardMark(1);
               break;
            case 2:
               this.dataArr = FlowerGivingManager.instance.getDataByRewardMark(3);
         }
         SocketManager.Instance.out.getFlowerRankInfo(this.type,0);
         SocketManager.Instance.out.getFlowerRewardStatus();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("flowerGiving.rankBG");
         addChild(this._bg);
         this._bottomBg = ComponentFactory.Instance.creat("flowerGiving.bottomBG2");
         addChild(this._bottomBg);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         PositionUtils.setPos(this._rankTxt,"flowerGiving.rankView.rankTxtPos");
         this._rankTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.rankTxt");
         addChild(this._rankTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         PositionUtils.setPos(this._nameTxt,"flowerGiving.rankView.nameTxtPos");
         this._nameTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.nameTxt");
         addChild(this._nameTxt);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         PositionUtils.setPos(this._numTxt,"flowerGiving.rankView.numTxtPos");
         this._numTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.numTxt");
         addChild(this._numTxt);
         this._basePrizeTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         PositionUtils.setPos(this._basePrizeTxt,"flowerGiving.rankView.basePrizePos");
         this._basePrizeTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.basePrizeTxt");
         addChild(this._basePrizeTxt);
         this._superPrizeTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.titleTxt");
         PositionUtils.setPos(this._superPrizeTxt,"flowerGiving.rankView.superPrizePos");
         this._superPrizeTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.superPrizeTxt");
         addChild(this._superPrizeTxt);
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.PageCountBg");
         addChild(this._pageBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.pageTxt");
         addChild(this._pageTxt);
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.prevBtn");
         addChild(this._prevBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.nextBtn");
         addChild(this._nextBtn);
         this._myFlowerLabel = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerTitleTxt");
         PositionUtils.setPos(this._myFlowerLabel,"flowerGiving.rankView.myFlowerLabelPos");
         this._myFlowerLabel.text = LanguageMgr.GetTranslation("flowerGiving.rankView.myFlowerTitle");
         addChild(this._myFlowerLabel);
         this._myFlowerNum = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.myFlowerNumTxt");
         PositionUtils.setPos(this._myFlowerNum,"flowerGiving.rankView.myFlowerNumPos");
         addChild(this._myFlowerNum);
         this._myPlace = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.greenTxt");
         PositionUtils.setPos(this._myPlace,"flowerGiving.rankVeiw.greenTxtPos");
         this._myPlace.text = LanguageMgr.GetTranslation("flowerGiving.rankView.myPlaceTxt");
         addChild(this._myPlace);
         this._myPlace.visible = false;
         this._outOfRank = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.outOfRankTxt");
         PositionUtils.setPos(this._outOfRank,"flowerGiving.rankVeiw.greenTxtPos");
         this._outOfRank.text = LanguageMgr.GetTranslation("flowerGiving.rankView.outOfRank");
         addChild(this._outOfRank);
         this._outOfRank.visible = false;
         switch(this.type)
         {
            case 0:
               this._baseRequestTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.lightBrownTxt");
               PositionUtils.setPos(this._baseRequestTxt,"flowerGiving.rankVeiw.baseRequestPos");
               this._baseRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.baseRequest");
               addChild(this._baseRequestTxt);
               this._superRequestTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.lightBrownTxt");
               PositionUtils.setPos(this._superRequestTxt,"flowerGiving.rankVeiw.superRequestPos");
               this._superRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.superRequest");
               addChild(this._superRequestTxt);
               break;
            case 1:
            case 2:
               this._baseRequestTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.lightBrownTxt");
               PositionUtils.setPos(this._baseRequestTxt,"flowerGiving.rankVeiw.baseRequestPos");
               this._baseRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.baseRequest");
               addChild(this._baseRequestTxt);
               this._superRequestTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.lightBrownTxt");
               PositionUtils.setPos(this._superRequestTxt,"flowerGiving.rankVeiw.superRequestPos");
               this._superRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.superRequest");
               addChild(this._superRequestTxt);
               this._getRewardBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.rankView.getRewardBtn");
               PositionUtils.setPos(this._getRewardBtn,"flowerGiving.rankView.btnPos2");
               addChild(this._getRewardBtn);
         }
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.vBox");
         addChild(this._vbox);
         this.setRequestTxt();
      }
      
      private function setRequestTxt() : void
      {
         var _loc1_:String = FlowerGivingManager.instance.xmlData.remain2;
         var _loc2_:Array = _loc1_.split(",");
         switch(this.type)
         {
            case 0:
            case 1:
               this._baseRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.baseRequest",_loc2_[0]);
               this._superRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.superRequest",_loc2_[1]);
               break;
            case 2:
               this._baseRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.baseRequest",_loc2_[2]);
               this._superRequestTxt.text = LanguageMgr.GetTranslation("flowerGiving.rankView.superRequest",_loc2_[3]);
         }
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_FLOWER_RANK,this.__updateView);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         if(Boolean(this._getRewardBtn))
         {
            this._getRewardBtn.addEventListener(MouseEvent.CLICK,this.__getRewardBtnClick);
         }
         this._prevBtn.addEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      protected function __prevBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.curPage <= 0)
         {
            return;
         }
         SocketManager.Instance.out.getFlowerRankInfo(this.type,this.curPage - 1);
      }
      
      protected function __nextBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.curPage >= this.pageCount - 1)
         {
            return;
         }
         SocketManager.Instance.out.getFlowerRankInfo(this.type,this.curPage + 1);
      }
      
      protected function __getRewardBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(this.type)
         {
            case 1:
               SocketManager.Instance.out.sendGetFlowerReward(0);
               break;
            case 2:
               SocketManager.Instance.out.sendGetFlowerReward(1);
         }
      }
      
      private function __updateView(param1:FlowerGivingEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:FlowerRankInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:FlowerRankItem = null;
         this.clearItems();
         var _loc10_:PackageIn = param1.pkg;
         var _loc11_:int = _loc10_.readInt();
         if(this.type == _loc11_)
         {
            this.myFlowerCount = _loc10_.readInt();
            this.myPlace = _loc10_.readInt();
            this.pageCount = _loc10_.readInt();
            this.curPage = _loc10_.readInt();
            _loc2_ = _loc10_.readInt();
            _loc2_ = _loc2_ < LIST_LEN ? int(_loc2_) : int(LIST_LEN);
            _loc3_ = 0;
            while(_loc3_ <= _loc2_ - 1)
            {
               _loc4_ = new FlowerRankInfo();
               _loc4_.place = _loc10_.readInt();
               _loc4_.num = _loc10_.readInt();
               _loc4_.name = _loc10_.readUTF();
               _loc4_.vipLvl = _loc10_.readByte();
               _loc8_ = 0;
               while(_loc8_ <= this.dataArr.length - 1)
               {
                  _loc5_ = (this.dataArr[_loc8_] as GiftBagInfo).giftConditionArr[0].conditionValue;
                  _loc6_ = (this.dataArr[_loc8_] as GiftBagInfo).giftConditionArr[1].conditionValue;
                  if(_loc4_.place >= _loc5_ && _loc4_.place <= _loc6_)
                  {
                     _loc4_.rewardVec = (this.dataArr[_loc8_] as GiftBagInfo).giftRewardArr;
                     break;
                  }
                  _loc8_++;
               }
               if(Boolean(_loc4_.rewardVec))
               {
                  _loc9_ = new FlowerRankItem();
                  _loc9_.info = _loc4_;
                  this._vbox.addChild(_loc9_);
                  this._itemList.push(_loc9_);
               }
               _loc3_++;
            }
         }
         var _loc12_:int = 0;
         while(_loc12_ <= this.dataArr.length - 1)
         {
            _loc6_ = (this.dataArr[_loc12_] as GiftBagInfo).giftConditionArr[1].conditionValue;
            _loc7_ = _loc7_ > _loc6_ ? int(_loc7_) : int(_loc6_);
            _loc12_++;
         }
         var _loc13_:int = _loc7_ % LIST_LEN == 0 ? int(_loc7_ / LIST_LEN) : int(_loc7_ / LIST_LEN + 1);
         this.pageCount = this.pageCount > _loc13_ ? int(_loc13_) : int(this.pageCount);
         this.pageCount = this.pageCount == 0 ? int(1) : int(this.pageCount);
         this._myFlowerNum.text = this.myFlowerCount + "";
         if(this.myPlace <= 0 || this.myPlace > _loc7_)
         {
            this._myPlace.visible = false;
            this._outOfRank.visible = true;
         }
         else
         {
            this._myPlace.visible = true;
            this._outOfRank.visible = false;
            this._myPlace.text = LanguageMgr.GetTranslation("flowerGiving.rankView.myPlaceTxt",this.myPlace);
         }
         this._pageTxt.text = this.curPage + 1 + "/" + this.pageCount;
         if(Boolean(this._getRewardBtn))
         {
            this._getRewardBtn.enable = this.canBtnClick();
         }
      }
      
      private function clearItems() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ <= this._itemList.length - 1)
         {
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
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
         this.ysdRwardGet = _loc2_.readBoolean();
         this.accRwardGet = _loc2_.readBoolean();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         if(Boolean(this._getRewardBtn))
         {
            this._getRewardBtn.enable = this.canBtnClick();
         }
      }
      
      private function canBtnClick() : Boolean
      {
         switch(this.type)
         {
            case 1:
               return !this.ysdRwardGet;
            case 2:
               return !this.accRwardGet;
            default:
               return false;
         }
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_FLOWER_RANK,this.__updateView);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_REWARD,this.__getRewardSuccess);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.REWARD_INFO,this.__updateRewardStatus);
         if(Boolean(this._getRewardBtn))
         {
            this._getRewardBtn.removeEventListener(MouseEvent.CLICK,this.__getRewardBtnClick);
         }
         this._prevBtn.removeEventListener(MouseEvent.CLICK,this.__prevBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__nextBtnClick);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bottomBg);
         this._bottomBg = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._numTxt);
         this._numTxt = null;
         ObjectUtils.disposeObject(this._basePrizeTxt);
         this._basePrizeTxt = null;
         ObjectUtils.disposeObject(this._superPrizeTxt);
         this._superPrizeTxt = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         ObjectUtils.disposeObject(this._prevBtn);
         this._prevBtn = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._myFlowerLabel);
         this._myFlowerLabel = null;
         ObjectUtils.disposeObject(this._myFlowerNum);
         this._myFlowerNum = null;
         ObjectUtils.disposeObject(this._myPlace);
         this._myPlace = null;
         ObjectUtils.disposeObject(this._baseRequestTxt);
         this._baseRequestTxt = null;
         ObjectUtils.disposeObject(this._superRequestTxt);
         this._superRequestTxt = null;
         ObjectUtils.disposeObject(this._getRewardBtn);
         this._getRewardBtn = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         var _loc1_:int = 0;
         while(_loc1_ <= this._itemList.length - 1)
         {
            ObjectUtils.disposeObject(this._itemList[_loc1_]);
            this._itemList[_loc1_] = null;
            _loc1_++;
         }
      }
   }
}

