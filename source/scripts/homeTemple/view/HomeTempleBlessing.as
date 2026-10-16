package homeTemple.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import homeTemple.HomeTempleController;
   import homeTemple.data.HomeTempleModel;
   import homeTemple.event.HomeTempleEvent;
   
   public class HomeTempleBlessing extends Sprite implements Disposeable
   {
      
      public static var StartNum:int = 0;
      
      private var _bloodText:FilterFrameText;
      
      private var _defenseText:FilterFrameText;
      
      private var _attackText:FilterFrameText;
      
      private var _armorText:FilterFrameText;
      
      private var _agilityText:FilterFrameText;
      
      private var _luckyText:FilterFrameText;
      
      private var _leftBtn:BaseButton;
      
      private var _rightBtn:BaseButton;
      
      private var _blessSprite:Sprite;
      
      private var _blessList:Vector.<HomeTempleBlessItem>;
      
      private var _tipBtnVec:Vector.<BaseButton>;
      
      private var _blessPosArr:Array = [PositionUtils.creatPoint("home.temple.bless.blessPos0"),PositionUtils.creatPoint("home.temple.bless.blessPos1"),PositionUtils.creatPoint("home.temple.bless.blessPos2"),PositionUtils.creatPoint("home.temple.bless.blessPos3"),PositionUtils.creatPoint("home.temple.bless.blessPos4"),PositionUtils.creatPoint("home.temple.bless.blessPos5")];
      
      public function HomeTempleBlessing()
      {
         super();
         this._blessList = new Vector.<HomeTempleBlessItem>(6);
         this._tipBtnVec = new Vector.<BaseButton>();
         StartNum = HomeTempleController.Instance.currentInfo.CurrentSelectIndex;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.x = -45;
         this.y = -89;
         this._blessSprite = new Sprite();
         PositionUtils.setPos(this._blessSprite,"home.temple.blessViewPos");
         addChild(this._blessSprite);
         this.creatBless();
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("home.temple.leftBtn");
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("home.temple.rightBtn");
         addChild(this._rightBtn);
         this._bloodText = ComponentFactory.Instance.creatComponentByStylename("home.temple.bloodText");
         addChild(this._bloodText);
         this._defenseText = ComponentFactory.Instance.creatComponentByStylename("home.temple.defenseText");
         addChild(this._defenseText);
         this._attackText = ComponentFactory.Instance.creatComponentByStylename("home.temple.attackText");
         addChild(this._attackText);
         this._luckyText = ComponentFactory.Instance.creatComponentByStylename("home.temple.luckyText");
         addChild(this._luckyText);
         this._agilityText = ComponentFactory.Instance.creatComponentByStylename("home.temple.resistanceText");
         addChild(this._agilityText);
         this._armorText = ComponentFactory.Instance.creatComponentByStylename("home.temple.armorText");
         addChild(this._armorText);
         this.setTextInfo();
         this.creatTipBtn();
         this.width = 505;
      }
      
      private function creatTipBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("home.temple.rectTipBtn");
            _loc2_.tipData = LanguageMgr.GetTranslation("home.temple.rectTipText0");
            PositionUtils.setPos(_loc2_,"home.temple.rectTipBtnPos" + _loc1_);
            addChild(_loc2_);
            this._tipBtnVec.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function setTextInfo() : void
      {
         var _loc1_:HomeTempleModel = HomeTempleController.Instance.getPropertyInfoByIndex(StartNum);
         this._bloodText.text = LanguageMgr.GetTranslation("MaxHp") + ":" + _loc1_.Blood.toString();
         this._defenseText.text = LanguageMgr.GetTranslation("defence") + ":" + _loc1_.Defence.toString();
         this._attackText.text = LanguageMgr.GetTranslation("attack") + ":" + _loc1_.Attack.toString();
         this._luckyText.text = LanguageMgr.GetTranslation("luck") + ":" + _loc1_.Luck.toString();
         this._agilityText.text = LanguageMgr.GetTranslation("agility") + _loc1_.Agility.toString();
         this._armorText.text = LanguageMgr.GetTranslation("recovery") + ":" + _loc1_.Guard.toString();
      }
      
      private function initEvent() : void
      {
         this._leftBtn.addEventListener("click",this.__onLeftBtnClick);
         this._rightBtn.addEventListener("click",this.__onRightBtnClick);
         HomeTempleController.Instance.addEventListener("homeTempleUpdateBlessingState",this.__onUpdateBlessingState);
      }
      
      protected function __onUpdateBlessingState(param1:HomeTempleEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            if(_loc2_ >= HomeTempleController.Instance.getStarNum())
            {
               this._blessList[_loc2_].filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               this._blessList[_loc2_].filters = null;
            }
            _loc2_++;
         }
         this.updateBlessPos();
      }
      
      private function creatBless() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new HomeTempleBlessItem(_loc1_);
            _loc2_.blessBtn.addEventListener("click",this.__onBlessClick);
            _loc3_ = this.getPosIndex(_loc1_);
            PositionUtils.setPos(_loc2_,this._blessPosArr[_loc3_]);
            _loc2_.blessMovie.scaleX = _loc2_.blessMovie.scaleY = _loc3_ == 0 ? 1.2 : 0.8;
            if(_loc1_ >= HomeTempleController.Instance.getStarNum())
            {
               _loc2_.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               _loc2_.filters = null;
            }
            this._blessList[_loc1_] = _loc2_;
            this._blessSprite.addChild(this._blessList[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function __onBlessClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._blessList.length)
         {
            if(this._blessList[_loc2_].blessBtn == param1.currentTarget)
            {
               StartNum = _loc2_ + 1;
               break;
            }
            _loc2_++;
         }
         this.updateBlessPos();
      }
      
      public function resetBlessingPos() : void
      {
         StartNum = HomeTempleController.Instance.currentInfo.CurrentSelectIndex;
         this.updateBlessPos();
      }
      
      private function updateBlessPos() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.getPosIndex(_loc1_);
            _loc3_ = this._blessPosArr[_loc2_];
            _loc4_ = _loc2_ == 0 ? 1.2 : 0.8;
            TweenLite.to(this._blessList[_loc1_],1,{
               "x":_loc3_.x,
               "y":_loc3_.y
            });
            TweenLite.to(this._blessList[_loc1_].blessMovie,1,{
               "scaleX":_loc4_,
               "scaleY":_loc4_
            });
            _loc1_++;
         }
         this.setTextInfo();
         this.updateTipBtn();
      }
      
      private function updateTipBtn() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this._tipBtnVec[_loc1_].tipData = LanguageMgr.GetTranslation("home.temple.rectTipText" + Math.max(StartNum - 1,0).toString());
            _loc1_++;
         }
      }
      
      private function getPosIndex(param1:int) : int
      {
         var _loc2_:int = StartNum == 0 ? 1 : StartNum;
         var _loc3_:int = param1 + 1 - _loc2_;
         if(_loc3_ < 0)
         {
            _loc3_ += 6;
         }
         else if(_loc3_ > 5)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      protected function __onLeftBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         --StartNum;
         if(StartNum < 1)
         {
            StartNum = 6;
         }
         this.updateBlessPos();
      }
      
      protected function __onRightBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ++StartNum;
         if(StartNum > 6)
         {
            StartNum = 1;
         }
         this.updateBlessPos();
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener("click",this.__onLeftBtnClick);
         this._rightBtn.removeEventListener("click",this.__onRightBtnClick);
         HomeTempleController.Instance.removeEventListener("homeTempleUpdateBlessingState",this.__onUpdateBlessingState);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.removeEvent();
         ObjectUtils.disposeObject(this._leftBtn);
         this._leftBtn = null;
         ObjectUtils.disposeObject(this._rightBtn);
         this._rightBtn = null;
         _loc1_ = 0;
         while(_loc1_ < this._blessList.length)
         {
            this._blessList[_loc1_].blessBtn.removeEventListener("click",this.__onBlessClick);
            ObjectUtils.disposeObject(this._blessList[_loc1_]);
            this._blessList[_loc1_] = null;
            _loc1_++;
         }
         this._blessList = null;
         _loc2_ = 0;
         while(_loc2_ < this._tipBtnVec.length)
         {
            ObjectUtils.disposeObject(this._tipBtnVec[_loc2_]);
            this._tipBtnVec[_loc2_] = null;
            _loc2_++;
         }
         this._tipBtnVec = null;
         ObjectUtils.disposeObject(this._bloodText);
         this._bloodText = null;
         ObjectUtils.disposeObject(this._defenseText);
         this._defenseText = null;
         ObjectUtils.disposeObject(this._attackText);
         this._attackText = null;
         ObjectUtils.disposeObject(this._armorText);
         this._armorText = null;
         ObjectUtils.disposeObject(this._agilityText);
         this._agilityText = null;
         ObjectUtils.disposeObject(this._luckyText);
         this._luckyText = null;
      }
   }
}

