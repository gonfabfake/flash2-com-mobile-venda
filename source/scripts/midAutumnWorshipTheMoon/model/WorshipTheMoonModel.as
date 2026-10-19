package midAutumnWorshipTheMoon.model
{
   import midAutumnWorshipTheMoon.view.WorshipTheMoonMainFrame;
   
   public class WorshipTheMoonModel
   {
      
      private static var instance:WorshipTheMoonModel;
      
      private var _view:WorshipTheMoonMainFrame;
      
      private var _isopen:Boolean = false;
      
      private var _timesRemain:int = -1;
      
      private var _usedTimes:int = -1;
      
      private var _on200timesGainID:int;
      
      private var _currentMoonType:int;
      
      private var _awardsBoxInfoList:Vector.<WorshipTheMoonAwardsBoxInfo>;
      
      private var _itemsCanGainsIDList:Vector.<int>;
      
      private var _pricePerWorship:int;
      
      private var _isOnceBtnShowBuyTipThisLogin:Boolean = true;
      
      private var _isOnceBtnUseBindMoney:Boolean = false;
      
      private var _isTensBtnShowBuyTipThisLogin:Boolean = true;
      
      private var _isTensBtnUseBindMoney:Boolean = false;
      
      private var _timesGoingToWorship:int = 0;
      
      private var _state200AwardsBoxIcon:int;
      
      public function WorshipTheMoonModel(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : WorshipTheMoonModel
      {
         if(!instance)
         {
            instance = new WorshipTheMoonModel(new inner());
         }
         return instance;
      }
      
      public function init(param1:WorshipTheMoonMainFrame) : void
      {
         this._view = param1;
      }
      
      public function dispose() : void
      {
         this._view = null;
      }
      
      public function getIsActivityOpen() : Boolean
      {
         return this._isopen;
      }
      
      public function onceBtnShowTipsAgain() : void
      {
         this._isOnceBtnShowBuyTipThisLogin = true;
      }
      
      public function tensBtnShowTipsAgain() : void
      {
         this._isTensBtnShowBuyTipThisLogin = true;
      }
      
      public function onceBtnNotShowBuyTipsAgainThisLogin(param1:Boolean) : void
      {
         this._isOnceBtnShowBuyTipThisLogin = false;
         this._isOnceBtnUseBindMoney = param1;
      }
      
      public function tensBtnNotShowBuyTipsAgainThisLogin(param1:Boolean) : void
      {
         this._isTensBtnShowBuyTipThisLogin = false;
         this._isTensBtnUseBindMoney = param1;
      }
      
      public function getPricePerWorship() : int
      {
         return this._pricePerWorship;
      }
      
      public function getIsOnceBtnShowBuyTipThisLogin() : Boolean
      {
         return this._isOnceBtnShowBuyTipThisLogin;
      }
      
      public function getIsTensBtnShowBuyTipThisLogin() : Boolean
      {
         return this._isTensBtnShowBuyTipThisLogin;
      }
      
      public function updateIsOnceBtnUseBindMoney(param1:Boolean) : void
      {
         this._isOnceBtnUseBindMoney = param1;
      }
      
      public function updateIsTensBtnUseBindMoney(param1:Boolean) : void
      {
         this._isTensBtnUseBindMoney = param1;
      }
      
      public function getIsOnceBtnUseBindMoney() : Boolean
      {
         return this._isOnceBtnUseBindMoney;
      }
      
      public function getIsTensBtnUseBindMoney() : Boolean
      {
         return this._isTensBtnUseBindMoney;
      }
      
      public function getNeedMoneyTimes(param1:int) : int
      {
         return Math.max(0,param1 - this._timesRemain);
      }
      
      public function getNeedMoney(param1:int) : int
      {
         return this._pricePerWorship * this.getNeedMoneyTimes(param1);
      }
      
      public function getTimesRemain() : int
      {
         return this._timesRemain;
      }
      
      public function getUsedTimes() : int
      {
         return this._usedTimes;
      }
      
      public function getAwardsGainedBoxInfoList() : Vector.<WorshipTheMoonAwardsBoxInfo>
      {
         return this._awardsBoxInfoList;
      }
      
      public function getItemsCanGainsIDList() : Vector.<int>
      {
         return this._itemsCanGainsIDList;
      }
      
      public function getCurrentMoonType() : int
      {
         return this._currentMoonType;
      }
      
      public function get200TimesGainsID() : int
      {
         return this._on200timesGainID;
      }
      
      public function updateIsOpen(param1:Boolean) : void
      {
         this._isopen = param1;
      }
      
      public function updatePrice(param1:int) : void
      {
         this._pricePerWorship = param1;
      }
      
      public function update200TimesGain(param1:int) : void
      {
         this._on200timesGainID = param1;
         this._view.update200TimesGains();
      }
      
      public function updateFreeCounts(param1:int) : void
      {
         this._timesRemain = param1;
         this._view.updateTimesRemains();
      }
      
      public function updateWorshipedCounts(param1:int) : void
      {
         this._usedTimes = param1;
         this._view.updateUsedTimes();
      }
      
      public function update200State(param1:int) : void
      {
         if((param1 + 1) * 200 - this._usedTimes > 0)
         {
            this._state200AwardsBoxIcon = 1;
         }
         else
         {
            this._state200AwardsBoxIcon = 2;
         }
         this._view.update200TimesGains();
      }
      
      public function canGain200AwardsBox() : int
      {
         return this._state200AwardsBoxIcon;
      }
      
      public function updateAwardsBoxInfoList(param1:Vector.<WorshipTheMoonAwardsBoxInfo>) : void
      {
         this._awardsBoxInfoList = param1;
         if(this._awardsBoxInfoList.length == 1)
         {
            this._currentMoonType = this._awardsBoxInfoList[0].moonType;
            this._view.playOnceAnimation();
         }
         else
         {
            this._view.playTenTimesAnimation();
         }
      }
      
      public function updateItemsCanGainsIDList(param1:Vector.<int>) : void
      {
         this._itemsCanGainsIDList = param1;
         this._view.updateAwardItemsCanGainList();
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
