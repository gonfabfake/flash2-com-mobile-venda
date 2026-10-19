package ddt.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   
   public class ItemCellEffectMngr
   {
      
      private static var effectState:IState;
      
      public static const EFFECT_RUN_AROUND:int = 0;
      
      public static const SIZE_BAG_CELL:int = 100;
      
      public static const SIZE_SHOP_ITEM_CELL:int = 101;
      
      public function ItemCellEffectMngr()
      {
         super();
      }
      
      public static function getEffect(param1:Object, param2:int = 0, param3:int = 100) : MovieClip
      {
         var _loc4_:MovieClip = null;
         _loc4_ = null;
         switch(param2)
         {
            case EFFECT_RUN_AROUND:
               _loc4_ = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
               effectState = new StateRunAround();
               _loc4_.mouseChildren = false;
               _loc4_.mouseEnabled = false;
               effectState.setSize(_loc4_,param1,param3);
               effectState = null;
               return _loc4_;
            default:
               throw "没有这样的特效类型.";
         }
      }
   }
}

import flash.display.MovieClip;

interface IState
{
   
   function setSize(param1:MovieClip, param2:Object, param3:int) : void;
}

class StateRunAround implements IState
{
   
   public function StateRunAround()
   {
      super();
   }
   
   public function setSize(param1:MovieClip, param2:Object, param3:int) : void
   {
      switch(param3)
      {
         case 100:
            param1.scaleX = param1.scaleY = 1;
            param1.x = param2.x - 1;
            param1.y = param2.y - 1;
            break;
         case 101:
            param1.scaleX = param1.scaleY = 56 / 45;
            param1.x = param2.x + 9;
            param1.y = param2.y + 10;
      }
   }
}
