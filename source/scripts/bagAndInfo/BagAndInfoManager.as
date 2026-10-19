package bagAndInfo
{
   import bagAndInfo.bag.ring.data.RingDataAnalyzer;
   import bagAndInfo.bag.ring.data.RingSystemData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.bossbox.AwardsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   
   public class BagAndInfoManager extends EventDispatcher
   {
      
      private static var _instance:BagAndInfoManager;
      
      private var _bagAndGiftFrame:BagAndGiftFrame;
      
      private var _frame:BaseAlerFrame;
      
      private var _progress:int = 0;
      
      private var infos:Array;
      
      private var _type:int = 0;
      
      private var _bagtype:int = 0;
      
      public var isUpgradePack:Boolean;
      
      public var RingData:Dictionary;
      
      public function BagAndInfoManager(param1:SingletonForce)
      {
         super();
      }
      
      public static function get Instance() : BagAndInfoManager
      {
         if(_instance == null)
         {
            _instance = new BagAndInfoManager(new SingletonForce());
         }
         return _instance;
      }
      
      public function get isShown() : Boolean
      {
         if(!this._bagAndGiftFrame)
         {
            return false;
         }
         return true;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_OPENUP,this.__openPreviewListFrame);
      }
      
      protected function __openPreviewListFrame(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         _loc3_.position = 20;
         var _loc4_:String = _loc3_.readUTF();
         var _loc5_:int = int(_loc3_.readByte());
         this.infos = [];
         while(Boolean(_loc3_.bytesAvailable))
         {
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = _loc3_.readInt();
            _loc2_ = ItemManager.fill(_loc2_);
            _loc2_.Count = _loc3_.readInt();
            _loc2_.IsBinds = _loc3_.readBoolean();
            _loc2_.ValidDate = _loc3_.readInt();
            _loc2_.StrengthenLevel = _loc3_.readInt();
            _loc2_.AttackCompose = _loc3_.readInt();
            _loc2_.DefendCompose = _loc3_.readInt();
            _loc2_.AgilityCompose = _loc3_.readInt();
            _loc2_.LuckCompose = _loc3_.readInt();
            this.infos.push(_loc2_);
         }
         this.showPreviewFrame(_loc4_,this.infos);
      }
      
      private function explorerManualPrompt(param1:int, param2:String) : void
      {
         var _loc3_:String = LanguageMgr.GetTranslation("explorerManual.manualOpen.goodPrompt",param1,param2);
         MessageTipManager.getInstance().show(_loc3_,0,true);
      }
      
      public function showPreviewFrame(param1:String, param2:Array) : void
      {
         var _loc3_:AwardsView = null;
         var _loc4_:FilterFrameText = null;
         _loc3_ = null;
         _loc4_ = null;
         _loc3_ = new AwardsView();
         _loc3_.goodsList = param2;
         _loc3_.boxType = 4;
         _loc4_ = ComponentFactory.Instance.creat("bagandinfo.awardsFFT");
         if(this.isUpgradePack)
         {
            this.isUpgradePack = false;
            _loc4_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle2");
            _loc4_.x = 30;
         }
         else
         {
            _loc4_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
            _loc4_.x = 75;
         }
         this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame");
         var _loc5_:AlertInfo = new AlertInfo(param1);
         _loc5_.showCancel = false;
         _loc5_.moveEnable = false;
         this._frame.info = _loc5_;
         this._frame.addToContent(_loc3_);
         this._frame.addToContent(_loc4_);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SoundManager.instance.play("008");
               _loc2_ = param1.currentTarget as BaseAlerFrame;
               _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               _loc2_.dispose();
               SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      private function __createBag(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BAG)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createBag);
            this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
            this.showBagAndInfo(this._type,"",this._bagtype);
         }
      }
      
      public function showBagAndInfo(param1:int = 0, param2:String = "", param3:int = 0) : void
      {
         var type:int = param1;
         var name:String = param2;
         var bagtype:int = param3;
         this._type = type;
         this._bagtype = bagtype;
         if(this._bagAndGiftFrame == null)
         {
            try
            {
               this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
               this._bagAndGiftFrame.show(type,name,bagtype);
               dispatchEvent(new Event(Event.OPEN));
            }
            catch(e:Error)
            {
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.BAG);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createBag);
            }
         }
         else
         {
            this._bagAndGiftFrame.show(type,name,bagtype);
            dispatchEvent(new Event(Event.OPEN));
         }
      }
      
      public function hideBagAndInfo() : void
      {
         if(Boolean(this._bagAndGiftFrame))
         {
            this._bagAndGiftFrame.dispose();
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
         }
      }
      
      public function clearReference() : void
      {
         this._bagAndGiftFrame = null;
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function loadRingSystemInfo(param1:RingDataAnalyzer) : void
      {
         this.RingData = param1.data;
      }
      
      public function getCurrentRingData() : RingSystemData
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = PlayerManager.Instance.Self.RingExp;
         _loc2_ = 1;
         while(_loc2_ <= RingSystemData.TotalLevel)
         {
            if(_loc3_ <= 0)
            {
               _loc1_ = this.RingData[1];
               break;
            }
            if(_loc3_ < this.RingData[_loc2_].Exp)
            {
               _loc1_ = this.RingData[_loc2_ - 1];
               break;
            }
            if(_loc2_ == RingSystemData.TotalLevel && _loc3_ >= this.RingData[_loc2_].Exp)
            {
               _loc1_ = this.RingData[_loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getRingData(param1:int) : RingSystemData
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = param1;
         _loc3_ = 1;
         while(_loc3_ <= RingSystemData.TotalLevel)
         {
            if(_loc4_ <= 0)
            {
               _loc2_ = this.RingData[1];
               break;
            }
            if(_loc4_ < this.RingData[_loc3_].Exp)
            {
               _loc2_ = this.RingData[_loc3_ - 1];
               break;
            }
            if(_loc3_ == RingSystemData.TotalLevel && _loc4_ >= this.RingData[_loc3_].Exp)
            {
               _loc2_ = this.RingData[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

class SingletonForce
{
   
   public function SingletonForce()
   {
      super();
   }
}
