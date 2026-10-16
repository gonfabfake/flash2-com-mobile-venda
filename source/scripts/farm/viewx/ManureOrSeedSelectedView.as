package farm.viewx
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petsBag.PetsBagManager;
   import shop.manager.ShopBuyManager;
   
   public class ManureOrSeedSelectedView extends Sprite implements Disposeable
   {
      
      public static const SEED:int = 1;
      
      public static const MANURE:int = 2;
      
      public static const manureIdArr:Array = [333101,333102,333103,333104];
      
      private var manureVec:Array;
      
      private var _manureSelectViewBg:ScaleBitmapImage;
      
      private var _title:ScaleFrameImage;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<FarmCell>;
      
      private var _type:int;
      
      private var _cellInfos:Array;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _currentCell:FarmCell;
      
      private var _currentImg:Bitmap;
      
      public function ManureOrSeedSelectedView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set viewType(param1:int) : void
      {
         this._type = param1;
         this.cellInfos();
         this.upCells(0);
         visible = true;
         this._title.setFrame(this._type);
         if(this._type == 1)
         {
            if(PetsBagManager.instance.haveTaskOrderByID(369))
            {
               PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(101);
               PetsBagManager.instance.showPetFarmGuildArrow(102,0,"farmTrainer.selectSeedArrowPos","asset.farmTrainer.selectSeed","farmTrainer.selectSeedTipPos",this);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener("click",this.__onClose);
         this._preBtn.addEventListener("click",this.__onPageBtnClick);
         this._nextBtn.addEventListener("click",this.__onPageBtnClick);
         PlayerManager.Instance.Self.getBag(13).addEventListener("update",this.__bagUpdate);
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener("click",this.__onClose);
         this._preBtn.removeEventListener("click",this.__onPageBtnClick);
         this._nextBtn.removeEventListener("click",this.__onPageBtnClick);
         PlayerManager.Instance.Self.getBag(13).removeEventListener("update",this.__bagUpdate);
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._manureSelectViewBg = ComponentFactory.Instance.creatComponentByStylename("farm.manureselectViewBg");
         this._title = ComponentFactory.Instance.creatComponentByStylename("farm.selectedView.title");
         this._title.setFrame(this._type);
         this._preBtn = ComponentFactory.Instance.creat("farm.btnPrePage1");
         this._nextBtn = ComponentFactory.Instance.creat("farm.btnNextPage1");
         this._closeBtn = ComponentFactory.Instance.creat("farm.seedselectcloseBtn");
         this._hBox = ComponentFactory.Instance.creat("farm.cropBox");
         addChild(this._manureSelectViewBg);
         addChild(this._title);
         addChild(this._preBtn);
         addChild(this._nextBtn);
         addChild(this._closeBtn);
         addChild(this._hBox);
         this._cells = new Vector.<FarmCell>(3);
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this._cells[_loc1_] = new FarmCell();
            this._cells[_loc1_].addEventListener("click",this.__clickHandler);
            this._hBox.addChild(this._cells[_loc1_]);
            _loc1_++;
         }
         this.manureVec = [];
         _loc2_ = 0;
         while(_loc2_ < manureIdArr.length)
         {
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = manureIdArr[_loc2_];
            ObjectUtils.copyProperties(_loc3_,ItemManager.Instance.getTemplateById(_loc3_.TemplateID));
            this.manureVec.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.visible = false;
         this._currentCell = param1.currentTarget as FarmCell;
         if(this._currentCell.itemInfo.Count != 0)
         {
            this._currentCell.dragStart();
            if(this._type == 1)
            {
               if(PetsBagManager.instance.haveTaskOrderByID(369))
               {
                  PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(102);
                  PetsBagManager.instance.showPetFarmGuildArrow(103,-150,"farmTrainer.seedFieldArrowPos","asset.farmTrainer.seedField","farmTrainer.seedFieldTipPos");
               }
            }
            else if(this._type == 2)
            {
               if(PetsBagManager.instance.haveTaskOrderByID(369))
               {
                  PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(105);
                  PetsBagManager.instance.showPetFarmGuildArrow(106,-150,"farmTrainer.useFertilizerArrowPos","asset.farmTrainer.useFertilizer","farmTrainer.useFertilizerTipPos");
               }
            }
         }
         else
         {
            ShopBuyManager.Instance.buyFarmShop(this._currentCell.itemInfo.TemplateID);
         }
      }
      
      private function __bagUpdate(param1:BagEvent) : void
      {
         this.cellInfos();
         this.upCells(this._currentPage);
      }
      
      private function __onClose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         visible = false;
         PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(102);
         PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(105);
      }
      
      private function __onPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? 0 : int(Number(this._currentPage - 1));
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? this._totlePage : int(this._currentPage + 1);
         }
         this.upCells(this._currentPage);
      }
      
      private function cellInfos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = this._type == 1 ? PlayerManager.Instance.Self.getBag(13).findItems(32) : PlayerManager.Instance.Self.getBag(13).findItems(33);
         if(this._type == 2)
         {
            _loc1_ = 0;
            while(_loc1_ < this.manureVec.length)
            {
               this.manureVec[_loc1_].Count = 0;
               _loc2_ = 0;
               while(_loc2_ < _loc3_.length)
               {
                  if(_loc3_[_loc2_].TemplateID == this.manureVec[_loc1_].TemplateID)
                  {
                     ObjectUtils.copyProperties(this.manureVec[_loc1_],_loc3_[_loc2_]);
                     break;
                  }
                  _loc2_++;
               }
               _loc1_++;
            }
            this._cellInfos = this.manureVec;
         }
         else
         {
            _loc3_.sortOn("TemplateID",16);
            this._cellInfos = _loc3_;
         }
         this._totlePage = this._cellInfos.length % 3 == 0 ? int(this._cellInfos.length / 3 - 1) : int(Number(this._cellInfos.length / 3));
      }
      
      private function upCells(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         this._currentPage = param1;
         var _loc3_:int = param1 * 3;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            if(Boolean(this._cellInfos[_loc2_ + _loc3_]))
            {
               this._cells[_loc2_].itemInfo = this._cellInfos[_loc2_ + _loc3_];
               if(this._cells[_loc2_].itemInfo.Count > 0)
               {
                  this._cells[_loc2_].visible = true;
               }
               else
               {
                  this._cells[_loc2_].visible = false;
               }
            }
            else
            {
               this._cells[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function compareFun(param1:int, param2:int) : Number
      {
         if(param1 < param2)
         {
            return 1;
         }
         if(param1 > param2)
         {
            return -1;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            if(Boolean(this._cells[_loc1_]))
            {
               ObjectUtils.disposeObject(this._cells[_loc1_]);
               this._cells[_loc1_].removeEventListener("click",this.__clickHandler);
            }
            this._cells[_loc1_] = null;
            _loc1_++;
         }
         this._cells = null;
         if(Boolean(this._manureSelectViewBg))
         {
            ObjectUtils.disposeObject(this._manureSelectViewBg);
         }
         this._manureSelectViewBg = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(Boolean(this._preBtn))
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._closeBtn))
         {
            ObjectUtils.disposeObject(this._closeBtn);
         }
         this._closeBtn = null;
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

