package ddtKingWay.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DDTKingWayLevelTargetItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _taskTargetText:FilterFrameText;
      
      private var _stateImage:ScaleFrameImage;
      
      private var _jumpBtn:BaseButton;
      
      private var _num:int;
      
      private var _taskStatus:Boolean;
      
      private var _info:QuestInfo;
      
      public function DDTKingWayLevelTargetItem(param1:int = 0)
      {
         super();
         this._num = param1;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtKingWay.itembg" + (param1 % 2 + 1));
         this._stateImage = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.completestatusIcom");
         this._taskTargetText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.taskTargetText");
         this._jumpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.upgradeBtn");
         this._jumpBtn.addEventListener("click",this.textClickHandler);
         addChild(this._bg);
         addChild(this._taskTargetText);
         addChild(this._stateImage);
         addChild(this._jumpBtn);
      }
      
      public function updataStutas(param1:QuestInfo, param2:Boolean, param3:Boolean) : void
      {
         this._info = param1;
         this._taskStatus = param2;
         this.creatStateText(param3);
      }
      
      private function creatStateText(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if((!this._info.data || this._info.progress[this._num] <= 0) && param1)
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 1;
         }
         this._stateImage.setFrame(_loc2_);
         this._taskTargetText.setFrame(_loc2_);
         this._taskTargetText.text = this._info.conditions[this._num].description;
      }
      
      private function textClickHandler(param1:MouseEvent) : void
      {
      }
      
      public function dispose() : void
      {
         this._jumpBtn.removeEventListener("click",this.textClickHandler);
         ObjectUtils.disposeObject(this._taskTargetText);
         this._taskTargetText = null;
         ObjectUtils.disposeObject(this._stateImage);
         this._stateImage = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._jumpBtn);
         this._jumpBtn = null;
      }
   }
}

