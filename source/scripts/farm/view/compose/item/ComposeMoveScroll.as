package farm.view.compose.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ComposeMoveScroll extends Sprite implements Disposeable
   {
      
      private const SHOW_HOUSEITEM_COUNT:int = 5;
      
      private var _currentShowIndex:int = 0;
      
      private var _petsImgVec:Vector.<FarmHouseItem>;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _bag:BagInfo;
      
      private var _hBox:HBox;
      
      private var _start:int;
      
      public function ComposeMoveScroll()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.button.left");
         this._leftBtn.transparentEnable = true;
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.button.right");
         addChild(this._rightBtn);
         this._petsImgVec = new Vector.<FarmHouseItem>(5);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("farm.componsePnl.hbox");
         addChild(this._hBox);
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new FarmHouseItem();
            this._petsImgVec[_loc1_] = _loc2_;
            this._hBox.addChild(_loc2_);
            _loc1_++;
         }
         this._bag = PlayerManager.Instance.Self.getBag(14);
         this._start = 0;
         this.update();
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener("click",this.__ClickHandler);
         this._rightBtn.addEventListener("click",this.__ClickHandler);
         this._bag.addEventListener("update",this.__bagUpdate);
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener("click",this.__ClickHandler);
         this._rightBtn.removeEventListener("click",this.__ClickHandler);
         this._bag.removeEventListener("update",this.__bagUpdate);
      }
      
      private function __bagUpdate(param1:BagEvent) : void
      {
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.clearItem();
         if(this._bag.items.length > 0)
         {
            _loc1_ = this._bag.items.length > this._start + 5 ? int(this._start + 5) : this._bag.items.length;
            _loc2_ = this._start;
            while(_loc2_ < _loc1_)
            {
               this._petsImgVec[_loc2_ - this._start].info = this._bag.items.list[_loc2_];
               _loc2_++;
            }
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            this._petsImgVec[_loc1_].info = null;
            _loc1_++;
         }
      }
      
      private function __ClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._leftBtn:
               if(this._start - 1 >= 0)
               {
                  this._start -= 1;
               }
               break;
            case this._rightBtn:
               if(this._start + 1 <= this._bag.items.length - 5)
               {
                  this._start += 1;
               }
         }
         this.update();
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         this.removeEvent();
         this._bag = null;
         this._start = 0;
         for each(_loc1_ in this._petsImgVec)
         {
            if(Boolean(_loc1_))
            {
               _loc1_.dispose();
               _loc1_ = null;
            }
         }
         this._petsImgVec.splice(0,this._petsImgVec.length);
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
            this._hBox = null;
         }
         if(Boolean(this._leftBtn))
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(Boolean(this._rightBtn))
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

