package boguAdventure.view
{
   import boguAdventure.BoguAdventureControl;
   import boguAdventure.cell.BoguAdventureCell;
   import boguAdventure.model.BoguAdventureActionType;
   import boguAdventure.model.BoguAdventureCellInfo;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.PerspectiveProjection;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BoguAdventureMap extends Sprite implements Disposeable
   {
      
      private static const MAP_WIDTH:int = 10;
      
      private static const MAP_HEIGHT:int = 7;
      
      private var _mapBg:Bitmap;
      
      private var _cellList:Vector.<BoguAdventureCell>;
      
      private var _control:BoguAdventureControl;
      
      public function BoguAdventureMap(param1:BoguAdventureControl)
      {
         super();
         this._control = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.transform.perspectiveProjection = new PerspectiveProjection();
         this.transform.perspectiveProjection.projectionCenter = new Point(500,300);
         this.rotationX = -38;
         this._mapBg = UICreatShortcut.creatAndAdd("boguAdventure.gameView.Bg",this);
         this.createMapCell();
      }
      
      public function getCellPosIndex(param1:int, param2:Point) : Point
      {
         if(param1 == 0)
         {
            return new Point(100,100);
         }
         var _loc3_:BoguAdventureCell = this.getCellByIndex(param1);
         var _loc4_:Rectangle = _loc3_.getRect(stage);
         var _loc5_:Point = this.localToGlobal(new Point(_loc3_.x,_loc3_.y));
         var _loc6_:Number = _loc5_.x + int(_loc4_.width * 0.5) - param2.x;
         var _loc7_:Number = _loc5_.y + int(_loc4_.height * 0.5) - param2.y;
         var _loc8_:String = param1 < 10 ? param1.toString() : param1.toString().charAt(1);
         _loc6_ = _loc8_ == "1" ? Number(_loc6_ - 10) : (_loc8_ == "2" ? Number(_loc6_ - 8) : (_loc8_ == "3" ? Number(_loc6_ = _loc6_ - 6) : Number(_loc6_)));
         return new Point(_loc6_,_loc7_);
      }
      
      public function getCellByIndex(param1:int) : BoguAdventureCell
      {
         return this._cellList[param1 - 1];
      }
      
      public function playFineMineAction(param1:int) : void
      {
         var _loc2_:BoguAdventureCell = this.getCellByIndex(param1);
         _loc2_.playShineAction();
      }
      
      public function mouseClickClose() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function mouseClickOpen() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
      }
      
      private function createMapCell() : void
      {
         var _loc1_:BoguAdventureCell = null;
         _loc1_ = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._cellList = new Vector.<BoguAdventureCell>();
         _loc2_ = 0;
         while(_loc2_ < MAP_HEIGHT)
         {
            _loc3_ = 0;
            while(_loc3_ < MAP_WIDTH)
            {
               _loc1_ = new BoguAdventureCell();
               _loc1_.addEventListener(MouseEvent.CLICK,this.__onClickCell);
               _loc1_.addEventListener(BoguAdventureCell.PLAY_COMPLETE,this.__onPlayComplete);
               _loc1_.x = 20 + _loc3_ * _loc1_.width;
               _loc1_.y = 19 + _loc2_ * _loc1_.height;
               addChild(_loc1_);
               this._cellList.push(_loc1_);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function __onClickCell(param1:MouseEvent) : void
      {
         if(!(param1.target is BoguAdventureCell))
         {
            return;
         }
         var _loc2_:BoguAdventureCell = param1.target as BoguAdventureCell;
         if(this._control.changeMouse)
         {
            return;
         }
         if(this._control.checkGameOver())
         {
            return;
         }
         if(this._control.currentIndex == _loc2_.info.index)
         {
            return;
         }
         if(_loc2_.info.state == BoguAdventureCellInfo.OPEN)
         {
            if(_loc2_.info.result == BoguAdventureCellInfo.MINE)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.walkTip"));
               return;
            }
         }
         if(_loc2_.info.state == BoguAdventureCellInfo.SIGN)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.isSign"));
            return;
         }
         this.mouseClickClose();
         this.boguWalk(_loc2_.info.index);
      }
      
      private function boguWalk(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = this._control.currentIndex - 1 < 0 ? int(0) : int(this._control.currentIndex - 1);
         var _loc5_:uint = param1 - 1 < 0 ? uint(0) : uint(param1 - 1);
         var _loc6_:String = _loc4_ < 10 ? "0" + _loc4_ : _loc4_.toString();
         var _loc7_:String = _loc5_ < 10 ? "0" + _loc5_ : _loc5_.toString();
         var _loc8_:SceneCharacterDirection = null;
         if(this._control.currentIndex == 0)
         {
            _loc3_.push(this.getCellPosIndex(1,this._control.bogu.focusPos));
         }
         if(_loc6_.charAt(1) != _loc7_.charAt(1))
         {
            if(_loc6_.charAt(1) < _loc7_.charAt(1))
            {
               this._control.bogu.dir = SceneCharacterDirection.RB;
            }
            else
            {
               this._control.bogu.dir = SceneCharacterDirection.LB;
            }
            _loc2_ = int(_loc7_.charAt(0) + _loc6_.charAt(1)) + 1;
            _loc3_.push(this.getCellPosIndex(_loc2_,this._control.bogu.focusPos));
         }
         _loc3_.push(this.getCellPosIndex(param1,this._control.bogu.focusPos));
         this._control.currentIndex = param1;
         this._control.walk(_loc3_);
      }
      
      private function __onPlayComplete(param1:Event) : void
      {
         var _loc2_:BoguAdventureCell = param1.currentTarget as BoguAdventureCell;
         this._control.playActionComplete({
            "type":BoguAdventureActionType.ACTION_FINT_MINE,
            "index":_loc2_.info.index
         });
      }
      
      public function dispose() : void
      {
         var _loc1_:BoguAdventureCell = null;
         while(Boolean(this._cellList.length))
         {
            _loc1_ = this._cellList.pop();
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onClickCell);
            _loc1_.removeEventListener(BoguAdventureCell.PLAY_COMPLETE,this.__onPlayComplete);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._cellList = null;
         ObjectUtils.disposeObject(this._mapBg);
         this._mapBg = null;
         this._control = null;
      }
   }
}

