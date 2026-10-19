package halloween
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class HalloweenPrizeView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _rank:FilterFrameText;
      
      private var _prize:FilterFrameText;
      
      private var vbox:VBox;
      
      public function HalloweenPrizeView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:ItemTemplateInfo = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:BagCell = null;
         this._bg = ComponentFactory.Instance.creat("asset.halloween.prize.bg");
         this._rank = ComponentFactory.Instance.creat("asset.halloween.titleName");
         this._prize = ComponentFactory.Instance.creat("asset.halloween.titleName");
         PositionUtils.setPos(this._rank,"asset.pos.title1");
         PositionUtils.setPos(this._prize,"asset.pos.title2");
         this._rank.text = LanguageMgr.GetTranslation("ddt.halloween.titleName1");
         this._prize.text = LanguageMgr.GetTranslation("ddt.halloween.titleName2");
         addChild(this._bg);
         this.vbox = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.prize.vbox");
         this.vbox.autoSize = 2;
         var _loc7_:int = 0;
         while(_loc7_ < HalloweenManager.instance.prizeArr.length)
         {
            _loc1_ = new HBox();
            _loc1_.spacing = 5;
            _loc1_.autoSize = 2;
            _loc2_ = 0;
            while(_loc2_ < HalloweenManager.instance.prizeArr[_loc7_].length)
            {
               _loc3_ = ComponentFactory.Instance.creatBitmap("asset.halloween.prize.cell");
               _loc4_ = ItemManager.Instance.getTemplateById(HalloweenManager.instance.prizeArr[_loc7_][_loc2_].templateId) as ItemTemplateInfo;
               _loc5_ = new InventoryItemInfo();
               ObjectUtils.copyProperties(_loc5_,_loc4_);
               _loc5_.ValidDate = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].validate;
               _loc5_.StrengthenLevel = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].strenthLevel;
               _loc5_.AttackCompose = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].attack;
               _loc5_.DefendCompose = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].defend;
               _loc5_.LuckCompose = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].luck;
               _loc5_.AgilityCompose = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].agility;
               _loc5_.IsBinds = HalloweenManager.instance.prizeArr[_loc7_][_loc2_].isBind;
               _loc6_ = new BagCell(_loc2_,_loc5_,false,_loc3_);
               _loc6_.setContentSize(35,35);
               _loc6_.setCount(HalloweenManager.instance.prizeArr[_loc7_][_loc2_].count);
               _loc1_.addChild(_loc6_);
               _loc2_++;
            }
            this.vbox.addChild(_loc1_);
            _loc7_++;
         }
         this.vbox.x = 167 + (218 - this.vbox.width) / 2;
         addChild(this.vbox);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._prize);
         }
         this._prize = null;
      }
   }
}

