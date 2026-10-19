package rank
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.CoreManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.IEventDispatcher;
   import rank.analyzer.RankingListAwardAnalyzer;
   import rank.data.RankAwardInfo;
   import rank.data.RankInfo;
   import rank.model.RankModel;
   import rank.view.RankFrame;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftConditionInfo;
   
   public class RankManager extends CoreManager
   {
      
      private static var _instance:RankManager;
      
      private var _frame:RankFrame;
      
      public var model:RankModel;
      
      public var reweadDataList:Vector.<RankAwardInfo>;
      
      public var lastUpdateTime:String;
      
      public function RankManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : RankManager
      {
         if(!_instance)
         {
            _instance = new RankManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new RankModel();
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["rank"],this.onLoadedNew);
      }
      
      public function activityAwardComp(param1:RankingListAwardAnalyzer) : void
      {
         this.reweadDataList = param1.itemList;
         this.lastUpdateTime = param1.lastUpdateTime;
         this._frame = ComponentFactory.Instance.creatCustomObject("rank.RankFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("ddt.rankFrame.title");
         this._frame.initNew();
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      private function onLoadedNew() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("RankingListAwardList.xml?ran=" + Math.random()),5);
         _loc1_.loadErrorMessage = "RankingListAwardList";
         _loc1_.analyzer = new RankingListAwardAnalyzer(this.activityAwardComp);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      public function rankData(param1:Array, param2:int) : RankInfo
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:RankInfo = new RankInfo();
         _loc3_ = 0;
         loop0:
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_] as GiftBagInfo;
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ >= _loc4_.giftConditionArr.length)
               {
                  _loc3_++;
                  continue loop0;
               }
               _loc6_ = _loc4_.giftConditionArr[_loc5_] as GiftConditionInfo;
               if(_loc6_.conditionIndex == 0 && _loc6_.conditionValue == param2)
               {
                  break;
               }
               _loc5_++;
            }
            _loc7_.beginIndex = _loc6_.conditionValue;
            _loc7_.endIndex = _loc6_.remain1;
            _loc7_.giftRewardArr = _loc4_.giftRewardArr.slice();
            return _loc7_;
         }
         return _loc7_;
      }
      
      public function setCurrentInfo() : void
      {
         this._frame.setRightView();
      }
   }
}

