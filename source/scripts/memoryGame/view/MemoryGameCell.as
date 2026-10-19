package memoryGame.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import memoryGame.MemoryGameManager;
   
   public class MemoryGameCell extends Sprite implements Disposeable
   {
      
      private static const TURN_EVENT:String = "turnComplete";
      
      private static const PLAY_OPEN_COMPLETE:String = "playOpenComplete";
      
      private static const PLAY_CLOSE_COMPLETE:String = "playCloseComplete";
      
      private var _index:int = 0;
      
      private var _isOpen:Boolean;
      
      private var _turnMC:MovieClip;
      
      private var _cell:BagCell;
      
      public function MemoryGameCell(param1:int)
      {
         super();
         this._index = param1;
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         buttonMode = true;
         this._turnMC = ClassUtils.CreatInstance("asset.memoryGame.cellTurn");
         addChild(this._turnMC);
         this._cell = this.createCell();
         addChild(this._cell);
      }
      
      public function open(param1:int, param2:int) : void
      {
         this.setInfo(param1,param2);
         if(!this._isOpen)
         {
            MemoryGameManager.instance.playOpenStart();
            this._isOpen = true;
            this._turnMC.gotoAndPlay(3);
         }
      }
      
      public function close() : void
      {
         MemoryGameManager.instance.playCloseStart();
         this._cell.visible = false;
         this._turnMC.gotoAndPlay(32);
         this._isOpen = false;
      }
      
      public function openDefault(param1:int, param2:int) : void
      {
         this.setInfo(param1,param2);
         this._isOpen = true;
         this._turnMC.gotoAndStop(2);
         this._cell.visible = true;
      }
      
      public function closeDefault() : void
      {
         this._cell.visible = false;
         this._turnMC.gotoAndStop(1);
         this._isOpen = false;
      }
      
      public function shine() : void
      {
      }
      
      private function setInfo(param1:int, param2:int) : void
      {
         if(!this._cell.info || this._cell.info.TemplateID != param1)
         {
            this._cell.info = ItemManager.Instance.getTemplateById(param1);
         }
         this._cell.setCount(param2);
      }
      
      private function __onTurnComplete(param1:Event) : void
      {
         this._cell.visible = true;
      }
      
      private function __onPlayOpenComplete(param1:Event) : void
      {
         MemoryGameManager.instance.playOpenStop();
      }
      
      private function __onPlayCloseComplete(param1:Event) : void
      {
         MemoryGameManager.instance.playCloseStop();
      }
      
      private function createCell(param1:int = 11096) : BagCell
      {
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,60,60);
         _loc2_.graphics.endFill();
         var _loc3_:BagCell = new BagCell(0,null,true,_loc2_,false);
         PositionUtils.setPos(_loc3_,"memoryGame.cellPos");
         return _loc3_;
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!MemoryGameManager.instance.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.activityTips"));
            return;
         }
         if(!this._isOpen)
         {
            if(MemoryGameManager.instance.count > 0)
            {
               if(MemoryGameManager.instance.playActionAllComplete() && !MemoryGameManager.instance.turning)
               {
                  SocketManager.Instance.out.sendMemoryGameTurnover(this._index);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("carnival.clickTip"));
               }
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.notTurn"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.cardOpenTips"));
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener("click",this.__onClick);
         this._turnMC.addEventListener("turnComplete",this.__onTurnComplete);
         this._turnMC.addEventListener("playOpenComplete",this.__onPlayOpenComplete);
         this._turnMC.addEventListener("playCloseComplete",this.__onPlayCloseComplete);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener("click",this.__onClick);
         this._turnMC.removeEventListener("turnComplete",this.__onTurnComplete);
         this._turnMC.removeEventListener("playOpenComplete",this.__onPlayOpenComplete);
         this._turnMC.removeEventListener("playCloseComplete",this.__onPlayCloseComplete);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._cell = null;
         this._turnMC = null;
      }
   }
}

