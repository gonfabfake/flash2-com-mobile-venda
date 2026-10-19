package Indiana.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class IndianaTitleCellView extends Sprite implements Disposeable
   {
      
      private var group:Vector.<IndianaTitleCell>;
      
      private var _currentCell:IndianaTitleCell;
      
      public var callBack:Function;
      
      private var _bg:Bitmap;
      
      private var _cells:Array;
      
      public function IndianaTitleCellView()
      {
         super();
         this.group = new Vector.<IndianaTitleCell>();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.indiana.titleview.bg");
         addChild(this._bg);
         this._cells = [];
      }
      
      private function initCell() : void
      {
         var _loc1_:IndianaTitleCell = new IndianaTitleCell();
         _loc1_.setContentSize(44,44);
         _loc1_.addEventListener("click",this.__cellClickHandler);
         addChild(_loc1_);
         this.group.push(_loc1_);
         _loc1_ = new IndianaTitleCell();
         _loc1_.setContentSize(44,44);
         addChild(_loc1_);
         _loc1_.addEventListener("click",this.__cellClickHandler);
         this.group.push(_loc1_);
         _loc1_ = new IndianaTitleCell();
         _loc1_.setContentSize(44,44);
         addChild(_loc1_);
         _loc1_.addEventListener("click",this.__cellClickHandler);
         this.group.push(_loc1_);
         PositionUtils.setPos(this.group[0],"indiana.cell.index_1");
         PositionUtils.setPos(this.group[1],"indiana.cell.index_2");
         PositionUtils.setPos(this.group[2],"indiana.cell.index_3");
      }
      
      private function clearCells() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = int(this._cells.length);
         while(this._cells.length > 0)
         {
            _loc1_ = this._cells.shift();
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
      }
      
      private function sortCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = int(this._cells.length);
         var _loc8_:Array = [];
         if(_loc7_ > 0)
         {
            _loc1_ = 0;
            _loc2_ = 10;
            if(_loc7_ % 2 == 0)
            {
               _loc4_ = ComponentFactory.Instance.creat("indiana.cell.index_4");
               _loc5_ = ComponentFactory.Instance.creat("indiana.cell.index_5");
               while(_loc1_ < _loc7_)
               {
                  _loc3_ = new Point();
                  if(_loc1_ % 2 == 0)
                  {
                     _loc3_.x = _loc4_.x - int(_loc1_ / 2) * (this._cells[_loc1_].width + _loc2_);
                     _loc3_.y = _loc4_.y;
                  }
                  else
                  {
                     _loc3_.x = _loc5_.x + int(_loc1_ / 2) * (this._cells[_loc1_].width + _loc2_);
                     _loc3_.y = _loc5_.y;
                  }
                  _loc8_.push(_loc3_);
                  _loc1_++;
               }
            }
            else
            {
               _loc6_ = ComponentFactory.Instance.creat("indiana.cell.index_6");
               while(_loc1_ < _loc7_)
               {
                  _loc3_ = new Point();
                  if(_loc1_ % 2 == 0)
                  {
                     _loc3_.x = _loc6_.x - int(_loc1_ / 2) * (this._cells[_loc1_].width + _loc2_);
                     _loc3_.y = _loc6_.y;
                  }
                  else
                  {
                     _loc3_.x = _loc6_.x + int(Math.ceil(_loc1_ / 2)) * (this._cells[_loc1_].width + _loc2_);
                     _loc3_.y = _loc6_.y;
                  }
                  _loc8_.push(_loc3_);
                  _loc1_++;
               }
            }
            _loc8_.sort(this.sortPos);
            _loc1_ = 0;
            while(_loc1_ < _loc7_)
            {
               this._cells[_loc1_].x = _loc8_[_loc1_].x;
               this._cells[_loc1_].y = _loc8_[_loc1_].y;
               _loc1_++;
            }
         }
      }
      
      private function sortPos(param1:Point, param2:Point) : Number
      {
         if(param1.x < param2.x)
         {
            return -1;
         }
         if(param1.x > param2.x)
         {
            return 1;
         }
         return 0;
      }
      
      public function setInfos(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         this.clearCells();
         if(param1 != null)
         {
            _loc2_ = int(param1.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = new IndianaTitleCell();
               _loc3_.setContentSize(44,44);
               _loc3_.addEventListener("click",this.__cellClickHandler);
               _loc3_.Info = param1[_loc4_];
               this._cells.push(_loc3_);
               addChild(_loc3_);
               _loc4_++;
            }
            this.sortCell();
         }
      }
      
      public function get currentCell() : IndianaTitleCell
      {
         return this._currentCell;
      }
      
      public function get leftCell() : IndianaTitleCell
      {
         var _loc1_:int = 0;
         if(Boolean(this._currentCell))
         {
            _loc1_ = this._cells.indexOf(this._currentCell);
            if(_loc1_ > 0)
            {
               _loc1_--;
               return this._cells[_loc1_];
            }
            return this._cells[this._cells.length - 1];
         }
         return null;
      }
      
      public function get rightCell() : IndianaTitleCell
      {
         var _loc1_:int = 0;
         if(Boolean(this._currentCell))
         {
            _loc1_ = this._cells.indexOf(this._currentCell);
            if(_loc1_ < this._cells.length - 1)
            {
               _loc1_++;
               return this._cells[_loc1_];
            }
            return this._cells[0];
         }
         return null;
      }
      
      private function __cellClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:IndianaTitleCell = param1.currentTarget as IndianaTitleCell;
         if(this._currentCell != _loc2_)
         {
            this._currentCell.selected = false;
            this._currentCell = _loc2_;
            _loc2_.selected = true;
            if(Boolean(this._currentCell.Info))
            {
               SocketManager.Instance.out.sendUpdateSysDate();
               SocketManager.Instance.out.sendIndianaEnterGame(this._currentCell.Info.PeriodId);
            }
         }
      }
      
      public function updateCurrentCell(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._cells.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._cells[_loc2_].Info.PeriodId == param1)
            {
               if(Boolean(this._currentCell))
               {
                  if(this._currentCell != this._cells[_loc2_])
                  {
                     this._currentCell.selected = false;
                     this._cells[_loc2_].selected = true;
                     this._currentCell = this._cells[_loc2_];
                     return;
                  }
               }
               else
               {
                  this._currentCell = this._cells[_loc2_];
                  this._currentCell.selected = true;
               }
            }
            _loc2_++;
         }
      }
      
      private function removeEvent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._cells.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._cells[_loc1_].removeEventListener("click",this.__cellClickHandler);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         var _loc2_:int = int(this._cells.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            ObjectUtils.disposeObject(this._cells[_loc1_]);
            this._cells[_loc1_] = null;
            _loc1_++;
         }
         this._cells = null;
      }
   }
}

