package lotteryTicket
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import hallIcon.HallIconManager;
   import lotteryTicket.data.LotteryTicketInfo;
   import lotteryTicket.model.LotteryModel;
   import lotteryTicket.view.LotteryMainView;
   import road7th.comm.PackageIn;
   
   public class LotteryManager extends CoreManager
   {
      
      private static var _instance:LotteryManager;
      
      public var model:LotteryModel;
      
      public var isClick:Boolean = false;
      
      private var _main:LotteryMainView;
      
      public function LotteryManager()
      {
         super();
      }
      
      public static function get instance() : LotteryManager
      {
         if(!_instance)
         {
            _instance = new LotteryManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new LotteryModel();
         SocketManager.Instance.addEventListener("lotteryTicket",this.lotteryHandler);
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.itemInfoList = param1;
      }
      
      private function lotteryHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:PackageIn = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc6_ = param1.pkg;
         var _loc7_:int = _loc6_.readInt();
         switch(_loc7_)
         {
            case 0:
               this.model.isopen = _loc6_.readBoolean();
               this.model.isCanBuyBall = _loc6_.readBoolean();
               this.model.gameIndex = _loc6_.readInt();
               this.model.dataList = [];
               _loc2_ = 0;
               while(_loc2_ < 8)
               {
                  _loc3_ = _loc6_.readUTF();
                  if(_loc3_ != "")
                  {
                     _loc4_ = new LotteryTicketInfo();
                     _loc4_.ifBuy = true;
                     _loc4_.ticketArr = [_loc3_.substr(0,1),_loc3_.substr(1,1),_loc3_.substr(2,1),_loc3_.substr(3,1)];
                     this.model.dataList.push(_loc4_);
                  }
                  _loc2_++;
               }
               if(Boolean(this._main))
               {
                  this._main.initData();
               }
               else
               {
                  this.updataEnterIcon();
               }
               break;
            case 1:
               this.model.poolCount = _loc6_.readInt();
               this.model.displayResults = _loc6_.readUTF();
               this.model.firstCount = _loc6_.readInt();
               this.model.firstMoney = _loc6_.readInt();
               _loc5_ = _loc6_.readUTF();
               if(_loc5_.length > 0)
               {
                  this.model.firstPlayerInfo = _loc5_.split("|");
               }
               else
               {
                  this.model.firstPlayerInfo = [];
               }
               this.model.secondCount = _loc6_.readInt();
               this.model.secondMoney = _loc6_.readInt();
               this.model.thirdCount = _loc6_.readInt();
               this.model.thirdMoney = _loc6_.readInt();
               this.model.fourthCount = _loc6_.readInt();
               this.model.fourthMoney = _loc6_.readInt();
               if(Boolean(this._main))
               {
                  this.closeFrame();
                  break;
               }
               if(this.isClick)
               {
                  show();
               }
         }
      }
      
      public function closeFrame() : void
      {
         ObjectUtils.disposeObject(this._main);
         this._main = null;
      }
      
      public function loadResource() : void
      {
         if(StateManager.currentStateType == "main")
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            UIModuleLoader.Instance.addUIModuleImp("lotteryTicket");
         }
      }
      
      private function createFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == "lotteryTicket")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            SocketManager.Instance.out.getLotteryPrizeInfo();
         }
      }
      
      override protected function onLoaded() : void
      {
         this._main = ComponentFactory.Instance.creatComponentByStylename("lottery.mainframe");
         LayerManager.Instance.addToLayer(this._main,3,true,2);
      }
      
      public function updataEnterIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler("lotteryTicket",this.model.isopen);
         }
      }
   }
}

