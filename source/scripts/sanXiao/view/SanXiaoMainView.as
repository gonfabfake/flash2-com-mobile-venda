package sanXiao.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonForArrange;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sanXiao.SanXiaoManager;
   
   public class SanXiaoMainView extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _selectGridBox:HBox;
      
      private var _selectGroup:SelectedButtonGroup;
      
      private var _btnGame:SelectedButtonForArrange;
      
      private var _btnStore:SelectedButtonForArrange;
      
      private var _btnDetail:SelectedButtonForArrange;
      
      private var _viewGame:SanXiaoViewGame;
      
      private var _viewStore:SanXiaoViewStore;
      
      private var _viewDetail:SanXiaoViewDetail;
      
      private var _curView:Sprite;
      
      private var _help:BaseButton;
      
      public function SanXiaoMainView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         titleText = LanguageMgr.GetTranslation("sanxiao.title");
         autoExit = true;
         escEnable = true;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("sanxiao.bg");
         addToContent(this._bg);
         this._viewGame = new SanXiaoViewGame();
         this._viewStore = new SanXiaoViewStore();
         this._viewDetail = new SanXiaoViewDetail();
         PositionUtils.setPos(this._viewGame,"sanxiao.page.pt");
         PositionUtils.setPos(this._viewStore,"sanxiao.page.pt");
         PositionUtils.setPos(this._viewDetail,"sanxiao.page.pt");
         this._selectGridBox = new HBox();
         PositionUtils.setPos(this._selectGridBox,"sanxiao.btns.pt");
         this._selectGroup = new SelectedButtonGroup();
         this._btnGame = ComponentFactory.Instance.creat("sanxiao.gameBtn");
         this._btnStore = ComponentFactory.Instance.creat("sanxiao.storeBtn");
         this._btnDetail = ComponentFactory.Instance.creat("sanxiao.detailBtn");
         this._selectGroup.addSelectItem(this._btnGame);
         this._selectGroup.addSelectItem(this._btnStore);
         this._selectGroup.addSelectItem(this._btnDetail);
         this._selectGridBox.addChild(this._btnGame);
         this._selectGridBox.addChild(this._btnStore);
         this._selectGridBox.addChild(this._btnDetail);
         addToContent(this._selectGridBox);
         this._help = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":708,
            "y":2
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"ast.sanxiao.help",408,488);
         this.addEvents();
         if(SanXiaoManager.getInstance().endTime.time <= TimeManager.Instance.Now().time)
         {
            Helpers.grey(this._btnGame);
            addToContent(this._viewStore);
            this._viewStore.update();
            this._selectGroup.selectIndex = 1;
         }
         else
         {
            Helpers.colorful(this._btnGame);
            addToContent(this._viewGame);
            this._viewGame.update();
            this._selectGroup.selectIndex = 0;
         }
      }
      
      private function addEvents() : void
      {
         this._btnGame.addEventListener("click",this.onBtnClick);
         this._btnStore.addEventListener("click",this.onBtnClick);
         this._btnDetail.addEventListener("click",this.onBtnClick);
         this._selectGroup.addEventListener("change",this.onSelectGroupChange);
      }
      
      private function removeEvents() : void
      {
         this._btnGame.removeEventListener("click",this.onBtnClick);
         this._btnStore.removeEventListener("click",this.onBtnClick);
         this._btnDetail.removeEventListener("click",this.onBtnClick);
         this._selectGroup.removeEventListener("change",this.onSelectGroupChange);
      }
      
      protected function onBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function onSelectGroupChange(param1:Event) : void
      {
         this._viewGame.parent && _container.removeChild(this._viewGame);
         this._viewStore.parent && _container.removeChild(this._viewStore);
         this._viewDetail.parent && _container.removeChild(this._viewDetail);
         switch(int(this._selectGroup.selectIndex))
         {
            case 0:
               if(SanXiaoManager.getInstance().endTime.time <= TimeManager.Instance.Now().time)
               {
                  Helpers.grey(this._btnGame);
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("sanxiao.timesOut"),0,true);
                  this._selectGroup.selectIndex = 1;
                  return;
               }
               Helpers.colorful(this._btnGame);
               addToContent(this._viewGame);
               this._viewGame.update();
               break;
            case 1:
               addToContent(this._viewStore);
               this._viewStore.update();
               break;
            case 2:
               addToContent(this._viewDetail);
               this._viewDetail.update();
         }
         this._selectGridBox.arrange();
      }
      
      public function lockProps() : void
      {
         this._viewGame && this._viewGame.lockProps();
      }
      
      public function unLockProps() : void
      {
         this._viewGame && this._viewGame.unLockProps();
      }
      
      public function updateDropOutItem() : void
      {
         this._viewGame && this._viewGame.updateDropOutItem();
      }
      
      public function update() : void
      {
         this._viewGame && this._viewGame.parent && this._viewGame.update();
         this._viewStore && this._viewStore.parent && this._viewStore.update();
         this._viewDetail && this._viewDetail.parent && this._viewDetail.update();
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         this._help.dispose();
         this._help = null;
         ObjectUtils.disposeObject(this._viewDetail);
         ObjectUtils.disposeObject(this._viewGame);
         ObjectUtils.disposeObject(this._viewStore);
         ObjectUtils.disposeObject(this._selectGroup);
         ObjectUtils.disposeObject(this._selectGridBox);
         this._viewDetail = null;
         this._viewGame = null;
         this._viewStore = null;
         this._selectGroup = null;
         this._selectGridBox = null;
         super.dispose();
      }
   }
}

