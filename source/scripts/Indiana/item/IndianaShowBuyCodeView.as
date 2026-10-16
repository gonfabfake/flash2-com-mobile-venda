package Indiana.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class IndianaShowBuyCodeView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _scroller:ScrollPanel;
      
      private var _titleTxt:GradientBitmapText;
      
      private var _title1Txt:GradientBitmapText;
      
      private var _beginNum:Array;
      
      private var _list:SimpleTileList;
      
      private var _closeBtn:BaseButton;
      
      private var _titletimes:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      private var _rightBtn:BaseButton;
      
      private var _leftBtn:BaseButton;
      
      private var _pageTxt:FilterFrameText;
      
      private var _totlePage:int;
      
      private var _currentPage:int = 1;
      
      private var timesarr:Array = [];
      
      public function IndianaShowBuyCodeView(param1:Array)
      {
         super();
         this._beginNum = param1;
         this.initView();
         this.initEvent();
         this.initItem();
      }
      
      private function initItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:int = int(this._beginNum.length);
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc2_ = int(this._beginNum[_loc4_].split("|")[0]);
            _loc1_ = int(this._beginNum[_loc4_].split("|")[1]);
            _loc3_ += _loc1_;
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
               this.timesarr.push((_loc2_ + _loc6_).toString());
               _loc6_++;
            }
            _loc4_++;
         }
         this._totlePage = Math.ceil(_loc3_ / 15);
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         this.setPage(this._currentPage);
         this._titletimes.text = _loc3_.toString();
         this._scroller.setView(this._content);
      }
      
      private function setPage(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:* = 0;
         _loc3_ = (param1 - 1) * 15;
         var _loc4_:int = _loc3_ + 15;
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            if(_loc2_ < this.timesarr.length)
            {
               _loc6_++;
               if(_loc6_ % 5 == 0)
               {
                  _loc5_.push(this.timesarr[_loc2_] + "\n");
               }
               else
               {
                  _loc5_.push(this.timesarr[_loc2_] + "  ");
               }
            }
            _loc2_++;
         }
         this._content.text = _loc5_.join("");
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener("click",this.__clickHandler);
         this._rightBtn.addEventListener("click",this.__rightClickHandler);
         this._leftBtn.addEventListener("click",this.__leftClickHandler);
      }
      
      private function removeEvent() : void
      {
         this._closeBtn.removeEventListener("click",this.__clickHandler);
         this._rightBtn.removeEventListener("click",this.__rightClickHandler);
         this._leftBtn.removeEventListener("click",this.__leftClickHandler);
      }
      
      private function __rightClickHandler(param1:MouseEvent) : void
      {
         if(this._currentPage < this._totlePage)
         {
            ++this._currentPage;
         }
         else
         {
            this._currentPage = 1;
         }
         this.setPage(this._currentPage);
      }
      
      private function __leftClickHandler(param1:MouseEvent) : void
      {
         if(this._currentPage > 1)
         {
            --this._currentPage;
         }
         else
         {
            this._currentPage = this._totlePage;
         }
         this.setPage(this._currentPage);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.buycode.bg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("indiana.buycode.Title");
         this._titleTxt.setText(LanguageMgr.GetTranslation("Indiana.has.join.countI"));
         this._title1Txt = ComponentFactory.Instance.creatComponentByStylename("indiana.buycode.Title");
         this._title1Txt.setText(LanguageMgr.GetTranslation("Indiana.has.join.countII"));
         this._scroller = ComponentFactory.Instance.creatComponentByStylename("indiana.scroll.buycodepanel");
         this._titletimes = ComponentFactory.Instance.creatComponentByStylename("indiana.buytitleNum.Txt");
         PositionUtils.setPos(this._titletimes,"indiana.buy.title.times.pos");
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.but.closebtn");
         this._content = ComponentFactory.Instance.creatComponentByStylename("indiana.buycontent.Txt");
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.buycode.right");
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.buycode.left");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("indiana.buycontent.Txt");
         var _loc1_:TextFormat = this._pageTxt.defaultTextFormat;
         _loc1_.align = "center";
         this._pageTxt.defaultTextFormat = _loc1_;
         this._pageTxt.autoSize = "none";
         this._pageTxt.width = 60;
         this._pageTxt.height = 20;
         PositionUtils.setPos(this._pageTxt,"indiana.buycode.page.pos");
         this._pageTxt.text = "0/0";
         this._list = new SimpleTileList(5);
         this._list.hSpace = 10;
         this._list.vSpace = 10;
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._title1Txt);
         addChild(this._scroller);
         addChild(this._closeBtn);
         addChild(this._titletimes);
         addChild(this._rightBtn);
         addChild(this._leftBtn);
         addChild(this._pageTxt);
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTxt = null;
         this._title1Txt = null;
         this._scroller = null;
         this._list = null;
         this._closeBtn = null;
         this._beginNum = null;
         this._titletimes = null;
      }
   }
}

