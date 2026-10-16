package Indiana.item
{
   import Indiana.model.IndianaData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   
   public class IndianaRecodeItem extends Sprite implements Disposeable
   {
      
      private var _timeTxt:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _severName:FilterFrameText;
      
      private var _timers:FilterFrameText;
      
      private var _lookMa:FilterFrameText;
      
      private var _info:IndianaData;
      
      public function IndianaRecodeItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         PositionUtils.setPos(this._timeTxt,"indiana.recodetime.pos");
         this._name = ComponentFactory.Instance.creatComponentByStylename("indiana.name.Txt");
         PositionUtils.setPos(this._name,"indiana.recodename.pos");
         this._severName = ComponentFactory.Instance.creatComponentByStylename("indiana.name.Txt");
         PositionUtils.setPos(this._severName,"indiana.recodesever.pos");
         this._timers = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         PositionUtils.setPos(this._timers,"indiana.recodetimeNum.pos");
         this._lookMa = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         this._lookMa.mouseEnabled = true;
         PositionUtils.setPos(this._lookMa,"indiana.recodeCheck.pos");
         addChild(this._timeTxt);
         addChild(this._name);
         addChild(this._severName);
         addChild(this._timers);
         addChild(this._lookMa);
      }
      
      private function initEvent() : void
      {
         this._lookMa.addEventListener("link",this.__linkHandler);
      }
      
      private function removeEvent() : void
      {
         this._lookMa.removeEventListener("link",this.__linkHandler);
      }
      
      private function __linkHandler(param1:TextEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = param1.text.split("|");
         if(_loc3_[0] == "clickother")
         {
            _loc2_ = int(_loc3_[1]);
            SocketManager.Instance.out.sendIndianaCode(_loc2_,this._info.useId);
         }
      }
      
      public function set info(param1:IndianaData) : void
      {
         this._info = param1;
         if(Boolean(this._info))
         {
            this._timeTxt.text = this._info.joinTime;
            this._name.text = this._info.nickName;
            this._severName.text = this._info.areaName;
            this._timers.text = this._info.joinCount.toString();
            this._lookMa.htmlText = LanguageMgr.GetTranslation("Indiana.recode.checkNum",this._info.per_Id);
            this._lookMa.x = this._timers.textWidth + this._timers.x + 3;
         }
      }
      
      override public function get height() : Number
      {
         return 17;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._timeTxt = null;
         this._name = null;
         this._severName = null;
         this._timers = null;
         this._lookMa = null;
      }
   }
}

