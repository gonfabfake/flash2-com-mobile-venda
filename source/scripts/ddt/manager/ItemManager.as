package ddt.manager
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.analyze.EquipSuitTempleteAnalyzer;
   import ddt.data.analyze.GoodCategoryAnalyzer;
   import ddt.data.analyze.ItemTempleteAnalyzer;
   import ddt.data.analyze.SuitTemplateAnalyzer;
   import ddt.data.goods.CateCoryInfo;
   import ddt.data.goods.EquipSuitTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.SuitTemplateInfo;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   [Event(name="templateReady",type="flash.events.Event")]
   public class ItemManager extends EventDispatcher
   {
      
      private static var _instance:ItemManager;
      
      private var _categorys:Vector.<CateCoryInfo>;
      
      private var _goodsTemplates:DictionaryData;
      
      private var _storeCateCory:Array;
      
      private var _SuitTemplates:Dictionary;
      
      private var _EquipSuit:Dictionary;
      
      private var _EquipTemplates:Dictionary;
      
      public function ItemManager()
      {
         super();
      }
      
      public static function fill(param1:InventoryItemInfo) : InventoryItemInfo
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         ObjectUtils.copyProperties(param1,_loc2_);
         return param1;
      }
      
      public static function get Instance() : ItemManager
      {
         if(_instance == null)
         {
            _instance = new ItemManager();
         }
         return _instance;
      }
      
      public static function copy(param1:InventoryItemInfo) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc2_,param1);
         return _loc2_;
      }
      
      public static function fillByID(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc2_,ItemManager.Instance.getTemplateById(param1));
         return _loc2_;
      }
      
      public function setupGoodsTemplates(param1:ItemTempleteAnalyzer) : void
      {
         this._goodsTemplates = param1.list;
      }
      
      public function setupGoodsCategory(param1:GoodCategoryAnalyzer) : void
      {
         this._categorys = param1.list;
      }
      
      public function getTemplateById(param1:int) : ItemTemplateInfo
      {
         return this._goodsTemplates[param1];
      }
      
      public function get categorys() : Vector.<CateCoryInfo>
      {
         return this._categorys.slice(0);
      }
      
      public function get storeCateCory() : Array
      {
         return this._storeCateCory;
      }
      
      public function set storeCateCory(param1:Array) : void
      {
         this._storeCateCory = param1;
      }
      
      public function get goodsTemplates() : DictionaryData
      {
         return this._goodsTemplates;
      }
      
      public function getFreeTemplateByCategoryId(param1:int, param2:int = 0) : ItemTemplateInfo
      {
         if(param1 != EquipType.ARM)
         {
            return this.getTemplateById(Number(String(param1) + String(param2) + "01"));
         }
         return this.getTemplateById(Number(String(param1) + "00" + String(param2)));
      }
      
      public function searchGoodsNameByStr(param1:String) : Array
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         for each(_loc2_ in this._goodsTemplates)
         {
            if(_loc2_.Name.indexOf(param1) > -1)
            {
               if(_loc4_.length == 0)
               {
                  _loc4_.push(_loc2_.Name);
               }
               else
               {
                  _loc3_ = 0;
                  while(true)
                  {
                     if(_loc3_ >= _loc4_.length)
                     {
                        break;
                     }
                     if(_loc4_[_loc3_] == _loc2_.Name)
                     {
                        break;
                     }
                     if(_loc3_ == _loc4_.length - 1)
                     {
                        _loc4_.push(_loc2_.Name);
                     }
                     _loc3_++;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public function setupSuitTemplates(param1:SuitTemplateAnalyzer) : void
      {
         this._SuitTemplates = param1.list;
      }
      
      public function setupEquipSuitTemplates(param1:EquipSuitTempleteAnalyzer) : void
      {
         this._EquipSuit = param1.dic;
         this._EquipTemplates = param1.data;
      }
      
      public function get EquipSuit() : Dictionary
      {
         return this._EquipSuit;
      }
      
      public function getSuitTemplateByID(param1:String) : SuitTemplateInfo
      {
         return this._SuitTemplates[param1];
      }
      
      public function getEquipSuitbyContainEquip(param1:String) : EquipSuitTemplateInfo
      {
         return this._EquipTemplates[param1];
      }
      
      public function addGoodsTemplates(param1:ItemTempleteAnalyzer) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         for each(_loc2_ in param1.list)
         {
            if(!this._goodsTemplates.hasKey(_loc2_.TemplateID))
            {
               this._goodsTemplates.add(_loc2_.TemplateID,_loc2_);
            }
            else
            {
               this._goodsTemplates[_loc2_.TemplateID] = _loc2_;
            }
         }
      }
      
      public function getPropByTypeAndPro() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this._goodsTemplates)
         {
            if(_loc2_.CategoryID == 10 && _loc2_.Property8 == "1")
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
   }
}

