package ddtKingWay.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import ddtKingWay.DDTKingWayManager;
   import flash.events.MouseEvent;
   
   public class DDTKingWayMainView extends Frame
   {
      
      private var _bg:Image;
      
      private var _bgItem:Image;
      
      private var _btnHelp:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _prevBtn:BaseButton;
      
      private var _leftView:DDTKingWayLevelView;
      
      private var _HBox:HBox;
      
      private var _item:ScaleFrameImage;
      
      private var _list:Vector.<ScaleFrameImage>;
      
      private var _index:int;
      
      private var _maxIndex:int;
      
      private var _currentGradeIndex:int;
      
      public function DDTKingWayMainView()
      {
         super();
         InviteManager.Instance.enabled = false;
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         super.init();
         this._bgItem = ComponentFactory.Instance.creatComponentByStylename("ddtKingWay.bgItem");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.MainBg");
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":756,
            "y":2
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.ddtKingWay.view.help",450,380);
         this._leftView = new DDTKingWayLevelView();
         this._index = DDTKingWayManager.instance.getPageIndexByGrade(PlayerManager.Instance.Self.Grade);
         this._currentGradeIndex = this._index + 1;
         if(PlayerManager.Instance.Self.Grade >= 70)
         {
            this._maxIndex = this._index + 1;
         }
         else
         {
            this._maxIndex = this._index + 2;
         }
         this._list = new Vector.<ScaleFrameImage>();
         _loc1_ = 0;
         while(_loc1_ <= this._maxIndex && _loc1_ < DDTKingWayManager.QUEST_LIST.length)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.levelItemBg" + (_loc1_ + 3));
            this._list[_loc1_] = _loc2_;
            _loc1_++;
         }
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("ddtKingWay.nextBtn");
         this._prevBtn = ComponentFactory.Instance.creatComponentByStylename("ddtKingWay.prevBtn");
         this._nextBtn.addEventListener("click",this.__onClickNext);
         this._prevBtn.addEventListener("click",this.__onClickPrev);
         this._HBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.levelItemhbox");
         this.updateView();
      }
      
      private function __onClickNext(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._index += 1;
         this.updateView();
      }
      
      private function __onClickPrev(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._index -= 1;
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._prevBtn.enable = true;
         this._nextBtn.enable = true;
         if(this._index == 0)
         {
            this._prevBtn.enable = false;
         }
         if(this._maxIndex == this._index + 1)
         {
            this._nextBtn.enable = false;
         }
         this._HBox.removeAllChild();
         _loc1_ = 0;
         while(_loc1_ <= this._maxIndex && _loc1_ < DDTKingWayManager.QUEST_LIST.length)
         {
            if(Math.abs(_loc1_ - this._index) <= 1)
            {
               _loc2_ = this._list[_loc1_];
               if(_loc1_ == this._index)
               {
                  _loc2_.setFrame(2);
               }
               else
               {
                  _loc2_.setFrame(1);
               }
               this._HBox.addChild(_loc2_);
            }
            _loc1_++;
         }
         this._HBox.arrange();
         if(this._index == 0)
         {
            PositionUtils.setPos(this._HBox,"asset.ddtKingWay.levelItemPos2");
         }
         else
         {
            PositionUtils.setPos(this._HBox,"asset.ddtKingWay.levelItemPos1");
         }
         if(this._currentGradeIndex <= this._index)
         {
            this._leftView.updataView(DDTKingWayManager.instance.model[DDTKingWayManager.QUEST_LIST[this._index]],false);
         }
         else
         {
            this._leftView.updataView(DDTKingWayManager.instance.model[DDTKingWayManager.QUEST_LIST[this._index]],true);
         }
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._bg))
         {
            addToContent(this._bg);
         }
         if(Boolean(this._bgItem))
         {
            addToContent(this._bgItem);
         }
         if(Boolean(this._btnHelp))
         {
            addToContent(this._btnHelp);
         }
         if(Boolean(this._HBox))
         {
            addToContent(this._HBox);
         }
         if(Boolean(this._nextBtn))
         {
            addToContent(this._nextBtn);
         }
         if(Boolean(this._prevBtn))
         {
            addToContent(this._prevBtn);
         }
         if(Boolean(this._leftView))
         {
            addToContent(this._leftView);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         InviteManager.Instance.enabled = true;
         this._nextBtn.removeEventListener("click",this.__onClickNext);
         this._prevBtn.removeEventListener("click",this.__onClickPrev);
         ObjectUtils.disposeObject(this._btnHelp);
         _loc1_ = 0;
         while(_loc1_ < this._list.length)
         {
            this._list[_loc1_].dispose();
            _loc1_++;
         }
         if(Boolean(this._HBox))
         {
            this._HBox.disposeAllChildren();
         }
         super.dispose();
         this._btnHelp = null;
         this._bg = null;
         this._bgItem = null;
         this._HBox = null;
         this._leftView = null;
      }
   }
}

