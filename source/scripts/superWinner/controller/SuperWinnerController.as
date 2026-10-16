package superWinner.controller
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import road7th.comm.PackageIn;
   import superWinner.event.SuperWinnerEvent;
   import superWinner.model.SuperWinnerModel;
   import superWinner.view.SuperWinnerView;
   
   public class SuperWinnerController extends BaseStateView
   {
      
      private static var _instance:SuperWinnerController;
      
      private var _view:SuperWinnerView;
      
      private var _model:SuperWinnerModel;
      
      private var _pkg:PackageIn;
      
      public function SuperWinnerController()
      {
         super();
         this._model = new SuperWinnerModel();
      }
      
      public static function get instance() : SuperWinnerController
      {
         if(!_instance)
         {
            _instance = new SuperWinnerController();
         }
         return _instance;
      }
      
      public function get model() : SuperWinnerModel
      {
         return this._model;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this.init();
         this.initSocket();
      }
      
      private function initSocket() : void
      {
         this._model.setRoomInfo(this._pkg);
      }
      
      public function enterSuperWinnerRoom(param1:PackageIn) : void
      {
         this._pkg = param1;
      }
      
      public function timesUp(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readByte();
         switch(_loc2_)
         {
            case 0:
               this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.PROGRESS_TIMES_UP));
               break;
            case 1:
               this._model.formatMyAwards(param1);
               break;
            case 2:
               this._model.sendGetAwardsMsg(param1);
               this._model.formatAwards(param1);
               break;
            case 3:
               this._model.flushChampion(param1,true);
         }
      }
      
      public function returnDices(param1:PackageIn) : void
      {
         this._model.isCurrentDiceGetAward = param1.readBoolean();
         this._model.currentAwardLevel = param1.readByte();
         var _loc2_:Vector.<int> = new Vector.<int>(6,true);
         var _loc3_:int = 0;
         while(_loc3_ < 6)
         {
            _loc2_[_loc3_] = param1.readByte();
            _loc3_++;
         }
         this._model.currentDicePoints = _loc2_;
         this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.RETURN_DICES));
      }
      
      public function startRollDices() : void
      {
         this._model.dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.START_ROLL_DICES));
      }
      
      public function joinRoom(param1:PackageIn) : void
      {
         this._model.joinRoom(param1);
      }
      
      public function endGame() : void
      {
         if(Boolean(this._view))
         {
            this._view.endGame();
         }
      }
      
      private function init() : void
      {
         this._model = new SuperWinnerModel();
         this._view = new SuperWinnerView(this);
         addChild(this._view);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getType() : String
      {
         return StateType.SUPER_WINNER;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._view);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         super.leaving(param1);
      }
   }
}

