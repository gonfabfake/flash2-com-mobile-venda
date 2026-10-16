package morn.core.ex
{
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import morn.core.components.Box;
   import morn.core.components.Button;
   import morn.core.components.Component;
   import morn.core.components.HBox;
   import morn.core.components.Image;
   import morn.core.components.Label;
   import morn.core.handlers.Handler;
   import morn.core.utils.StringUtils;
   
   public class PageNavigaterEx extends Component
   {
      
      protected static const FIRSTBUTTON_STYLE:String = "asset.ui.pageNavBtn.first2";
      
      protected static const PREVBUTTON_STYLE:String = "asset.ui.pageNavBtn.pre2";
      
      protected static const NEXTBUTTON_STYLE:String = "asset.ui.pageNavBtn.next2";
      
      protected static const LASTBUTTON_STYLE:String = "asset.ui.pageNavBtn.last2";
      
      protected static const PAGEIMG_STYLE:String = "asset.ui.combox.inputBg1";
      
      private static const FIRSTBTN_NAME:String = "firstBtn";
      
      private static const PREVBTN_NAME:String = "prevBtn";
      
      private static const NEXTBTN_NAME:String = "nextBtn";
      
      private static const LASTBTN_NAME:String = "lastBtn";
      
      protected static const PAGEBG_WIDTH:int = 50;
      
      protected static const SIMPLE:String = "simple";
      
      protected static const COMPLEXITY:String = "complexity";
      
      protected static const PAGENUM_STROKE:String = "0x000000,1,4,4,10";
      
      protected static const PAGENUM_BGSIZE:String = "80,25";
      
      protected static const PAGENUM_BGGRID:String = "5,5,10,10,0";
      
      public static var lableStyle:Array = ["Arial",14,16777215,"false",2];
      
      private var _hBox:HBox;
      
      protected const MIN_PAGE:int = 1;
      
      protected var _firstBtn:Button;
      
      protected var _prevBtn:Button;
      
      protected var _nextBtn:Button;
      
      protected var _lastBtn:Button;
      
      protected var _pageNumText:Label;
      
      protected var _pageNumBg:Image;
      
      protected var _pageNumAlign:String = "center";
      
      protected var _isLoop:Boolean = false;
      
      protected var _spacing:int;
      
      protected var _currentPage:int = 1;
      
      protected var _maxPage:int = 1;
      
      protected var _pageNumXOffset:int;
      
      protected var _pageSpri:Box;
      
      protected var _selectHandler:Handler;
      
      protected var _type:String = "complexity";
      
      public function PageNavigaterEx()
      {
         super();
      }
      
      override protected function preinitialize() : void
      {
         mouseChildren = true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addChild(this._hBox = new HBox());
         this._hBox.addChild(this._firstBtn = this.createButton("asset.ui.pageNavBtn.first2","firstBtn"));
         this._hBox.addChild(this._prevBtn = this.createButton("asset.ui.pageNavBtn.pre2","prevBtn"));
         this._hBox.addChild(this._pageSpri = new Box());
         this._pageSpri.addChild(this._pageNumBg = new Image("asset.ui.combox.inputBg1"));
         this._pageSpri.addChild(this._pageNumText = new Label());
         this._hBox.addChild(this._nextBtn = this.createButton("asset.ui.pageNavBtn.next2","nextBtn"));
         this._hBox.addChild(this._lastBtn = this.createButton("asset.ui.pageNavBtn.last2","lastBtn"));
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._pageNumBg.smoothing = true;
         this._hBox.align = "top";
         this.pageNumBgSizeGrid = "5,5,10,10,0";
         this.pageNumSize = "80,25";
         this.updatePageNumStyle("");
         this._pageNumText.stroke = "0x000000,1,4,4,10";
         callLater(this.updatePage);
      }
      
      protected function __onClick(param1:MouseEvent) : void
      {
         switch(param1.target.name)
         {
            case "firstBtn":
               if(this.currentPage == 1)
               {
                  return;
               }
               this.currentPage = 1;
               break;
            case "prevBtn":
               if(this.currentPage - 1 < 1)
               {
                  if(this.isLoop)
                  {
                     this.currentPage = this.maxPage;
                  }
                  else
                  {
                     this._currentPage = 1;
                  }
                  return;
               }
               this.currentPage -= 1;
               break;
            case "nextBtn":
               if(this.currentPage + 1 > this.maxPage)
               {
                  if(this.isLoop)
                  {
                     this.currentPage = 1;
                  }
                  else
                  {
                     this._currentPage = this.maxPage;
                  }
                  break;
               }
               this.currentPage += 1;
               break;
            case "lastBtn":
               if(this.currentPage != this.maxPage)
               {
                  this.currentPage = this.maxPage;
               }
         }
      }
      
      protected function checkBtnState() : void
      {
         var _loc1_:* = false;
         var _loc2_:* = false;
         if(!this.isLoop)
         {
            _loc1_ = this.currentPage == 1;
            _loc2_ = this.currentPage == this.maxPage;
            if(Boolean(_loc1_) || this._prevBtn.disabled)
            {
               this._firstBtn.disabled = this._prevBtn.disabled = _loc1_;
            }
            if(Boolean(_loc2_) || this._nextBtn.disabled)
            {
               this._lastBtn.disabled = this._nextBtn.disabled = _loc2_;
            }
         }
      }
      
      protected function updatePage() : void
      {
         this._pageNumText.text = this.getCurrentPageViewToString();
         this.checkBtnState();
         this.updatePageNum();
         if(this._selectHandler != null)
         {
            this._selectHandler.executeWith([this.currentPage]);
         }
      }
      
      protected function getCurrentPageViewToString() : String
      {
         var _loc1_:int = Math.max(this.currentPage,1);
         var _loc2_:int = Math.max(this._maxPage,1);
         return _loc1_ + "/" + _loc2_;
      }
      
      protected function createButton(param1:String, param2:String) : Button
      {
         var _loc3_:Button = new Button(param1);
         _loc3_.name = param2;
         _loc3_.stateNum = 1;
         _loc3_.addEventListener("click",this.__onClick);
         return _loc3_;
      }
      
      protected function updatePageNum() : void
      {
         var _loc1_:* = 0;
         this._pageNumText.y = this._pageNumBg.height - this._pageNumText.height >> 1;
         switch(this._pageNumAlign)
         {
            case "left":
               this._pageNumText.x = this._pageNumXOffset;
               break;
            case "center":
               _loc1_ = this._pageNumBg.width - this._pageNumText.width >> 1;
               this._pageNumText.x = _loc1_ + this._pageNumXOffset;
               break;
            case "right":
               _loc1_ = int(this._pageNumBg.width - this._pageNumText.width);
               this._pageNumText.x = _loc1_ + this._pageNumXOffset;
               break;
            default:
               this._pageNumText.x = this._pageNumXOffset;
         }
      }
      
      public function get maxPage() : int
      {
         return this._maxPage;
      }
      
      public function set maxPage(param1:int) : void
      {
         if(this._maxPage == param1)
         {
            return;
         }
         this._maxPage = param1;
         callLater(this.updatePage);
      }
      
      public function set currentPage(param1:int) : void
      {
         this._currentPage = param1;
         callLater(this.updatePage);
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function get isLoop() : Boolean
      {
         return this._isLoop;
      }
      
      public function set isLoop(param1:Boolean) : void
      {
         if(this._isLoop == param1)
         {
            return;
         }
         this._isLoop = param1;
      }
      
      public function get spacing() : int
      {
         return this._spacing;
      }
      
      public function set spacing(param1:int) : void
      {
         if(this._spacing == param1)
         {
            return;
         }
         this._spacing = param1;
         this._hBox.space = this.spacing;
      }
      
      public function set pageNumBgStyle(param1:String) : void
      {
         this._pageNumBg.skin = param1;
      }
      
      public function set firstButtonStyle(param1:String) : void
      {
         this.changeButton("firstBtn",param1);
      }
      
      public function set prevButtonStyle(param1:String) : void
      {
         this.changeButton("prevBtn",param1);
      }
      
      public function set nextButtonStyle(param1:String) : void
      {
         this.changeButton("nextBtn",param1);
      }
      
      public function set lastButtonStyle(param1:String) : void
      {
         this.changeButton("lastBtn",param1);
      }
      
      protected function changeButton(param1:String, param2:String) : void
      {
         var _loc3_:Button = this._hBox.getChildByName(param1) as Button;
         if(_loc3_.skin != param2)
         {
            _loc3_.skin = param2;
            callLater(this._hBox.refresh);
         }
      }
      
      public function set pageNumBgSizeGrid(param1:String) : void
      {
         this._pageNumBg.sizeGrid = param1;
      }
      
      public function set pageNumSize(param1:String) : void
      {
         var _loc2_:Array = param1.split(",");
         if(_loc2_ == null || _loc2_.length <= 1)
         {
            return;
         }
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:int = int(_loc2_[1]);
         this._pageNumBg.width = _loc3_;
         this._pageNumBg.height = _loc4_;
         callLater(this.updatePageNum);
      }
      
      public function set pageNumAlign(param1:String) : void
      {
         this._pageNumAlign = param1;
         callLater(this.updatePageNum);
      }
      
      public function set pageNumXOffset(param1:int) : void
      {
         this._pageNumXOffset = param1;
         callLater(this.updatePageNum);
      }
      
      public function get selectHandler() : Handler
      {
         return this._selectHandler;
      }
      
      public function set selectHandler(param1:Handler) : void
      {
         this._selectHandler = param1;
      }
      
      public function set pageNumStroke(param1:String) : void
      {
         this._pageNumText.stroke = param1;
         callLater(this.updatePageNum);
      }
      
      public function set pageNumStyle(param1:String) : void
      {
         this.updatePageNumStyle(param1);
         callLater(this.updatePageNum);
      }
      
      protected function updatePageNumStyle(param1:String) : void
      {
         var _loc2_:Array = StringUtils.fillArray(lableStyle,param1);
         this._pageNumText.format = new TextFormat(_loc2_[0],_loc2_[1],_loc2_[2],_loc2_[3]);
         this._pageNumText.letterSpacing = _loc2_[4];
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(param1:String) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
         this.updateComponent();
      }
      
      protected function updateComponent() : void
      {
         if(this._hBox == null)
         {
            return;
         }
         switch(this.type)
         {
            case "simple":
               if(this._hBox.numChildren > 3)
               {
                  this._hBox.removeChild(this._firstBtn);
                  this._hBox.removeChild(this._lastBtn);
               }
               break;
            case "complexity":
               if(this._hBox.numChildren < 5)
               {
                  this._hBox.addChildAt(this._firstBtn,0);
                  this._hBox.addChildAt(this._lastBtn,this._hBox.numChildren - 1);
               }
         }
      }
      
      override public function dispose() : void
      {
         this._firstBtn && this._firstBtn.dispose();
         this._prevBtn && this._prevBtn.dispose();
         this._nextBtn && this._nextBtn.dispose();
         this._lastBtn && this._lastBtn.dispose();
         this._pageNumBg && this._pageNumBg.dispose();
         this._pageNumText && this._pageNumText.dispose();
         this._hBox && this._hBox.removeChildren();
         this._pageSpri = null;
         this._firstBtn = null;
         this._prevBtn = null;
         this._nextBtn = null;
         this._lastBtn = null;
         this._pageNumBg = null;
         this._pageNumText = null;
         this._hBox = null;
         super.dispose();
      }
   }
}

