package memoryGame.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import memoryGame.MemoryGameManager;
   import memoryGame.data.MemoryGameGoodsInfo;
   
   public class MemoryGameShopItem extends Sprite implements Disposeable
   {
      
      private var _scoreText:FilterFrameText;
      
      private var _cell:BagCell;
      
      private var _info:MemoryGameGoodsInfo;
      
      private var _gainGoodsBtn:SimpleBitmapButton;
      
      private var _get:Bitmap;
      
      public function MemoryGameShopItem(param1:MemoryGameGoodsInfo)
      {
         super();
         this._info = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._scoreText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.scoreText");
         this._scoreText.text = this._info.Point.toString();
         PositionUtils.setPos(this._scoreText,"memoryGame.shopItemTextPos");
         addChild(this._scoreText);
         this._gainGoodsBtn = ComponentFactory.Instance.creatComponentByStylename("memoryGame.gainGoodsBtn");
         this._gainGoodsBtn.addEventListener("click",this.__onClick);
         addChild(this._gainGoodsBtn);
         var _loc1_:InventoryItemInfo = ItemManager.fillByID(this._info.ItemID);
         _loc1_.ValidDate = this._info.Valid;
         _loc1_.Count = this._info.Count;
         _loc1_.IsBinds = this._info.IsBind;
         this._cell = new BagCell(0);
         this._cell.info = _loc1_;
         PositionUtils.setPos(this._cell,"memoryGame.shopItemCellPos");
         addChild(this._cell);
         this._get = ComponentFactory.Instance.creatBitmap("asset.memoryGame.get");
         addChild(this._get);
      }
      
      public function updateState() : void
      {
         if(MemoryGameManager.instance.getRewardList.hasKey(this._info.ID))
         {
            this._gainGoodsBtn.visible = false;
            this._get.visible = true;
         }
         else
         {
            this._get.visible = false;
            this._gainGoodsBtn.visible = true;
            if(MemoryGameManager.instance.score >= this._info.Point)
            {
               this._gainGoodsBtn.enable = true;
            }
            else
            {
               this._gainGoodsBtn.enable = false;
            }
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(MemoryGameManager.instance.score >= this._info.Point)
         {
            this._gainGoodsBtn.visible = false;
            this._get.visible = true;
            MemoryGameManager.instance.getRewardList.add(this._info.ID,true);
            SocketManager.Instance.out.sendMemoryGameGetReward(this._info.ID);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.pointTips"));
         }
      }
      
      override public function get height() : Number
      {
         return 45;
      }
      
      public function dispose() : void
      {
         this._gainGoodsBtn.removeEventListener("click",this.__onClick);
         ObjectUtils.disposeAllChildren(this);
         this._get = null;
         this._scoreText = null;
         this._cell = null;
         this._gainGoodsBtn = null;
      }
   }
}

