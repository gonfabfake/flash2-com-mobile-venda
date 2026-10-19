package boguAdventure.view
{
   import bagAndInfo.cell.CellContentCreator;
   import boguAdventure.BoguAdventureControl;
   import boguAdventure.model.BoguAdventureActionType;
   import boguAdventure.player.BoguAdventurePlayer;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class BoguAdventureChangeView extends Sprite implements Disposeable
   {
      
      public static const MINE:String = "mine";
      
      public static const SIGN:String = "sign";
      
      private var _bogu:BoguAdventurePlayer;
      
      private var _control:BoguAdventureControl;
      
      private var _list:Dictionary;
      
      private var _move:Boolean;
      
      private var _explodeAction:MovieClip;
      
      private var _awardAction:MovieClip;
      
      private var _mineNum:ScaleFrameImage;
      
      private var _awardImgae:CellContentCreator;
      
      private var _boguDie:Bitmap;
      
      public function BoguAdventureChangeView(param1:BoguAdventureControl)
      {
         super();
         this._control = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._list = new Dictionary();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.createBogu();
         this.initEvent();
      }
      
      public function boguWalk(param1:Array) : void
      {
         this.clearWarnAction();
         this._bogu.playerWalk(param1);
         this._control.isMove = true;
         this._move = true;
      }
      
      public function placeGoods(param1:String, param2:int, param3:Point) : void
      {
         var _loc4_:Bitmap = null;
         _loc4_ = null;
         var _loc5_:String = param2.toString();
         if(this._list[_loc5_] != null)
         {
            return;
         }
         _loc4_ = UICreatShortcut.creatAndAdd("boguAdventure.mapView." + param1,this);
         _loc4_.x = param3.x;
         _loc4_.y = param3.y;
         if(Boolean(this._mineNum))
         {
            swapChildren(this._mineNum,_loc4_);
         }
         this.changeShowLevel(getChildIndex(this._bogu));
         this._list[_loc5_] = _loc4_;
      }
      
      public function celarGoods(param1:int) : void
      {
         var _loc2_:String = param1.toString();
         if(this._list[_loc2_] == null)
         {
            return;
         }
         var _loc3_:Bitmap = this._list[_loc2_] as Bitmap;
         ObjectUtils.disposeObject(_loc3_);
         _loc3_ = null;
         delete this._list[_loc2_];
      }
      
      public function playExplodAciton() : void
      {
         if(Boolean(this._explodeAction))
         {
            return;
         }
         this._explodeAction = UICreatShortcut.creatAndAdd("boguAdventure.view.explodeAction",this);
         this._explodeAction.stop();
         this._explodeAction.x = this._bogu.x + this._bogu.focusPos.x;
         this._explodeAction.y = this._bogu.y - 11;
         this._bogu.sceneCharacterActionType = BoguAdventurePlayer.WEEP;
         this.changeShowLevel(getChildIndex(this._bogu));
         this._explodeAction.play();
         this._explodeAction.addEventListener(Event.ENTER_FRAME,this.__onPlayExplodAcitonComplete);
         SoundManager.instance.play("069");
      }
      
      public function playAwardAction(param1:int) : void
      {
         if(Boolean(this._awardImgae))
         {
            return;
         }
         this._awardImgae = new CellContentCreator();
         this._awardImgae.info = ItemManager.Instance.getTemplateById(param1);
         this._awardImgae.loadSync(this.onCreateAwardImageComplete);
      }
      
      public function playWarnAction(param1:int, param2:Point) : void
      {
         this.clearWarnAction();
         if(!this._mineNum && param1 > 0)
         {
            this._mineNum = UICreatShortcut.creatAndAdd("boguAdventure.view.mineNum",this);
            this._mineNum.setFrame(param1);
            this._mineNum.x = param2.x;
            this._mineNum.y = param2.y;
            addChild(this._mineNum);
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._bogu))
         {
            this._bogu.update();
         }
         if(this._move)
         {
            this.changeShowLevel(getChildIndex(this._bogu));
         }
      }
      
      public function resetBogu(param1:Point) : void
      {
         this._move = false;
         this._control.isMove = false;
         this._bogu.dir = SceneCharacterDirection.RB;
         this._bogu.x = param1.x;
         this._bogu.y = param1.y;
         addChild(this._bogu);
      }
      
      public function clearChangeView() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this._list)
         {
            ObjectUtils.disposeObject(this._list[_loc1_] as Bitmap);
            this._list[_loc1_] = null;
            delete this._list[_loc1_];
         }
         this._list = new Dictionary();
      }
      
      private function __onPlayExplodAcitonComplete(param1:Event) : void
      {
         if(this._explodeAction.currentFrame == this._explodeAction.totalFrames)
         {
            this.clearExplodeAction();
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.playActionComplete({"type":BoguAdventureActionType.ACTINO_EXPLODE});
         }
      }
      
      private function clearExplodeAction() : void
      {
         if(Boolean(this._explodeAction))
         {
            this._explodeAction.stop();
            this._explodeAction.removeEventListener(Event.ENTER_FRAME,this.__onPlayExplodAcitonComplete);
            ObjectUtils.disposeAllChildren(this._explodeAction);
            ObjectUtils.disposeObject(this._explodeAction);
            this._explodeAction = null;
         }
      }
      
      private function onCreateAwardImageComplete() : void
      {
         if(Boolean(this._awardAction))
         {
            return;
         }
         this._awardAction = UICreatShortcut.creatAndAdd("boguAdventure.view.awardAction",this);
         this._awardAction.stop();
         this._awardImgae.width = this._awardImgae.height = 15;
         this._awardAction["mc"].addChild(this._awardImgae);
         this._awardAction.x = this._bogu.x + this._bogu.focusPos.x - 133;
         this._awardAction.y = this._bogu.y;
         this._bogu.sceneCharacterActionType = BoguAdventurePlayer.LAUGH;
         this._awardAction.play();
         this._awardAction.addEventListener(Event.ENTER_FRAME,this.__onPlayAwardAcitonComplete);
      }
      
      private function __onPlayAwardAcitonComplete(param1:Event) : void
      {
         if(this._awardAction.currentFrame == this._awardAction.totalFrames)
         {
            this.clearAwardAction();
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.playActionComplete({"type":BoguAdventureActionType.ACTION_AWARD});
         }
      }
      
      private function clearAwardAction() : void
      {
         if(Boolean(this._awardAction))
         {
            this._awardAction.stop();
            this._awardAction.removeEventListener(Event.ENTER_FRAME,this.__onPlayAwardAcitonComplete);
            ObjectUtils.disposeObject(this._awardImgae);
            this._awardImgae = null;
            ObjectUtils.disposeAllChildren(this._awardAction);
            ObjectUtils.disposeObject(this._awardAction);
            this._awardAction = null;
         }
      }
      
      public function clearWarnAction() : void
      {
         if(Boolean(this._mineNum))
         {
            ObjectUtils.disposeObject(this._mineNum);
            this._mineNum = null;
         }
      }
      
      public function boguState(param1:Boolean) : void
      {
         ObjectUtils.disposeObject(this._boguDie);
         this._boguDie = null;
         if(param1)
         {
            this._bogu.visible = true;
         }
         else
         {
            this._boguDie = UICreatShortcut.creatAndAdd("boguAdventure.view.die",this);
            if(this._bogu.dir == SceneCharacterDirection.LB)
            {
               this._boguDie.scaleX = -1;
            }
            else
            {
               this._boguDie.scaleX = 1;
            }
            this._boguDie.x = this._bogu.x;
            this._boguDie.y = this._bogu.y;
            this._bogu.visible = false;
         }
      }
      
      private function __onStopMove(param1:SceneCharacterEvent) : void
      {
         if(!Boolean(param1.data))
         {
            this._move = false;
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.walkComplete();
         }
         else
         {
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.WALK;
         }
      }
      
      private function createBogu() : void
      {
         this._bogu = new BoguAdventurePlayer(this.createBoguComplete);
         this._bogu.moveSpeed = 0.2;
         this._bogu.mouseChildren = false;
         this._bogu.mouseEnabled = false;
         addChild(this._bogu);
      }
      
      private function createBoguComplete(param1:BoguAdventurePlayer, param2:Boolean, param3:int = 0) : void
      {
         if(param2)
         {
            this._bogu.sceneCharacterActionType = BoguAdventurePlayer.STOP;
            this._control.bogu = this._bogu;
            return;
         }
         throw new Error("加载啵咕形象失败!检查下资源文件!");
      }
      
      private function changeShowLevel(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = getChildAt(param1);
         for each(_loc2_ in this._list)
         {
            this.swapShowLevel(getChildIndex(_loc3_),getChildIndex(_loc2_));
         }
      }
      
      private function swapShowLevel(param1:int, param2:int) : void
      {
         if(param1 == param2)
         {
            return;
         }
         var _loc3_:DisplayObject = getChildAt(param1);
         var _loc4_:DisplayObject = getChildAt(param2);
         if(Math.abs(_loc3_.x - _loc4_.x) < 150 && Math.abs(_loc3_.y - _loc4_.y) < 150)
         {
            if(_loc3_.y + _loc3_.height > _loc4_.y + _loc4_.height)
            {
               if(param1 < param2)
               {
                  this.swapChildrenAt(param1,param2);
               }
            }
            else if(param1 > param2)
            {
               this.swapChildrenAt(param1,param2);
            }
         }
      }
      
      private function initEvent() : void
      {
         this._bogu.addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__onStopMove);
      }
      
      private function removeEvent() : void
      {
         this._bogu.removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.__onStopMove);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.clearAwardAction();
         this.clearExplodeAction();
         removeChild(this._bogu);
         this.clearChangeView();
         this.clearWarnAction();
         this._list = null;
         this._bogu.dispose();
         this._bogu = null;
         this._control = null;
         ObjectUtils.disposeObject(this._boguDie);
         this._boguDie = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}

