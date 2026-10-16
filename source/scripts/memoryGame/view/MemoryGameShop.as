package memoryGame.view
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
   import memoryGame.MemoryGameManager;
   import memoryGame.data.MemoryGameGoodsInfo;
   
   public class MemoryGameShop extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _timeText:FilterFrameText;
      
      private var _contentText:FilterFrameText;
      
      private var _scoreText:FilterFrameText;
      
      private var _vBox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function MemoryGameShop()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.memoryGame.shop.bg");
         addChild(this._bg);
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.dayText");
         this._timeText.text = MemoryGameManager.instance.dateToString();
         PositionUtils.setPos(this._timeText,"memoryGame.shopTimePos");
         addChild(this._timeText);
         this._contentText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.contentText");
         this._contentText.text = LanguageMgr.GetTranslation("memoryGame.shopTips");
         PositionUtils.setPos(this._contentText,"memoryGame.shopContentPos");
         addChild(this._contentText);
         this._scoreText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.scoreText");
         PositionUtils.setPos(this._scoreText,"memoryGame.shopScorePos");
         addChild(this._scoreText);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("memoryGame.scroolPanel");
         addChild(this._scrollPanel);
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("memoryGame.MemoryGameFrame.shop.vBox");
         var _loc3_:Vector.<MemoryGameGoodsInfo> = MemoryGameManager.instance.goodsList();
         var _loc4_:int = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = new MemoryGameShopItem(_loc3_[_loc1_]);
            this._vBox.addChild(_loc2_);
            _loc1_++;
         }
         this._vBox.arrange();
         this._scrollPanel.setView(this._vBox);
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         this._scoreText.text = MemoryGameManager.instance.score.toString();
         _loc1_ = 0;
         while(_loc1_ < this._vBox.numChildren)
         {
            (this._vBox.getChildAt(_loc1_) as MemoryGameShopItem).updateState();
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._vBox = null;
         this._scrollPanel = null;
      }
   }
}

