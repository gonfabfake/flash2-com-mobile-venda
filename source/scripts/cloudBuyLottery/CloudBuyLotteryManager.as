package cloudBuyLottery
{
   import cloudBuyLottery.data.CloudBuyAnalyzer;
   import cloudBuyLottery.loader.LoaderUIModule;
   import cloudBuyLottery.model.CloudBuyLotteryModel;
   import cloudBuyLottery.model.CloudBuyLotteryPackageType;
   import cloudBuyLottery.view.CloudBuyLotteryFrame;
   import cloudBuyLottery.view.ExpBar;
   import cloudBuyLottery.view.WinningLogItemInfo;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class CloudBuyLotteryManager extends Sprite
   {
      
      private static var _instance:CloudBuyLotteryManager;
      
      public static const UPDATE_INFO:String = "updateInfo";
      
      public static const INDIVIDUAL:String = "Individual";
      
      public static const FRAMEUPDATE:String = "frmeupdate";
      
      private var _model:CloudBuyLotteryModel;
      
      private var cloudBuyFrame:CloudBuyLotteryFrame;
      
      public var logArr:Array;
      
      public function CloudBuyLotteryManager(param1:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : CloudBuyLotteryManager
      {
         if(CloudBuyLotteryManager._instance == null)
         {
            CloudBuyLotteryManager._instance = new CloudBuyLotteryManager(new PrivateClass());
         }
         return CloudBuyLotteryManager._instance;
      }
      
      public function setup() : void
      {
         this._model = new CloudBuyLotteryModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CLOUDBUY,this.__cloudBuyLotteryHandle);
      }
      
      private function __cloudBuyLotteryHandle(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case CloudBuyLotteryPackageType.OPEN_GAME:
               this.activityOpen(_loc2_);
               break;
            case CloudBuyLotteryPackageType.Enter_GAME:
               this.enterGame(_loc2_);
               break;
            case CloudBuyLotteryPackageType.BUY_GOODS:
               this.buyGoods(_loc2_);
               break;
            case CloudBuyLotteryPackageType.UPDATE_INFO:
               this.updateInfo(_loc2_);
               break;
            case CloudBuyLotteryPackageType.GET_REWARD:
               this.getReward(_loc2_);
         }
      }
      
      private function activityOpen(param1:PackageIn) : void
      {
         this._model.isOpen = param1.readBoolean();
         this.initIcon(this._model.isOpen);
         if(!this._model.isOpen)
         {
            return;
         }
         this._loadXml("BuyItemRewardLogList.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
      }
      
      private function enterGame(param1:PackageIn) : void
      {
         this._model.templateId = param1.readInt();
         this._model.templatedIdCount = param1.readInt();
         this._model.validDate = param1.readInt();
         this._model.property = param1.readUTF().split(",");
         this._model.count = param1.readInt();
         if(this._model.count <= 0)
         {
            return;
         }
         this._model.buyGoodsIDArray = new Array();
         this._model.buyGoodsCountArray = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this._model.count)
         {
            this._model.buyGoodsIDArray[_loc2_] = param1.readInt();
            this._model.buyGoodsCountArray[_loc2_] = param1.readInt();
            _loc2_++;
         }
         this._model.buyMoney = param1.readInt();
         this._model.maxNum = param1.readInt();
         this._model.currentNum = param1.readInt();
         this._model.luckTime = param1.readDate();
         this._model.luckCount = param1.readInt();
         this._model.remainTimes = param1.readInt();
         this._model.isGame = param1.readBoolean();
         LoaderUIModule.Instance.loadUIModule(this.initOpenFrame,null,UIModuleTypes.CLOUDBUY);
      }
      
      private function buyGoods(param1:PackageIn) : void
      {
      }
      
      private function updateInfo(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         this._model.templatedIdCount = param1.readInt();
         this._model.validDate = param1.readInt();
         this._model.property = param1.readUTF().split(",");
         this._model.maxNum = param1.readInt();
         this._model.currentNum = param1.readInt();
         this._model.luckTime = param1.readDate();
         this._model.luckCount = param1.readInt();
         this._model.remainTimes = param1.readInt();
         this._model.isGame = param1.readBoolean();
         if(this._model.templateId != _loc2_ || this._model.isGame == false)
         {
            this._loadXml("BuyItemRewardLogList.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
         }
         this._model.templateId = _loc2_;
         dispatchEvent(new Event(UPDATE_INFO));
      }
      
      private function getReward(param1:PackageIn) : void
      {
         this._model.isGetReward = param1.readBoolean();
         if(this._model.isGetReward)
         {
            this._model.remainTimes = param1.readInt();
            this._model.luckDrawId = param1.readInt();
         }
         dispatchEvent(new Event(INDIVIDUAL));
         dispatchEvent(new Event(FRAMEUPDATE));
      }
      
      public function loaderCloudBuyFrame() : void
      {
         if(this._model.isOpen)
         {
            SocketManager.Instance.out.sendEnterGame();
         }
      }
      
      private function initOpenFrame() : void
      {
         this.cloudBuyFrame = ComponentFactory.Instance.creatComponentByStylename("cloudBuyFrame");
         LayerManager.Instance.addToLayer(this.cloudBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      public function initIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CLOUDBUYLOTTERY,param1);
         if(this.cloudBuyFrame != null && param1 == false)
         {
            if(Boolean(this.cloudBuyFrame))
            {
               ObjectUtils.disposeObject(this.cloudBuyFrame);
            }
            this.cloudBuyFrame = null;
         }
      }
      
      public function returnTen(param1:String) : int
      {
         if(param1.length > 1)
         {
            return int(param1.charAt(0)) + 1;
         }
         return 1;
      }
      
      public function returnABit(param1:String) : int
      {
         if(param1.length <= 1)
         {
            return int(param1.charAt(0)) + 1;
         }
         return int(param1.charAt(1)) + 1;
      }
      
      public function refreshTimePlayTxt() : String
      {
         var _loc1_:Number = this._model.luckTime.getTime();
         var _loc2_:Number = TimeManager.Instance.Now().getTime();
         var _loc3_:Number = _loc1_ - _loc2_;
         _loc3_ = _loc3_ < 0 ? Number(0) : Number(_loc3_);
         var _loc4_:int = 0;
         var _loc5_:String = "";
         var _loc6_:int = _loc3_ / (1000 * 60 * 60);
         var _loc7_:int = (_loc3_ - _loc6_ * 1000 * 60 * 60) / (1000 * 60);
         var _loc8_:int = (_loc3_ - _loc6_ * 1000 * 60 * 60 - _loc7_ * 1000 * 60) / 1000;
         return _loc6_ + ":" + _loc7_ + ":" + _loc8_;
      }
      
      private function _loadXml(param1:String, param2:int, param3:String = "") : void
      {
         var _loc4_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(param1),param2);
         _loc4_.loadErrorMessage = param3;
         _loc4_.analyzer = new CloudBuyAnalyzer(this.logComplete);
         LoadResourceManager.Instance.startLoad(_loc4_);
      }
      
      private function logComplete(param1:DataAnalyzer) : void
      {
         var _loc2_:WinningLogItemInfo = null;
         if(param1 is CloudBuyAnalyzer)
         {
            this.logArr = CloudBuyAnalyzer(param1).dataArr;
         }
         if(this.logArr == null || this.logArr.length <= 0)
         {
            return;
         }
         var _loc3_:Vector.<WinningLogItemInfo> = new Vector.<WinningLogItemInfo>();
         var _loc4_:int = 0;
         while(_loc4_ < this.logArr.length)
         {
            _loc2_ = new WinningLogItemInfo();
            _loc2_.TemplateID = int(this.logArr[_loc4_].templateId);
            _loc2_.validate = int(this.logArr[_loc4_].validate);
            _loc2_.count = int(this.logArr[_loc4_].count);
            _loc2_.property = this.logArr[_loc4_].property.split(",");
            _loc2_.nickName = this.logArr[_loc4_].nickName;
            _loc3_.push(_loc2_);
            _loc4_++;
         }
         this._model.myGiftData = _loc3_;
      }
      
      public function get model() : CloudBuyLotteryModel
      {
         return this._model;
      }
      
      public function get expBar() : ExpBar
      {
         return this.cloudBuyFrame.expBar;
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
