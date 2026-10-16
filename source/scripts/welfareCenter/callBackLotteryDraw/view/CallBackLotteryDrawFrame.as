package welfareCenter.callBackLotteryDraw.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   import welfareCenter.callBackLotteryDraw.LotteryDrawModel;
   
   public class CallBackLotteryDrawFrame extends Sprite implements Disposeable
   {
      
      private var _callBackLotteryDrawInitSp:CallBackLotteryDrawInitSp;
      
      private var _callBackLotteryDrawSp:CallBackLotteryDrawSp;
      
      public function CallBackLotteryDrawFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:CallBackLotteryDrawManager = CallBackLotteryDrawManager.instance;
         var _loc2_:LotteryDrawModel = _loc1_.callBackLotteryDrawModel;
         if(_loc2_.phase == 0 && _loc1_.getCallBackLeftSec() > 0 || _loc2_.awardArr == null || _loc2_.awardArr.length == 0)
         {
            this._callBackLotteryDrawInitSp = new CallBackLotteryDrawInitSp();
            addChild(this._callBackLotteryDrawInitSp);
         }
         else
         {
            this._callBackLotteryDrawSp = new CallBackLotteryDrawSp();
            addChild(this._callBackLotteryDrawSp);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._callBackLotteryDrawInitSp = null;
         this._callBackLotteryDrawSp = null;
      }
   }
}

