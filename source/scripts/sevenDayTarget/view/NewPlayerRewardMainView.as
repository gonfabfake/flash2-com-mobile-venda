package sevenDayTarget.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sevenDayTarget.controller.NewPlayerRewardManager;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   
   public class NewPlayerRewardMainView extends Sprite
   {
      
      public static var CHONGZHI:int = 1;
      
      public static var XIAOFEI:int = 2;
      
      public static var HUNLI:int = 3;
      
      private var _bg:Bitmap;
      
      private var _downBack:ScaleBitmapImage;
      
      private var _titleText1:FilterFrameText;
      
      private var _titleText2:FilterFrameText;
      
      private var _titleText3:FilterFrameText;
      
      private var _scrollpanel:ScrollPanel;
      
      private var _scrollpanel2:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _vbox2:VBox;
      
      private var _helpBnt:BaseButton;
      
      public function NewPlayerRewardMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:NewPlayerRewardInfo = null;
         var _loc2_:NewPlayerRewardItem = null;
         var _loc3_:NewPlayerRewardInfo = null;
         var _loc4_:NewPlayerRewardItem = null;
         var _loc5_:NewPlayerRewardInfo = null;
         var _loc6_:NewPlayerRewardItem = null;
         this._bg = ComponentFactory.Instance.creat("sevenDay.newPlayerBg");
         this._downBack = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.scale9cornerImageTree");
         this._titleText1 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
         this._titleText2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
         this._titleText3 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext3");
         this._titleText1.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title1");
         this._titleText2.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title2");
         this._titleText3.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.title3");
         addChild(this._downBack);
         addChild(this._bg);
         addChild(this._titleText1);
         addChild(this._titleText2);
         addChild(this._titleText3);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.chongzhiVbox");
         this._scrollpanel = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.chongzhiList");
         var _loc7_:Array = NewPlayerRewardManager.Instance.model.chongzhiInfoArr;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_.length)
         {
            _loc1_ = _loc7_[_loc8_];
            _loc2_ = new NewPlayerRewardItem();
            _loc2_.setInfo(_loc1_);
            this._vbox.addChild(_loc2_);
            _loc8_++;
         }
         this._scrollpanel.setView(this._vbox);
         this._scrollpanel.invalidateViewport();
         addChild(this._scrollpanel);
         this._vbox2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.xiaofeiVbox");
         this._scrollpanel2 = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.xiaofeiList");
         var _loc9_:Array = NewPlayerRewardManager.Instance.model.xiaofeiInfoArr;
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc3_ = _loc9_[_loc10_];
            _loc4_ = new NewPlayerRewardItem();
            _loc4_.setInfo(_loc3_);
            this._vbox2.addChild(_loc4_);
            _loc10_++;
         }
         this._scrollpanel2.setView(this._vbox2);
         this._scrollpanel2.invalidateViewport();
         addChild(this._scrollpanel2);
         var _loc11_:Array = NewPlayerRewardManager.Instance.model.hunliInfoArr;
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_.length)
         {
            _loc5_ = _loc11_[_loc12_];
            _loc6_ = new NewPlayerRewardItem();
            _loc6_.setInfo(_loc5_);
            addChild(_loc6_);
            PositionUtils.setPos(_loc6_,"newSevenDayAndNewPlayer.hunliListPos");
            _loc12_++;
         }
         this.addHelpBnt();
      }
      
      private function addHelpBnt() : void
      {
         this._helpBnt = ComponentFactory.Instance.creatComponentByStylename("newPlayerReward.helpBnt");
         addChild(this._helpBnt);
         PositionUtils.setPos(this._helpBnt,"newPlayerReward.view.helpBntPos");
         this._helpBnt.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SevenDayTargetHelpFrame = ComponentFactory.Instance.creat("sevenDayTarget.helpView");
         var _loc3_:MovieClip = ComponentFactory.Instance.creat("newPlayerReward.view.helpContentText");
         _loc2_.changeContent(_loc3_);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}

