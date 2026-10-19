package sanXiao.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sanXiao.SanXiaoManager;
   import sanXiao.model.SXRewardItemData;
   
   public class SXRewardItem extends Sprite implements Disposeable
   {
      
      private var _data:SXRewardItemData;
      
      private var _scoreNeededText:FilterFrameText;
      
      private var _priseItem:BagCell;
      
      private var _btnGainPrise:SimpleBitmapButton;
      
      private var _gainedBmp:Bitmap;
      
      public function SXRewardItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._scoreNeededText = ComponentFactory.Instance.creat("sanxiao.storeItemPrice.Txt");
         PositionUtils.setPos(this._scoreNeededText,"sanxiao.detailItemScore.pt");
         addChild(this._scoreNeededText);
         this._priseItem = new BagCell(0);
         PositionUtils.setPos(this._priseItem,"sanxiao.detailItemBagCell.pt");
         addChild(this._priseItem);
         this._btnGainPrise = ComponentFactory.Instance.creat("sanxiao.gainPrise.btn");
         this._btnGainPrise.addEventListener("click",this.onGainPriseClick);
         addChild(this._btnGainPrise);
         this._gainedBmp = ComponentFactory.Instance.creatBitmap("ast.sanxiao.gainedBmp");
         this._gainedBmp.x = this._btnGainPrise.x + (this._btnGainPrise.width - this._gainedBmp.width) * 0.5;
         this._gainedBmp.y = this._btnGainPrise.y + (this._btnGainPrise.height - this._gainedBmp.height) * 0.5;
      }
      
      protected function onGainPriseClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._data == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         GameInSocketOut.sendSXGainPrise(this._data.id);
      }
      
      public function update(param1:Object) : void
      {
         var _loc2_:InventoryItemInfo = null;
         this._data = param1 as SXRewardItemData;
         _loc2_ = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc2_,ItemManager.Instance.getTemplateById(this._data.TempleteID));
         _loc2_.ValidDate = this._data.Valid;
         _loc2_.Count = this._data.count;
         _loc2_.Property5 = "1";
         _loc2_.IsBinds = this._data.isBind;
         this._priseItem.info = _loc2_;
         this._priseItem.setCount(_loc2_.Count);
         this._scoreNeededText.text = this._data.point.toString();
         this._btnGainPrise.enable = SanXiaoManager.getInstance().score >= this._data.point && !this._data.gained;
         if(this._data.gained)
         {
            addChild(this._gainedBmp);
            this._btnGainPrise.parent && removeChild(this._btnGainPrise);
         }
         else
         {
            this._gainedBmp.parent && removeChild(this._gainedBmp);
            addChild(this._btnGainPrise);
         }
      }
      
      override public function get height() : Number
      {
         return 45;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._btnGainPrise))
         {
            this._btnGainPrise.removeEventListener("click",this.onGainPriseClick);
         }
         ObjectUtils.disposeAllChildren(this);
         this._scoreNeededText = null;
         this._priseItem = null;
         this._btnGainPrise = null;
         this._gainedBmp = null;
      }
   }
}

