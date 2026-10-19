package newYearRice
{
   import cloudBuyLottery.loader.LoaderUIModule;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import newYearRice.data.NewYearRicePackageType;
   import newYearRice.model.NewYearRiceModel;
   import newYearRice.view.NewYearRiceMainView;
   import newYearRice.view.NewYearRiceOpenFrameView;
   import road7th.comm.PackageIn;
   
   public class NewYearRiceManager extends EventDispatcher
   {
      
      private static var _instance:NewYearRiceManager;
      
      public static const UPDATEVIEW:String = "updateView";
      
      private var _model:NewYearRiceModel;
      
      private var _main:NewYearRiceMainView;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      public function NewYearRiceManager(param1:PrivateClass)
      {
         super();
      }
      
      public static function get instance() : NewYearRiceManager
      {
         if(NewYearRiceManager._instance == null)
         {
            NewYearRiceManager._instance = new NewYearRiceManager(new PrivateClass());
         }
         return NewYearRiceManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new NewYearRiceModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEW_YEAR_RICE,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         var _loc4_:CrazyTankSocketEvent = null;
         switch(_loc3_)
         {
            case NewYearRicePackageType.NEWYEARRICE_OPENORCLOSE:
               this.openOrclose(_loc2_);
               break;
            case NewYearRicePackageType.NEWYEARRICE_INFO:
               this.openNewYearRiceView(_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODCOOK:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODCOOK,_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODENTER:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODENTER,_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODINVITE:
               this.yearFoodRoomInvitePlayer(_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODEXITROOM:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.EXITYEARFOODROOM,_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODROOMINVITE:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODROOMINVITE,_loc2_);
               break;
            case NewYearRicePackageType.YEARFOODCREATEFOOD:
               _loc4_ = new CrazyTankSocketEvent(CrazyTankSocketEvent.YEARFOODCREATEFOOD,_loc2_);
         }
         if(Boolean(_loc4_))
         {
            dispatchEvent(_loc4_);
         }
      }
      
      private function openOrclose(param1:PackageIn = null) : void
      {
         this._model.isOpen = param1.readBoolean();
         this.showEnterIcon(this._model.isOpen);
      }
      
      private function yearFoodRoomInvitePlayer(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         this._model.roomType = param1.readInt();
         this._model.playersLength = param1.readInt();
         if(this._model.playersLength > 0)
         {
            this._model.playersArray = [];
            _loc2_ = 0;
            while(_loc2_ < this._model.playersLength)
            {
               _loc3_ = new Object();
               _loc3_.ID = param1.readInt();
               _loc3_.Style = param1.readUTF();
               _loc3_.NikeName = param1.readUTF();
               _loc3_.Sex = param1.readBoolean();
               this._model.playersArray[_loc2_] = _loc3_;
               _loc2_++;
            }
            if(NewYearRiceManager.instance.model.openFrameView != null)
            {
               dispatchEvent(new Event(UPDATEVIEW));
            }
            else
            {
               StateManager.setState(StateType.MAIN);
               LoaderUIModule.Instance.loadUIModule(this.addOpenFrameView,null,UIModuleTypes.NEWYEARRICE);
            }
         }
      }
      
      private function addOpenFrameView() : void
      {
         if(Boolean(this._openFrameView))
         {
            ObjectUtils.disposeObject(this._openFrameView);
            this._openFrameView = null;
         }
         this._openFrameView = ComponentFactory.Instance.creatComponentByStylename("NewYearRiceMainView.NewYearRiceOpenView");
         this._openFrameView.setViewFrame(this._model.roomType);
         this._openFrameView.updatePlayerItem(this._model.playersArray);
         this._openFrameView.setBtnEnter();
         LayerManager.Instance.addToLayer(this._openFrameView,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function openNewYearRiceView(param1:PackageIn) : void
      {
         this._model.yearFoodInfo = param1.readInt();
         LoaderUIModule.Instance.loadUIModule(this.initOpenFrame,null,UIModuleTypes.NEWYEARRICE);
      }
      
      public function onClickNewYearRiceIcon(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(StateManager.currentStateType == StateType.MAIN)
         {
            SocketManager.Instance.out.sendCheckNewYearRiceInfo();
         }
         LoaderUIModule.Instance.loadUIModule(this.initOpenFrame,null,UIModuleTypes.NEWYEARRICE);
      }
      
      private function initOpenFrame() : void
      {
         this._main = ComponentFactory.Instance.creatComponentByStylename("NewYearRice.MainView");
         LayerManager.Instance.addToLayer(this._main,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function showEnterIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.NEWYEARRICE,param1);
         if(this._main != null && param1 == false)
         {
            if(Boolean(this._main))
            {
               ObjectUtils.disposeObject(this._main);
            }
            this._main = null;
         }
      }
      
      public function returnComponent(param1:Bitmap, param2:String) : Component
      {
         var _loc3_:Component = null;
         _loc3_ = null;
         _loc3_ = new Component();
         _loc3_.tipData = param2;
         _loc3_.tipDirctions = "0,1,2";
         _loc3_.tipStyle = "ddt.view.tips.OneLineTip";
         _loc3_.tipGapH = 20;
         _loc3_.width = param1.width;
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         param1.x = 0;
         param1.y = 0;
         _loc3_.addChild(param1);
         return _loc3_;
      }
      
      public function get model() : NewYearRiceModel
      {
         return this._model;
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this._model.itemInfoList = param1;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
