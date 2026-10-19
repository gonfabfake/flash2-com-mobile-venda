package game.view.prop
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.EquipType;
   import ddt.data.FightPropMode;
   import ddt.data.PropInfo;
   import ddt.data.UsePropErrorCode;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.LivingEvent;
   import ddt.events.SharedEvent;
   import ddt.manager.DragManager;
   import ddt.manager.InGameCursor;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MaxBtnStateManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import game.GameManager;
   import game.model.LocalPlayer;
   import org.aswing.KeyStroke;
   import org.aswing.KeyboardManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class RightPropBar extends FightPropBar
   {
      
      private var _startPos:Point;
      
      private var _mouseHolded:Boolean = false;
      
      private var _elasped:int = 0;
      
      private var _last:int = 0;
      
      private var _container:DisplayObjectContainer;
      
      private var _localVisible:Boolean = true;
      
      private var _tweenComplete:Boolean = true;
      
      private var _rightPropBarBorder:Array = [];
      
      private var _cellSprite:Sprite;
      
      private var cell:PropCell;
      
      private var _tempPlace:int;
      
      private var _maxBtn:PropMaxBtn;
      
      private var _packUpBtn:SimpleBitmapButton;
      
      private var _dropDownBtn:SimpleBitmapButton;
      
      private var _isPackUp:Boolean = false;
      
      private var _greyFilter:Array;
      
      private var bmp:Bitmap;
      
      public function RightPropBar(param1:LocalPlayer, param2:DisplayObjectContainer)
      {
         this._container = param2;
         super(param1);
         this.isPackUp = false;
         this.setItems();
      }
      
      private function setPropBarBorder(param1:int, param2:Boolean) : void
      {
         if(Boolean(this._rightPropBarBorder) && Boolean(this._rightPropBarBorder[param1]))
         {
            this._rightPropBarBorder[param1].visible = param2;
         }
      }
      
      public function get isPackUp() : Boolean
      {
         return this._isPackUp;
      }
      
      public function set isPackUp(param1:Boolean) : void
      {
         this._isPackUp = param1;
         if(this._isPackUp)
         {
            this.setPropBarBorder(0,false);
            this.setPropBarBorder(1,true);
         }
         else
         {
            this.setPropBarBorder(0,true);
            this.setPropBarBorder(1,false);
         }
      }
      
      public function setup(param1:DisplayObjectContainer) : void
      {
         this._container = param1;
         this._container.addChild(this);
         if(_mode == FightPropMode.VERTICAL)
         {
            x = _background.width;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "x":0,
                  "alpha":1
               });
            }
         }
         else
         {
            y = 102;
            if(SharedManager.Instance.propTransparent)
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":0.5
               });
            }
            else
            {
               TweenLite.to(this,0.3,{
                  "y":0,
                  "alpha":1
               });
            }
         }
      }
      
      private function setItems() : void
      {
         var _loc1_:* = null;
         var _loc2_:PropInfo = null;
         var _loc3_:Array = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:Boolean = false;
         var _loc6_:InventoryItemInfo = PlayerManager.Instance.Self.PropBag.findFistItemByTemplateId(EquipType.T_ALL_PROP,true,true);
         var _loc7_:Object = SharedManager.Instance.GameKeySets;
         for(_loc1_ in _loc7_)
         {
            if(int(_loc1_) == 9)
            {
               break;
            }
            _loc2_ = new PropInfo(ItemManager.Instance.getTemplateById(_loc7_[_loc1_]));
            if(Boolean(_loc6_) || PlayerManager.Instance.Self.hasBuff(BuffInfo.FREE))
            {
               if(Boolean(_loc6_))
               {
                  _loc2_.Place = _loc6_.Place;
               }
               else
               {
                  _loc2_.Place = -1;
               }
               _loc2_.Count = -1;
               _cells[int(_loc1_) - 1].info = _loc2_;
               _loc5_ = true;
            }
            else
            {
               _loc3_ = PlayerManager.Instance.Self.PropBag.findItemsByTempleteID(_loc7_[_loc1_]);
               if(_loc3_.length > 0)
               {
                  _loc2_.Place = _loc3_[0].Place;
                  for each(_loc4_ in _loc3_)
                  {
                     _loc2_.Count += _loc4_.Count;
                  }
                  _cells[int(_loc1_) - 1].info = _loc2_;
                  _loc5_ = true;
               }
               else
               {
                  _cells[int(_loc1_) - 1].info = _loc2_;
               }
            }
         }
         if(_loc5_)
         {
            this.handleItem();
         }
      }
      
      protected function handleItem() : void
      {
         var _loc1_:* = null;
         if(PlayerManager.Instance.Self.Grade >= 16)
         {
            this._greyFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._maxBtn = new PropMaxBtn();
            this.bmp = ComponentFactory.Instance.creat("asset.game.prop.Max");
            this.bmp.smoothing = true;
            this.bmp.width = 37;
            this.bmp.height = 37;
            _loc1_ = ComponentFactory.Instance.creatBitmap("asset.game.prop.ShortcutKey4");
            _loc1_.x = 23;
            _loc1_.y = -1;
            this._maxBtn.addChild(this.bmp);
            this._maxBtn.addChild(_loc1_);
            PositionUtils.setPos(this._maxBtn,"prop.maxbtn");
            this._maxBtn.addEventListener("mouseOver",this.onMaxOver);
            this._maxBtn.addEventListener("mouseOut",this.onMaxOut);
            this._packUpBtn = ComponentFactory.Instance.creat("prop.packUpBtn");
            this._dropDownBtn = ComponentFactory.Instance.creat("prop.dropDwonBtn");
            addChild(this._packUpBtn);
            this._packUpBtn.addEventListener("click",this.onPackUpClick);
            this._dropDownBtn.addEventListener("click",this.onDropDownClick);
            this.addEvents();
            MaxBtnStateManager.getInstance().requireState();
         }
         this.updatePropByEnergy();
         if(_self.autoOnHook)
         {
            this._packUpBtn.dispatchEvent(new MouseEvent("click"));
         }
      }
      
      private function addEvents() : void
      {
         MaxBtnStateManager.getInstance().addEvents();
         MaxBtnStateManager.getInstance().addEventListener("maxbtnstate_change",this.onMaxBtnStateChange);
      }
      
      protected function onMaxBtnStateChange(param1:Event) : void
      {
         switch(MaxBtnStateManager.getInstance().maxBtnIsPackUp)
         {
            case true:
               this.packUpEffect();
               break;
            case false:
               this.dropDownEffect();
         }
      }
      
      protected function onMaxOut(param1:MouseEvent) : void
      {
         this._maxBtn.scaleX = 1;
         this._maxBtn.x += 3;
         this._maxBtn.scaleY = 1;
         TweenMax.killTweensOf(this._maxBtn);
         this._maxBtn.filters = [];
      }
      
      protected function onMaxOver(param1:MouseEvent) : void
      {
         this._maxBtn.scaleX = 1.1;
         this._maxBtn.x -= 3;
         this._maxBtn.scaleY = 1.1;
         if(!TweenMax.isTweening(this._maxBtn))
         {
            TweenMax.to(this._maxBtn,0.5,{
               "repeat":-1,
               "yoyo":true,
               "glowFilter":{
                  "color":16777011,
                  "alpha":1,
                  "blurX":4,
                  "blurY":4,
                  "strength":3
               }
            });
         }
      }
      
      protected function onPackUpClick(param1:MouseEvent) : void
      {
         this.packUpEffect();
         MaxBtnStateManager.getInstance().packUp();
      }
      
      private function packUpEffect() : void
      {
         var _loc1_:int = 0;
         this.packUp();
         _loc1_ = 3;
         if(_cells != null)
         {
            while(_loc1_ < _cells.length)
            {
               _cells[_loc1_].visible = false;
               _cells[_loc1_].mouseEnabled = false;
               _loc1_++;
            }
         }
         if(Boolean(this._maxBtn))
         {
            this._cellSprite.addChild(this._maxBtn);
            this._maxBtn.addEventListener("click",this.onMaxClick);
         }
         DisplayUtils.setFrame(_background,3);
         StageReferance.stage.focus = null;
      }
      
      private function packUp() : void
      {
         this.isPackUp = true;
         if(this._packUpBtn != null)
         {
            this._packUpBtn.parent && removeChild(this._packUpBtn);
            this._packUpBtn.mouseEnabled = false;
         }
         if(this._dropDownBtn != null)
         {
            addChild(this._dropDownBtn);
            this._dropDownBtn.mouseEnabled = true;
         }
      }
      
      protected function onDropDownClick(param1:MouseEvent) : void
      {
         this.dropDownEffect();
         MaxBtnStateManager.getInstance().dropDown();
      }
      
      private function dropDownEffect() : void
      {
         var _loc1_:int = 0;
         this.dropDown();
         _loc1_ = 3;
         if(_cells != null)
         {
            while(_loc1_ < _cells.length)
            {
               _cells[_loc1_].visible = true;
               _cells[_loc1_].mouseEnabled = true;
               _loc1_++;
            }
         }
         if(Boolean(this._maxBtn) && Boolean(this._maxBtn.parent))
         {
            this._maxBtn.parent.removeChild(this._maxBtn);
         }
         if(Boolean(this._maxBtn))
         {
            this._maxBtn.removeEventListener("click",this.onMaxClick);
         }
         DisplayUtils.setFrame(_background,2);
         StageReferance.stage.focus = null;
      }
      
      private function dropDown() : void
      {
         this.isPackUp = false;
         if(this._dropDownBtn != null)
         {
            this._dropDownBtn.parent && removeChild(this._dropDownBtn);
            this._dropDownBtn.mouseEnabled = false;
         }
         if(this._packUpBtn != null)
         {
            addChild(this._packUpBtn);
            this._packUpBtn.mouseEnabled = true;
         }
      }
      
      override protected function updatePropByEnergy() : void
      {
         var _loc1_:PropCell = null;
         var _loc2_:PropInfo = null;
         for each(_loc1_ in _cells)
         {
            if(Boolean(_loc1_.info))
            {
               _loc2_ = _loc1_.info;
               if(Boolean(_loc2_))
               {
                  if(_self.energy < _loc2_.needEnergy)
                  {
                     _loc1_.enabled = false;
                     this.clearArrowByProp(_loc2_,false,true);
                  }
                  else if(!_self.twoKillEnabled && (_loc1_.info.TemplateID == EquipType.ADD_TWO_ATTACK || _loc1_.info.TemplateID == EquipType.ADD_ONE_ATTACK || _loc1_.info.TemplateID == EquipType.THREEKILL))
                  {
                     _loc1_.enabled = false;
                  }
                  else if(_loc1_.info.TemplateID == EquipType.THREEKILL)
                  {
                     _loc1_.enabled = _self.threeKillEnabled;
                  }
                  else
                  {
                     _loc1_.enabled = true;
                  }
               }
            }
         }
         this.checkMaxFilter();
      }
      
      private function checkMaxFilter() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(Boolean(this._maxBtn))
         {
            this._maxBtn.mouseEnabled = false;
            _loc1_ = this._greyFilter;
            _loc2_ = 3;
            while(_loc2_ < _cells.length)
            {
               if(_cells[_loc2_].enabled)
               {
                  _loc1_ = [];
                  this._maxBtn.mouseEnabled = true;
                  break;
               }
               _loc2_++;
            }
            this.bmp.filters = _loc1_;
         }
      }
      
      private function clearArrowByProp(param1:PropInfo, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         switch(param1.TemplateID)
         {
            case 10002:
               this.clearArr(ArrowType.TIP_ONE,param2);
               break;
            case 10003:
               this.clearArr(ArrowType.TIP_THREE,param2);
               if(!param3)
               {
                  this.clearArr(ArrowType.TIP_POWER,param2);
               }
               break;
            case 10008:
               this.clearArr(ArrowType.TIP_TEN_PERCENT,param2);
         }
      }
      
      private function clearArr(param1:int, param2:Boolean) : void
      {
         if(NewHandContainer.Instance.hasArrow(param1))
         {
            NewHandContainer.Instance.clearArrowByID(param1);
            if(param2)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.view.propContainer.ItemContainer.energy"));
            }
         }
      }
      
      override protected function __itemClicked(param1:MouseEvent) : void
      {
         var _loc2_:PropCell = null;
         var _loc3_:String = null;
         if(!this._localVisible)
         {
            return;
         }
         if(_enabled)
         {
            if(_self.isUsedPetSkillWithNoItem)
            {
               return;
            }
            _self.isUsedItem = true;
            _loc2_ = param1.currentTarget as PropCell;
            if(!_loc2_.enabled)
            {
               return;
            }
            SoundManager.instance.play("008");
            _loc3_ = _self.useProp(_loc2_.info,1);
            if(_loc3_ != UsePropErrorCode.Done && _loc3_ != UsePropErrorCode.None)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.game.prop." + _loc3_));
            }
            else if(_loc3_ == UsePropErrorCode.Done)
            {
               this.clearArrowByProp(_loc2_.info);
            }
            super.__itemClicked(param1);
            StageReferance.stage.focus = null;
         }
      }
      
      override protected function addEvent() : void
      {
         _self.addEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.addEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.addEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.addEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.addEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.addEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.addEvent();
      }
      
      private function __setEnable(param1:Event) : void
      {
         var _loc2_:PropCell = null;
         for each(_loc2_ in _cells)
         {
            if(_loc2_.info.TemplateID == EquipType.ADD_TWO_ATTACK)
            {
               _loc2_.enabled = false;
            }
            if(_loc2_.info.TemplateID == EquipType.THREEKILL)
            {
               _loc2_.enabled = false;
            }
            if(_loc2_.info.TemplateID == EquipType.ADD_ONE_ATTACK)
            {
               _loc2_.enabled = false;
            }
         }
      }
      
      protected function __transparentChanged(param1:Event) : void
      {
         if(this._tweenComplete && Boolean(parent))
         {
            if(SharedManager.Instance.propTransparent)
            {
               alpha = 0.5;
            }
            else
            {
               alpha = 1;
            }
         }
      }
      
      private function __attackingChanged(param1:LivingEvent) : void
      {
         if(_self.isAttacking && parent == null && this._localVisible)
         {
            TweenLite.killTweensOf(this,true);
            this._container.addChild(this);
            if(_mode == FightPropMode.VERTICAL)
            {
               alpha = 0;
               x = _background.width;
               if(SharedManager.Instance.propTransparent)
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":0.5,
                     "onComplete":this.showComplete
                  });
               }
               else
               {
                  TweenLite.to(this,0.3,{
                     "x":0,
                     "alpha":1,
                     "onComplete":this.showComplete
                  });
               }
               this._tweenComplete = false;
            }
            else
            {
               if(SharedManager.Instance.propTransparent)
               {
                  alpha = 0.5;
               }
               else
               {
                  alpha = 1;
               }
               x = 0;
               TweenLite.to(this,0.3,{"x":0});
            }
         }
         else if(!_self.isAttacking)
         {
            if(PlayerManager.Instance.Self.Grade > 15)
            {
               if(Boolean(parent))
               {
                  this.hide();
               }
            }
         }
      }
      
      private function showComplete() : void
      {
         this._tweenComplete = true;
      }
      
      private function hide() : void
      {
         TweenLite.killTweensOf(this.cell);
         DragManager.__upDrag(null);
         InGameCursor.show();
         this._tweenComplete = false;
         TweenLite.to(this,0.3,{
            "alpha":0,
            "onComplete":this.hideComplete
         });
      }
      
      private function hideComplete() : void
      {
         this._tweenComplete = true;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function __shoot(param1:LivingEvent) : void
      {
         if(PlayerManager.Instance.Self.Grade > 15)
         {
            if(Boolean(parent))
            {
               TweenLite.killTweensOf(this,true);
               this.hide();
            }
         }
      }
      
      override protected function __enabledChanged(param1:LivingEvent) : void
      {
         this.enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __rightEnabledChanged(param1:LivingEvent) : void
      {
         this.enabled = _self.propEnabled && _self.rightPropEnabled;
      }
      
      private function __threeKillChanged(param1:LivingEvent) : void
      {
         var _loc2_:PropCell = null;
         for each(_loc2_ in _cells)
         {
            if(_loc2_.info.TemplateID == EquipType.THREEKILL)
            {
               _loc2_.enabled = _self.threeKillEnabled;
            }
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         if(_enabled != param1)
         {
            _enabled = param1;
            if(_enabled)
            {
               this._cellSprite.filters = null;
               this.updatePropByEnergy();
            }
            else
            {
               this._cellSprite.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
            }
            for each(_loc2_ in _cells)
            {
               if(_loc2_.info.TemplateID == 10003)
               {
                  _loc2_.enabled = _self.threeKillEnabled;
               }
               else
               {
                  _loc2_.enabled = _enabled;
               }
            }
         }
      }
      
      override protected function __keyDown(param1:KeyboardEvent) : void
      {
         if(!_enabled)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case KeyStroke.VK_1.getCode():
            case KeyStroke.VK_NUMPAD_1.getCode():
               _cells[0].useProp();
               break;
            case KeyStroke.VK_2.getCode():
            case KeyStroke.VK_NUMPAD_2.getCode():
               _cells[1].useProp();
               break;
            case KeyStroke.VK_3.getCode():
            case KeyStroke.VK_NUMPAD_3.getCode():
               _cells[2].useProp();
               break;
            case KeyStroke.VK_4.getCode():
               if(this.isPackUp)
               {
                  this.useMaxBtn();
               }
               else
               {
                  _cells[3].useProp();
               }
               break;
            case KeyStroke.VK_NUMPAD_4.getCode():
               _cells[3].useProp();
               break;
            case KeyStroke.VK_5.getCode():
            case KeyStroke.VK_NUMPAD_5.getCode():
               _cells[4].useProp();
               break;
            case KeyStroke.VK_6.getCode():
            case KeyStroke.VK_NUMPAD_6.getCode():
               _cells[5].useProp();
               break;
            case KeyStroke.VK_7.getCode():
            case KeyStroke.VK_NUMPAD_7.getCode():
               _cells[6].useProp();
               break;
            case KeyStroke.VK_8.getCode():
            case KeyStroke.VK_NUMPAD_8.getCode():
               _cells[7].useProp();
         }
      }
      
      protected function onMaxClick(param1:MouseEvent) : void
      {
         if(_enabled)
         {
            this.useMaxBtn();
         }
      }
      
      private function useMaxBtn() : void
      {
         var _loc1_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         _loc1_.addEventListener("energyChanged",this.onChange);
         this.sortPercentProps();
         this.check();
         this.updatePropByEnergy();
      }
      
      override protected function configUI() : void
      {
         _background = ComponentFactory.Instance.creatComponentByStylename("RightPropBack");
         addChild(_background);
         super.configUI();
      }
      
      override protected function drawCells() : void
      {
         var _loc1_:PropCell = null;
         var _loc2_:int = 0;
         this._cellSprite = new Sprite();
         addChild(this._cellSprite);
         while(_loc2_ < 8)
         {
            _loc1_ = new PropCell(String(_loc2_ + 1),_mode,true);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__itemClicked);
            _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.__DownItemHandler);
            this._cellSprite.addChild(_loc1_);
            addChild(_loc1_);
            _cells.push(_loc1_);
            _loc2_++;
         }
         this.drawLayer();
      }
      
      private function __DownItemHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_TEN_PERSENT) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THREE_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TWO_OPEN) && PlayerManager.Instance.Self.IsWeakGuildFinish(Step.THIRTY_OPEN) && this._tweenComplete == true)
         {
            this.cell = param1.currentTarget as PropCell;
            this._tempPlace = _cells.indexOf(this.cell) + 1;
            this._container.addEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
            TweenLite.to(this.cell,0.5,{"onComplete":this.OnCellComplete});
         }
      }
      
      private function OnCellComplete() : void
      {
         KeyboardManager.getInstance().isStopDispatching = true;
         this.cell.dragStart();
      }
      
      private function __UpItemHandler(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.cell);
         this._container.removeEventListener(MouseEvent.MOUSE_UP,this.__UpItemHandler);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._cellSprite))
         {
            ObjectUtils.disposeAllChildren(this._cellSprite);
            ObjectUtils.disposeObject(this._cellSprite);
            this._cellSprite = null;
         }
         if(Boolean(_background))
         {
            ObjectUtils.disposeObject(_background);
            _background = null;
         }
         if(this._maxBtn != null)
         {
            this._maxBtn.removeEventListener("mouseOut",this.onMaxOut);
            this._maxBtn.removeEventListener("mouseOver",this.onMaxOver);
            ObjectUtils.disposeObject(this._maxBtn);
            this._maxBtn = null;
         }
         if(this._dropDownBtn != null)
         {
            this._dropDownBtn.removeEventListener("click",this.onDropDownClick);
            ObjectUtils.disposeObject(this._dropDownBtn);
            this._dropDownBtn = null;
         }
         if(this._packUpBtn != null)
         {
            this._packUpBtn.removeEventListener("click",this.onPackUpClick);
            ObjectUtils.disposeObject(this._packUpBtn);
            this._packUpBtn = null;
         }
         super.dispose();
         this._rightPropBarBorder = null;
      }
      
      override protected function removeEvent() : void
      {
         var _loc1_:PropCell = null;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClicked);
         }
         _self.removeEventListener(LivingEvent.THREEKILL_CHANGED,this.__threeKillChanged);
         _self.removeEventListener(LivingEvent.RIGHTENABLED_CHANGED,this.__rightEnabledChanged);
         _self.removeEventListener(LivingEvent.SHOOT,this.__shoot);
         _self.removeEventListener(LivingEvent.ATTACKING_CHANGED,this.__attackingChanged);
         _self.removeEventListener(LocalPlayer.SET_ENABLE,this.__setEnable);
         SharedManager.Instance.removeEventListener(SharedEvent.TRANSPARENTCHANGED,this.__transparentChanged);
         super.removeEvent();
      }
      
      override protected function drawLayer() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._startPos = ComponentFactory.Instance.creatCustomObject("RightPropPos" + _mode);
         var _loc4_:int = int(_cells.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            if(_mode == FightPropMode.VERTICAL)
            {
               _loc2_ = this._startPos.x + 5;
               _loc3_ = this._startPos.y + 6 + _loc1_ * (36 + 3);
            }
            else
            {
               _loc2_ = this._startPos.x + 6 + _loc1_ * (36 + 3);
               _loc3_ = this._startPos.y + 5;
            }
            _cells[_loc1_].setPossiton(_loc2_,_loc3_);
            _cells[_loc1_].setMode(_mode);
            if(_inited)
            {
               TweenLite.to(_cells[_loc1_],0.05 * (_loc4_ - _loc1_),{
                  "x":_loc2_,
                  "y":_loc3_
               });
            }
            else
            {
               _cells[_loc1_].x = _loc2_;
               _cells[_loc1_].y = _loc3_;
            }
            _loc1_++;
         }
         DisplayUtils.setFrame(_background,_mode);
         PositionUtils.setPos(_background,this._startPos);
      }
      
      override public function enter() : void
      {
         super.enter();
      }
      
      public function get mode() : int
      {
         return _mode;
      }
      
      public function setPropVisible(param1:int, param2:Boolean) : void
      {
         var _loc3_:PropCell = null;
         if(param1 < _cells.length)
         {
            _cells[param1].setVisible(param2);
            if(param2)
            {
               if(!_cells[param1].parent)
               {
                  this._cellSprite.addChild(_cells[param1]);
               }
            }
            else if(Boolean(_cells[param1].parent))
            {
               _cells[param1].parent.removeChild(_cells[param1]);
            }
         }
         for each(_loc3_ in _cells)
         {
            if(_loc3_.localVisible)
            {
               this.setVisible(true);
               return;
            }
         }
         this.setVisible(false);
      }
      
      public function setVisible(param1:Boolean) : void
      {
         if(this._localVisible != param1)
         {
            this._localVisible = param1;
            if(this._localVisible)
            {
               if(_self.isAttacking && parent == null)
               {
                  this._container.addChild(this);
               }
            }
            else if(Boolean(parent))
            {
               parent.removeChild(this);
            }
         }
      }
      
      public function hidePropBar() : void
      {
         this.visible = false;
      }
      
      private function onChange(param1:LivingEvent) : void
      {
         this.check();
      }
      
      private function check() : void
      {
         var _loc1_:int = 0;
         var _loc2_:LocalPlayer = GameManager.Instance.Current.selfGamePlayer;
         _loc1_ = 0;
         while(_loc1_ < _percentPropsList.length)
         {
            if(_percentPropsList[_loc1_].info.needEnergy <= _loc2_.energy)
            {
               _percentPropsList[_loc1_].dispatchEvent(new MouseEvent("click"));
               return;
            }
            _loc1_++;
         }
         _loc2_.removeEventListener("energyChanged",this.onChange);
      }
      
      private function sortPercentProps() : void
      {
         var j:int;
         var sortPercent:* = function(param1:PropCell, param2:PropCell):Number
         {
            var _loc3_:int = param1.info.TemplateID;
            var _loc4_:int = param2.info.TemplateID;
            if(_loc3_ < _loc4_)
            {
               return -1;
            }
            if(_loc3_ == _loc4_)
            {
               return 0;
            }
            return 1;
         };
         _percentPropsList.length = 0;
         j = 0;
         while(j < _cells.length)
         {
            switch(int(_cells[j].info.TemplateID) - 10004)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
                  _percentPropsList.push(_cells[j]);
            }
            j++;
         }
         _percentPropsList.sort(sortPercent);
      }
   }
}

