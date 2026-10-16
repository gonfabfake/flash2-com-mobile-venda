package memoryGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import memoryGame.MemoryGameManager;
   
   public class MemoryGameFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _selectedBtnsHBox:HBox;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _gameBtn:SelectedButton;
      
      private var _rewardsBtn:SelectedButton;
      
      private var _gameView:MemoryGameView;
      
      private var _shopView:MemoryGameShop;
      
      private var _btnHelp:BaseButton;
      
      public function MemoryGameFrame()
      {
         super();
         this.initEvent();
         this.checkActivity();
      }
      
      override protected function init() : void
      {
         InviteManager.Instance.enabled = false;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("memoryGame.MemoryGameFrame.bg");
         this._gameBtn = ComponentFactory.Instance.creatComponentByStylename("memoryGame.gameBtn");
         this._rewardsBtn = ComponentFactory.Instance.creatComponentByStylename("memoryGame.scoreBtn");
         this._rewardsBtn.x = 110;
         this._selectedBtnsHBox = ComponentFactory.Instance.creatComponentByStylename("memoryGame.MemoryGameFrame.hBox");
         this._btnGroup = new SelectedButtonGroup();
         this._selectedBtnsHBox.addChild(this._gameBtn);
         this._selectedBtnsHBox.addChild(this._rewardsBtn);
         this._btnGroup.addSelectItem(this._gameBtn);
         this._btnGroup.addSelectItem(this._rewardsBtn);
         this._btnGroup.selectIndex = 0;
         super.init();
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":720,
            "y":2
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.memoryGame.view.help",408,488);
         titleText = LanguageMgr.GetTranslation("memoryGame.title");
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._bg))
         {
            addToContent(this._bg);
         }
         if(Boolean(this._selectedBtnsHBox))
         {
            addToContent(this._selectedBtnsHBox);
         }
         if(Boolean(this._gameView))
         {
            addToContent(this._gameView);
         }
         if(Boolean(this._shopView))
         {
            addToContent(this._shopView);
         }
      }
      
      override protected function onResponse(param1:int) : void
      {
         if(MemoryGameManager.instance.playActionAllComplete() && !MemoryGameManager.instance.turning)
         {
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.notClose"));
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               if(!this._gameView)
               {
                  this._gameView = new MemoryGameView(this);
                  SocketManager.Instance.out.sendMemoryGameInfo();
                  PositionUtils.setPos(this._gameView,"memoryGame.gameViewPos");
               }
               if(Boolean(this._shopView))
               {
                  this._shopView.visible = false;
               }
               this._gameView.visible = true;
               break;
            case 1:
               if(!this._shopView)
               {
                  this._shopView = new MemoryGameShop();
                  PositionUtils.setPos(this._shopView,"memoryGame.shopViewPos");
               }
               if(Boolean(this._gameView))
               {
                  this._gameView.visible = false;
               }
               this._shopView.visible = true;
               this._shopView.update();
         }
         this.addChildren();
      }
      
      public function shopViewUpdate() : void
      {
         if(Boolean(this._shopView))
         {
            this._shopView.update();
         }
      }
      
      private function checkActivity() : void
      {
         var _loc1_:Boolean = MemoryGameManager.instance.isValid;
         this.__changeHandler(null);
         if(!_loc1_)
         {
            this._gameBtn.enable = false;
            this._btnGroup.selectIndex = 1;
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener("change",this.__changeHandler);
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener("change",this.__changeHandler);
      }
      
      override public function dispose() : void
      {
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         ObjectUtils.disposeObject(this._btnHelp);
         super.dispose();
         this._bg = null;
         this._gameView = null;
         this._shopView = null;
         this._selectedBtnsHBox = null;
         this._btnHelp = null;
      }
   }
}

