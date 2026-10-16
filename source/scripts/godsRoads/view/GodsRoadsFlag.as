package godsRoads.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import godsRoads.manager.GodsRoadsManager;
   
   public class GodsRoadsFlag extends Component
   {
      
      private var _lv:int = 1;
      
      private var _alertTxt:FilterFrameText;
      
      private var _btn:BaseButton;
      
      private var _numBitmapArray:Array = [];
      
      private var _pointsNum:Sprite;
      
      private var _offX:int = 6;
      
      private var _perBmp:Bitmap;
      
      private var progressTxt:Bitmap;
      
      private var isOpen:Boolean = false;
      
      private var _progressNum:int;
      
      public function GodsRoadsFlag(param1:int)
      {
         this._lv = param1;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creat("godsRoads.ddLevelBtn" + this._lv);
         addChild(this._btn);
         if(this._lv > 1)
         {
            this._alertTxt = ComponentFactory.Instance.creat("godsRoads.conditionsTxt");
            this._alertTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.openConditions",LanguageMgr.GetTranslation("ddt.godsRoads.lv" + this._lv));
            addChild(this._alertTxt);
         }
         this._pointsNum = new Sprite();
         PositionUtils.setPos(this._pointsNum,"godsRoads.numPos");
         addChild(this._pointsNum);
         this.progressTxt = ComponentFactory.Instance.creat("asset.godsRoads.programeTxt");
         this.progressTxt.visible = false;
         addChild(this.progressTxt);
         this._btn.addEventListener(MouseEvent.CLICK,this.__changeSteps);
      }
      
      public function set enable(param1:Boolean) : void
      {
         this.isOpen = param1;
         if(param1 == true)
         {
            this._btn.filterString = "null,lightFilter,null,grayFilter";
            if(Boolean(this._alertTxt))
            {
               this._alertTxt.visible = false;
            }
         }
         else
         {
            if(this._lv == GodsRoadsManager.instance._model.godsRoadsData.currentLevel + 1)
            {
               this._alertTxt.textFormatStyle = "godsRoads.TextFormat";
            }
            this._btn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
            if(Boolean(this._alertTxt))
            {
               this._alertTxt.visible = true;
            }
         }
         this._btn.setFrame(1);
      }
      
      public function get isOpened() : Boolean
      {
         return this.isOpen;
      }
      
      private function getFA(param1:String) : Array
      {
         return ComponentFactory.Instance.creatFrameFilters(param1);
      }
      
      private function __changeSteps(param1:MouseEvent) : void
      {
         GodsRoadsManager.instance.changeSteps(this._lv);
      }
      
      public function get enable() : Boolean
      {
         return this.isOpen;
      }
      
      public function set progressNum(param1:int) : void
      {
         this._progressNum = param1;
         this.setCountDownNumber(this._progressNum);
         this.showProgress = true;
      }
      
      public function get progressNum() : int
      {
         return this._progressNum;
      }
      
      public function set showProgress(param1:Boolean) : void
      {
         this.progressTxt.visible = param1;
      }
      
      private function setCountDownNumber(param1:int) : void
      {
         var _loc2_:Bitmap = null;
         _loc2_ = null;
         var _loc3_:String = String(param1);
         var _loc4_:String = "";
         var _loc5_:int = 0;
         this.deleteBitmapArray();
         this._numBitmapArray = new Array();
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = _loc3_.charAt(_loc6_);
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.godsRoads.num" + _loc4_);
            _loc2_.x = _loc2_.bitmapData.width * _loc6_ - _loc6_ * this._offX;
            _loc5_ = _loc2_.x + _loc2_.bitmapData.width;
            this._pointsNum.addChild(_loc2_);
            this._numBitmapArray.push(_loc2_);
            _loc6_++;
         }
         this._perBmp = ComponentFactory.Instance.creatBitmap("asset.godsRoads.num%");
         this._perBmp.x = _loc5_ - this._offX;
         this._pointsNum.addChild(this._perBmp);
         this._numBitmapArray.push(this._perBmp);
      }
      
      private function deleteBitmapArray() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._numBitmapArray))
         {
            _loc1_ = 0;
            while(_loc1_ < this._numBitmapArray.length)
            {
               this._numBitmapArray[_loc1_].bitmapData.dispose();
               this._numBitmapArray[_loc1_] = null;
               _loc1_++;
            }
            this._numBitmapArray.length = 0;
            this._numBitmapArray = null;
         }
      }
   }
}

