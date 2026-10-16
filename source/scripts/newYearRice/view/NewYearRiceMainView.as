package newYearRice.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   
   public class NewYearRiceMainView extends Frame
   {
      
      public static const DINNER:int = 0;
      
      public static const BANQUET:int = 1;
      
      public static const HAN:int = 2;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      private var _main:MovieClip;
      
      private var _dinnerSelectedBtn:SelectedButton;
      
      private var _banquetSelectedBtn:SelectedButton;
      
      private var _hanSelectedBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _materialsBg:Bitmap;
      
      private var _rewardBg:Bitmap;
      
      private var _makeBtn:BaseButton;
      
      private var _materialsNum_1:FilterFrameText;
      
      private var _materialsNum_2:FilterFrameText;
      
      private var _materialsNum_3:FilterFrameText;
      
      private var _materialsNum_4:FilterFrameText;
      
      private var _goodItemContainerAll:Sprite;
      
      private var _currentNum:Array;
      
      private var _maxNum:Array;
      
      private var _helpBtn:BaseButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _selfInfo:SelfInfo;
      
      private var _price:int;
      
      private var _roomType:int;
      
      private var _psTxt:FilterFrameText;
      
      private var _alert1:BaseAlerFrame;
      
      private var _alert:BaseAlerFrame;
      
      private var _materialsArr:Array;
      
      public function NewYearRiceMainView()
      {
         super();
         this._selfInfo = PlayerManager.Instance.Self;
         this.initView();
         this.addEvnets();
      }
      
      private function initView() : void
      {
         this._main = ClassUtils.CreatInstance("asset.newYearRice.view") as MovieClip;
         PositionUtils.setPos(this._main,"asset.newYearRice.view.pos");
         addToContent(this._main);
         this._dinnerSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.dinnerSelectedBtn");
         addToContent(this._dinnerSelectedBtn);
         this._banquetSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.banquetSelectedBtn");
         addToContent(this._banquetSelectedBtn);
         this._hanSelectedBtn = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.hanSelectedBtn");
         addToContent(this._hanSelectedBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._dinnerSelectedBtn);
         this._btnGroup.addSelectItem(this._banquetSelectedBtn);
         this._btnGroup.addSelectItem(this._hanSelectedBtn);
         this._btnGroup.selectIndex = DINNER;
         this._materialsBg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsTxtBG");
         addToContent(this._materialsBg);
         this.showMaterials();
         this._materialsNum_1 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_1");
         this._materialsNum_2 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_2");
         this._materialsNum_3 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_3");
         this._materialsNum_4 = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.materialsNum_4");
         addToContent(this._materialsNum_1);
         addToContent(this._materialsNum_2);
         addToContent(this._materialsNum_3);
         addToContent(this._materialsNum_4);
         this._psTxt = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.psTxt");
         this._psTxt.htmlText = LanguageMgr.GetTranslation("NewYearRiceMainView.psTxtLG");
         addToContent(this._psTxt);
         this._rewardBg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.RewardBg");
         addToContent(this._rewardBg);
         this._makeBtn = ComponentFactory.Instance.creat("NewYearRiceMainView.makeBtn");
         addToContent(this._makeBtn);
         this._helpBtn = ComponentFactory.Instance.creat("NewYearRiceMainView.helpBtn");
         addToContent(this._helpBtn);
         if(NewYearRiceManager.instance.model.yearFoodInfo > 0)
         {
            SocketManager.Instance.out.sendCheckMakeNewYearFood();
            return;
         }
         this.updateView(this._btnGroup.selectIndex);
      }
      
      private function addEvnets() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._makeBtn.addEventListener(MouseEvent.CLICK,this.__makeBtnHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpBtnHandler);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCOOK,this.__yearFoodCook);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODENTER,this.__yearFoodEnter);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._makeBtn.removeEventListener(MouseEvent.CLICK,this.__makeBtnHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpBtnHandler);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.YEARFOODCOOK,this.__yearFoodCook);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.YEARFOODENTER,this.__yearFoodEnter);
      }
      
      private function __yearFoodCook(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.out.sendCheckMakeNewYearFood();
      }
      
      private function __yearFoodEnter(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._roomType = _loc2_.readInt();
         this._openFrameView = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.NewYearRiceOpenView");
         this._openFrameView.setViewFrame(this._roomType);
         this._openFrameView.roomPlayerItem(PlayerManager.Instance.Self.ID);
         LayerManager.Instance.addToLayer(this._openFrameView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         this.dispose();
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this.updateView(this._btnGroup.selectIndex);
      }
      
      private function updateView(param1:int = 0) : void
      {
         this._currentNum = this.upDatafitCount(ServerConfigManager.instance.localYearFoodItems);
         switch(param1)
         {
            case DINNER:
               this.showDinnerView();
               break;
            case BANQUET:
               this.showBanquetView();
               break;
            case HAN:
               this.showHanView();
         }
         if(Boolean(this._goodItemContainerAll))
         {
            ObjectUtils.disposeObject(this._goodItemContainerAll);
            this._goodItemContainerAll = null;
         }
         this._goodItemContainerAll = new Sprite();
         this._goodItemContainerAll.x = 29;
         this._goodItemContainerAll.y = -16;
         this.showGoods(NewYearRiceManager.instance.model.itemInfoList);
      }
      
      private function showDinnerView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[0].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function showBanquetView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[1].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function showHanView() : void
      {
         this._maxNum = ServerConfigManager.instance.localYearFoodItemsCount[2].toString().split(",");
         this.updateMaterialsText(this._currentNum,this._maxNum);
      }
      
      private function __makeBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._materialsArr.length > 0)
         {
            _loc2_ = "";
            _loc3_ = ServerConfigManager.instance.localYearFoodItemsPrices;
            _loc4_ = 0;
            while(_loc4_ < this._materialsArr.length)
            {
               switch(this._materialsArr[_loc4_].id)
               {
                  case 0:
                     _loc2_ += "Vegetais x" + this._materialsArr[_loc4_].number + "  ";
                     this._price += int(_loc3_[_loc4_]) * int(this._materialsArr[_loc4_].number);
                     break;
                  case 1:
                     _loc2_ += "Carne x" + this._materialsArr[_loc4_].number + "  ";
                     this._price += int(_loc3_[_loc4_]) * int(this._materialsArr[_loc4_].number);
                     break;
                  case 2:
                     _loc2_ += "Bebida Alcoólica x" + this._materialsArr[_loc4_].number + "  ";
                     this._price += int(_loc3_[_loc4_]) * int(this._materialsArr[_loc4_].number);
                     break;
                  case 3:
                     _loc2_ += "Fruto do Mar" + this._materialsArr[_loc4_].number + "  ";
                     this._price += int(_loc3_[_loc4_]) * int(this._materialsArr[_loc4_].number);
               }
               _loc4_++;
            }
            this._alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("NewYearRiceMainView.view.money",_loc2_,this._price),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            this._alert1.addEventListener(FrameEvent.RESPONSE,this.__makeNewYearRice);
         }
         else
         {
            SocketManager.Instance.out.makeNewYearRice(0,this._btnGroup.selectIndex,this._materialsArr);
         }
      }
      
      private function __makeNewYearRice(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__makeNewYearRice);
         _loc2_.disposeChildren = true;
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._price)
            {
               this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this._alert.moveEnable = false;
               this._alert.addEventListener(FrameEvent.RESPONSE,this._responseI);
               return;
            }
            SocketManager.Instance.out.makeNewYearRice(1,this._btnGroup.selectIndex,this._materialsArr);
         }
         this._price = 0;
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function showMaterials() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Bitmap = null;
         var _loc3_:Bitmap = null;
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc1_ = new Sprite();
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsBG" + _loc4_);
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.newYearRice.MaterialsNumFrame");
            _loc1_.addChild(_loc3_);
            _loc1_.addChild(_loc2_);
            addToContent(_loc1_);
            PositionUtils.setPos(_loc1_,"NewYearRiceMainView.Materials" + _loc4_);
            _loc4_++;
         }
      }
      
      private function updateMaterialsText(param1:Array, param2:Array) : void
      {
         var _loc3_:Object = null;
         this._materialsArr = [];
         var _loc4_:int = 0;
         this._materialsNum_1.text = param1[0] + "/" + param2[0];
         this._materialsNum_2.text = param1[1] + "/" + param2[1];
         this._materialsNum_3.text = param1[2] + "/" + param2[2];
         this._materialsNum_4.text = param1[3] + "/" + param2[3];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            if(param1[_loc5_] >= param2[_loc5_])
            {
               switch(_loc5_)
               {
                  case 0:
                     this._materialsNum_1.text = param1[0] + "/" + param2[0];
                     this.setTFStyle(this._materialsNum_1);
                     break;
                  case 1:
                     this._materialsNum_2.text = param1[1] + "/" + param2[1];
                     this.setTFStyle(this._materialsNum_2);
                     break;
                  case 2:
                     this._materialsNum_3.text = param1[2] + "/" + param2[2];
                     this.setTFStyle(this._materialsNum_3);
                     break;
                  case 3:
                     this._materialsNum_4.text = param1[3] + "/" + param2[3];
                     this.setTFStyle(this._materialsNum_4);
               }
            }
            else
            {
               _loc3_ = new Object();
               _loc3_.number = param2[_loc5_] - param1[_loc5_];
               _loc3_.id = _loc5_;
               this._materialsArr[_loc4_] = _loc3_;
               _loc4_++;
            }
            _loc5_++;
         }
      }
      
      public function upDatafitCount(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:BagInfo = this._selfInfo.getBag(BagInfo.PROPBAG);
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = _loc4_.getItemCountByTemplateId(param1[_loc5_]);
            _loc3_.push(_loc2_);
            _loc5_++;
         }
         return _loc3_;
      }
      
      private function getMaterialsPrice(param1:Array) : Array
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(param1[_loc4_]) as ItemTemplateInfo;
            _loc3_.push(_loc2_.Property3);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function setTFStyle(param1:FilterFrameText) : void
      {
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.color = [16374016];
         param1.setTextFormat(_loc2_,0,param1.length);
      }
      
      private function showGoods(param1:Array) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:Number = NaN;
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:InventoryItemInfo = null;
         var _loc7_:BagCell = null;
         _loc2_ = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         while(_loc9_ < param1.length)
         {
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.newYearRice.GoodsFrame");
            _loc4_ = _loc3_.width + 15;
            _loc4_ *= int(_loc8_ % 6);
            _loc3_.x = _loc4_ - 34;
            _loc3_.y = 230;
            _loc5_ = ItemManager.Instance.getTemplateById(param1[_loc2_].TemplateID) as ItemTemplateInfo;
            if(param1[_loc2_].Quality != this._btnGroup.selectIndex + 1)
            {
               _loc2_++;
            }
            else
            {
               _loc6_ = new InventoryItemInfo();
               ObjectUtils.copyProperties(_loc6_,_loc5_);
               _loc6_.ValidDate = param1[_loc2_].ValidDate;
               _loc6_.StrengthenLevel = param1[_loc2_].StrengthLevel;
               _loc6_.AttackCompose = param1[_loc2_].AttackCompose;
               _loc6_.DefendCompose = param1[_loc2_].DefendCompose;
               _loc6_.LuckCompose = param1[_loc2_].LuckCompose;
               _loc6_.AgilityCompose = param1[_loc2_].AgilityCompose;
               _loc6_.IsBinds = param1[_loc2_].IsBind;
               _loc6_.Count = param1[_loc2_].Count;
               _loc7_ = new BagCell(0,_loc6_,false);
               _loc7_.x = _loc4_ - 34 + 6;
               _loc7_.y = 236;
               _loc7_.setBgVisible(false);
               this._goodItemContainerAll.addChild(_loc3_);
               this._goodItemContainerAll.addChild(_loc7_);
               _loc2_++;
               _loc8_++;
            }
            _loc9_++;
         }
         addToContent(this._goodItemContainerAll);
      }
      
      private function __helpBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("NewYearRiceMainView.view.TexpView.helpTitle");
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("NewYearRiceMainView.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._alert1))
         {
            ObjectUtils.disposeObject(this._alert1);
            this._alert1 = null;
         }
         if(Boolean(this._alert))
         {
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
         }
      }
   }
}

