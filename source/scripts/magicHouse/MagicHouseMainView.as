package magicHouse
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import magicHouse.magicBox.MagicHouseBoxView;
   import magicHouse.magicCollection.MagicHouseCollectionMainView;
   import magicHouse.treasureHouse.MagicHouseTreasureHouseView;
   
   public class MagicHouseMainView extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _collectionBtn:SelectedButton;
      
      private var _treasureBtn:SelectedButton;
      
      private var _boxBtn:SelectedButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _collectionView:MagicHouseCollectionMainView;
      
      private var _treasureView:MagicHouseTreasureHouseView;
      
      private var _magicBoxView:MagicHouseBoxView;
      
      public function MagicHouseMainView()
      {
         super();
         titleText = LanguageMgr.GetTranslation("magichouse.mainview.frametitletext");
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         MagicHouseControl.instance.initServerConfig();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.bg");
         addToContent(this._bg);
         this._collectionBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.collectionBtn");
         addToContent(this._collectionBtn);
         this._treasureBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.treasureBtn");
         addToContent(this._treasureBtn);
         this._boxBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame.boxBtn");
         this._boxBtn.visible = true;
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._collectionBtn);
         this._btnGroup.addSelectItem(this._treasureBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__response);
         this._btnGroup.addEventListener("change",this.__changeHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__response);
         this._btnGroup.removeEventListener("change",this.__changeHandler);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               this._showCollectionView();
               break;
            case 1:
               this._showTreasureView();
               break;
            case 2:
               this._showMagicBoxView();
         }
      }
      
      protected function _showCollectionView() : void
      {
         if(!this._collectionView)
         {
            this._collectionView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicHouseCollectionMainView");
            addToContent(this._collectionView);
         }
         this._collectionView.visible = true;
         if(Boolean(this._treasureView))
         {
            this._treasureView.visible = false;
         }
         if(Boolean(this._magicBoxView))
         {
            this._magicBoxView.visible = false;
         }
         MagicHouseControl.instance.selectEquipFromBag();
         MagicHouseManager.instance.dispatchEvent(new Event("magichouse_updata"));
      }
      
      private function _showTreasureView() : void
      {
         if(!this._treasureView)
         {
            this._treasureView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicHouseTreasureHouseView");
            addToContent(this._treasureView);
         }
         this._treasureView.info = PlayerManager.Instance.Self;
         this._treasureView.visible = true;
         if(Boolean(this._collectionView))
         {
            this._collectionView.visible = false;
         }
         if(Boolean(this._magicBoxView))
         {
            this._magicBoxView.visible = false;
         }
      }
      
      private function _showMagicBoxView() : void
      {
         if(!this._magicBoxView)
         {
            this._magicBoxView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicBoxMainView");
            addToContent(this._magicBoxView);
         }
         this._magicBoxView.visible = true;
         if(Boolean(this._collectionView))
         {
            this._collectionView.visible = false;
         }
         if(Boolean(this._treasureView))
         {
            this._treasureView.visible = false;
         }
      }
      
      public function show(param1:int = 0) : void
      {
         LayerManager.Instance.addToLayer(this,3,true,2);
         this._btnGroup.selectIndex = param1;
         this._showCollectionView();
      }
      
      public function close() : void
      {
         this.dispose();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._collectionBtn))
         {
            ObjectUtils.disposeObject(this._collectionBtn);
         }
         this._collectionBtn = null;
         if(Boolean(this._treasureBtn))
         {
            ObjectUtils.disposeObject(this._treasureBtn);
         }
         this._treasureBtn = null;
         if(Boolean(this._boxBtn))
         {
            ObjectUtils.disposeObject(this._boxBtn);
         }
         this._boxBtn = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._collectionView))
         {
            ObjectUtils.disposeObject(this._collectionView);
         }
         this._collectionView = null;
         if(Boolean(this._treasureView))
         {
            ObjectUtils.disposeObject(this._treasureView);
         }
         this._treasureView = null;
         if(Boolean(this._magicBoxView))
         {
            ObjectUtils.disposeObject(this._magicBoxView);
         }
         this._magicBoxView = null;
         super.dispose();
      }
   }
}

