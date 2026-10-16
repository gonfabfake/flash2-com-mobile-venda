package league.view
{
   import battleGroud.BattleGroudControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.BattleGroudManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import league.LeagueControl;
   
   public class LeagueShopFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _moneyCountTxt:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _foreBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _shopCellList:Vector.<LeagueShopCell>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _goodsInfoList:Vector.<ShopItemInfo>;
      
      public function LeagueShopFrame()
      {
         var _loc1_:* = null;
         super();
         this._goodsInfoList = ShopManager.Instance.getValidGoodByType(93);
         var _loc2_:int = int(this._goodsInfoList.length);
         this._totlePage = Math.ceil(_loc2_ / 4);
         this._currentPage = 1;
         if(Boolean(BattleGroudControl.Instance.orderdata))
         {
            if(PlayerManager.Instance.Self.Grade < 20)
            {
               LeagueControl.instance.militaryRank = 0;
            }
            else
            {
               _loc1_ = BattleGroudManager.Instance.getBattleDataByPrestige(BattleGroudControl.Instance.orderdata.totalPrestige);
               LeagueControl.instance.militaryRank = _loc1_.Level;
            }
         }
         if(PlayerManager.Instance.Self.Grade < 20)
         {
            LeagueControl.instance.militaryRank = 0;
         }
         else
         {
            LeagueControl.instance.militaryRank = 0;
         }
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         titleText = LanguageMgr.GetTranslation("tank.menu.MatchesTxt");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.leagueShopFrame.bg");
         this._moneyCountTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.moneyCountTxt");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.pageTxt");
         this._foreBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.foreBtn");
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopFrame.nextBtn");
         addToContent(this._bg);
         addToContent(this._moneyCountTxt);
         addToContent(this._pageTxt);
         addToContent(this._foreBtn);
         addToContent(this._nextBtn);
         this._shopCellList = new Vector.<LeagueShopCell>(4);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new LeagueShopCell();
            _loc2_.x = 14 + _loc1_ % 2 * (_loc2_.width + 3);
            _loc2_.y = 263 + int(_loc1_ / 2) * (_loc2_.height + 2);
            addToContent(_loc2_);
            this._shopCellList[_loc1_] = _loc2_;
            _loc1_++;
         }
         this._shopCellList[1].x = 244;
         this._shopCellList[2].y = 350;
         this._shopCellList[3].x = 244;
         this._shopCellList[3].y = 350;
         this.refreshView();
         this.refreshMoneyTxt();
      }
      
      private function refreshView() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         var _loc3_:int = (this._currentPage - 1) * 4;
         var _loc4_:int = int(this._goodsInfoList.length);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = _loc3_ + _loc1_;
            if(_loc2_ >= _loc4_)
            {
               this._shopCellList[_loc1_].visible = false;
            }
            else
            {
               this._shopCellList[_loc1_].visible = true;
               this._shopCellList[_loc1_].refreshShow(this._goodsInfoList[_loc2_]);
            }
            _loc1_++;
         }
      }
      
      private function refreshMoneyTxt() : void
      {
         this._moneyCountTxt.text = PlayerManager.Instance.Self.leagueMoney.toString();
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._foreBtn.addEventListener("click",this.changePageHandler,false,0,true);
         this._nextBtn.addEventListener("click",this.changePageHandler,false,0,true);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.propertyChangeHandler);
         ShopManager.Instance.addEventListener("updatePersonalLimitShop",this.__onUpdatePersonLimitShop);
      }
      
      private function __onUpdatePersonLimitShop(param1:CEvent) : void
      {
         if(Boolean(param1) && int(param1.data) == 93)
         {
            this.refreshView();
         }
      }
      
      private function propertyChangeHandler(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["leagueMoney"]))
         {
            this.refreshMoneyTxt();
         }
      }
      
      private function changePageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SimpleBitmapButton = param1.currentTarget as SimpleBitmapButton;
         switch(_loc2_)
         {
            case this._foreBtn:
               if(this._currentPage <= 1)
               {
                  this._currentPage = this._totlePage;
               }
               else
               {
                  --this._currentPage;
               }
               break;
            case this._nextBtn:
               if(this._currentPage >= this._totlePage)
               {
                  this._currentPage = 1;
               }
               else
               {
                  ++this._currentPage;
               }
         }
         this.refreshView();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._foreBtn.removeEventListener("click",this.changePageHandler);
         this._nextBtn.removeEventListener("click",this.changePageHandler);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.propertyChangeHandler);
         ShopManager.Instance.removeEventListener("updatePersonalLimitShop",this.__onUpdatePersonLimitShop);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._moneyCountTxt = null;
         this._pageTxt = null;
         this._foreBtn = null;
         this._nextBtn = null;
         this._shopCellList = null;
         this._goodsInfoList = null;
         LeagueControl.instance.militaryRank = -1;
      }
   }
}

