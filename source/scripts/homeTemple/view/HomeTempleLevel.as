package homeTemple.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import homeTemple.HomeTempleController;
   import homeTemple.event.HomeTempleEvent;
   
   public class HomeTempleLevel extends Sprite implements Disposeable
   {
      
      private var _primaryImmolation:BagCell;
      
      private var _highImmolation:BagCell;
      
      private var _selectCell:BagCell;
      
      private var _rockBuy:BaseButton;
      
      private var _isInjectSelect:SelectedCheckButton;
      
      private var _immolationBtn:SimpleBitmapButton;
      
      private var _progress:HomeImmolationProgressBar;
      
      private var _textValue:HomeTempleTextValue;
      
      private var _levelMovie:MovieClip;
      
      private var _currentLevelTip:Image;
      
      private var _icon1Bmp:Bitmap;
      
      private var _icon2Bmp:Bitmap;
      
      private var _nowBmp:Bitmap;
      
      private var _levelLabelBmp:Bitmap;
      
      private var _nums:N_BitmapDataNumber;
      
      private var _levelBmp:Bitmap;
      
      private var _item1Txt:FilterFrameText;
      
      private var _item2Txt:FilterFrameText;
      
      public function HomeTempleLevel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         this._primaryImmolation = new BagCell(1,ItemManager.Instance.getTemplateById(11176),true);
         this._primaryImmolation.scaleX = 0.7;
         this._primaryImmolation.scaleY = 0.7;
         this._primaryImmolation.tbxCount.alpha = 0;
         PositionUtils.setPos(this._primaryImmolation,"home.temple.levle.primaryImmolationPos");
         addChild(this._primaryImmolation);
         this._primaryImmolation.buttonMode = true;
         this._highImmolation = new BagCell(1,ItemManager.Instance.getTemplateById(11177),true);
         this._highImmolation.scaleX = 0.7;
         this._highImmolation.scaleY = 0.7;
         this._highImmolation.tbxCount.alpha = 0;
         PositionUtils.setPos(this._highImmolation,"home.temple.levle.highImmolationPos");
         addChild(this._highImmolation);
         this._highImmolation.buttonMode = true;
         this._item1Txt = ComponentFactory.Instance.creat("homeTemple.item1.txt");
         this._item1Txt.text = "000";
         addChild(this._item1Txt);
         this._item2Txt = ComponentFactory.Instance.creat("homeTemple.item2.txt");
         this._item2Txt.text = "000";
         addChild(this._item2Txt);
         this.setImmolationInfo();
         this._rockBuy = ComponentFactory.Instance.creatComponentByStylename("home.temple.level.buyRock");
         addChild(this._rockBuy);
         this._isInjectSelect = ComponentFactory.Instance.creatComponentByStylename("home.temple.level.isInjectSelect");
         addChild(this._isInjectSelect);
         this._immolationBtn = ComponentFactory.Instance.creatComponentByStylename("home.temple.immolationBtn");
         addChild(this._immolationBtn);
         this._immolationBtn.enable = HomeTempleController.Instance.currentInfo.CurrentLevel < HomeTempleController.MAXLEVEL ? true : false;
         this._progress = ComponentFactory.Instance.creatComponentByStylename("home.temple.levelProgress");
         this._progress.initProgress();
         addChild(this._progress);
         this._textValue = new HomeTempleTextValue();
         this._textValue.x = 449;
         this._textValue.y = -82;
         addChild(this._textValue);
         this._textValue.setPropertyValue();
         this.creatLevelMovie();
         this._currentLevelTip = ComponentFactory.Instance.creatComponentByStylename("home.temple.currentTipBtn");
         this._currentLevelTip.tipData = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.currentPropertyTxt");
         addChild(this._currentLevelTip);
         this._icon1Bmp = ComponentFactory.Instance.creatBitmap("asset.home.temple.icon1");
         PositionUtils.setPos(this._icon1Bmp,"home.temple.icon1Pos");
         addChild(this._icon1Bmp);
         this._icon2Bmp = ComponentFactory.Instance.creatBitmap("asset.home.temple.icon2");
         PositionUtils.setPos(this._icon2Bmp,"home.temple.icon2Pos");
         addChild(this._icon2Bmp);
         this._nowBmp = ComponentFactory.Instance.creatBitmap("asset.home.temple.now");
         PositionUtils.setPos(this._nowBmp,"home.temple.nowPos");
         addChild(this._nowBmp);
         this._levelLabelBmp = ComponentFactory.Instance.creatBitmap("asset.home.temple.level");
         PositionUtils.setPos(this._levelLabelBmp,"home.temple.levelLabelPos");
         addChild(this._levelLabelBmp);
         this._nums = new N_BitmapDataNumber();
         this._nums.numList = new Vector.<BitmapData>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            this._nums.numList.push(ComponentFactory.Instance.creatBitmapData("asset.home.temple.n" + _loc1_.toString()));
            _loc1_++;
         }
         this._nums.rect = new Rectangle(1,1,45,20);
         this._nums.gap = -1;
         this._levelBmp = new Bitmap(this._nums.getNumber("0"));
         PositionUtils.setPos(this._levelBmp,"home.temple.levelBmpPos");
         addChild(this._levelBmp);
         this.setLevelText();
         this.width = 268;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener("update",this.__onBagUpdate);
         this._rockBuy.addEventListener("click",this.__onBuyRockClick);
         this._isInjectSelect.addEventListener("click",this.__onInjectSelectClick);
         if(this._immolationBtn.enable)
         {
            this._immolationBtn.addEventListener("click",this.__onImmolationClick);
            this._immolationBtn.addEventListener("mouseOver",this.__onImmolationOver);
            this._immolationBtn.addEventListener("mouseOut",this.__onImmolationOut);
         }
         this._primaryImmolation.addEventListener("click",this.__onPrimaryClick);
         this._highImmolation.addEventListener("click",this.__onHighClick);
         HomeTempleController.Instance.addEventListener("homeTempleUpdateProperty",this.__onUpdateProperty);
         HomeTempleController.Instance.addEventListener("homeTempleUpdateBlessingState",this.__onUpdateBlessingState);
      }
      
      protected function __onUpdateBlessingState(param1:HomeTempleEvent) : void
      {
         this.creatLevelMovie();
      }
      
      private function creatLevelMovie() : void
      {
         if(Boolean(this._levelMovie))
         {
            removeChild(this._levelMovie);
            ObjectUtils.disposeObject(this._levelMovie);
            this._levelMovie = null;
         }
         var _loc1_:int = HomeTempleController.Instance.getStarNum();
         this._levelMovie = ComponentFactory.Instance.creat("asset.home.temple.a00" + _loc1_);
         this._levelMovie.scaleX = this._levelMovie.scaleY = 0.6;
         PositionUtils.setPos(this._levelMovie,"home.temple.levle.levelPos");
         addChild(this._levelMovie);
      }
      
      private function setImmolationInfo() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11176);
         var _loc2_:int = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11177);
         this._item1Txt.text = _loc1_.toString();
         this._item2Txt.text = _loc2_.toString();
         this._primaryImmolation.setCount(_loc1_);
         this._highImmolation.setCount(_loc2_);
         this.setSelectImagePos(_loc1_ > 0 ? this._primaryImmolation : this._highImmolation);
      }
      
      private function setSelectImagePos(param1:BagCell) : void
      {
         if(this._selectCell != param1)
         {
            this._selectCell = param1;
         }
      }
      
      protected function __onPrimaryClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.setSelectImagePos(this._primaryImmolation);
      }
      
      protected function __onHighClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.setSelectImagePos(this._highImmolation);
      }
      
      protected function __onUpdateProperty(param1:HomeTempleEvent) : void
      {
         this._textValue.setPropertyValue();
         var _loc2_:int = param1.data[0] < 6 ? int(param1.data[0]) : 5;
         var _loc3_:int = param1.data[1] < 6 ? int(param1.data[1]) : 5;
         this.playBombAnimation(_loc2_,_loc3_);
         this._progress.setProgress();
         this.setLevelText();
         this._item1Txt.text = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11176).toString();
         this._item2Txt.text = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11177).toString();
         this._primaryImmolation.setCount(PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11176));
         this._highImmolation.setCount(PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11177));
      }
      
      private function setLevelText() : void
      {
         var _loc1_:int = HomeTempleController.Instance.getStarLevelNum();
         this._levelBmp.bitmapData = this._nums.getNumber(_loc1_.toString());
      }
      
      private function playBombAnimation(param1:int, param2:int) : void
      {
         var deleteMovie:* = undefined;
         var tweenTo:* = undefined;
         var speed:Number = NaN;
         var upgrade:MovieClip = null;
         var min:int = param1;
         var max:int = param2;
         var playUpradeOver:* = function():void
         {
            playBombAnimation(min,max);
            setTimeout(tweenTo,200);
         };
         deleteMovie = function():void
         {
            if(contains(upgrade))
            {
               removeChild(upgrade);
            }
         };
         tweenTo = function():void
         {
            TweenLite.to(upgrade,speed / 2,{
               "y":0,
               "scaleX":0,
               "scaleY":0,
               "alpha":0,
               "onComplete":deleteMovie
            });
         };
         speed = 0.2;
         upgrade = ComponentFactory.Instance.creat("home.temple.upgradeAnimation");
         if(min > 0)
         {
            min--;
            upgrade.upgradeText.text = "+150%";
            addChild(upgrade);
            TweenLite.to(upgrade,speed,{
               "y":72,
               "scaleX":1.5,
               "scaleY":1.5,
               "alpha":1,
               "onComplete":playUpradeOver
            });
         }
         else if(max > 0)
         {
            max--;
            upgrade.upgradeText.text = "+200%";
            addChild(upgrade);
            TweenLite.to(upgrade,speed,{
               "y":72,
               "scaleX":1.5,
               "scaleY":1.5,
               "alpha":1,
               "onComplete":playUpradeOver
            });
         }
      }
      
      protected function __onImmolationClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(this._primaryImmolation.getCount() == 0 && this._highImmolation.getCount() == 0)
         {
            this._rockBuy.dispatchEvent(new MouseEvent("click"));
         }
         else
         {
            if(this._primaryImmolation.getCount() > 0)
            {
               this.setSelectImagePos(this._primaryImmolation);
            }
            else if(this._highImmolation.getCount() > 0)
            {
               this.setSelectImagePos(this._highImmolation);
            }
            else
            {
               _loc2_ = true;
               this._rockBuy.dispatchEvent(new MouseEvent("click"));
            }
            if(!_loc2_)
            {
               SoundManager.instance.playButtonSound();
               SocketManager.Instance.out.setHomeTempleImmolation(this._selectCell.info.TemplateID,this._isInjectSelect.selected);
            }
         }
      }
      
      protected function __onImmolationOver(param1:MouseEvent) : void
      {
         this._textValue.setPropertyValue(true);
      }
      
      protected function __onImmolationOut(param1:MouseEvent) : void
      {
         this._textValue.setPropertyValue();
      }
      
      protected function __onInjectSelectClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
      }
      
      protected function __onBuyRockClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.store.matte.itemNotBuy"));
      }
      
      protected function __onBagUpdate(param1:BagEvent) : void
      {
         this._item1Txt.text = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11176).toString();
         this._item2Txt.text = PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11177).toString();
         this._primaryImmolation.setCount(PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11176));
         this._highImmolation.setCount(PlayerManager.Instance.Self.getBag(1).getItemCountByTemplateId(11177));
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.__onBagUpdate);
         this._rockBuy.removeEventListener("click",this.__onBuyRockClick);
         this._isInjectSelect.removeEventListener("click",this.__onInjectSelectClick);
         this._immolationBtn.removeEventListener("click",this.__onImmolationClick);
         this._immolationBtn.removeEventListener("mouseOver",this.__onImmolationOver);
         this._immolationBtn.removeEventListener("mouseOut",this.__onImmolationOut);
         this._primaryImmolation.removeEventListener("click",this.__onPrimaryClick);
         this._highImmolation.removeEventListener("click",this.__onHighClick);
         HomeTempleController.Instance.removeEventListener("homeTempleUpdateProperty",this.__onUpdateProperty);
         HomeTempleController.Instance.removeEventListener("homeTempleUpdateBlessingState",this.__onUpdateBlessingState);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._item1Txt);
         this._item1Txt = null;
         ObjectUtils.disposeObject(this._item2Txt);
         this._item2Txt = null;
         ObjectUtils.disposeObject(this._icon1Bmp);
         this._icon1Bmp = null;
         ObjectUtils.disposeObject(this._icon2Bmp);
         this._icon2Bmp = null;
         ObjectUtils.disposeObject(this._nowBmp);
         this._nowBmp = null;
         ObjectUtils.disposeObject(this._levelLabelBmp);
         this._levelLabelBmp = null;
         ObjectUtils.disposeObject(this._nums);
         this._nums = null;
         ObjectUtils.disposeObject(this._levelBmp);
         this._levelBmp = null;
         ObjectUtils.disposeObject(this._rockBuy);
         this._rockBuy = null;
         ObjectUtils.disposeObject(this._isInjectSelect);
         this._isInjectSelect = null;
         ObjectUtils.disposeObject(this._immolationBtn);
         this._immolationBtn = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._textValue);
         this._textValue = null;
         ObjectUtils.disposeObject(this._levelMovie);
         this._levelMovie = null;
         ObjectUtils.disposeObject(this._currentLevelTip);
         this._currentLevelTip = null;
      }
   }
}

