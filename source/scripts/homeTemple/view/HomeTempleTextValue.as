package homeTemple.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import homeTemple.HomeTempleController;
   import homeTemple.data.HomeTempleModel;
   
   public class HomeTempleTextValue extends Sprite implements Disposeable
   {
      
      private var _propertyVec:Vector.<FilterFrameText>;
      
      private var _propertyOffVec:Vector.<FilterFrameText>;
      
      private var _propertyPosVec:Array = [PositionUtils.creatPoint("home.temple.levle.bloodTextPos"),PositionUtils.creatPoint("home.temple.levle.defenseTextPos"),PositionUtils.creatPoint("home.temple.levle.attackTextPos"),PositionUtils.creatPoint("home.temple.levle.luckyTextPos"),PositionUtils.creatPoint("home.temple.levle.resistanceTextPos"),PositionUtils.creatPoint("home.temple.levle.armorTextPos")];
      
      public function HomeTempleTextValue()
      {
         super();
         this._propertyVec = new Vector.<FilterFrameText>();
         this._propertyOffVec = new Vector.<FilterFrameText>();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("home.temple.propertyText");
            addChild(_loc2_);
            _loc2_.text = "10000";
            this._propertyVec.push(_loc2_);
            _loc1_++;
         }
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("home.temple.propertyOffText");
            addChild(_loc4_);
            _loc4_.text = "+100";
            this._propertyOffVec.push(_loc4_);
            _loc3_++;
         }
      }
      
      public function setPropertyValue(param1:Boolean = false) : void
      {
         var _loc5_:Array = null;
         var _loc2_:int = HomeTempleController.Instance.currentInfo.CurrentLevel;
         var _loc3_:HomeTempleModel = HomeTempleController.Instance.getPracticeByLevel(_loc2_);
         var _loc4_:HomeTempleModel = HomeTempleController.Instance.getPracticeByLevel(_loc2_ + 1);
         _loc5_ = [];
         _loc5_.push(_loc3_.Blood);
         _loc5_.push(_loc3_.Defence);
         _loc5_.push(_loc3_.Attack);
         _loc5_.push(_loc3_.Luck);
         _loc5_.push(_loc3_.Agility);
         _loc5_.push(_loc3_.Guard);
         var _loc6_:Array = [0,0,0,0,0,0];
         if(param1 && Boolean(_loc4_))
         {
            _loc6_[0] = _loc4_.Blood - _loc3_.Blood;
            _loc6_[1] = _loc4_.Defence - _loc3_.Defence;
            _loc6_[2] = _loc4_.Attack - _loc3_.Attack;
            _loc6_[3] = _loc4_.Luck - _loc3_.Luck;
            _loc6_[4] = _loc4_.Agility - _loc3_.Agility;
            _loc6_[5] = _loc4_.Guard - _loc3_.Guard;
         }
         this.setInfo(_loc5_,_loc6_);
      }
      
      private function setInfo(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            this._propertyVec[_loc3_].text = param1[_loc3_];
            this._propertyOffVec[_loc3_].text = param2[_loc3_] > 0 ? "+" + param2[_loc3_] : "";
            this._propertyVec[_loc3_].x = this._propertyPosVec[_loc3_].x - (this._propertyVec[_loc3_].width + this._propertyOffVec[_loc3_].width) / 2;
            this._propertyOffVec[_loc3_].x = this._propertyVec[_loc3_].x + this._propertyVec[_loc3_].width;
            this._propertyVec[_loc3_].y = this._propertyOffVec[_loc3_].y = this._propertyPosVec[_loc3_].y;
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this._propertyVec.length)
         {
            ObjectUtils.disposeObject(this._propertyVec[_loc1_]);
            this._propertyVec[_loc1_] = null;
            _loc1_++;
         }
         this._propertyVec = null;
         _loc2_ = 0;
         while(_loc2_ < this._propertyOffVec.length)
         {
            ObjectUtils.disposeObject(this._propertyOffVec[_loc2_]);
            this._propertyOffVec[_loc2_] = null;
            _loc2_++;
         }
         this._propertyOffVec = null;
      }
   }
}

