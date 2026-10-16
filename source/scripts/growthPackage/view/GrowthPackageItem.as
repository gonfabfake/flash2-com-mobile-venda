package growthPackage.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import growthPackage.GrowthPackageManager;
   import growthPackage.data.GrowthPackageInfo;
   
   public class GrowthPackageItem extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _levelHead:Bitmap;
      
      private var _cellsBg:ScaleBitmapImage;
      
      private var _cells:HBox;
      
      private var _cellsArr:Array;
      
      private var _getBtn:TextButton;
      
      private var _getBtnGlow:MovieClip;
      
      private var _getIcon:Bitmap;
      
      private var _cellsBgWidth:Number;
      
      public function GrowthPackageItem(param1:int)
      {
         super();
         this._index = param1;
         this.initView();
         this.updateView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._levelHead = ComponentFactory.Instance.creatBitmap("assets.growthPackage.Item" + this._index);
         if(this._index < 3)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg1");
         }
         else if(this._index < 6)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg2");
         }
         else if(this._index < 9)
         {
            this._cellsBg = ComponentFactory.Instance.creatComponentByStylename("growthPackage.LevelBg3");
         }
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("growthPackage.getBtn");
         this._getBtn.text = LanguageMgr.GetTranslation("ddt.growthPackage.itemGetBtnTxt");
         this._getBtnGlow = ClassUtils.CreatInstance("assets.growthPackage.BtnGlow");
         this._getBtnGlow.mouseChildren = false;
         this._getBtnGlow.mouseEnabled = false;
         this._getBtnGlow.x = this._getBtn.x - 5;
         this._getBtnGlow.y = this._getBtn.y - 1;
         this._getIcon = ComponentFactory.Instance.creatBitmap("assets.growthPackage.getIcon");
         addChild(this._levelHead);
         if(Boolean(this._cellsBg))
         {
            this._cellsBgWidth = this._cellsBg.width;
            PositionUtils.setPos(this._cellsBg,"growthPackageItem.cellsBgPos");
            addChild(this._cellsBg);
         }
         this._cells = new HBox();
         this._cells.spacing = 2;
         PositionUtils.setPos(this._cells,"growthPackageItem.cellsPos");
         if(this._index > 5)
         {
            this._cells.y = 5;
         }
         addChild(this._cells);
         addChild(this._getBtn);
         addChild(this._getBtnGlow);
         addChild(this._getIcon);
         this.isComplete(0);
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__getBtnClickHandler);
      }
      
      private function removeEvent() : void
      {
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getBtnClickHandler);
      }
      
      private function __getBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(GrowthPackageManager.instance.model.isBuy < 1)
         {
            GrowthPackageManager.instance.showBuyFrame();
         }
         else
         {
            SocketManager.Instance.out.sendGrowthPackageGetItems(this._index);
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GrowthPackageInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:GrowthPackageCell = null;
         this._cellsArr = new Array();
         var _loc5_:Vector.<GrowthPackageInfo> = GrowthPackageManager.instance.model.itemInfoList[this._index];
         if(Boolean(_loc5_))
         {
            _loc1_ = 0;
            while(_loc1_ < _loc5_.length)
            {
               _loc2_ = _loc5_[_loc1_];
               _loc3_ = GrowthPackageManager.instance.model.getInventoryItemInfo(_loc2_);
               _loc4_ = this.creatItemCell(_loc3_);
               this._cells.addChild(_loc4_);
               this._cellsArr.push(_loc4_);
               _loc1_++;
            }
            this._cells.arrange();
         }
         this._cellsBg.width = this._cells.width + 33;
         if(this._cellsBg.width < this._cellsBgWidth)
         {
            this._cellsBg.width = this._cellsBgWidth;
         }
         this.updateState();
      }
      
      public function updateState() : void
      {
         var _loc1_:int = int(GrowthPackageManager.instance.model.isCompleteList[this._index]);
         var _loc2_:int = int(GrowthPackageManager.instance.model.gradeList[this._index]);
         if(this._index == 0 && _loc1_ != 1)
         {
            this.isComplete(2);
         }
         else if(_loc1_ == 0 && PlayerManager.Instance.Self.Grade >= _loc2_)
         {
            this.isComplete(2);
         }
         else
         {
            this.isComplete(_loc1_);
         }
      }
      
      public function isComplete(param1:int) : void
      {
         if(param1 == 0)
         {
            this._getBtn.mouseEnabled = false;
            this._getBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._getBtn.visible = true;
            this._getBtnGlow.visible = false;
            this._getIcon.visible = false;
         }
         else if(param1 == 1)
         {
            this._getBtn.visible = false;
            this._getBtnGlow.visible = false;
            this._getIcon.visible = true;
         }
         else if(param1 == 2)
         {
            this._getBtn.mouseEnabled = true;
            this._getBtn.filters = null;
            this._getBtn.visible = true;
            this._getBtnGlow.visible = true;
            this._getIcon.visible = false;
         }
      }
      
      protected function creatItemCell(param1:InventoryItemInfo) : GrowthPackageCell
      {
         var _loc2_:GrowthPackageCell = new GrowthPackageCell(0,null);
         _loc2_.width = 47;
         _loc2_.height = 46;
         _loc2_.info = param1;
         return _loc2_;
      }
      
      private function clearCells() : void
      {
         var _loc1_:GrowthPackageCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._cellsArr.length)
         {
            _loc1_ = GrowthPackageCell(this._cellsArr[_loc2_]);
            ObjectUtils.disposeObject(_loc1_);
            _loc2_++;
         }
         this._cellsArr = null;
         ObjectUtils.disposeAllChildren(this._cells);
         ObjectUtils.disposeObject(this._cells);
         this._cells = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearCells();
         ObjectUtils.disposeObject(this._levelHead);
         this._levelHead = null;
         ObjectUtils.disposeObject(this._cellsBg);
         this._cellsBg = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
         if(Boolean(this._getBtnGlow))
         {
            this._getBtnGlow.stop();
            ObjectUtils.disposeObject(this._getBtnGlow);
            this._getBtnGlow = null;
         }
         ObjectUtils.disposeObject(this._getIcon);
         this._getIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

