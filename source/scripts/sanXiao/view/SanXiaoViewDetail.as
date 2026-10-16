package sanXiao.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.utils.DateUtils;
   import sanXiao.SanXiaoManager;
   
   public class SanXiaoViewDetail extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _timeRemainText:FilterFrameText;
      
      private var _detailText:FilterFrameText;
      
      private var _priseText:FilterFrameText;
      
      private var _itemList:Vector.<SXRewardItem>;
      
      private var _itemContainer:VBox;
      
      private var _scroll:ScrollPanel;
      
      public function SanXiaoViewDetail()
      {
         super();
         this.init();
         this.addEvents();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("ast.sanxiao.bg.detail");
         addChild(this._bg);
         this._timeRemainText = ComponentFactory.Instance.creat("sanxiao.storeText.Txt");
         this._timeRemainText.text = "00:00:00";
         PositionUtils.setPos(this._timeRemainText,"sanxiao.detailTimeRemain.pt");
         addChild(this._timeRemainText);
         this._detailText = ComponentFactory.Instance.creat("sanxiao.storeText.Txt");
         this._detailText.text = "测试";
         PositionUtils.setPos(this._detailText,"sanxiao.detailDescribe.pt");
         addChild(this._detailText);
         this._priseText = ComponentFactory.Instance.creat("sanxiao.storeItemPrice.Txt");
         this._priseText.text = "000";
         PositionUtils.setPos(this._priseText,"sanxiao.detailPriseScore.pt");
         addChild(this._priseText);
         this._itemList = new Vector.<SXRewardItem>();
         this._itemContainer = new VBox();
         this._itemContainer.spacing = 0;
         var _loc3_:Array = SanXiaoManager.getInstance().scoreRewardList;
         var _loc4_:int = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = new SXRewardItem();
            _loc2_.update(_loc3_[_loc1_]);
            this._itemContainer.addChild(_loc2_);
            this._itemList.push(_loc2_);
            _loc1_++;
         }
         this._itemContainer.arrange();
         this._scroll = ComponentFactory.Instance.creatComponentByStylename("sanxiao.Detail.scrollList");
         this._scroll.setView(this._itemContainer);
         addChild(this._scroll);
      }
      
      private function addEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         this._timeRemainText.text = DateUtils.dateFormat(SanXiaoManager.getInstance().endTime);
         this._detailText.text = LanguageMgr.GetTranslation("sanxiao.detailDescribe");
         this._priseText.text = SanXiaoManager.getInstance().score.toString();
         var _loc2_:Array = SanXiaoManager.getInstance().scoreRewardList;
         var _loc3_:int = int(this._itemList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this._itemList[_loc1_].update(_loc2_[_loc1_]);
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemList))
         {
            this._itemList.length = 0;
            this._itemList = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._scroll = null;
         this._itemContainer = null;
         this._timeRemainText = null;
         this._detailText = null;
         this._priseText = null;
      }
   }
}

