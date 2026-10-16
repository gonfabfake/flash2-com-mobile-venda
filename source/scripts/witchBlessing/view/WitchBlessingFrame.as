package witchBlessing.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class WitchBlessingFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _text:FilterFrameText;
      
      private var _numberSelecter:NumberSelecter;
      
      private var _needText:FilterFrameText;
      
      public function WitchBlessingFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = null;
         _loc1_ = null;
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("witchBlessing.view.doubleBlessTxt"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         _loc1_ = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.blessCount");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.NumberSelecter");
         PositionUtils.setPos(this._numberSelecter,"witchBlessing.expCountSelecterPos");
         this._numberSelecter.addEventListener(Event.CHANGE,this.__seleterChange);
         this._numberSelecter.x = 146;
         this._numberSelecter.y = 78;
         this._needText = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.NeedText");
         this._needText.visible = false;
         addToContent(_loc1_);
         addToContent(this._numberSelecter);
         addToContent(this._needText);
      }
      
      public function show(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(param3 > param4)
         {
            this._numberSelecter.valueLimit = 1 + "," + param4;
         }
         else
         {
            this._numberSelecter.valueLimit = 1 + "," + param3;
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._numberSelecter.currentValue = 1;
         if(this.isDoubleTime(ServerConfigManager.instance.getWitchBlessDoubleGpTime))
         {
            this._needText.htmlText = LanguageMgr.GetTranslation("witchBlessing.View.NeedExpText",ServerConfigManager.instance.getWitchBlessMoney,int(ServerConfigManager.instance.getWitchBlessGP[2]) * 2,param2);
         }
         else
         {
            this._needText.htmlText = LanguageMgr.GetTranslation("witchBlessing.View.NeedExpText",ServerConfigManager.instance.getWitchBlessMoney,ServerConfigManager.instance.getWitchBlessGP[2],param2);
         }
         this._needText.visible = true;
      }
      
      private function isDoubleTime(param1:String) : Boolean
      {
         var _loc2_:Array = param1.split("-");
         var _loc3_:Array = _loc2_[0].toString().split(":");
         var _loc4_:Array = _loc2_[1].toString().split(":");
         var _loc5_:Date = TimeManager.Instance.Now();
         var _loc6_:Boolean = false;
         if(int(_loc3_[0]) <= _loc5_.getHours() && int(_loc3_[1]) <= _loc5_.getMinutes())
         {
            if(int(_loc4_[0]) >= _loc5_.getHours() && int(_loc4_[1]) >= _loc5_.getMinutes())
            {
               _loc6_ = true;
            }
         }
         return _loc6_;
      }
      
      private function __seleterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function get count() : int
      {
         return this._numberSelecter.currentValue;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._numberSelecter))
         {
            this._numberSelecter.removeEventListener(Event.CHANGE,this.__seleterChange);
         }
         this.removeView();
      }
      
      private function removeView() : void
      {
         ObjectUtils.disposeObject(this._numberSelecter);
         this._numberSelecter = null;
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._needText);
         this._needText = null;
      }
   }
}

