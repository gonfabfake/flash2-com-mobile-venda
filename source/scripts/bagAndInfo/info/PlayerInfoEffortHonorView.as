package bagAndInfo.info
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.events.EffortEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.EffortManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class PlayerInfoEffortHonorView extends Sprite implements Disposeable
   {
      
      private var _nameChoose:ComboBox;
      
      private var _honorArray:Array;
      
      public function PlayerInfoEffortHonorView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._nameChoose = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNameChoose");
         addChild(this._nameChoose);
         this._nameChoose.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         NewTitleManager.instance.addEventListener(NewTitleEvent.SELECT_TITLE,this.__onSelectTitle);
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function __onSelectTitle(param1:NewTitleEvent) : void
      {
         var _loc2_:String = param1.data[0];
         if(Boolean(_loc2_))
         {
            SocketManager.Instance.out.sendReworkRank(_loc2_);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["honor"] == true)
         {
            if(PlayerManager.Instance.Self.honor != "")
            {
               this._nameChoose.textField.text = this.limitarTexto(PlayerManager.Instance.Self.honor);
               NewTitleManager.instance.dispatchEvent(new NewTitleEvent(NewTitleEvent.SET_SELECT_TITLE));
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newTitleView.useTitleSuccessTxt",this._nameChoose.textField.text));
            }
            else
            {
               this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
            }
         }
      }
      
      private function limitarTexto(param1:String, param2:int = 11) : String
      {
         if(param1.length > param2)
         {
            return param1.substr(0,param2 - 3) + "...";
         }
         return param1;
      }
      
      private function __buttonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         NewTitleManager.instance.show();
      }
      
      private function __upadte(param1:EffortEvent) : void
      {
         this.setlist(EffortManager.Instance.getHonorArray());
         this.update();
      }
      
      private function update() : void
      {
         if(PlayerManager.Instance.Self.honor != "")
         {
            this._nameChoose.textField.text = this.limitarTexto(PlayerManager.Instance.Self.honor);
         }
         else
         {
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._honorArray[param1.index];
         if(Boolean(_loc2_))
         {
            SocketManager.Instance.out.sendReworkRank(_loc2_);
         }
         else
         {
            SocketManager.Instance.out.sendReworkRank("");
            this._nameChoose.textField.text = LanguageMgr.GetTranslation("bagAndInfo.info.PlayerInfoEffortHonorView.selecting");
         }
      }
      
      public function setlist(param1:Array) : void
      {
         this._honorArray = [];
         this._honorArray = param1;
         if(!this._honorArray)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         this._nameChoose.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         EffortManager.Instance.removeEventListener(EffortEvent.FINISH,this.__upadte);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
         this._nameChoose.dispose();
         this._nameChoose = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

