package superWinner.view.smallAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import superWinner.controller.SuperWinnerController;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerSmallAwardView extends Sprite implements Disposeable
   {
      
      private var _awardsArr:Vector.<SuperWinnerSmallAward> = new Vector.<SuperWinnerSmallAward>(6,true);
      
      public function SuperWinnerSmallAwardView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:SuperWinnerSmallAward = null;
         var _loc3_:Point = null;
         _loc1_ = 0;
         _loc2_ = null;
         _loc3_ = null;
         _loc1_ = 1;
         while(_loc1_ <= 6)
         {
            _loc2_ = new SuperWinnerSmallAward(_loc1_);
            _loc3_ = ComponentFactory.Instance.creatCustomObject("superWinner.smallAward" + _loc1_);
            _loc2_.x = _loc3_.x;
            _loc2_.y = _loc3_.y;
            this._awardsArr[_loc1_ - 1] = _loc2_;
            addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         SuperWinnerController.instance.model.addEventListener(SuperWinnerEvent.FLUSH_MY_AWARDS,this.flushAwards);
      }
      
      private function flushAwards(param1:SuperWinnerEvent) : void
      {
         var _loc2_:Array = SuperWinnerController.instance.model.myAwards;
         var _loc3_:uint = 0;
         while(_loc3_ < this._awardsArr.length)
         {
            this._awardsArr[_loc3_].awardNum = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      private function removeEvent() : void
      {
         SuperWinnerController.instance.model.removeEventListener(SuperWinnerEvent.FLUSH_MY_AWARDS,this.flushAwards);
      }
      
      public function dispose() : void
      {
         this._awardsArr = null;
         ObjectUtils.removeChildAllChildren(this);
         this.removeEvent();
      }
   }
}

