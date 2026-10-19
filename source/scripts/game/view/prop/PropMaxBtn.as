package game.view.prop
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PropMaxBtn extends Sprite implements Disposeable, ITipedDisplay
   {
      
      private var _tipInfo:ToolPropInfo;
      
      public function PropMaxBtn()
      {
         super();
         this._tipInfo = new ToolPropInfo();
         this._tipInfo.count = 0;
         this._tipInfo.shortcutKey = "4";
         this._tipInfo.valueType = "max";
         this._tipInfo.showTurn = false;
         this._tipInfo.showThew = true;
         this._tipInfo.showCount = true;
         var _loc1_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc1_.Name = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.max");
         _loc1_.Description = LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.maxDetail");
         this._tipInfo.info = _loc1_;
         ShowTipManager.Instance.addTip(this);
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
      }
      
      public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "5,2,7,1,6,4";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 20;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 20;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "core.ToolPropTips";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

