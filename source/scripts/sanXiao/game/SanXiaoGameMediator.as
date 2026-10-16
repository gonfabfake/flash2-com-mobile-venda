package sanXiao.game
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.ConfirmAlertData;
   import ddt.utils.HelperBuyAlert;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import sanXiao.SanXiaoController;
   import sanXiao.SanXiaoManager;
   import sanXiao.model.Pos;
   import sanXiao.model.SXCellData;
   import sanXiao.model.SXModel;
   
   public class SanXiaoGameMediator extends EventDispatcher
   {
      
      private static var instance:SanXiaoGameMediator;
      
      private var _game:SXGame;
      
      private var _model:SXModel;
      
      private var _manager:SanXiaoManager;
      
      private var _boomListList:Array;
      
      private var _fallListList:Array;
      
      private var _nameStrings:Array;
      
      private var _timeUpdateList:Dictionary;
      
      private var _moneyData:ConfirmAlertData;
      
      public function SanXiaoGameMediator(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : SanXiaoGameMediator
      {
         if(!instance)
         {
            instance = new SanXiaoGameMediator(new inner());
         }
         return instance;
      }
      
      public function getGameView() : SXGame
      {
         if(!this._model)
         {
            this._model = new SXModel();
         }
         if(!this._manager)
         {
            this._manager = SanXiaoManager.getInstance();
         }
         this._moneyData || (this._moneyData = new ConfirmAlertData());
         this._nameStrings = ["",LanguageMgr.GetTranslation("sanxiao.propName.crossBomb"),LanguageMgr.GetTranslation("sanxiao.propName.squareBomb"),LanguageMgr.GetTranslation("sanxiao.propName.clearColor"),LanguageMgr.GetTranslation("sanxiao.propName.changeColor")];
         this._model.initMap();
         this._timeUpdateList = new Dictionary();
         this._game = new SXGame();
         return this._game;
      }
      
      public function killGame() : void
      {
         this._game.removeEventListener("enterFrame",this.onEF);
         ObjectUtils.disposeObject(this._game);
         this._timeUpdateList = null;
         this._game = null;
         this._model = null;
         this._nameStrings.length = 0;
         this._nameStrings = null;
      }
      
      public function startGame() : void
      {
         var _loc2_:* = undefined;
         if(this._model == null || this._game == null)
         {
            return;
         }
         this.startAnimation();
         var _loc1_:Array = SanXiaoManager.getInstance().mapInfo;
         if(_loc1_ == null || _loc1_.length == 0)
         {
            this._model.createNewMap();
            GameInSocketOut.sendSXCreateMap(this._model.mapInfo());
         }
         else
         {
            this._model.setMap(_loc1_);
         }
         for(_loc2_ in this._timeUpdateList)
         {
            delete this._timeUpdateList[_loc2_];
         }
         this._boomListList = [];
         this._fallListList = [];
         !this._game.hasEventListener("enterFrame") && this._game.addEventListener("enterFrame",this.onEF);
         this._game.resetGame();
      }
      
      protected function onEF(param1:Event) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._timeUpdateList)
         {
            _loc2_ && _loc2_();
         }
      }
      
      public function createNewMap() : void
      {
         this._model.createNewMap();
         GameInSocketOut.sendSXCreateMap(this._model.mapInfo());
         this._game.resetGame();
      }
      
      public function startAnimation() : void
      {
         SanXiaoController.getInstance().lockFrame();
      }
      
      public function stopAnimation() : void
      {
         SanXiaoController.getInstance().unLockFrame();
      }
      
      public function addTween(param1:DisplayObject, param2:Function) : void
      {
         this._timeUpdateList[param1] = param2;
      }
      
      public function removeTween(param1:DisplayObject) : void
      {
         delete this._timeUpdateList[param1];
      }
      
      public function get stepRemain() : Number
      {
         var _loc1_:Number = SanXiaoManager.getInstance().stepRemain;
         if(_loc1_ <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("sanxiao.stepNoRemaining"));
         }
         return _loc1_;
      }
      
      public function set curProp(param1:int) : void
      {
         this._model && (this._model.curProp = param1);
      }
      
      public function checkProp(param1:Pos) : void
      {
         var __curProp:int;
         var __score:String;
         var $curPos:Pos = null;
         var __name:String = null;
         var msg:String = null;
         $curPos = param1;
         var onUsePropConfirm:* = function(param1:BaseAlerFrame):void
         {
            _moneyData.notShowAlertAgain = param1["isNoPrompt"];
         };
         var onUsePropCheckOut:* = function():void
         {
            _moneyData.isBind = CheckMoneyUtils.instance.isBind;
            _game.checkProp($curPos);
         };
         var onUsePropCancel:* = function():void
         {
            _moneyData.notShowAlertAgain = false;
         };
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         __curProp = this._model.curProp;
         __score = SanXiaoManager.getInstance().getPropScore(__curProp);
         __name = this._nameStrings[__curProp];
         this._moneyData.moneyNeeded = int(SanXiaoManager.getInstance().getPropCurPrice(__curProp));
         switch(this._moneyData.notShowAlertAgain)
         {
            case true:
               CheckMoneyUtils.instance.checkMoney(this._moneyData.isBind,this._moneyData.moneyNeeded,onUsePropCheckOut,onUsePropCancel);
               break;
            case false:
               msg = LanguageMgr.GetTranslation("sanxiao.buyPropConfirm",this._moneyData.moneyNeeded,__name);
               HelperBuyAlert.getInstance().alert(msg,this._moneyData,"SimpleAlertWithNotShowAgain",onUsePropCheckOut,onUsePropConfirm,onUsePropCancel,1);
         }
      }
      
      public function sendUseCrossBomb() : void
      {
         GameInSocketOut.sendSXPropCrossBomb(this._moneyData.isBind,this._moneyData.moneyNeeded);
      }
      
      public function sendUseSquareBomb() : void
      {
         GameInSocketOut.sendSXPropSquareBomb(this._moneyData.isBind,this._moneyData.moneyNeeded);
      }
      
      public function sendUseClearColor() : void
      {
         GameInSocketOut.sendSXPropClearColor(this._moneyData.isBind,this._moneyData.moneyNeeded);
      }
      
      public function sendUseChangeColor(param1:int, param2:int) : void
      {
         GameInSocketOut.sendSXPropChangeColor(this._moneyData.isBind,this._moneyData.moneyNeeded,param1,param2);
      }
      
      public function sendBoomList(param1:SXCellItem, param2:SXCellItem, param3:Vector.<SXCellData>) : void
      {
         var _loc8_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         var _loc6_:Dictionary = new Dictionary();
         _loc4_ = 1;
         while(_loc4_ <= this._model.typeCount)
         {
            _loc6_[_loc4_] = [];
            _loc4_++;
         }
         var _loc7_:int = int(param3.length);
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            (_loc6_[param3[_loc4_].type] as Array).push(param3[_loc4_].row,param3[_loc4_].column);
            _loc4_++;
         }
         for each(_loc8_ in _loc6_)
         {
            if(_loc8_.length > 0)
            {
               _loc5_.push(_loc8_);
            }
         }
         if(param1 == null || param2 == null)
         {
            this._boomListList.push(-1,-1,-1,-1,_loc5_);
         }
         else
         {
            this._boomListList.push(param1.curPos.row,param1.curPos.column,param2.curPos.row,param2.curPos.column,_loc5_);
         }
         param1 = null;
         param2 = null;
         _loc5_ = null;
         _loc6_ = null;
      }
      
      public function sendFillList(param1:Vector.<SXCellData>) : void
      {
         this._fallListList.push(param1);
      }
      
      public function sendHitsEnd() : void
      {
         while(this._boomListList.length > 0)
         {
            GameInSocketOut.sendSXBoom(this._boomListList.shift(),this._boomListList.shift(),this._boomListList.shift(),this._boomListList.shift(),this._boomListList.shift());
            GameInSocketOut.sendSXFillCellList(this._fallListList.shift());
         }
         this._boomListList.length = 0;
         this._fallListList.length = 0;
         GameInSocketOut.sendSXHitsEnd();
      }
      
      public function buyTimes(param1:int, param2:Boolean) : void
      {
         GameInSocketOut.sendSXBuyOneTimes(param1,param2);
      }
      
      public function get model() : SXModel
      {
         return this._model;
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
