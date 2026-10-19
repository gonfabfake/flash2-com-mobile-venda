package farm.view.compose
{
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.view.compose.item.ComposeItem;
   import farm.view.compose.item.ComposeMoveScroll;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import petsBag.PetsBagManager;
   import shop.view.ShopItemCell;
   
   public class FarmComposePnl extends Sprite implements Disposeable
   {
      
      private var _selectComposeBtn:BaseButton;
      
      private var _composeActionBtn:SimpleBitmapButton;
      
      private var _itemComposeVec:Vector.<ComposeItem>;
      
      private var _composeScroll:ComposeMoveScroll;
      
      private var _bg1:DisplayObject;
      
      private var _bg2:DisplayObject;
      
      private var _maxCount:int = -1;
      
      private var _foodID:int;
      
      private var _selectComposeBtnShine:IEffect;
      
      private var _result:ShopItemCell;
      
      private var _configmPnl:ConfirmComposeAlertFrame;
      
      private var _confirmComposeFoodAlertFrame:ConfirmComposeFoodAlertFrame;
      
      public function FarmComposePnl()
      {
         super();
         this._itemComposeVec = new Vector.<ComposeItem>();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc4_:Point = null;
         var _loc6_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         this._bg1 = ComponentFactory.Instance.creat("asset.farmHouse.composebg1");
         addChild(this._bg1);
         this._bg2 = ComponentFactory.Instance.creat("farm.farmHouse.composebg2");
         addChild(this._bg2);
         this._composeScroll = new ComposeMoveScroll();
         addChild(this._composeScroll);
         _loc4_ = PositionUtils.creatPoint("farm.composeMoveScroll.point");
         this._composeScroll.x = _loc4_.x;
         this._composeScroll.y = _loc4_.y;
         this._selectComposeBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnSelectHouseCompose");
         addChild(this._selectComposeBtn);
         this._composeActionBtn = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnComposeAction");
         addChild(this._composeActionBtn);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = ComponentFactory.Instance.creat("asset.farm.baseImage5");
            _loc3_ = ComponentFactory.Instance.creat("farmHouse.composeItem",[_loc2_]);
            PositionUtils.setPos(_loc3_,"farm.houseCompose.point" + _loc1_);
            this._itemComposeVec.push(_loc3_);
            addChild(_loc3_);
            _loc1_++;
         }
         var _loc5_:Sprite = new Sprite();
         _loc5_.graphics.beginFill(16777215,0);
         _loc5_.graphics.drawRect(0,0,50,50);
         _loc5_.graphics.endFill();
         this._result = new ShopItemCell(_loc5_);
         this._result.cellSize = 50;
         PositionUtils.setPos(this._result,"farm.composePnl.cellPos");
         this._selectComposeBtn.addChild(this._result);
         this._selectComposeBtn.mouseChildren = true;
         _loc6_ = {};
         _loc6_["color"] = "gold";
         this._selectComposeBtnShine = EffectManager.Instance.creatEffect(3,this._selectComposeBtn,_loc6_);
         this._selectComposeBtnShine.play();
         this.upComposeBtn();
      }
      
      private function upComposeBtn() : void
      {
         this._composeActionBtn.enable = this._maxCount > 0;
         this.playSelectComposeBtnShine();
      }
      
      private function setCellInfo(param1:int, param2:ItemTemplateInfo, param3:int = 1) : void
      {
         if(param1 < 0 || param1 > 4)
         {
            return;
         }
         this._itemComposeVec[param1].info = param2;
         this._itemComposeVec[param1].useCount = param3;
         if(this._maxCount == -1)
         {
            this._maxCount = this._itemComposeVec[param1].maxCount;
         }
         else
         {
            this._maxCount = this._maxCount > this._itemComposeVec[param1].maxCount ? this._itemComposeVec[param1].maxCount : int(this._maxCount);
         }
      }
      
      private function initEvent() : void
      {
         this._composeActionBtn.addEventListener("click",this.__showComfigCompose);
         this._selectComposeBtn.addEventListener("click",this.__showConfirmComposeFoodAlertFrame);
         this._selectComposeBtn.addEventListener("rollOver",this.__onMouseRollover);
         this._selectComposeBtn.addEventListener("rollOut",this.__onMouseRollout);
         this._selectComposeBtn.addEventListener("mouseDown",this.__onMouseDown);
         PlayerManager.Instance.Self.getBag(14).addEventListener("update",this.__bagUpdate);
      }
      
      protected function __bagUpdate(param1:Event) : void
      {
         this.update();
      }
      
      private function __showComfigCompose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._itemComposeVec[0].info != null)
         {
            this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeAlert.confirmCompose");
            this._configmPnl.maxCount = this._maxCount;
            LayerManager.Instance.addToLayer(this._configmPnl,3,true,1);
            this._configmPnl.addEventListener("compose_count",this.__configmCount);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.componse.selected.me"));
         }
      }
      
      private function __showConfirmComposeFoodAlertFrame(param1:MouseEvent) : void
      {
         this.stopSelectComposeBtnShine();
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._confirmComposeFoodAlertFrame = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeAlert.confirmComposeFoodAlertFrame");
         this._confirmComposeFoodAlertFrame.addEventListener("selectFood",this.__selectFood);
         this._confirmComposeFoodAlertFrame.addEventListener("response",this.__confirmComposeFoodAlertFrameResponse);
         LayerManager.Instance.addToLayer(this._confirmComposeFoodAlertFrame,3,true,1);
      }
      
      private function closeConfirmComposeFoodAlertFrame() : void
      {
         if(Boolean(this._confirmComposeFoodAlertFrame))
         {
            this._confirmComposeFoodAlertFrame.removeEventListener("selectFood",this.__selectFood);
            this._confirmComposeFoodAlertFrame.dispose();
            this._confirmComposeFoodAlertFrame = null;
         }
      }
      
      private function __confirmComposeFoodAlertFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.closeConfirmComposeFoodAlertFrame();
         }
         this.playSelectComposeBtnShine();
      }
      
      private function __selectFood(param1:SelectComposeItemEvent) : void
      {
         this.stopSelectComposeBtnShine();
         SoundManager.instance.play("008");
         this._result.info = param1.data as ItemTemplateInfo;
         this._foodID = this._result.info.TemplateID;
         if(this._selectComposeBtn.backgound is MovieClip)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         this._maxCount = -1;
         this.update();
         if(PetsBagManager.instance.haveTaskOrderByID(370))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(110);
         }
         this.closeConfirmComposeFoodAlertFrame();
      }
      
      private function __configmCount(param1:SelectComposeItemEvent) : void
      {
         this._configmPnl.removeEventListener("compose_count",this.__configmCount);
         var _loc2_:int = int(param1.data);
         if(Boolean(this._foodID) && Boolean(int(_loc2_)))
         {
            if(PetsBagManager.instance.haveTaskOrderByID(370))
            {
               PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(112);
               PetsBagManager.instance.petModel.IsFinishTask5 = true;
            }
            SocketManager.Instance.out.sendCompose(this._foodID,_loc2_);
         }
      }
      
      public function clearInfo() : void
      {
         var _loc1_:int = 0;
         this._result.info = null;
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this.setCellInfo(_loc1_,null,0);
            _loc1_++;
         }
         if(this._selectComposeBtn.backgound is MovieClip)
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(1);
         }
         this.upComposeBtn();
      }
      
      private function stopSelectComposeBtnShine() : void
      {
         if(Boolean(this._selectComposeBtn) && Boolean(this._selectComposeBtn.backgound is MovieClip) && Boolean(this._result.info))
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         if(!this._result.info && !this._confirmComposeFoodAlertFrame)
         {
            this._selectComposeBtnShine.stop();
         }
      }
      
      private function playSelectComposeBtnShine() : void
      {
         if(Boolean(this._selectComposeBtn) && Boolean(this._selectComposeBtn.backgound is MovieClip) && Boolean(this._result.info))
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
         if(!this._result.info && !this._confirmComposeFoodAlertFrame)
         {
            this._selectComposeBtnShine.play();
         }
      }
      
      private function __onMouseDown(param1:MouseEvent) : void
      {
         if(Boolean(this._selectComposeBtn) && Boolean(this._selectComposeBtn.backgound is MovieClip) && Boolean(this._result.info))
         {
            (this._selectComposeBtn.backgound as MovieClip).gotoAndStop(4);
         }
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         this.stopSelectComposeBtnShine();
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         this.playSelectComposeBtnShine();
      }
      
      private function update() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         if(this._foodID != 0)
         {
            for each(_loc2_ in FarmComposeHouseController.instance().getComposeDetailByID(this._foodID))
            {
               this.setCellInfo(_loc1_++,ItemManager.Instance.getTemplateById(_loc2_.VegetableID),_loc2_.NeedCount);
            }
            this.upComposeBtn();
         }
      }
      
      private function removeEvent() : void
      {
         this._composeActionBtn.removeEventListener("click",this.__showComfigCompose);
         this._selectComposeBtn.removeEventListener("click",this.__showConfirmComposeFoodAlertFrame);
         this._selectComposeBtn.removeEventListener("rollOver",this.__onMouseRollover);
         this._selectComposeBtn.removeEventListener("rollOut",this.__onMouseRollout);
         this._selectComposeBtn.removeEventListener("mouseDown",this.__onMouseDown);
         PlayerManager.Instance.Self.getBag(14).removeEventListener("update",this.__bagUpdate);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         this.removeEvent();
         this._maxCount = -1;
         this.clearInfo();
         this._foodID = 0;
         for each(_loc1_ in this._itemComposeVec)
         {
            if(Boolean(_loc1_))
            {
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
         this._itemComposeVec.splice(0,this._itemComposeVec.length);
         if(Boolean(this._selectComposeBtn))
         {
            ObjectUtils.disposeObject(this._selectComposeBtn);
            this._selectComposeBtn = null;
         }
         if(Boolean(this._bg2))
         {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
         }
         if(Boolean(this._bg1))
         {
            ObjectUtils.disposeObject(this._bg1);
            this._bg1 = null;
         }
         if(Boolean(this._composeScroll))
         {
            ObjectUtils.disposeObject(this._composeScroll);
            this._composeScroll = null;
         }
         if(Boolean(this._composeActionBtn))
         {
            ObjectUtils.disposeObject(this._composeActionBtn);
            this._composeActionBtn = null;
         }
         if(Boolean(this._result))
         {
            ObjectUtils.disposeObject(this._result);
            this._result = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._selectComposeBtnShine))
         {
            EffectManager.Instance.removeEffect(this._selectComposeBtnShine);
            this._selectComposeBtnShine = null;
         }
      }
   }
}

