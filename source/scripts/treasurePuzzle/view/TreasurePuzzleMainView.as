package treasurePuzzle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import treasurePuzzle.data.TreasurePuzzlePiceData;
   
   public class TreasurePuzzleMainView extends Frame
   {
      
      private var _topBg:Bitmap;
      
      private var _downBg:Bitmap;
      
      private var _getRewardBnt:BaseButton;
      
      private var _helpBnt:BaseButton;
      
      private var _leftBnt:BaseButton;
      
      private var _rightBnt:BaseButton;
      
      private var _currentPuzzle:int;
      
      private var pice1DataText:FilterFrameText;
      
      private var pice2DataText:FilterFrameText;
      
      private var pice3DataText:FilterFrameText;
      
      private var pice4DataText:FilterFrameText;
      
      private var pice5DataText:FilterFrameText;
      
      private var pice6DataText:FilterFrameText;
      
      private var bg:Bitmap;
      
      private var pic_an1:Bitmap;
      
      private var pic_an2:Bitmap;
      
      private var pic_an3:Bitmap;
      
      private var pic_an4:Bitmap;
      
      private var pic_an5:Bitmap;
      
      private var pic_an6:Bitmap;
      
      private var pic_liang1:Bitmap;
      
      private var pic_liang2:Bitmap;
      
      private var pic_liang3:Bitmap;
      
      private var pic_liang4:Bitmap;
      
      private var pic_liang5:Bitmap;
      
      private var pic_liang6:Bitmap;
      
      public function TreasurePuzzleMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._topBg = ComponentFactory.Instance.creat("treasurePuzzle.topBg");
         this._downBg = ComponentFactory.Instance.creat("treasurePuzzle.downBg");
         this._getRewardBnt = ComponentFactory.Instance.creat("treasurePuzzle.getRewardBnt");
         this._helpBnt = ComponentFactory.Instance.creat("treasurePuzzle.helpBnt");
         this._leftBnt = ComponentFactory.Instance.creat("treasurePuzzle.leftBnt");
         this._rightBnt = ComponentFactory.Instance.creat("treasurePuzzle.rightBnt");
         this.pice1DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         this.pice2DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         this.pice3DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         this.pice4DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         this.pice5DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         this.pice6DataText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.mainView.piceDataContentText");
         PositionUtils.setPos(this.pice1DataText,"treasurePuzzle.mainView.pice1DataTextPos");
         PositionUtils.setPos(this.pice2DataText,"treasurePuzzle.mainView.pice2DataTextPos");
         PositionUtils.setPos(this.pice3DataText,"treasurePuzzle.mainView.pice3DataTextPos");
         PositionUtils.setPos(this.pice4DataText,"treasurePuzzle.mainView.pice4DataTextPos");
         PositionUtils.setPos(this.pice5DataText,"treasurePuzzle.mainView.pice5DataTextPos");
         PositionUtils.setPos(this.pice6DataText,"treasurePuzzle.mainView.pice6DataTextPos");
         this.currentPuzzle = 1;
         addToContent(this._downBg);
         addToContent(this._topBg);
         addToContent(this._getRewardBnt);
         addToContent(this._helpBnt);
      }
      
      public function set currentPuzzle(param1:int) : void
      {
         var _loc2_:TreasurePuzzlePiceData = null;
         var _loc3_:int = 0;
         var _loc4_:TreasurePuzzlePiceData = null;
         this._currentPuzzle = param1;
         TreasurePuzzleManager.Instance.currentPuzzle = this._currentPuzzle;
         while(_loc3_ < TreasurePuzzleManager.Instance.model.dataArr.length)
         {
            _loc4_ = TreasurePuzzleManager.Instance.model.dataArr[_loc3_];
            if(_loc4_.id == this._currentPuzzle)
            {
               _loc2_ = _loc4_;
               this.pice1DataText.text = _loc4_.hole1Have + "/" + _loc4_.hole1Need;
               this.pice2DataText.text = _loc4_.hole2Have + "/" + _loc4_.hole2Need;
               this.pice3DataText.text = _loc4_.hole3Have + "/" + _loc4_.hole3Need;
               this.pice4DataText.text = _loc4_.hole4Have + "/" + _loc4_.hole4Need;
               this.pice5DataText.text = _loc4_.hole5Have + "/" + _loc4_.hole5Need;
               this.pice6DataText.text = _loc4_.hole6Have + "/" + _loc4_.hole6Need;
               if(_loc4_.hole1Have >= _loc4_.hole1Need && _loc4_.hole2Have >= _loc4_.hole2Need && _loc4_.hole3Have >= _loc4_.hole3Need && _loc4_.hole4Have >= _loc4_.hole4Need && _loc4_.hole5Have >= _loc4_.hole5Need && _loc4_.hole6Have >= _loc4_.hole6Need && !_loc4_._canGetReward)
               {
                  this._getRewardBnt.enable = true;
               }
               else
               {
                  this._getRewardBnt.enable = false;
               }
            }
            _loc3_++;
         }
         if(this._currentPuzzle == 1)
         {
            this._leftBnt.enable = false;
            this._rightBnt.enable = true;
         }
         else if(this._currentPuzzle == TreasurePuzzleManager.Instance.model.dataArr.length)
         {
            this._rightBnt.enable = false;
            this._leftBnt.enable = true;
         }
         else
         {
            this._leftBnt.enable = true;
            this._rightBnt.enable = true;
         }
         this.getCurrentPicMap(this._currentPuzzle);
         this.showLightPic(_loc2_);
      }
      
      public function showLightPic(param1:TreasurePuzzlePiceData) : void
      {
         if(param1.hole1Have >= param1.hole1Need)
         {
            this.pic_liang1.visible = true;
         }
         else
         {
            this.pic_liang1.visible = false;
         }
         if(param1.hole2Have >= param1.hole2Need)
         {
            this.pic_liang2.visible = true;
         }
         else
         {
            this.pic_liang2.visible = false;
         }
         if(param1.hole3Have >= param1.hole3Need)
         {
            this.pic_liang3.visible = true;
         }
         else
         {
            this.pic_liang3.visible = false;
         }
         if(param1.hole4Have >= param1.hole4Need)
         {
            this.pic_liang4.visible = true;
         }
         else
         {
            this.pic_liang4.visible = false;
         }
         if(param1.hole5Have >= param1.hole5Need)
         {
            this.pic_liang5.visible = true;
         }
         else
         {
            this.pic_liang5.visible = false;
         }
         if(param1.hole6Have >= param1.hole6Need)
         {
            this.pic_liang6.visible = true;
         }
         else
         {
            this.pic_liang6.visible = false;
         }
      }
      
      public function getCurrentPicMap(param1:int) : void
      {
         var _loc2_:TreasurePuzzlePiceData = null;
         var _loc3_:int = 0;
         var _loc4_:TreasurePuzzlePiceData = null;
         var _loc5_:String = "treasurePuzzle.view.tu" + param1;
         this.bg = ComponentFactory.Instance.creat(_loc5_ + "Bg");
         this.pic_an1 = ComponentFactory.Instance.creat(_loc5_ + "_an1");
         this.pic_an2 = ComponentFactory.Instance.creat(_loc5_ + "_an2");
         this.pic_an3 = ComponentFactory.Instance.creat(_loc5_ + "_an3");
         this.pic_an4 = ComponentFactory.Instance.creat(_loc5_ + "_an4");
         this.pic_an5 = ComponentFactory.Instance.creat(_loc5_ + "_an5");
         this.pic_an6 = ComponentFactory.Instance.creat(_loc5_ + "_an6");
         this.pic_liang1 = ComponentFactory.Instance.creat(_loc5_ + "_liang1");
         this.pic_liang2 = ComponentFactory.Instance.creat(_loc5_ + "_liang2");
         this.pic_liang3 = ComponentFactory.Instance.creat(_loc5_ + "_liang3");
         this.pic_liang4 = ComponentFactory.Instance.creat(_loc5_ + "_liang4");
         this.pic_liang5 = ComponentFactory.Instance.creat(_loc5_ + "_liang5");
         this.pic_liang6 = ComponentFactory.Instance.creat(_loc5_ + "_liang6");
         PositionUtils.setPos(this.bg,"treasurePuzzle.view.tuBgPos");
         PositionUtils.setPos(this.pic_an1,"treasurePuzzle.view.tu_an1Pos");
         PositionUtils.setPos(this.pic_an2,"treasurePuzzle.view.tu_an2Pos");
         PositionUtils.setPos(this.pic_an3,"treasurePuzzle.view.tu_an3Pos");
         PositionUtils.setPos(this.pic_an4,"treasurePuzzle.view.tu_an4Pos");
         PositionUtils.setPos(this.pic_an5,"treasurePuzzle.view.tu_an5Pos");
         PositionUtils.setPos(this.pic_an6,"treasurePuzzle.view.tu_an6Pos");
         PositionUtils.setPos(this.pic_liang1,"treasurePuzzle.view.tu_liang1Pos");
         PositionUtils.setPos(this.pic_liang2,"treasurePuzzle.view.tu_liang2Pos");
         PositionUtils.setPos(this.pic_liang3,"treasurePuzzle.view.tu_liang3Pos");
         PositionUtils.setPos(this.pic_liang4,"treasurePuzzle.view.tu_liang4Pos");
         PositionUtils.setPos(this.pic_liang5,"treasurePuzzle.view.tu_liang5Pos");
         PositionUtils.setPos(this.pic_liang6,"treasurePuzzle.view.tu_liang6Pos");
         addToContent(this.bg);
         addToContent(this.pic_an1);
         addToContent(this.pic_an2);
         addToContent(this.pic_an3);
         addToContent(this.pic_an4);
         addToContent(this.pic_an5);
         addToContent(this.pic_an6);
         addToContent(this.pic_liang1);
         addToContent(this.pic_liang2);
         addToContent(this.pic_liang3);
         addToContent(this.pic_liang4);
         addToContent(this.pic_liang5);
         addToContent(this.pic_liang6);
         addToContent(this.pice1DataText);
         addToContent(this.pice2DataText);
         addToContent(this.pice3DataText);
         addToContent(this.pice4DataText);
         addToContent(this.pice5DataText);
         addToContent(this.pice6DataText);
         addToContent(this._leftBnt);
         addToContent(this._rightBnt);
         while(_loc3_ < TreasurePuzzleManager.Instance.model.dataArr.length)
         {
            _loc4_ = TreasurePuzzleManager.Instance.model.dataArr[_loc3_];
            if(_loc4_.id == this._currentPuzzle)
            {
               _loc2_ = _loc4_;
               if(_loc4_.hole1Have == 0 && _loc4_.hole2Have == 0 && _loc4_.hole3Have == 0 && _loc4_.hole4Have == 0 && _loc4_.hole5Have == 0 && _loc4_.hole6Have == 0)
               {
                  this.pic_an1.visible = false;
                  this.pic_an2.visible = false;
                  this.pic_an3.visible = false;
                  this.pic_an4.visible = false;
                  this.pic_an5.visible = false;
                  this.pic_an6.visible = false;
               }
               else
               {
                  this.pic_an1.visible = true;
                  this.pic_an2.visible = true;
                  this.pic_an3.visible = true;
                  this.pic_an4.visible = true;
                  this.pic_an5.visible = true;
                  this.pic_an6.visible = true;
               }
            }
            _loc3_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._getRewardBnt.addEventListener(MouseEvent.CLICK,this.__getRewardBntClick);
         this._helpBnt.addEventListener(MouseEvent.CLICK,this.__helpBntClick);
         this._leftBnt.addEventListener(MouseEvent.CLICK,this.__clickLeftBnt);
         this._rightBnt.addEventListener(MouseEvent.CLICK,this.__clickRightBnt);
      }
      
      private function __clickLeftBnt(param1:MouseEvent) : void
      {
         if(this._currentPuzzle - 1 < 1)
         {
            this.currentPuzzle = 1;
            return;
         }
         --this._currentPuzzle;
         this.currentPuzzle = this._currentPuzzle;
      }
      
      private function __clickRightBnt(param1:MouseEvent) : void
      {
         if(this._currentPuzzle + 1 > TreasurePuzzleManager.Instance.model.dataArr.length)
         {
            this.currentPuzzle = TreasurePuzzleManager.Instance.model.dataArr.length;
            return;
         }
         ++this._currentPuzzle;
         this.currentPuzzle = this._currentPuzzle;
      }
      
      private function __getRewardBntClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.treasurePuzzle_getReward(this._currentPuzzle);
      }
      
      public function showShiwuInfoView() : void
      {
         var _loc1_:TreasurePuzzleRewardInfoView = ComponentFactory.Instance.creat("treasurePuzzle.view.rewardInfoView");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function flushRewardBnt() : void
      {
         this.currentPuzzle = this._currentPuzzle;
      }
      
      private function __helpBntClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.treasurePuzzle_seeReward();
      }
      
      public function showHelpView() : void
      {
         var _loc1_:TreasurePuzzleHelpView = ComponentFactory.Instance.creat("treasurePuzzle.helpView");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._getRewardBnt.removeEventListener(MouseEvent.CLICK,this.__getRewardBntClick);
         this._helpBnt.removeEventListener(MouseEvent.CLICK,this.__helpBntClick);
         this._leftBnt.removeEventListener(MouseEvent.CLICK,this.__clickLeftBnt);
         this._rightBnt.removeEventListener(MouseEvent.CLICK,this.__clickRightBnt);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               TreasurePuzzleManager.Instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._topBg))
         {
            this._topBg.bitmapData.dispose();
            this._topBg = null;
         }
         if(Boolean(this._downBg))
         {
            this._downBg.bitmapData.dispose();
            this._downBg = null;
         }
         if(Boolean(this._getRewardBnt))
         {
            this._getRewardBnt.dispose();
            this._getRewardBnt = null;
         }
         if(Boolean(this._helpBnt))
         {
            this._helpBnt.dispose();
            this._helpBnt = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

