package treasurePuzzle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import treasurePuzzle.data.TreasurePuzzlePiceData;
   import treasurePuzzle.data.TreasurePuzzleRewardData;
   
   public class TreasurePuzzleHelpView extends Frame
   {
      
      private var _view:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      private var _topBg:Bitmap;
      
      private var _downBg:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _panel2:ScrollPanel;
      
      private var _vbox:VBox;
      
      public function TreasurePuzzleHelpView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         titleText = LanguageMgr.GetTranslation("treasurePuzzle.view.helpTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.frameBg");
         this._view.addChild(this._bg);
         this._topBg = ComponentFactory.Instance.creat("treasurePuzzle.treasurePuzzletopBg");
         this._downBg = ComponentFactory.Instance.creat("treasurePuzzle.treasurePuzzledownBg");
         this._view.addChild(this._topBg);
         this._view.addChild(this._downBg);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.helpPanel");
         this._view.addChild(this._panel);
         this._panel2 = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.helpPanel2");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.Vbox");
         this._view.addChild(this._panel2);
         addToContent(this._view);
         this.createRewardContent();
         this.createContent();
         enterEnable = true;
         escEnable = true;
      }
      
      private function createRewardContent() : void
      {
         var _loc1_:int = int(TreasurePuzzleManager.Instance.model.dataArr.length);
         this.setRewardInfo(_loc1_);
      }
      
      private function setRewardInfo(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:TreasurePuzzlePiceData = null;
         var _loc6_:Boolean = false;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:TreasurePuzzleRewardData = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:TreasurePuzzleHelpContentItem = null;
         var _loc14_:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleRed") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var _loc15_:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleBlue") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var _loc16_:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleYellow") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var _loc17_:Array = [_loc14_,_loc15_,_loc16_];
         var _loc18_:String = "";
         var _loc19_:int = 0;
         while(_loc19_ < TreasurePuzzleManager.Instance.model.dataArr.length)
         {
            _loc5_ = TreasurePuzzleManager.Instance.model.dataArr[_loc19_];
            _loc6_ = _loc5_.isShiwu;
            if(_loc6_)
            {
               _loc18_ += LanguageMgr.GetTranslation("treasurePuzzle.view.shiwuContent");
            }
            else
            {
               _loc7_ = _loc5_.rewardList;
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = _loc7_[_loc8_];
                  _loc10_ = _loc9_.rewardId;
                  _loc11_ = _loc9_.rewardNum;
                  _loc12_ = ItemManager.Instance.getTemplateById(_loc10_).Name;
                  if(_loc8_ == 0)
                  {
                     _loc18_ += _loc12_ + "x" + _loc11_;
                  }
                  else
                  {
                     _loc18_ += "、" + _loc12_ + "x" + _loc11_;
                  }
                  _loc8_++;
               }
            }
            _loc18_ += "/";
            _loc19_++;
         }
         var _loc20_:Array = _loc18_.split("/");
         _loc20_.splice(-1,1);
         var _loc21_:int = 0;
         while(_loc21_ < _loc20_.length)
         {
            _loc13_ = new TreasurePuzzleHelpContentItem(_loc21_,_loc17_[_loc21_],_loc20_[_loc21_]);
            this._vbox.addChild(_loc13_);
            _loc21_++;
         }
         var _loc22_:Sprite = new Sprite();
         var _loc23_:TextField = new TextField();
         _loc23_.height = 50;
         _loc23_.text = "111";
         _loc22_.alpha = 0;
         _loc22_.addChild(_loc23_);
         this._vbox.addChild(_loc22_);
         this._panel2.setView(this._vbox);
      }
      
      private function createContent() : void
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.contentTitle");
         _loc2_.text = LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitle");
         _loc1_.addChild(_loc2_);
         var _loc3_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.contentText");
         _loc3_.text = LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentText");
         _loc1_.addChild(_loc3_);
         this._panel.setView(_loc1_);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
            this._view = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

