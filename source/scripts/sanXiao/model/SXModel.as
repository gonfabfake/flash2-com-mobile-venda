package sanXiao.model
{
   public class SXModel
   {
      
      public static const PROP_NONE:int = 0;
      
      public static const PROP_CROSS_BOMB:int = 1;
      
      public static const PROP_SQUARE_BOMB:int = 2;
      
      public static const PROP_CLEAR_COLOR:int = 3;
      
      public static const PROP_CHANGE_COLOR:int = 4;
      
      public var ROW_COUNT:Number = 7;
      
      public var COLUMN_COUNT:Number = 7;
      
      public var tweenDuration:Number = 0.5;
      
      public var boomLength:int = 3;
      
      public var typeCount:int = 5;
      
      public var curProp:int = 0;
      
      private var _map:Vector.<Vector.<SXCellData>>;
      
      private var _row:Number = 0;
      
      private var _column:Number = 0;
      
      public function SXModel()
      {
         super();
      }
      
      public function initMap(param1:Number = 7, param2:Number = 7) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._row = param1;
         this._column = param2;
         this._map = new Vector.<Vector.<SXCellData>>();
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            this._map[_loc3_] = new Vector.<SXCellData>();
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               this._map[_loc3_][_loc4_] = new SXCellData(_loc3_,_loc4_);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function createNewMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._row)
         {
            _loc2_ = 0;
            while(_loc2_ < this._column)
            {
               _loc3_ = Math.random() * this.typeCount + 1;
               _loc4_ = this._map[Math.max(0,_loc1_ - 1)][_loc2_].type;
               if(_loc4_ == _loc3_)
               {
                  _loc3_ = (_loc4_ + 2) % this.typeCount + 1;
               }
               _loc4_ = this._map[_loc1_][Math.max(0,_loc2_ - 2)].type;
               if(_loc4_ == _loc3_)
               {
                  _loc3_ = (_loc3_ + 2) % this.typeCount + 1;
               }
               this._map[_loc1_][_loc2_].type = _loc3_;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function setMap(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(param1.length);
         _loc2_ = 2;
         while(_loc2_ < _loc3_)
         {
            this._map[param1[_loc2_ - 2]][param1[_loc2_ - 1]].type = param1[_loc2_];
            _loc2_ += 3;
         }
      }
      
      public function getData(param1:int, param2:int) : SXCellData
      {
         return this._map[param1][param2];
      }
      
      public function map() : Vector.<Vector.<SXCellData>>
      {
         return this._map;
      }
      
      public function mapInfo() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < this._row)
         {
            _loc2_ = 0;
            while(_loc2_ < this._column)
            {
               _loc3_.push(_loc1_);
               _loc3_.push(_loc2_);
               _loc3_.push(this._map[_loc1_][_loc2_].type);
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function mapDataArray() : Vector.<SXCellData>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<SXCellData> = new Vector.<SXCellData>();
         _loc1_ = 0;
         while(_loc1_ < this._row)
         {
            _loc2_ = 0;
            while(_loc2_ < this._column)
            {
               _loc3_.push(new SXCellData(_loc1_,_loc2_,this._map[_loc1_][_loc2_].type));
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function cellTypeExchange(param1:Pos, param2:int, param3:Pos, param4:int) : Boolean
      {
         var _loc5_:int = param1.row - param3.row;
         var _loc6_:int = param1.column - param3.column;
         if((_loc5_ == 1 || _loc5_ == -1) && _loc6_ == 0 || (_loc6_ == 1 || _loc6_ == -1) && _loc5_ == 0)
         {
            this._map[param1.row][param1.column].type = param4;
            this._map[param3.row][param3.column].type = param2;
            return true;
         }
         return false;
      }
      
      public function cellPropCrossBomb(param1:Pos) : Vector.<SXCellData>
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:Vector.<SXCellData> = new Vector.<SXCellData>();
         var _loc5_:int = param1.row;
         var _loc6_:int = param1.column;
         _loc2_ = _loc5_;
         _loc3_ = 0;
         while(_loc3_ < this.COLUMN_COUNT)
         {
            _loc4_.push(this._map[_loc2_][_loc3_]);
            _loc3_++;
         }
         _loc2_ = 0;
         _loc3_ = _loc6_;
         while(_loc2_ < _loc5_)
         {
            _loc4_.push(this._map[_loc2_][_loc3_]);
            _loc2_++;
         }
         _loc2_++;
         while(_loc2_ < this.ROW_COUNT)
         {
            _loc4_.push(this._map[_loc2_][_loc3_]);
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function cellPropSquareBomb(param1:Pos) : Vector.<SXCellData>
      {
         var _loc8_:* = undefined;
         var _loc2_:Vector.<SXCellData> = new Vector.<SXCellData>();
         var _loc3_:int = param1.row;
         var _loc4_:int = param1.column;
         var _loc5_:* = this.COLUMN_COUNT > _loc4_ + 1;
         var _loc6_:* = 0 < _loc4_;
         var _loc7_:* = this.ROW_COUNT > _loc3_ + 1;
         _loc8_ = 0 < _loc3_;
         (_loc8_) && _loc6_ && _loc2_.push(this._map[_loc3_ - 1][_loc4_ - 1]);
         _loc6_ && _loc2_.push(this._map[_loc3_][_loc4_ - 1]);
         _loc7_ && _loc6_ && _loc2_.push(this._map[_loc3_ + 1][_loc4_ - 1]);
         _loc8_ && _loc2_.push(this._map[_loc3_ - 1][_loc4_]);
         _loc2_.push(this._map[_loc3_][_loc4_]);
         _loc7_ && _loc2_.push(this._map[_loc3_ + 1][_loc4_]);
         _loc8_ && _loc5_ && _loc2_.push(this._map[_loc3_ - 1][_loc4_ + 1]);
         _loc5_ && _loc2_.push(this._map[_loc3_][_loc4_ + 1]);
         _loc7_ && _loc5_ && _loc2_.push(this._map[_loc3_ + 1][_loc4_ + 1]);
         return _loc2_;
      }
      
      public function cellPropClearColor(param1:Pos) : Vector.<SXCellData>
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:Vector.<SXCellData> = new Vector.<SXCellData>();
         var _loc3_:int = this._map[param1.row][param1.column].type;
         for each(_loc4_ in this._map)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.type == _loc3_)
               {
                  _loc2_.push(_loc5_);
               }
            }
         }
         return _loc2_;
      }
      
      public function cellPropChangeColor(param1:Pos) : Vector.<SXCellData>
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:Vector.<SXCellData> = new Vector.<SXCellData>();
         var _loc4_:int = this._map[param1.row][param1.column].type;
         while(true)
         {
            _loc2_ = Math.random() * this.typeCount + 1;
            if(_loc2_ != _loc4_)
            {
               break;
            }
         }
         for each(_loc5_ in this._map)
         {
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.type == _loc4_)
               {
                  _loc6_.type = _loc2_;
                  _loc3_.push(_loc6_);
               }
            }
         }
         return _loc3_;
      }
      
      private function checkBoomList(param1:Pos) : Vector.<SXCellData>
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = this._map[param1.row][param1.column].type;
         var _loc5_:Vector.<SXCellData> = new Vector.<SXCellData>();
         var _loc6_:Vector.<SXCellData> = new Vector.<SXCellData>();
         _loc3_ = param1.row - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = this._map[_loc3_][param1.column];
            _loc8_ = _loc2_.type;
            if(_loc4_ !== _loc8_)
            {
               _loc3_ = 0;
            }
            else if(!_loc2_.isLocked)
            {
               _loc2_.isLocked = true;
               _loc5_.push(_loc2_);
            }
            _loc3_ -= 1;
         }
         _loc3_ = param1.row + 1;
         while(_loc3_ < this._row)
         {
            _loc2_ = this._map[_loc3_][param1.column];
            _loc8_ = _loc2_.type;
            if(_loc4_ !== _loc8_)
            {
               _loc3_ = this._row;
            }
            else if(!_loc2_.isLocked)
            {
               _loc2_.isLocked = true;
               _loc5_.push(_loc2_);
            }
            _loc3_ += 1;
         }
         _loc3_ = param1.column - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = this._map[param1.row][_loc3_];
            _loc8_ = _loc2_.type;
            if(_loc4_ !== _loc8_)
            {
               _loc3_ = 0;
            }
            else if(!_loc2_.isLocked)
            {
               _loc2_.isLocked = true;
               _loc6_.push(_loc2_);
            }
            _loc3_ -= 1;
         }
         _loc3_ = param1.column + 1;
         while(_loc3_ < this._column)
         {
            _loc2_ = this._map[param1.row][_loc3_];
            _loc8_ = _loc2_.type;
            if(_loc4_ !== _loc8_)
            {
               _loc3_ = this._column;
            }
            else if(!_loc2_.isLocked)
            {
               _loc2_.isLocked = true;
               _loc6_.push(_loc2_);
            }
            _loc3_ += 1;
         }
         var _loc7_:Vector.<SXCellData> = new Vector.<SXCellData>();
         if(_loc5_.length >= this.boomLength - 1)
         {
            _loc7_ = _loc7_.concat(_loc5_);
         }
         else
         {
            for each(_loc9_ in _loc5_)
            {
               _loc9_.isLocked = false;
            }
         }
         if(_loc6_.length >= this.boomLength - 1)
         {
            _loc7_ = _loc7_.concat(_loc6_);
         }
         else
         {
            for each(_loc10_ in _loc6_)
            {
               _loc10_.isLocked = false;
            }
         }
         if(_loc7_.length > 0 && this._map[param1.row][param1.column].isLocked == false)
         {
            this._map[param1.row][param1.column].isLocked = true;
            _loc7_.push(this._map[param1.row][param1.column]);
         }
         _loc2_ = null;
         return _loc7_;
      }
      
      public function canBoomCellsList(param1:Array) : Vector.<SXCellData>
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<SXCellData> = new Vector.<SXCellData>();
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc2_.concat(this.checkBoomList(_loc3_.curPos));
         }
         for each(_loc4_ in _loc2_)
         {
            _loc4_.isLocked = false;
         }
         return _loc2_;
      }
      
      private function spread(param1:Vector.<SXCellData>) : Vector.<SXCellData>
      {
         var boomList:Vector.<SXCellData> = null;
         var spreadList:Vector.<SXCellData> = null;
         boomList = param1;
         var check:* = function(param1:SXCellData):void
         {
            var _loc2_:* = null;
            var _loc3_:int = 0;
            var _loc4_:int = param1.type;
            _loc3_ = param1.row - 1;
            if(_loc3_ >= 0)
            {
               _loc2_ = _map[_loc3_][param1.column];
               if(_loc2_.type == _loc4_ && _loc2_.isLocked == false)
               {
                  _loc2_.isLocked = true;
                  spreadList.push(_loc2_);
                  check(_loc2_);
               }
            }
            _loc3_ = param1.row + 1;
            if(_loc3_ < _row)
            {
               _loc2_ = _map[_loc3_][param1.column];
               if(_loc2_.type == _loc4_ && _loc2_.isLocked == false)
               {
                  _loc2_.isLocked = true;
                  spreadList.push(_loc2_);
                  check(_loc2_);
               }
            }
            _loc3_ = param1.column - 1;
            if(_loc3_ >= 0)
            {
               _loc2_ = _map[param1.row][_loc3_];
               if(_loc2_.type == _loc4_ && _loc2_.isLocked == false)
               {
                  _loc2_.isLocked = true;
                  spreadList.push(_loc2_);
                  check(_loc2_);
               }
            }
            _loc3_ = param1.column + 1;
            if(_loc3_ < _column)
            {
               _loc2_ = _map[param1.row][_loc3_];
               if(_loc2_.type == _loc4_ && _loc2_.isLocked == false)
               {
                  _loc2_.isLocked = true;
                  spreadList.push(_loc2_);
                  check(_loc2_);
               }
            }
         };
         spreadList = new Vector.<SXCellData>();
         var len:int = int(boomList.length);
         var k:int = 0;
         while(k < len)
         {
            check(boomList[k]);
            k++;
         }
         if(spreadList.length > 0)
         {
            boomList = boomList.concat(spreadList);
         }
         return boomList;
      }
      
      public function boomAndFall(param1:Vector.<SXCellData>) : Vector.<SXCellData>
      {
         var _loc8_:* = undefined;
         var _loc9_:Vector.<SXCellData> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 7)
         {
            _loc3_ = 0;
            while(_loc3_ < 7)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         for each(_loc8_ in param1)
         {
            _loc8_.type = 0;
         }
         _loc9_ = new Vector.<SXCellData>();
         _loc6_ = 0;
         while(_loc6_ < this.COLUMN_COUNT)
         {
            _loc5_ = new Vector.<int>();
            _loc7_ = this.ROW_COUNT - 1;
            while(_loc7_ >= 0)
            {
               _loc4_ = this._map[_loc7_][_loc6_];
               if(_loc4_.type != 0)
               {
                  _loc5_.push(_loc4_.type);
               }
               _loc4_.type = 0;
               _loc7_--;
            }
            _loc7_ = this.ROW_COUNT - 1;
            while(_loc7_ >= 0)
            {
               if(_loc5_.length == 0)
               {
                  this._map[_loc7_][_loc6_].type = int(Math.random() * this.typeCount + 1);
                  _loc9_.push(this._map[_loc7_][_loc6_]);
               }
               else
               {
                  this._map[_loc7_][_loc6_].type = _loc5_.shift();
               }
               _loc7_--;
            }
            _loc6_++;
         }
         _loc4_ = null;
         _loc5_ = null;
         return _loc9_;
      }
      
      public function isDieMap() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         loop0:
         while(_loc1_ < this.ROW_COUNT)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ >= this.COLUMN_COUNT)
               {
                  _loc1_++;
                  continue loop0;
               }
               this._map[_loc1_][_loc2_].row = _loc1_;
               this._map[_loc1_][_loc2_].column = _loc2_;
               if(this.isDie(_loc1_,_loc2_) == false)
               {
                  break;
               }
               _loc2_++;
            }
            return false;
         }
         return true;
      }
      
      private function isDie(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:* = param1 - 1 > -1;
         var _loc4_:* = param1 - 2 > -1;
         var _loc5_:* = param1 - 3 > -1;
         var _loc6_:* = param1 + 1 < this.ROW_COUNT;
         var _loc7_:* = param1 + 2 < this.ROW_COUNT;
         var _loc8_:* = param1 + 3 < this.ROW_COUNT;
         var _loc9_:* = param2 - 1 > -1;
         var _loc10_:* = param2 - 2 > -1;
         var _loc11_:* = param2 - 3 > -1;
         var _loc12_:* = param2 + 1 < this.COLUMN_COUNT;
         var _loc13_:* = param2 + 2 < this.COLUMN_COUNT;
         var _loc14_:* = param2 + 3 < this.COLUMN_COUNT;
         var _loc15_:int = this._map[param1][param2].type;
         if(Boolean(_loc6_))
         {
            if(this._map[param1 + 1][param2].type == _loc15_)
            {
               if(Boolean(_loc8_))
               {
                  if(this._map[param1 + 3][param2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc7_) && Boolean(_loc12_))
               {
                  if(this._map[param1 + 2][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc7_) && Boolean(_loc9_))
               {
                  if(this._map[param1 + 2][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc4_))
               {
                  if(this._map[param1 - 2][param2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc9_))
               {
                  if(this._map[param1 - 1][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc12_))
               {
                  if(this._map[param1 - 1][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
            }
            if(Boolean(_loc9_) && Boolean(_loc12_))
            {
               if(this._map[param1 + 1][param2 - 1].type == _loc15_ && this._map[param1 + 1][param2 + 1].type == _loc15_)
               {
                  return false;
               }
            }
         }
         if(Boolean(_loc3_))
         {
            if(this._map[param1 - 1][param2].type == _loc15_)
            {
               if(Boolean(_loc5_))
               {
                  if(this._map[param1 - 3][param2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc4_) && Boolean(_loc12_))
               {
                  if(this._map[param1 - 2][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc4_) && Boolean(_loc9_))
               {
                  if(this._map[param1 - 2][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc7_))
               {
                  if(this._map[param1 + 2][param2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc9_))
               {
                  if(this._map[param1 + 1][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc12_))
               {
                  if(this._map[param1 + 1][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
            }
            if(Boolean(_loc9_) && Boolean(_loc12_))
            {
               if(this._map[param1 - 1][param2 - 1].type == _loc15_ && this._map[param1 - 1][param2 + 1].type == _loc15_)
               {
                  return false;
               }
            }
         }
         if(Boolean(_loc12_))
         {
            if(this._map[param1][param2 + 1].type == _loc15_)
            {
               if(Boolean(_loc14_))
               {
                  if(this._map[param1][param2 + 3].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc13_))
               {
                  if(this._map[param1 - 1][param2 + 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc13_))
               {
                  if(this._map[param1 + 1][param2 + 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc10_))
               {
                  if(this._map[param1][param2 - 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc9_))
               {
                  if(this._map[param1 + 1][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc9_))
               {
                  if(this._map[param1 - 1][param2 - 1].type == _loc15_)
                  {
                     return false;
                  }
               }
            }
            if(Boolean(_loc3_) && Boolean(_loc6_))
            {
               if(this._map[param1 - 1][param2 + 1].type == _loc15_ && this._map[param1 + 1][param2 + 1].type == _loc15_)
               {
                  return false;
               }
            }
         }
         if(Boolean(_loc9_))
         {
            if(this._map[param1][param2 - 1].type == _loc15_)
            {
               if(Boolean(_loc11_))
               {
                  if(this._map[param1][param2 - 3].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc10_))
               {
                  if(this._map[param1 - 1][param2 - 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc10_))
               {
                  if(this._map[param1 + 1][param2 - 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc13_))
               {
                  if(this._map[param1][param2 + 2].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc6_) && Boolean(_loc12_))
               {
                  if(this._map[param1 + 1][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
               if(Boolean(_loc3_) && Boolean(_loc12_))
               {
                  if(this._map[param1 - 1][param2 + 1].type == _loc15_)
                  {
                     return false;
                  }
               }
            }
            if(Boolean(_loc3_) && Boolean(_loc6_))
            {
               if(this._map[param1 - 1][param2 - 1].type == _loc15_ && this._map[param1 + 1][param2 - 1].type == _loc15_)
               {
                  return false;
               }
            }
         }
         return true;
      }
   }
}

