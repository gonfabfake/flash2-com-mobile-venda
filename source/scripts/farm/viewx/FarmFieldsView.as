package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Sprite;
   import petsBag.PetsBagManager;
   
   public class FarmFieldsView extends Sprite implements Disposeable
   {
      
      private var _fields:Vector.<FarmFieldBlock>;
      
      private var _configmPnl:ConfirmKillCropAlertFrame;
      
      public function FarmFieldsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener("fieldsInfoReady",this.__fieldInfoReady);
         FarmModelController.instance.addEventListener("hasSeeding",this.__hasSeeding);
         FarmModelController.instance.addEventListener("frushField",this.__frushField);
         FarmModelController.instance.addEventListener("gainField",this.__gainField);
         FarmModelController.instance.addEventListener("accelerateField",this.__accelerateField);
         FarmModelController.instance.addEventListener("helperSwitchField",this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener("helperkeyfield",this.__helperKeyHandler);
         FarmModelController.instance.addEventListener("killCropField",this.__onKillcropField);
         FarmModelController.instance.addEventListener("beginHelper",this.__setFields);
         FarmModelController.instance.addEventListener("stopHelper",this.__frushField);
      }
      
      private function remvoeEvent() : void
      {
         FarmModelController.instance.removeEventListener("fieldsInfoReady",this.__fieldInfoReady);
         FarmModelController.instance.removeEventListener("hasSeeding",this.__hasSeeding);
         FarmModelController.instance.removeEventListener("frushField",this.__frushField);
         FarmModelController.instance.removeEventListener("gainField",this.__gainField);
         FarmModelController.instance.removeEventListener("accelerateField",this.__accelerateField);
         FarmModelController.instance.removeEventListener("helperSwitchField",this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener("helperkeyfield",this.__helperKeyHandler);
         FarmModelController.instance.removeEventListener("killCropField",this.__onKillcropField);
         FarmModelController.instance.removeEventListener("beginHelper",this.__setFields);
         FarmModelController.instance.removeEventListener("stopHelper",this.__frushField);
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._fields = new Vector.<FarmFieldBlock>(16);
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = new FarmFieldBlock(_loc1_);
            PositionUtils.setPos(_loc2_,"farm.fieldsView.fieldPos" + _loc1_);
            _loc2_.addEventListener("killcropshow",this.__showComfigKillCrop);
            addChild(_loc2_);
            this._fields[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.__fieldInfoReady(null);
      }
      
      private function __setFields(param1:FarmEvent) : void
      {
         this.setFieldByHelper();
      }
      
      public function setFieldByHelper() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.ID != FarmModelController.instance.model.currentFarmerId)
         {
            return;
         }
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            return;
         }
         var _loc3_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         _loc1_ = 0;
         while(_loc1_ < FarmModelController.instance.model.fieldsInfo.length)
         {
            _loc2_ = (new Date().getTime() - _loc3_[_loc1_].payTime.getTime()) / 3600000;
            if(_loc3_[_loc1_].fieldValidDate > _loc2_ || _loc3_[_loc1_].fieldValidDate == -1)
            {
               this._fields[_loc1_].setBeginHelper(FarmModelController.instance.model.helperArray[1]);
            }
            _loc1_++;
         }
      }
      
      protected function __fieldInfoReady(param1:FarmEvent) : void
      {
         this.upFields();
         this.upFlagPlace();
         this.setFieldByHelper();
      }
      
      private function __hasSeeding(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.seedingFieldInfo.fieldID)
            {
               this._fields[_loc2_].info = FarmModelController.instance.model.seedingFieldInfo;
               if(PetsBagManager.instance.haveTaskOrderByID(369))
               {
                  PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(103);
               }
               break;
            }
            _loc2_++;
         }
         this.autoHelperHandler(FarmModelController.instance.model.seedingFieldInfo);
      }
      
      private function __frushField(param1:FarmEvent) : void
      {
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.upFields();
            this.upFlagPlace();
            this.setFieldByHelper();
         }
      }
      
      private function __gainField(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.gainFieldId);
         _loc2_ = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.gainFieldId)
            {
               this._fields[_loc2_].info = _loc3_;
               this.upFlagPlace();
               break;
            }
            _loc2_++;
         }
         if(_loc3_.isAutomatic)
         {
            this.autoHelperHandler(_loc3_);
         }
      }
      
      private function __accelerateField(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.matureId);
         _loc2_ = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.matureId)
            {
               this._fields[_loc2_].info = _loc3_;
               break;
            }
            _loc2_++;
         }
         this.autoHelperHandler(_loc3_);
      }
      
      private function __helperSwitchHandler(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.isAutoId)
            {
               this._fields[_loc2_].info = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
               return;
            }
            _loc2_++;
         }
      }
      
      private function __helperKeyHandler(param1:FarmEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = FarmModelController.instance.model.batchFieldIDArray;
         for each(_loc3_ in _loc2_)
         {
            this._fields[_loc3_].info = FarmModelController.instance.model.getfieldInfoById(_loc3_);
         }
      }
      
      private function __onKillcropField(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.killCropId);
         _loc2_ = 0;
         while(_loc2_ < 16)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.killCropId)
            {
               this._fields[_loc2_].info = _loc3_;
               return;
            }
            _loc2_++;
         }
      }
      
      private function upFields() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
         var _loc5_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = _loc5_[_loc1_].fieldID;
            if(Boolean(this._fields[_loc2_]))
            {
               this._fields[_loc2_].info = _loc5_[_loc1_];
               this.autoHelperHandler(this._fields[_loc2_].info);
               _loc4_.splice(_loc4_.indexOf(_loc2_),1);
            }
            _loc1_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            this._fields[_loc4_[_loc3_]].info = null;
            _loc3_++;
         }
      }
      
      private function upFlagPlace() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [8,9,10,11,12,13,14,15];
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            _loc1_ = FarmModelController.instance.model.fieldsInfo;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].fieldID >= 8 && (Boolean(_loc1_[_loc2_].isDig) || Boolean(_loc1_[_loc2_].seedID != 0)))
               {
                  _loc5_.splice(_loc5_.indexOf(_loc1_[_loc2_].fieldID),1);
                  this._fields[_loc1_[_loc2_].fieldID].flag = false;
               }
               _loc2_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               if(_loc3_ == 0)
               {
                  this._fields[_loc5_[_loc3_]].flag = true;
               }
               else
               {
                  this._fields[_loc5_[_loc3_]].flag = false;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_.length)
            {
               this._fields[_loc5_[_loc4_]].flag = false;
               _loc4_++;
            }
         }
      }
      
      private function __showComfigKillCrop(param1:SelectComposeItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:FieldVO = param1.data as FieldVO;
         this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmKillCropAlertFrame");
         this._configmPnl.cropName(ItemManager.Instance.getTemplateById(_loc2_.seedID).Name,_loc2_.isAutomatic);
         this._configmPnl.fieldId = _loc2_.fieldID;
         this._configmPnl.addEventListener("killcropClick",this.__killCropClick);
         LayerManager.Instance.addToLayer(this._configmPnl,3,true,1);
      }
      
      private function __killCropClick(param1:SelectComposeItemEvent) : void
      {
         var _loc2_:int = param1.data as int;
         if(_loc2_ != -1)
         {
            FarmModelController.instance.killCrop(_loc2_);
         }
         if(Boolean(this._configmPnl))
         {
            this._configmPnl.removeEventListener("killcropClick",this.__killCropClick);
         }
         this.dispatchEvent(new SelectComposeItemEvent("killcropIcon"));
      }
      
      public function autoHelperHandler(param1:FieldVO) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         if(Boolean(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID) && Boolean(param1) && param1.isAutomatic)
         {
            if(param1.seedID == 0 && param1.isDig && param1.autoSeedID != 0)
            {
               _loc2_ = FarmModelController.instance.model.findItemInfo(32,param1.autoSeedID);
               if(Boolean(_loc2_))
               {
                  if(_loc2_.CategoryID == 32 && _loc2_.Count > 0)
                  {
                     if(_loc2_.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(param1.seedID != 0 && param1.autoFertilizerID != 0 && param1.AccelerateTime == 0)
            {
               _loc3_ = 1;
               _loc4_ = FarmModelController.instance.model.findItemInfo(33,param1.autoFertilizerID);
               if(Boolean(_loc4_))
               {
                  if(_loc4_.CategoryID == 33 && _loc4_.Count > 0)
                  {
                     FarmModelController.instance.accelerateField(_loc3_,param1.fieldID,param1.autoFertilizerID);
                     if(_loc4_.Count == 1)
                     {
                        return;
                     }
                  }
               }
            }
            if(param1.plantGrownPhase == 2)
            {
               FarmModelController.instance.getHarvest(param1.fieldID);
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            if(Boolean(this._fields[_loc1_]))
            {
               this._fields[_loc1_].removeEventListener("killcropshow",this.__showComfigKillCrop);
               ObjectUtils.disposeObject(this._fields[_loc1_]);
               this._fields[_loc1_] = null;
            }
            _loc1_++;
         }
         this.remvoeEvent();
         this._fields = null;
         if(Boolean(this._configmPnl))
         {
            ObjectUtils.disposeObject(this._configmPnl);
         }
         this._configmPnl = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get fields() : Vector.<FarmFieldBlock>
      {
         return this._fields;
      }
   }
}

