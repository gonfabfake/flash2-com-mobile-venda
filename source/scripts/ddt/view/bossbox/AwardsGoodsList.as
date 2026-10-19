package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   
   public class AwardsGoodsList extends Sprite implements Disposeable
   {
      
      private var _goodsList:Array;
      
      private var _list:SimpleTileList;
      
      private var panel:ScrollPanel;
      
      private var _cells:Array;
      
      public function AwardsGoodsList()
      {
         super();
         this.initList();
      }
      
      protected function initList() : void
      {
         this._list = new SimpleTileList(2);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this.panel = ComponentFactory.Instance.creat("TimeBoxScrollpanel");
         addChild(this.panel);
      }
      
      public function show(param1:Array) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:int = 0;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:BoxAwardsCell = null;
         var _loc6_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.beginChanges();
         var _loc7_:int = 0;
         while(_loc7_ < this._goodsList.length)
         {
            _loc3_ = 0;
            if(this._goodsList[_loc7_] is InventoryItemInfo)
            {
               _loc4_ = this._goodsList[_loc7_];
               _loc4_.IsJudge = true;
            }
            else if(this._goodsList[_loc7_] is BoxGoodsTempInfo)
            {
               _loc6_ = this._goodsList[_loc7_] as BoxGoodsTempInfo;
               _loc4_ = this.getTemplateInfo(_loc6_.TemplateId) as InventoryItemInfo;
               _loc4_.IsBinds = _loc6_.IsBind;
               _loc4_.LuckCompose = _loc6_.LuckCompose;
               _loc4_.DefendCompose = _loc6_.DefendCompose;
               _loc4_.AttackCompose = _loc6_.AttackCompose;
               _loc4_.AgilityCompose = _loc6_.AgilityCompose;
               _loc4_.StrengthenLevel = _loc6_.StrengthenLevel;
               _loc4_.ValidDate = _loc6_.ItemValid;
               _loc4_.IsJudge = true;
               _loc4_.Count = _loc6_.ItemCount;
            }
            else if(this._goodsList[_loc7_] is ItemTemplateInfo)
            {
               _loc2_ = this._goodsList[_loc7_] as ItemTemplateInfo;
            }
            else
            {
               _loc2_ = this._goodsList[_loc7_].info;
               _loc3_ = int(this._goodsList[_loc7_].count);
            }
            if(_loc4_ != null)
            {
               _loc2_ = _loc4_;
            }
            _loc5_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            _loc5_.info = _loc2_;
            if(_loc2_.hasOwnProperty("Count"))
            {
               _loc5_.count = _loc2_["Count"];
            }
            else if(_loc3_ > 0)
            {
               _loc5_.count = _loc3_;
            }
            else
            {
               _loc5_.count = 1;
            }
            this._list.addChild(_loc5_);
            this._cells.push(_loc5_);
            _loc7_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = this._goodsList.length > 6 ? int(ScrollPanel.ON) : int(ScrollPanel.OFF);
         this.panel.commitChanges();
      }
      
      public function showForVipLevelUpAward(param1:Array) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:VipBoxAwardsCell = null;
         var _loc4_:BoxGoodsTempInfo = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         var _loc5_:int = 0;
         while(_loc5_ < this._goodsList.length)
         {
            if(this._goodsList[_loc5_] is InventoryItemInfo)
            {
               _loc2_ = this._goodsList[_loc5_];
               _loc2_.IsJudge = true;
            }
            else
            {
               _loc4_ = this._goodsList[_loc5_] as BoxGoodsTempInfo;
               _loc2_ = this.getTemplateInfo(_loc4_.TemplateId) as InventoryItemInfo;
               _loc2_.IsBinds = _loc4_.IsBind;
               _loc2_.LuckCompose = _loc4_.LuckCompose;
               _loc2_.DefendCompose = _loc4_.DefendCompose;
               _loc2_.AttackCompose = _loc4_.AttackCompose;
               _loc2_.AgilityCompose = _loc4_.AgilityCompose;
               _loc2_.StrengthenLevel = _loc4_.StrengthenLevel;
               _loc2_.ValidDate = _loc4_.ItemValid;
               _loc2_.IsJudge = true;
               _loc2_.Count = _loc4_.ItemCount;
            }
            _loc3_ = ComponentFactory.Instance.creatCustomObject("vip.BoxAwardsCell");
            _loc3_.info = _loc2_;
            _loc3_.count = _loc2_.Count;
            this._list.addChild(_loc3_);
            this._cells.push(_loc3_);
            _loc5_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      public function showForVipAward(param1:Array) : void
      {
         var _loc2_:BoxAwardsCell = null;
         this._goodsList = param1;
         this._cells = new Array();
         this._list.dispose();
         this._list = new SimpleTileList(3);
         this._list.vSpace = 12;
         this._list.hSpace = 110;
         this._list.beginChanges();
         var _loc3_:int = 0;
         while(_loc3_ < this._goodsList.length)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            _loc2_.mouseChildren = false;
            _loc2_.mouseEnabled = false;
            _loc2_.info = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc3_]).TemplateId);
            _loc2_.count = 1;
            _loc2_.itemName = ItemManager.Instance.getTemplateById(BoxGoodsTempInfo(this._goodsList[_loc3_]).TemplateId).Name + "X" + String(BoxGoodsTempInfo(this._goodsList[_loc3_]).ItemCount);
            this._list.addChild(_loc2_);
            this._cells.push(_loc2_);
            _loc3_++;
         }
         this._list.commitChanges();
         this.panel.beginChanges();
         this.panel.width = 488;
         this.panel.height = 178;
         this.panel.setView(this._list);
         this.panel.hScrollProxy = ScrollPanel.OFF;
         this.panel.vScrollProxy = ScrollPanel.OFF;
         this.panel.commitChanges();
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         var _loc1_:BoxAwardsCell = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.dispose();
         }
         this._cells.splice(0,this._cells.length);
         this._cells = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this.panel))
         {
            ObjectUtils.disposeObject(this.panel);
         }
         this.panel = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

