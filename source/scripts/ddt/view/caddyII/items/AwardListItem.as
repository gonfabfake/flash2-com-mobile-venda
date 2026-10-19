package ddt.view.caddyII.items
{
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AwardListItem extends Sprite implements Disposeable
   {
      
      private var _userNameTxt:FilterFrameText;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _bitMapTxt:FilterFrameText;
      
      private var _bitMap:Bitmap;
      
      private var _content:Sprite;
      
      private var _bg:ScaleFrameImage;
      
      public function AwardListItem()
      {
         super();
      }
      
      public function initView(param1:String, param2:String, param3:String, param4:int) : void
      {
         var _loc5_:Bitmap = null;
         var _loc6_:Bitmap = null;
         _loc5_ = null;
         _loc6_ = null;
         _loc5_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc5_.x = 128;
         _loc5_.y = 1;
         _loc6_ = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         _loc6_.x = 288;
         _loc6_.y = 1;
         this._bg = ComponentFactory.Instance.creat("caddy.badLuck.paihangItemBG");
         this._bg.setFrame(param4 % 2 + 1);
         this._bg.width = 580;
         this._bg.height = 31;
         addChild(this._bg);
         if(param4 > 3)
         {
            this._bitMapTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.numbTxt");
            this._bitMapTxt.x = 54;
            this._bitMapTxt.y = 6;
            this._bitMapTxt.text = param4 + "th";
            addChild(this._bitMapTxt);
            this._bitMapTxt.visible = false;
         }
         else
         {
            this._bitMap = ComponentFactory.Instance.creatBitmap("asset.awardSystem.th" + param4);
            this._bitMap.x = 45;
            this._bitMap.y = 2;
            addChild(this._bitMap);
            this._bitMap.visible = false;
         }
         this._userNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.userNameTxt");
         this._userNameTxt.x = 130;
         this._userNameTxt.y = 5;
         this._userNameTxt.text = param1;
         addChild(this._userNameTxt);
         this._userNameTxt.visible = false;
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsNametxt");
         this._goodsNameTxt.text = param2;
         this._goodsNameTxt.x = 290;
         this._goodsNameTxt.y = 5;
         addChild(this._goodsNameTxt);
         this._goodsNameTxt.visible = false;
         addChild(_loc5_);
         addChild(_loc6_);
      }
      
      public function upDataUserName(param1:Object) : void
      {
         var _loc2_:InventoryItemInfo = null;
         _loc2_ = null;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:PersonalInfoCell = null;
         if(Boolean(this._userNameTxt))
         {
            if(Boolean(this._bitMapTxt))
            {
               this._bitMapTxt.visible = true;
            }
            if(Boolean(this._bitMap))
            {
               this._bitMap.visible = true;
            }
            this._userNameTxt.visible = true;
            this._goodsNameTxt.visible = true;
            if(Boolean(param1["Nickname"]))
            {
               this._userNameTxt.text = param1["Nickname"];
            }
            _loc2_ = new InventoryItemInfo();
            _loc3_ = ItemManager.Instance.getTemplateById(param1["TemplateID"]);
            ObjectUtils.copyProperties(_loc2_,_loc3_);
            _loc2_.IsBinds = param1.IsBinds;
            _loc2_.ValidDate = param1.ValidDate;
            _loc2_.StrengthenLevel = param1.StrengthenLevel;
            _loc2_.AttackCompose = param1.AttackCompose;
            _loc2_.DefendCompose = param1.DefendCompose;
            _loc2_.AgilityCompose = param1.AgilityCompose;
            _loc2_.LuckCompose = param1.LuckCompose;
            _loc2_.Count = param1.Count;
            if(Boolean(param1))
            {
               _loc4_ = new PersonalInfoCell();
               _loc4_.x = 530;
               _loc4_.y = 4;
               _loc4_.tipGapH = -10;
               _loc4_.tipGapV = -40;
               _loc4_.scaleX = _loc4_.scaleY = 0.5;
               _loc4_.info = _loc2_;
               if(param1["count"] != 0)
               {
                  this._goodsNameTxt.text = _loc4_.info.Name + "x" + param1["count"];
               }
               else
               {
                  this._goodsNameTxt.text = _loc4_.info.Name;
               }
               this._goodsNameTxt.text = _loc4_.info.Name;
               addChild(_loc4_);
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._userNameTxt = null;
         this._goodsNameTxt = null;
         this._bitMapTxt = null;
         this._content = null;
         this._bitMap = null;
         this._bg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

