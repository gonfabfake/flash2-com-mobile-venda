package moneyTree.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import moneyTree.MoneyTreeManager;
   import moneyTree.model.MoneyTreeModel;
   import moneyTree.ui.ListPanelMediator;
   
   public class MoneyTreeMainFrame extends Frame implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _bgMC:MovieClip;
      
      private var _fruitList:Vector.<Fruit> = new Vector.<Fruit>();
      
      private var _txtRemainNum:FilterFrameText;
      
      private var _btnSend:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _leafs:Bitmap;
      
      private var _friendsListPanel:ListPanel;
      
      private var _listBG:MutipleImage;
      
      private var _listPanelMediator:ListPanelMediator;
      
      private var _shineMC:MovieClip;
      
      private var _redPkgShineMC:MovieClip;
      
      public function MoneyTreeMainFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc3_:ComponentFactory = null;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         super.init();
         escEnable = true;
         _loc3_ = ComponentFactory.Instance;
         titleText = LanguageMgr.GetTranslation("moneyTree.title");
         var _loc4_:Sprite = ComponentFactory.Instance.creat("moneyTree.help");
         PositionUtils.setPos(_loc4_,"moneytree.HelpContentPos");
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"moneytree.helpBtn",null,LanguageMgr.GetTranslation("moneytree.helpTitle"),_loc4_,404,484) as SimpleBitmapButton;
         PositionUtils.setPos(this._helpBtn,"moneytree.helpBtnPos");
         this._bg = _loc3_.creatBitmap("moneyTree.bg");
         this._bg.x = 16;
         this._bg.y = 42;
         addToContent(this._bg);
         this._bgMC = _loc3_.creat("moneyTree.bg.movie");
         this._bgMC.x = 64;
         this._bgMC.y = 311;
         addToContent(this._bgMC);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new Fruit(_loc1_);
            PositionUtils.setPos(_loc2_,"moneyTree.fruit" + _loc1_.toString() + ".pos");
            addToContent(_loc2_);
            this._fruitList[_loc1_] = _loc2_;
            _loc1_++;
         }
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("asset.horseracing.bg");
         this._listBG.x = 344;
         this._listBG.y = 132;
         addToContent(this._listBG);
         this._friendsListPanel = _loc3_.creatComponentByStylename("moneyTree.ui.FriendsList");
         addToContent(this._friendsListPanel);
         this._listPanelMediator = new ListPanelMediator();
         this._listPanelMediator.setPanel(this._friendsListPanel);
         this._listPanelMediator.refresh(0);
         this._txtRemainNum = _loc3_.creat("moneyTree.txt.TimesRemain");
         addToContent(this._txtRemainNum);
         this._txtRemainNum.text = "";
         this._btnSend = _loc3_.creat("moneyTree.btn.send");
         addToContent(this._btnSend);
         this._btnSend.addEventListener("click",this.onSendClick);
         addEventListener("response",this._response);
      }
      
      public function pick(param1:int) : void
      {
         this._fruitList[param1].showPick();
      }
      
      public function resetFriendList() : void
      {
         this._listPanelMediator.reset();
      }
      
      public function updateRemainNum() : void
      {
         this._txtRemainNum.text = MoneyTreeManager.getInstance().model.getNumRedPkgRemain().toString();
      }
      
      public function updateFruits() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:MoneyTreeModel = MoneyTreeManager.getInstance().model;
         var _loc4_:int = int(this._fruitList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = _loc3_.getInfoAt(_loc1_);
            if(Boolean(_loc2_.isGrown))
            {
               this._fruitList[_loc1_].showGrown();
            }
            else
            {
               this._fruitList[_loc1_].showNormal();
            }
            _loc1_++;
         }
      }
      
      protected function onSendClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MoneyTreeManager.getInstance().sendRedPkgBtnClicked();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            MoneyTreeManager.getInstance().hideMainFrame();
         }
      }
      
      public function playFly() : void
      {
         this.mouseChildren = this.mouseEnabled = false;
         this.escEnable = false;
         if(!this._redPkgShineMC)
         {
            this._redPkgShineMC = ComponentFactory.Instance.creat("moneyTree.redPkg.shining");
            this._redPkgShineMC.x = 375;
            this._redPkgShineMC.y = 89;
         }
         if(!this._shineMC)
         {
            this._shineMC = ComponentFactory.Instance.creat("moneyTree.lightsFly");
            this._shineMC.x = 135;
            this._shineMC.y = 171;
         }
         addToContent(this._shineMC);
         this._shineMC.addEventListener("enterFrame",this.onShineEF);
         this._shineMC.gotoAndPlay(1);
         addToContent(this._redPkgShineMC);
         this._redPkgShineMC.addEventListener("enterFrame",this.onRedPkgShine);
         this._redPkgShineMC.gotoAndPlay(1);
      }
      
      protected function onRedPkgShine(param1:Event) : void
      {
         if(this._redPkgShineMC.currentFrame == this._redPkgShineMC.totalFrames)
         {
            this._redPkgShineMC.removeEventListener("enterFrame",this.onRedPkgShine);
            this._redPkgShineMC.parent && _container.removeChild(this._redPkgShineMC);
            this._redPkgShineMC.stop();
            this.mouseChildren = this.mouseEnabled = true;
            this.escEnable = true;
         }
      }
      
      protected function onShineEF(param1:Event) : void
      {
         if(this._shineMC.currentFrame == this._shineMC.totalFrames)
         {
            this._shineMC.removeEventListener("enterFrame",this.onShineEF);
            this._shineMC.parent && _container.removeChild(this._shineMC);
            this._shineMC.stop();
            this.mouseChildren = this.mouseEnabled = true;
            this.escEnable = true;
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener("response",this._response);
         if(Boolean(this._shineMC))
         {
            this._shineMC.removeEventListener("enterFrame",this.onShineEF);
            this._shineMC.stop();
            ObjectUtils.disposeObject(this._shineMC);
            this._shineMC = null;
         }
         if(Boolean(this._redPkgShineMC))
         {
            this._redPkgShineMC.removeEventListener("enterFrame",this.onRedPkgShine);
            this._redPkgShineMC.stop();
            ObjectUtils.disposeObject(this._redPkgShineMC);
            this._redPkgShineMC = null;
         }
         if(this._btnSend != null)
         {
            this._btnSend.removeEventListener("click",this.onSendClick);
            ObjectUtils.disposeObject(this._btnSend);
            this._btnSend = null;
         }
         super.dispose();
      }
   }
}

