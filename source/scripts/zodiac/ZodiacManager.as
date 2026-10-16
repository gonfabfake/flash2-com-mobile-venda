package zodiac
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class ZodiacManager extends EventDispatcher
   {
      
      private static var _instance:ZodiacManager;
      
      public var questArr:Array;
      
      public var indexTypeArr:Dictionary;
      
      public var awardRecord:int;
      
      public var maxCounts:int;
      
      public var finshedCounts:int;
      
      public var isOpen:Boolean;
      
      private var newIndex:int;
      
      private var _frame:ZodiacFrame;
      
      public var index:int = 0;
      
      private var _loadComplete:Boolean;
      
      private var _useFirst:Boolean = true;
      
      public var inRolling:Boolean = false;
      
      private var _questCounts:int = 0;
      
      public function ZodiacManager(param1:InstanceClass, param2:IEventDispatcher = null)
      {
         super(param2);
         this.indexTypeArr = new Dictionary();
      }
      
      public static function get instance() : ZodiacManager
      {
         var _loc1_:InstanceClass = null;
         if(_instance == null)
         {
            _loc1_ = new InstanceClass();
            _instance = new ZodiacManager(_loc1_);
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ZODIAC,this.__zodiacHandler);
      }
      
      public function get questCounts() : int
      {
         this._questCounts = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.questArr.length)
         {
            if(this.questArr[_loc1_] != 0)
            {
               ++this._questCounts;
            }
            _loc1_++;
         }
         return this._questCounts;
      }
      
      private function __zodiacHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:int = _loc5_.readInt();
         switch(_loc6_)
         {
            case 1:
               this.isOpen = _loc5_.readBoolean();
               if(this.questArr == null)
               {
                  this.questArr = [];
               }
               _loc2_ = 0;
               while(_loc2_ < 12)
               {
                  this.questArr[_loc2_] = _loc5_.readInt();
                  _loc2_++;
               }
               this.awardRecord = _loc5_.readInt();
               this.maxCounts = _loc5_.readInt();
               this.finshedCounts = _loc5_.readInt();
               this.setIndexTypeDic(_loc5_);
               break;
            case 2:
               this.isOpen = _loc5_.readBoolean();
               if(this.questArr == null)
               {
                  this.questArr = [];
               }
               _loc3_ = 0;
               while(_loc3_ < 12)
               {
                  _loc4_ = _loc5_.readInt();
                  if(this.questArr[_loc3_] != _loc4_ && _loc4_ != 0)
                  {
                     this.newIndex = _loc3_ + 1;
                     this.questArr[_loc3_] = _loc4_;
                     if(Boolean(this._frame))
                     {
                        this._frame.rollingView.rolling(this.newIndex);
                     }
                     this.setCurrentIndexView(this.newIndex);
                  }
                  this.questArr[_loc3_] = _loc4_;
                  _loc3_++;
               }
               this.awardRecord = _loc5_.readInt();
               this.maxCounts = _loc5_.readInt();
               this.finshedCounts = _loc5_.readInt();
               this.setIndexTypeDic(_loc5_);
               this.updateMessage();
         }
         if(this.isOpen)
         {
            this.createIcon();
         }
         else
         {
            this.removeIcon();
         }
      }
      
      private function setIndexTypeDic(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = param1.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readInt();
            _loc3_ = param1.readInt();
            this.indexTypeArr[_loc2_] = _loc3_;
            _loc5_++;
         }
      }
      
      public function updateMessage() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.mainView.updateView();
            this._frame.rollingView.update();
         }
      }
      
      public function createIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ZODIAC,true);
      }
      
      public function removeIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.ZODIAC,false);
      }
      
      public function frameDispose() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.dispose();
            this._frame = null;
         }
      }
      
      public function setCurrentIndexView(param1:int) : void
      {
         if(this.inRolling == true)
         {
            return;
         }
         this.index = param1;
         if(Boolean(this._frame))
         {
            this._frame.mainView.setViewIndex(this.index);
         }
      }
      
      public function getCurrentIndex() : int
      {
         var _loc1_:int = 0;
         if(this.index == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.questArr.length)
            {
               if(this.questArr[_loc1_] != 0)
               {
                  this.index = _loc1_ + 1;
               }
               _loc1_++;
            }
         }
         return this.index;
      }
      
      public function showFrame() : void
      {
         if(this._loadComplete)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainFrame.ZodiacFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
         else if(this._useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ZODIAC);
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ZODIAC)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ZODIAC)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            this._loadComplete = true;
            this._useFirst = false;
            this.showFrame();
         }
      }
   }
}

class InstanceClass
{
   
   public function InstanceClass()
   {
      super();
   }
}
