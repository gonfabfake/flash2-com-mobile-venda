package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import foodActivity.FoodActivityManager;
   
   public class FoodActivityEnterIcon extends Sprite implements Disposeable
   {
      
      private var _foodActivityIcon:MovieImage;
      
      private var _foodActivityTxt:FilterFrameText;
      
      private var _timeBg:Bitmap;
      
      private var _timeTxt:FilterFrameText;
      
      private var _timeSp:Sprite;
      
      private var _minutesArr:Array;
      
      public function FoodActivityEnterIcon()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._foodActivityIcon = ComponentFactory.Instance.creat("hall.foodActivityBtn");
         this._foodActivityIcon.buttonMode = true;
         addChild(this._foodActivityIcon);
         this._foodActivityTxt = ComponentFactory.Instance.creatComponentByStylename("hall.foodActivity.countTxt");
         this._foodActivityTxt.x = 58;
         this._foodActivityTxt.y = 5;
         this._foodActivityTxt.text = "" + FoodActivityManager.Instance.cookingCount;
         addChild(this._foodActivityTxt);
         this._timeSp = new Sprite();
         this._timeBg = ComponentFactory.Instance.creatBitmap("foodActivity.timeBGAsset");
         this._timeTxt = ComponentFactory.Instance.creat("foodActivity.TimeBoxStyle");
         this._timeTxt.x = this._timeBg.x + (this._timeBg.width - this._timeTxt.width) / 2;
         this._timeTxt.y = this._timeBg.y + 1;
         this._timeSp.addChild(this._timeBg);
         this._timeSp.addChild(this._timeTxt);
         addChild(this._timeSp);
         this._timeSp.visible = false;
      }
      
      public function showTxt() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = FoodActivityManager.Instance.info.remain2.split("|");
         this._minutesArr = [];
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            this._minutesArr.push(_loc2_[_loc1_].split(",")[0]);
            _loc1_++;
         }
         if(FoodActivityManager.Instance.cookingCount == 0 && FoodActivityManager.Instance.state == 0)
         {
            FoodActivityManager.Instance.startTime();
         }
         else
         {
            FoodActivityManager.Instance.endTime();
         }
      }
      
      public function set text(param1:String) : void
      {
         this._foodActivityTxt.text = param1;
      }
      
      public function startTime(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._timeSp.visible = true;
         if(FoodActivityManager.Instance.sumTime > 0)
         {
            this.updateTime();
            return;
         }
         if(param1)
         {
            _loc2_ = FoodActivityManager.Instance.delayTime;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this._minutesArr.length)
            {
               if(FoodActivityManager.Instance.currentSumTime < this._minutesArr[_loc3_])
               {
                  _loc2_ = this._minutesArr[_loc3_] - FoodActivityManager.Instance.currentSumTime;
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc2_ == 0)
         {
            FoodActivityManager.Instance.endTime();
            return;
         }
         FoodActivityManager.Instance.sumTime = _loc2_ * 60;
         this.updateTime();
      }
      
      public function updateTime() : void
      {
         var _loc1_:int = FoodActivityManager.Instance.sumTime / 60;
         var _loc2_:int = FoodActivityManager.Instance.sumTime % 60;
         var _loc3_:String = "";
         if(_loc1_ < 10)
         {
            _loc3_ += "0" + _loc1_;
         }
         else
         {
            _loc3_ += _loc1_;
         }
         _loc3_ += ":";
         if(_loc2_ < 10)
         {
            _loc3_ += "0" + _loc2_;
         }
         else
         {
            _loc3_ += _loc2_;
         }
         this._timeTxt.text = _loc3_;
      }
      
      public function endTime() : void
      {
         this._timeSp.visible = false;
      }
      
      protected function __showFoodActivityFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         FoodActivityManager.Instance.show();
      }
      
      private function initEvent() : void
      {
         this._foodActivityIcon.addEventListener("click",this.__showFoodActivityFrame);
      }
      
      private function removeEvent() : void
      {
         this._foodActivityIcon.removeEventListener("click",this.__showFoodActivityFrame);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._foodActivityIcon);
         this._foodActivityIcon = null;
         ObjectUtils.disposeObject(this._foodActivityTxt);
         this._foodActivityTxt = null;
         ObjectUtils.disposeObject(this._timeBg);
         this._timeBg = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._timeSp);
         this._timeSp = null;
      }
   }
}

