package welfareCenter.icon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class WelfareCenterItem extends Sprite implements Disposeable, ISelectable
   {
      
      protected var _icon:MutipleImage;
      
      protected var _type:int;
      
      protected var _selected:Boolean;
      
      protected var _shine:MovieClip;
      
      protected var _filter:Array;
      
      public function WelfareCenterItem(param1:int)
      {
         super();
         this._type = param1;
         this.init();
      }
      
      protected function init() : void
      {
         this._icon = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.gift.icon" + this._type);
         this._icon.buttonMode = true;
         addChild(this._icon);
         this._shine = ComponentFactory.Instance.creat("asset.welfareCeneter.iconItemShine");
         PositionUtils.setPos(this._shine,"welfareCenter.gradeGiftView.ItemShinePos");
         this._shine.visible = false;
         addChild(this._shine);
         this._filter = ComponentFactory.Instance.creatFilters("welfareCenter.boxFilter");
         this.filters = this._filter;
      }
      
      public function get canClick() : Boolean
      {
         return true;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set isShine(param1:Boolean) : void
      {
         this._shine.visible = param1;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this.filters = this._selected ? [] : this._filter;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._icon = null;
         this._shine = null;
         this._filter = null;
      }
   }
}

