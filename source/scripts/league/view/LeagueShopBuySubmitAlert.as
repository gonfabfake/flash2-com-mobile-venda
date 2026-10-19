package league.view
{
   import ddt.command.QuickBuyAlertBase;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class LeagueShopBuySubmitAlert extends QuickBuyAlertBase
   {
      
      private var _buyNum:int;
      
      private var _goodsId:int;
      
      public function LeagueShopBuySubmitAlert()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         _sprite.mouseEnabled = _sprite.mouseChildren = _sprite.visible = false;
         _totalTipText.text = LanguageMgr.GetTranslation("leagueShopView.todayBuyText");
         totalText.x = 258;
         totalText.y = 77;
         _submitButton.y = 141;
      }
      
      override protected function refreshNumText() : void
      {
         var _loc1_:String = String(_number.number * _perPrice);
         totalText.text = _loc1_ + "\n\n" + this._buyNum;
      }
      
      override public function setData(param1:int, param2:int, param3:int) : void
      {
         this._goodsId = param2;
         super.setData(param1,this._goodsId,param3);
      }
      
      public function setBuyNum(param1:int) : void
      {
         this._buyNum = param1;
         this.refreshNumText();
         _number.maximum = this._buyNum;
      }
      
      override protected function __buy(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _number.number)
         {
            _loc3_.push(this._goodsId);
            _loc4_.push(1);
            _loc5_.push("");
            _loc6_.push("");
            _loc7_.push("");
            _loc8_.push(1);
            _loc9_.push("");
            _loc2_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc9_,0,_loc8_);
         dispose();
      }
   }
}

