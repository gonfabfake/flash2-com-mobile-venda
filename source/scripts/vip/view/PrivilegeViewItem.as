package vip.view
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PrivilegeViewItem extends Sprite implements Disposeable
   {
      
      public static const TRUE_FLASE_TYPE:int = 0;
      
      public static const UNIT_TYPE:int = 1;
      
      public static const GRAPHICS_TYPE:int = 2;
      
      public static const NORMAL_TYPE:int = 3;
      
      public static const ICON_TYPE:int = 4;
      
      public static const GOODS_TYPE:int = 5;
      
      private var _bg:Image;
      
      private var _seperators:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _content:Vector.<String>;
      
      private var _displayContent:Vector.<DisplayObject>;
      
      private var _itemType:int;
      
      private var _extraDisplayObject:*;
      
      private var _extraDisplayObjectList:Vector.<DisplayObject>;
      
      private var _interceptor:Function;
      
      private var _analyzeFunction:Function;
      
      private var _crossFilter:String = "0";
      
      public function PrivilegeViewItem(param1:int = 3, param2:* = null)
      {
         super();
         this._itemType = param1;
         this._extraDisplayObject = param2;
         this._extraDisplayObjectList = new Vector.<DisplayObject>();
         this._analyzeFunction = this.analyzeContent;
         if(this._itemType == 4)
         {
            this._analyzeFunction = this.analyzeContentForTypeIcon;
         }
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemBg");
         this._seperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemSeperators");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTitleTxt");
         addChild(this._bg);
         addChild(this._seperators);
         addChild(this._titleTxt);
      }
      
      protected function analyzeContentForTypeIcon(param1:Array) : Vector.<DisplayObject>
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc8_:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos2");
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_] as ItemTemplateInfo;
            _loc5_ = _loc4_ + 1;
            _loc3_ = ComponentFactory.Instance.creat("vip.reward.lv" + _loc5_);
            _loc6_ = new BaseCell(_loc3_);
            _loc6_.info = _loc2_;
            _loc6_.getContent().visible = false;
            PositionUtils.setPos(_loc6_,_loc8_);
            _loc8_.x += _loc6_.width + 7;
            _loc7_.push(_loc6_);
            _loc4_++;
         }
         return _loc7_;
      }
      
      protected function analyzeContent(param1:Vector.<String>) : Vector.<DisplayObject>
      {
         var _loc11_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc10_:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos");
         for each(_loc11_ in param1)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTxt");
            _loc2_.text = this._interceptor == null ? _loc11_ : this._interceptor(_loc11_);
            PositionUtils.setPos(_loc2_,_loc10_);
            _loc10_.x += _loc2_.width + 5;
            if(_loc11_ == this._crossFilter)
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
               _loc3_.x = _loc2_.width - _loc3_.width + _loc2_.x;
               _loc3_.y = _loc2_.y;
               _loc9_.push(_loc3_);
            }
            else
            {
               switch(this._itemType)
               {
                  case 0:
                     _loc4_ = _loc11_ == "1" ? ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.Tick") : ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
                     _loc4_.x = _loc2_.width - _loc4_.width + _loc2_.x;
                     _loc4_.y = _loc2_.y;
                     _loc9_.push(_loc4_);
                     break;
                  case 1:
                     _loc2_.text += this._extraDisplayObject;
                     break;
                  case 2:
                     _loc5_ = new Sprite();
                     _loc6_ = ComponentFactory.Instance.creatBitmap(this._extraDisplayObject);
                     this._extraDisplayObjectList.push(_loc6_);
                     this._extraDisplayObjectList.push(_loc2_);
                     _loc2_.width -= _loc6_.width;
                     _loc6_.x = _loc2_.width + _loc2_.x;
                     _loc6_.y = _loc2_.y;
                     _loc5_.addChild(_loc2_);
                     _loc5_.addChild(_loc6_);
                     _loc9_.push(_loc5_);
                     break;
                  case 5:
                     _loc7_ = ItemManager.fillByID(int(_loc11_));
                     _loc7_.IsBinds = true;
                     _loc8_ = new BagCell(0);
                     _loc8_.info = _loc7_;
                     _loc8_.setCountNotVisible();
                     _loc8_.width = _loc8_.height = 30;
                     _loc8_.x = _loc2_.width - 32 + _loc2_.x;
                     _loc8_.y = 2;
                     _loc9_.push(_loc8_);
               }
               _loc9_.push(_loc2_);
            }
         }
         return _loc9_;
      }
      
      public function set crossFilter(param1:String) : void
      {
         this._crossFilter = param1;
      }
      
      public function set contentInterceptor(param1:Function) : void
      {
         this._interceptor = param1;
      }
      
      public function set itemTitleText(param1:String) : void
      {
         this._titleTxt.text = param1;
         if(this._titleTxt.textHeight > 20)
         {
            this._titleTxt.y = 2;
         }
      }
      
      public function set analyzeFunction(param1:Function) : void
      {
         this._analyzeFunction = param1;
      }
      
      public function set itemContent(param1:Vector.<String>) : void
      {
         this._content = param1;
         this._displayContent = this._analyzeFunction(this._content);
         this.updateView();
      }
      
      public function set itemContentForIcontype(param1:Array) : void
      {
         this._displayContent = this._analyzeFunction(param1);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._displayContent)
         {
            addChild(_loc1_);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._displayContent != null)
         {
            for each(_loc2_ in this._displayContent)
            {
               ObjectUtils.disposeObject(_loc2_);
            }
         }
         this._displayContent = null;
         for each(_loc1_ in this._extraDisplayObjectList)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._extraDisplayObjectList = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._seperators);
         ObjectUtils.disposeObject(this._titleTxt);
         this._bg = null;
         this._seperators = null;
         this._titleTxt = null;
      }
   }
}

