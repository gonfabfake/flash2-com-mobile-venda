package superWinner.view.bigAwards
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import superWinner.controller.SuperWinnerController;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerBigAwardView extends Sprite implements Disposeable
   {
      
      private var _awardsArr:Vector.<SuperWinnerBigAward> = new Vector.<SuperWinnerBigAward>(6,true);
      
      public function SuperWinnerBigAwardView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         var i:uint = 0;
         var awards:SuperWinnerBigAward = null;
         var point:Point = null;
         i = 0;
         awards = null;
         point = null;
         var addEventListenersToAward:Function = function(param1:SuperWinnerBigAward, param2:uint):void
         {
            param1.addEventListener(MouseEvent.ROLL_OVER,showTip);
            param1.addEventListener(MouseEvent.ROLL_OUT,hideTip);
         };
         i = 1;
         while(i <= 6)
         {
            awards = new SuperWinnerBigAward(i);
            point = ComponentFactory.Instance.creatCustomObject("superWinner.bigAward" + i);
            awards.x = point.x;
            awards.y = point.y;
            this._awardsArr[i - 1] = awards;
            addEventListenersToAward(awards,i);
            addChild(awards);
            i++;
         }
      }
      
      private function showTip(param1:MouseEvent) : void
      {
         var _loc2_:SuperWinnerBigAward = param1.currentTarget as SuperWinnerBigAward;
         var _loc3_:SuperWinnerEvent = new SuperWinnerEvent(SuperWinnerEvent.SHOW_TIP);
         _loc3_.resultData = _loc2_.awardType;
         this.dispatchEvent(_loc3_);
      }
      
      private function hideTip(param1:MouseEvent) : void
      {
         var _loc2_:SuperWinnerBigAward = param1.currentTarget as SuperWinnerBigAward;
         var _loc3_:SuperWinnerEvent = new SuperWinnerEvent(SuperWinnerEvent.HIDE_TIP);
         _loc3_.resultData = _loc2_.awardType;
         this.dispatchEvent(_loc3_);
      }
      
      private function initEvent() : void
      {
         SuperWinnerController.instance.model.addEventListener(SuperWinnerEvent.FLUSH_AWARDS,this.flushAwards);
      }
      
      private function flushAwards(param1:SuperWinnerEvent) : void
      {
         var _loc2_:Array = SuperWinnerController.instance.model.awards;
         var _loc3_:uint = 0;
         while(_loc3_ < this._awardsArr.length)
         {
            this._awardsArr[_loc3_].awardNum = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      private function removeEvent() : void
      {
         SuperWinnerController.instance.model.removeEventListener(SuperWinnerEvent.FLUSH_AWARDS,this.flushAwards);
      }
      
      public function dispose() : void
      {
         var _loc1_:SuperWinnerBigAward = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._awardsArr.length)
         {
            _loc1_ = this._awardsArr[_loc2_];
            if(_loc1_.hasEventListener(MouseEvent.ROLL_OVER))
            {
               _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.showTip);
            }
            if(_loc1_.hasEventListener(MouseEvent.ROLL_OUT))
            {
               _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.hideTip);
            }
            _loc2_++;
         }
         this._awardsArr = null;
         ObjectUtils.removeChildAllChildren(this);
         this.removeEvent();
      }
   }
}

