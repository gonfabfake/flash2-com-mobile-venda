package Indiana.item
{
   import Indiana.IndianaDataManager;
   import Indiana.analyzer.IndianaShopItemInfo;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public class IndianaTitleCell extends BaseCell
   {
      
      private var _infoNew:IndianaShopItemInfo;
      
      private var _selectImage:DisplayObject;
      
      public function IndianaTitleCell()
      {
         super(ComponentFactory.Instance.creatComponentByStylename("indiana.title.cell.bg"),info,true);
      }
      
      override protected function init() : void
      {
         super.init();
         overBg = ComponentFactory.Instance.creatComponentByStylename("indiana.title.cellLight");
         this._selectImage = ComponentFactory.Instance.creatComponentByStylename("indiana.title.cellLight");
         this._selectImage.visible = false;
         addChild(this._selectImage);
      }
      
      public function set Info(param1:IndianaShopItemInfo) : void
      {
         if(Boolean(this._infoNew))
         {
            clearCreatingContent();
         }
         this._infoNew = param1;
         info = IndianaDataManager.instance.getTemplatesByShopId(this._infoNew.ShopId);
         setChildIndex(this._selectImage,numChildren - 1);
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         if(Boolean(overBg) && !this.selected)
         {
            overBg.visible = true;
            setChildIndex(overBg,numChildren - 1);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(!this._selectImage.visible && param1)
         {
            SoundManager.instance.play("008");
         }
         this._selectImage.visible = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selectImage.visible;
      }
      
      public function get Info() : IndianaShopItemInfo
      {
         return this._infoNew;
      }
      
      override public function dispose() : void
      {
         clearLoading();
         clearCreatingContent();
         this._infoNew = null;
         ObjectUtils.disposeObject(this._selectImage);
         this._selectImage = null;
         super.dispose();
      }
   }
}

