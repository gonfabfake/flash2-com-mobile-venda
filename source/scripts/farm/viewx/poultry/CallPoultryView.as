package farm.viewx.poultry
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.utils.Dictionary;
   
   public class CallPoultryView extends BaseAlerFrame
   {
      
      private var _titleBg:ScaleBitmapImage;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _poultryBox:ComboBox;
      
      public function CallPoultryView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         _loc1_.moveEnable = false;
         _loc1_.autoDispose = false;
         info = _loc1_;
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("farm.friendListTitleBg");
         PositionUtils.setPos(this._titleBg,"asset.farm.poultry.titlePos");
         addToContent(this._titleBg);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("farm.callPoultry.alertBg");
         addToContent(this._btnBg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._titleTxt.text = LanguageMgr.GetTranslation("farm.tree.callPoultry.titleText");
         PositionUtils.setPos(this._titleTxt,"asset.farm.poultry.titleTxtPos");
         addToContent(this._titleTxt);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._infoText.text = LanguageMgr.GetTranslation("farm.tree.callPoultry.infoText");
         PositionUtils.setPos(this._infoText,"asset.farm.poultry.infoTextPos");
         addToContent(this._infoText);
         this._poultryBox = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.callView.poultryMenu");
         addToContent(this._poultryBox);
         this.addPoultryName();
      }
      
      private function addPoultryName() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:VectorListModel = this._poultryBox.listPanel.vectorListModel;
         _loc1_.clear();
         var _loc2_:int = FarmModelController.instance.model.FarmTreeLevel;
         var _loc3_:Dictionary = FarmModelController.instance.model.farmPoultryInfo;
         if(_loc2_ > 0)
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.Level % 10 == 1 && _loc4_.Level <= _loc2_)
               {
                  _loc1_.append(_loc4_.MonsterName);
               }
            }
         }
         else
         {
            _loc1_.append(_loc3_[_loc2_].MonsterName);
         }
         this._poultryBox.textField.text = _loc1_.last();
         this._poultryBox.currentSelectedIndex = _loc1_.size() - 1;
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__closeFarmHelper);
         this._poultryBox.listPanel.list.addEventListener("listItemClick",this.__onListClick);
      }
      
      protected function __onListClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __closeFarmHelper(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode) - 3)
         {
            case 0:
               SocketManager.Instance.out.callFarmPoultry(this._poultryBox.currentSelectedIndex * 10 + 1);
         }
         this.dispose();
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__closeFarmHelper);
         this._poultryBox.listPanel.list.removeEventListener("listItemClick",this.__onListClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._titleBg))
         {
            this._titleBg.dispose();
            this._titleBg = null;
         }
         if(Boolean(this._btnBg))
         {
            this._btnBg.dispose();
            this._btnBg = null;
         }
         if(Boolean(this._titleTxt))
         {
            this._titleTxt.dispose();
            this._titleTxt = null;
         }
         if(Boolean(this._infoText))
         {
            this._infoText.dispose();
            this._infoText = null;
         }
         if(Boolean(this._poultryBox))
         {
            this._poultryBox.dispose();
            this._poultryBox = null;
         }
         super.dispose();
      }
   }
}

