package treasure.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureField extends Sprite implements Disposeable
   {
      
      private var X:Number = 236;
      
      private var Y:Number = 281;
      
      private var W:Number = 61;
      
      private var H:Number = 45;
      
      private var _fieldList:Vector.<TreasureCell>;
      
      private var cartoon:MovieClip;
      
      private var _fieldMc:MovieClip;
      
      private var _fieldMcList:Array;
      
      public function TreasureField(param1:Sprite)
      {
         super();
         param1.addChild(this);
         this.initListener();
      }
      
      private function initListener() : void
      {
         TreasureManager.instance.addEventListener("fieldChange",this.__fieldChangeHandler);
      }
      
      public function setField(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this.creatField();
         this._fieldList = new Vector.<TreasureCell>();
         var _loc5_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc4_ = new TreasureCell(_loc5_ + 1,param1);
               _loc4_.x = this.X + (_loc4_.width + 2 - this.W) * _loc2_ + this.W * _loc3_;
               _loc4_.y = this.Y + (_loc4_.height - 4 - this.H) * _loc2_ - this.H * _loc3_;
               addChild(_loc4_);
               _loc4_.addEvent();
               this._fieldList.push(_loc4_);
               _loc5_++;
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function creatField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = 0;
         _loc2_ = 0;
         _loc3_ = 0;
         this._fieldMcList = [];
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._fieldMc = ComponentFactory.Instance.creat("asset.treasure.field");
               this._fieldMc.x = this.X + (this._fieldMc.width + 2 - this.W) * _loc1_ + this.W * _loc2_;
               this._fieldMc.y = this.Y + (this._fieldMc.height - 4 - this.H) * _loc1_ - this.H * _loc2_;
               if(TreasureModel.instance.itemList[_loc3_].pos > 0)
               {
                  this._fieldMc.gotoAndStop(2);
               }
               else
               {
                  this._fieldMc.gotoAndStop(1);
               }
               addChild(this._fieldMc);
               this._fieldMcList.push(this._fieldMc);
               _loc3_++;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function __fieldChangeHandler(param1:TreasureEvents) : void
      {
         this._fieldMcList[param1.info.pos - 1].gotoAndStop(2);
      }
      
      public function endGameShow() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._fieldList.length)
         {
            if(TreasureModel.instance.itemList[this._fieldList[_loc1_]._fieldPos - 1].pos == 0)
            {
               this._fieldList[_loc1_].creatCartoon("end");
            }
            _loc1_++;
         }
      }
      
      public function playStartCartoon() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         _loc1_ = 0;
         while(_loc1_ < this._fieldList.length)
         {
            this._fieldList[_loc1_].cartoon.visible = false;
            _loc1_++;
         }
         this.cartoon = ComponentFactory.Instance.creat("asset.treasure.cartoon2");
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,43,43);
         _loc4_.graphics.endFill();
         _loc2_ = 1;
         while(_loc2_ <= TreasureModel.instance.itemList.length)
         {
            _loc3_ = new TreasureFieldCell(_loc4_,TreasureModel.instance.itemList[_loc2_ - 1]);
            this.cartoon["mc" + _loc2_].addChild(_loc3_);
            _loc2_++;
         }
         addChild(this.cartoon);
         PositionUtils.setPos(this.cartoon,"cartoon2.pos");
         this.cartoon.addEventListener("enterFrame",this.onCompleteHandeler);
      }
      
      public function digField(param1:int) : void
      {
         swapChildren(this._fieldList[param1 - 1],this._fieldList[this._fieldList.length - 1]);
         this._fieldList[param1 - 1].digBackHandler();
      }
      
      private function onCompleteHandeler(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.cartoon != null && this.cartoon.currentFrame == this.cartoon.totalFrames)
         {
            this.cartoon.removeEventListener("enterFrame",this.onCompleteHandeler);
            if(Boolean(this.cartoon))
            {
               ObjectUtils.disposeObject(this.cartoon);
            }
            this.cartoon = null;
            _loc2_ = 0;
            while(_loc2_ < this._fieldList.length)
            {
               this._fieldList[_loc2_].addEvent();
               _loc2_++;
            }
         }
      }
      
      private function removeListener() : void
      {
         TreasureManager.instance.removeEventListener("fieldChange",this.__fieldChangeHandler);
      }
      
      public function dispose() : void
      {
         this.removeListener();
         if(Boolean(this.cartoon))
         {
            ObjectUtils.disposeObject(this.cartoon);
         }
         this.cartoon = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

