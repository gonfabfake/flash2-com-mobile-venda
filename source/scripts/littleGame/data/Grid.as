package littleGame.data
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   
   public class Grid implements Disposeable
   {
      
      public static const straightCost:Number = 1;
      
      public static const diagCost:Number = 1.41421;
      
      public var type:int;
      
      public var cellSize:int = 7;
      
      private var _cols:int;
      
      private var _rows:int;
      
      private var _nodes:Array = new Array();
      
      private var _endNode:Node;
      
      private var _startNode:Node;
      
      private var _astar:AStar;
      
      private var _width:int;
      
      private var _height:int;
      
      public function Grid(param1:int, param2:int)
      {
         super();
         this._cols = param1;
         this._rows = param2;
         this._width = this._rows * this.cellSize;
         this._height = this._cols * this.cellSize;
         this._astar = new AStar(this);
         this.creatGrid();
      }
      
      public function dispose() : void
      {
         var _loc1_:Node = null;
         var _loc2_:Array = this._nodes.shift();
         while(_loc2_ != null)
         {
            _loc1_ = _loc2_.shift();
            while(_loc1_ != null)
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = _loc2_.shift();
            }
            _loc2_ = this._nodes.shift();
         }
         ObjectUtils.disposeObject(this._astar);
         this._astar = null;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function get nodes() : Array
      {
         return this._nodes;
      }
      
      public function get path() : Array
      {
         return this._astar.path;
      }
      
      public function get endNode() : Node
      {
         return this._endNode;
      }
      
      public function get startNode() : Node
      {
         return this._startNode;
      }
      
      public function setEndNode(param1:int, param2:int) : void
      {
         if(this._nodes[param2] != null)
         {
            this._endNode = this._nodes[param2][param1];
         }
      }
      
      public function setStartNode(param1:int, param2:int) : void
      {
         if(this._nodes[param2] != null)
         {
            this._startNode = this._nodes[param2][param1];
         }
      }
      
      public function fillPath() : Boolean
      {
         return this._astar.fillPath();
      }
      
      private function creatGrid() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._cols)
         {
            _loc1_ = new Array();
            _loc2_ = 0;
            while(_loc2_ < this._rows)
            {
               _loc1_.push(new Node(_loc2_,_loc3_));
               _loc2_++;
            }
            this._nodes.push(_loc1_);
            _loc3_++;
         }
      }
      
      public function calculateLinks(param1:int) : void
      {
         var _loc2_:int = 0;
         this.type = param1;
         var _loc3_:int = 0;
         while(_loc3_ < this._cols)
         {
            _loc2_ = 0;
            while(_loc2_ < this._rows)
            {
               this.initNodeLink(this._nodes[_loc3_][_loc2_],param1);
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      public function getNode(param1:int, param2:int) : Node
      {
         var _loc3_:int = Math.min(param2,this._nodes.length - 1);
         _loc3_ = Math.max(0,_loc3_);
         var _loc4_:int = Math.min(param1,this._nodes[0].length - 1);
         _loc4_ = Math.max(0,_loc4_);
         return this._nodes[_loc3_][_loc4_];
      }
      
      public function setNodeWalkAble(param1:int, param2:int, param3:Boolean) : void
      {
         if(Boolean(this._nodes[param2]) && Boolean(this._nodes[param2][param1]))
         {
            this._nodes[param2][param1].walkable = param3;
         }
      }
      
      private function clearNodeLink(param1:Node) : void
      {
      }
      
      private function initNodeLink(param1:Node, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Node = null;
         var _loc5_:Node = null;
         var _loc6_:int = Math.max(0,param1.x - 1);
         var _loc7_:int = Math.min(this._rows - 1,param1.x + 1);
         var _loc8_:int = Math.max(0,param1.y - 1);
         var _loc9_:int = Math.min(this._cols - 1,param1.y + 1);
         var _loc10_:Vector.<Node> = new Vector.<Node>();
         var _loc11_:int = _loc6_;
         while(_loc11_ <= _loc7_)
         {
            _loc3_ = _loc8_;
            for(; _loc3_ <= _loc9_; _loc3_++)
            {
               _loc4_ = this.getNode(_loc11_,_loc3_);
               if(!(_loc4_ == param1 || !_loc4_.walkable))
               {
                  if(param2 != 2 && _loc11_ != param1.x && _loc3_ != param1.y)
                  {
                     _loc5_ = this.getNode(param1.x,_loc3_);
                     if(!_loc5_.walkable)
                     {
                        continue;
                     }
                     _loc5_ = this.getNode(_loc11_,param1.y);
                     if(!_loc5_.walkable)
                     {
                        continue;
                     }
                  }
                  _loc10_[_loc10_.length] = _loc4_;
               }
            }
            _loc11_++;
         }
         param1.links = _loc10_;
      }
   }
}

