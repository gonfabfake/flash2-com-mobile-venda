package rank.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class RankCell extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleFrameImage;
      
      private var _titlefield:FilterFrameText;
      
      private var _selected:Boolean = false;
      
      private var _info:GmActivityInfo;
      
      public function RankCell(param1:GmActivityInfo)
      {
         super();
         this._info = param1;
         this.initUI();
      }
      
      public function get info() : GmActivityInfo
      {
         return this._info;
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
         DisplayUtils.setFrame(this._bg,this._selected ? 2 : 1);
         DisplayUtils.setFrame(this._titlefield,this._selected ? 2 : 1);
      }
      
      private function initUI() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("rank.ActivityCellBg");
         this._titlefield = ComponentFactory.Instance.creatComponentByStylename("rank.ActivityCellTitleText");
         DisplayUtils.setFrame(this._bg,this._selected ? 2 : 1);
         addChild(this._bg);
         this._titlefield.htmlText = "<b>·</b> " + this._info.activityName;
         addChild(this._titlefield);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titlefield);
         this._titlefield = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

