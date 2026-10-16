package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.manager.LanguageMgr;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import gemstone.info.GemstoneStaticInfo;
   
   public class GemstoneTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _fiSoulName:FilterFrameText;
      
      private var _quality:SimpleItem;
      
      private var _type:SimpleItem;
      
      private var _attack:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _luck:FilterFrameText;
      
      private var _grade1:FilterFrameText;
      
      private var _grade2:FilterFrameText;
      
      private var _grade3:FilterFrameText;
      
      private var _forever:FilterFrameText;
      
      private var _displayList:Vector.<DisplayObject>;
      
      public function GemstoneTip()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(param1:Object) : void
      {
         this._tempData = param1;
         if(!this._tempData)
         {
            return;
         }
         this._displayList = new Vector.<DisplayObject>();
         this.updateView();
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:FilterFrameText = null;
         var _loc2_:GemstonTipItem = null;
         var _loc3_:Object = null;
         this.clear();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._bg.width = 360;
         this._bg.height = 340;
         this.tipbackgound = this._bg;
         this._fiSoulName = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._displayList.push(this._fiSoulName);
         var _loc4_:Vector.<GemstoneStaticInfo> = this._tempData as Vector.<GemstoneStaticInfo>;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            if(_loc4_[_loc6_].attack != 0)
            {
               _loc3_ = new Object();
               _loc3_.id = _loc4_[_loc6_].id;
               _loc3_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",_loc4_[_loc6_].level,String(_loc4_[_loc6_].attack));
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstone");
               _loc2_ = new GemstonTipItem();
               _loc2_.setInfo(_loc3_);
               this._displayList.push(_loc2_);
            }
            else if(_loc4_[_loc6_].defence != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstone");
               _loc3_ = new Object();
               _loc3_.id = _loc4_[_loc6_].id;
               _loc3_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",_loc4_[_loc6_].level,String(_loc4_[_loc6_].defence));
               _loc2_ = new GemstonTipItem();
               _loc2_.setInfo(_loc3_);
               this._displayList.push(_loc2_);
            }
            else if(_loc4_[_loc6_].agility != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstone");
               _loc3_ = new Object();
               _loc3_.id = _loc4_[_loc6_].id;
               _loc3_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",_loc4_[_loc6_].level,String(_loc4_[_loc6_].agility));
               _loc2_ = new GemstonTipItem();
               _loc2_.setInfo(_loc3_);
               this._displayList.push(_loc2_);
            }
            else if(_loc4_[_loc6_].luck != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstone");
               _loc3_ = new Object();
               _loc3_.id = _loc4_[_loc6_].id;
               _loc3_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",_loc4_[_loc6_].level,String(_loc4_[_loc6_].luck));
               _loc2_ = new GemstonTipItem();
               _loc2_.setInfo(_loc3_);
               this._displayList.push(_loc2_);
            }
            else if(_loc4_[_loc6_].blood != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstone");
               _loc3_ = new Object();
               _loc3_.id = _loc4_[_loc6_].id;
               _loc3_.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",_loc4_[_loc6_].level,String(_loc4_[_loc6_].blood));
               _loc2_ = new GemstonTipItem();
               _loc2_.setInfo(_loc3_);
               this._displayList.push(_loc2_);
            }
            _loc6_++;
         }
         this.initPos();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override protected function init() : void
      {
      }
      
      private function initPos() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:int = int(this._displayList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._displayList[_loc1_].y = _loc1_ * 30 + 5;
            this._displayList[_loc1_].x = 5;
            addChild(this._displayList[_loc1_] as DisplayObject);
            _loc1_++;
         }
      }
   }
}

