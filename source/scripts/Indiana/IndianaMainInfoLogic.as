package Indiana
{
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.item.IndianaResoultLose;
   import Indiana.item.IndianaResoultSuccess;
   import Indiana.model.IndianaModel;
   import Indiana.model.IndianaShowData;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class IndianaMainInfoLogic extends Sprite implements Disposeable
   {
      
      private var _infoView:IndianaInfoPanel;
      
      private var _discloseView:IndiananDiscloseCountDownPanel;
      
      private var _currentView:*;
      
      private var _info:IndianaShopItemInfo;
      
      private var _itemInfo:IndianaGoodsItemInfo;
      
      private var _showData:IndianaShowData;
      
      private var _loseView:IndianaResoultLose;
      
      private var _successView:IndianaResoultSuccess;
      
      public function IndianaMainInfoLogic()
      {
         super();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         IndianaDataManager.instance.addEventListener("turn_to_announced",this.__turntoannouncedHandler);
      }
      
      private function __turntoannouncedHandler(param1:Event) : void
      {
         this.updataState();
         this._currentView.setInfo(this._info);
      }
      
      private function removeEvent() : void
      {
         IndianaDataManager.instance.removeEventListener("turn_to_announced",this.__turntoannouncedHandler);
      }
      
      private function updataState() : void
      {
         this._showData = IndianaDataManager.instance.currentShowData;
         if(this._showData.state == IndianaModel.INDIANA_SHOWING)
         {
            if(this._showData.luckCode == 0)
            {
               if(Boolean(this._currentView) && this._currentView != this._loseView)
               {
                  this._currentView.visible = false;
                  if(this._currentView is IndiananDiscloseCountDownPanel)
                  {
                     this._currentView.stopTime();
                  }
               }
               if(this._loseView == null)
               {
                  this._loseView = new IndianaResoultLose();
                  addChild(this._loseView);
               }
               this._loseView.visible = true;
               this._currentView = this._loseView;
            }
            else
            {
               if(Boolean(this._currentView) && this._currentView != this._successView)
               {
                  this._currentView.visible = false;
                  if(this._currentView is IndiananDiscloseCountDownPanel)
                  {
                     this._currentView.stopTime();
                  }
               }
               if(this._successView == null)
               {
                  this._successView = new IndianaResoultSuccess();
                  addChild(this._successView);
               }
               this._successView.visible = true;
               this._currentView = this._successView;
            }
         }
         if(this._showData.state == IndianaModel.INDIANA_COUNTDOWN)
         {
            if(Boolean(this._currentView) && !(this._currentView is IndiananDiscloseCountDownPanel))
            {
               this._currentView.visible = false;
            }
            if(this._discloseView == null)
            {
               this._discloseView = new IndiananDiscloseCountDownPanel();
               addChild(this._discloseView);
            }
            this._discloseView.visible = true;
            this._currentView = this._discloseView;
         }
         if(this._showData.state == IndianaModel.INDIANA_DOING)
         {
            if(Boolean(this._currentView) && !(this._currentView is IndianaInfoPanel))
            {
               this._currentView.visible = false;
               if(this._currentView is IndiananDiscloseCountDownPanel)
               {
                  this._currentView.stopTime();
               }
            }
            if(this._infoView == null)
            {
               this._infoView = new IndianaInfoPanel();
               addChild(this._infoView);
            }
            this._infoView.visible = true;
            this._currentView = this._infoView;
         }
      }
      
      public function upDate() : void
      {
         this._info = IndianaDataManager.instance.getCurrentShopItem;
         if(Boolean(this._info))
         {
            this._itemInfo = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(this._info.ShopId);
         }
         this.updataState();
         this._currentView.setInfo(this._info);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._currentView = null;
         this._discloseView = null;
         this._infoView = null;
      }
   }
}

