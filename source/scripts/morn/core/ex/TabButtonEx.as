package morn.core.ex
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import morn.core.components.Component;
   import morn.core.components.ISelect;
   import morn.core.components.Image;
   import morn.core.components.Label;
   import morn.core.components.Styles;
   import morn.core.events.UIEvent;
   import morn.core.handlers.Handler;
   import morn.core.utils.ObjectUtils;
   import morn.core.utils.StringUtils;
   
   public class TabButtonEx extends Component implements ISelect
   {
      
      protected var _selected:Boolean;
      
      protected var _clickHandler:Handler;
      
      protected var _tabItemBg:Image;
      
      protected var _bgSizeGrid:String = "";
      
      protected var _tabItemBg2:Image;
      
      protected var _offsets:Array;
      
      protected var _rects:Array;
      
      protected var _skin:String;
      
      protected var _skins:Array;
      
      protected var _toggle:Boolean;
      
      protected var _lastClickTime:int;
      
      protected var _clickInterval:int;
      
      protected var _showClickTooQuickTip:Boolean = false;
      
      protected var _enableRollOverLightEffect:Boolean = true;
      
      protected var _btnLabel:Label;
      
      protected var _labelMargin:Array;
      
      protected var _labelColors:Array = Styles.buttonLabelColors;
      
      protected var _autoSize:Boolean = true;
      
      public function TabButtonEx()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         addChild(this._tabItemBg = new Image());
         addChild(this._tabItemBg2 = new Image());
         addChild(this._btnLabel = new Label());
      }
      
      override protected function initialize() : void
      {
         this._btnLabel.align = "center";
         addEventListener("rollOver",this.onMouse);
         addEventListener("rollOut",this.onMouse);
         addEventListener("click",this.onMouse);
         addEventListener("mouseUp",this.onMouse);
         buttonMode = true;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get tabItemBg() : Image
      {
         return this._tabItemBg;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            if(this._selected == false)
            {
               filters = null;
            }
            callLater(this.changeState);
         }
      }
      
      public function set bgSizeGrid(param1:String) : void
      {
         if(this._bgSizeGrid != param1)
         {
            this._bgSizeGrid = param1;
            callLater(this.changeState);
         }
      }
      
      public function set rects(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(param1 == null || param1 == "")
         {
            this._rects = null;
         }
         else
         {
            this._rects = [];
            _loc2_ = param1.split("|");
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_.push(_loc2_[_loc4_].split(","));
               _loc4_++;
            }
            if(_loc3_.length > 2)
            {
               this._rects.push([new Rectangle(_loc3_[0][0],_loc3_[0][1],_loc3_[0][2],_loc3_[0][3]),new Rectangle(_loc3_[1][0],_loc3_[1][1],_loc3_[1][2],_loc3_[1][3])]);
               this._rects.push([new Rectangle(_loc3_[2][0],_loc3_[2][1],_loc3_[2][2],_loc3_[2][3]),new Rectangle(_loc3_[3][0],_loc3_[3][1],_loc3_[3][2],_loc3_[3][3])]);
            }
            else
            {
               this._rects.push([new Rectangle(_loc3_[0][0],_loc3_[0][1],_loc3_[0][2],_loc3_[0][3])]);
               this._rects.push([new Rectangle(_loc3_[1][0],_loc3_[1][1],_loc3_[1][2],_loc3_[1][3])]);
            }
         }
      }
      
      public function set skin(param1:String) : void
      {
         if(this._skin != param1)
         {
            this._skin = param1;
            this.changeSkins();
            callLater(this.changeState);
            callLater(this.changeLabelSize);
         }
      }
      
      protected function changeLabelSize() : void
      {
         if(this._labelMargin == null || this._labelMargin.length == 0)
         {
            this._btnLabel.width = this._tabItemBg ? this._tabItemBg.width : Number(width);
            this._btnLabel.height = this._tabItemBg ? this._tabItemBg.height : Number(height);
            this._btnLabel.x = this._btnLabel.y = 0;
         }
         else if(this._labelMargin.length == 2)
         {
            this._btnLabel.width = this._tabItemBg ? this._tabItemBg.width : Number(width);
            this._btnLabel.height = this._tabItemBg ? this._tabItemBg.height : Number(height);
            this._btnLabel.x = int(this._labelMargin[0]);
            this._btnLabel.y = int(this._labelMargin[1]);
         }
         else if(this._labelMargin.length == 4)
         {
            this._btnLabel.width = width - int(this._labelMargin[0]) - int(this._labelMargin[2]);
            this._btnLabel.height = ObjectUtils.getTextField(this._btnLabel.format).height;
            this._btnLabel.x = int(this._labelMargin[0]);
            this._btnLabel.y = (height - this._btnLabel.height) * 0.5 + int(this._labelMargin[1]) - int(this._labelMargin[3]);
         }
      }
      
      public function set labelMargin(param1:String) : void
      {
         this._labelMargin = param1.split(",");
         callLater(this.changeLabelSize);
      }
      
      public function set offsets(param1:String) : void
      {
         if(param1 == "" || param1 == null)
         {
            this._offsets = null;
         }
         else if(String(this._offsets) != param1)
         {
            this._offsets = param1.split(",");
            callLater(this.changeState);
         }
      }
      
      public function set toggle(param1:Boolean) : void
      {
         this._toggle = param1;
      }
      
      public function set showClickTooQuickTip(param1:Boolean) : void
      {
         this._showClickTooQuickTip = param1;
      }
      
      public function set enableRollOverLightEffect(param1:Boolean) : void
      {
         this._enableRollOverLightEffect = param1;
      }
      
      public function set clickInterval(param1:int) : void
      {
         this._clickInterval = param1;
      }
      
      protected function changeState() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._skins))
         {
            _loc1_ = this._selected ? 1 : 0;
            this._tabItemBg.skin = this._skins[_loc1_][0];
            if(this._bgSizeGrid != "")
            {
               this._tabItemBg.sizeGrid = this._bgSizeGrid;
            }
            if(Boolean(this._rects))
            {
               this.setRect(this._tabItemBg,this._rects[_loc1_][0]);
            }
            else
            {
               this.setRect(this._tabItemBg,null);
            }
            this._tabItemBg2.visible = this._skins[0].length == 2;
            if(this._tabItemBg2.visible)
            {
               this._tabItemBg2.skin = this._skins[_loc1_][1];
               if(Boolean(this._rects) && this._rects[_loc1_].length == 2)
               {
                  this.setRect(this._tabItemBg2,this._rects[_loc1_][1]);
               }
               else if(Boolean(this._offsets))
               {
                  this._tabItemBg2.x = int(this._offsets[0]);
                  this._tabItemBg2.y = int(this._offsets[1]);
               }
               else
               {
                  this.setRect(this._tabItemBg2,null);
               }
            }
            if(this._labelColors.length > 1 && this.selected)
            {
               this._btnLabel.color = this._labelColors[1];
            }
            else
            {
               this._btnLabel.color = this._labelColors[0];
            }
            this.changeLabelSize();
         }
      }
      
      private function setRect(param1:Sprite, param2:Rectangle = null) : void
      {
         var _loc3_:Rectangle = null;
         _loc3_ = param2 || new Rectangle();
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         if(Boolean(_loc3_.width))
         {
            param1.width = _loc3_.width;
         }
         if(Boolean(_loc3_.height))
         {
            param1.height = _loc3_.height;
         }
      }
      
      protected function changeSkins() : void
      {
         this._skins = [];
         var _loc1_:Array = this._skin.split(",");
         this._skins.push(_loc1_[0].split("|"));
         this._skins.push(_loc1_[1].split("|"));
      }
      
      public function get labelColors() : String
      {
         return String(this._labelColors);
      }
      
      public function set labelColors(param1:String) : void
      {
         this._labelColors = StringUtils.fillArray(this._labelColors,param1);
         callLater(this.changeState);
      }
      
      public function get clickHandler() : Handler
      {
         return this._clickHandler;
      }
      
      public function set clickHandler(param1:Handler) : void
      {
         this._clickHandler = param1;
      }
      
      protected function onMouse(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this._toggle == false && this._selected || _disabled)
         {
            return;
         }
         if(param1.type == "click")
         {
            _loc2_ = getTimer();
            if(_loc2_ - this._lastClickTime >= this._clickInterval)
            {
               this._lastClickTime = _loc2_;
               if(this._toggle)
               {
                  this.selected = !this._selected;
               }
               if(Boolean(this._clickHandler))
               {
                  this._clickHandler.execute();
               }
            }
            else if(this._showClickTooQuickTip)
            {
               App.stage.dispatchEvent(new UIEvent("APP_DDT_MSG","您点击的频率太高，请稍后再试"));
            }
            return;
         }
         if(param1.type == "rollOver")
         {
            if(this._enableRollOverLightEffect)
            {
               filters = [Styles.singleButtonFilter];
            }
         }
         else if(param1.type == "rollOut")
         {
            if(this._enableRollOverLightEffect)
            {
               filters = null;
            }
         }
      }
      
      public function get label() : String
      {
         return this._btnLabel.text;
      }
      
      public function set label(param1:String) : void
      {
         if(this._btnLabel.text != param1)
         {
            this._btnLabel.text = param1;
            callLater(this.changeState);
         }
      }
      
      public function set labelHtml(param1:String) : void
      {
         this._btnLabel.htmlText = param1;
         callLater(this.changeState);
      }
      
      public function get labelStroke() : String
      {
         return this._btnLabel.stroke;
      }
      
      public function set labelStroke(param1:String) : void
      {
         this._btnLabel.stroke = param1;
      }
      
      public function get labelSize() : Object
      {
         return this._btnLabel.size;
      }
      
      public function set labelSize(param1:Object) : void
      {
         this._btnLabel.size = param1;
         callLater(this.changeLabelSize);
      }
      
      public function get labelBold() : Object
      {
         return this._btnLabel.bold;
      }
      
      public function set labelBold(param1:Object) : void
      {
         this._btnLabel.bold = param1;
         callLater(this.changeLabelSize);
      }
      
      public function get letterSpacing() : Object
      {
         return this._btnLabel.letterSpacing;
      }
      
      public function set letterSpacing(param1:Object) : void
      {
         this._btnLabel.letterSpacing = param1;
         callLater(this.changeLabelSize);
      }
      
      public function get labelFont() : String
      {
         return this._btnLabel.font;
      }
      
      public function set labelFont(param1:String) : void
      {
         this._btnLabel.font = param1;
         callLater(this.changeLabelSize);
      }
      
      public function get labelLeading() : Object
      {
         return this._btnLabel.leading;
      }
      
      public function set labelLeading(param1:Object) : void
      {
         this._btnLabel.leading = param1;
         callLater(this.changeLabelSize);
      }
      
      public function get btnLabel() : Label
      {
         return this._btnLabel;
      }
      
      override protected function resetPosition() : void
      {
      }
      
      override public function dispose() : void
      {
         removeEventListener("rollOver",this.onMouse);
         removeEventListener("rollOut",this.onMouse);
         removeEventListener("mouseUp",this.onMouse);
         removeEventListener("click",this.onMouse);
         this._tabItemBg && this._tabItemBg.dispose();
         this._tabItemBg2 && this._tabItemBg2.dispose();
         this._btnLabel && this._btnLabel.dispose();
         super.dispose();
         this._tabItemBg = null;
         this._tabItemBg2 = null;
         this._btnLabel = null;
      }
   }
}

