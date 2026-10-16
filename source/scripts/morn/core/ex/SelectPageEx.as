package morn.core.ex
{
   import flash.events.Event;
   import morn.core.components.Button;
   import morn.core.components.Component;
   import morn.core.handlers.Handler;
   
   public class SelectPageEx extends Component
   {
      
      protected static const WIDTH:int = 207;
      
      protected static const HEIGHT:int = 33;
      
      protected static const MAXTOTLE:int = 10;
      
      private var _totle:int = 0;
      
      private var _btnArr:Array;
      
      private var _curIndex:int = 0;
      
      public function SelectPageEx()
      {
         super();
      }
      
      public function get curIndex() : int
      {
         return this._curIndex;
      }
      
      public function set curIndex(param1:int) : void
      {
         this._curIndex = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._btnArr = [];
         this.width = 207;
         this.height = 33;
         this.mouseChildren = true;
      }
      
      public function set totle(param1:int) : void
      {
         this._totle = param1;
         this.createBtn();
      }
      
      private function createBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this.removeBtns();
         _loc1_ = 0;
         while(_loc1_ < this._totle)
         {
            _loc2_ = new Button();
            _loc2_.stateNum = 1;
            _loc2_.label = "";
            _loc2_.clickHandler = new Handler(this._btnClickHandler,[_loc2_]);
            this._btnArr.push(_loc2_);
            _loc2_.x = _loc1_ * 20;
            addChild(_loc2_);
            _loc1_++;
         }
         this.changeBtnState();
         this.pageSetPosition();
      }
      
      private function pageSetPosition() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = int(this._btnArr.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._btnArr[_loc1_];
            _loc2_.x = (10 - _loc3_) * 10 + _loc1_ * 20;
            _loc1_++;
         }
      }
      
      private function changeBtnState() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._btnArr.length)
         {
            (this._btnArr[_loc1_] as Button).skin = _loc1_ == this._curIndex ? "asset.magicWardrobe.selected" : "asset.magicWardrobe.unSelected";
            _loc1_++;
         }
      }
      
      private function _btnClickHandler(param1:Object) : void
      {
         var _loc2_:int = this._btnArr.indexOf(param1);
         if(this._curIndex == _loc2_)
         {
            return;
         }
         this._curIndex = _loc2_;
         this.changeBtnState();
         dispatchEvent(new Event("change"));
      }
      
      private function removeBtns() : void
      {
         var _loc1_:* = null;
         while(Boolean(this._btnArr.length))
         {
            _loc1_ = this._btnArr.shift() as Button;
            _loc1_.dispose();
            _loc1_ = null;
         }
      }
      
      override public function dispose() : void
      {
         this.removeBtns();
         super.dispose();
      }
   }
}

