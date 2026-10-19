package sevenDayTarget.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   
   public class SevenDayTargetConditionCell extends Sprite
   {
      
      private var _todayQuestInfo:NewTargetQuestionInfo;
      
      private var conditionText:FilterFrameText;
      
      private var conditionUnComplete:Bitmap;
      
      private var conditionComplete:Bitmap;
      
      private var linkText:FilterFrameText;
      
      private var linkSp:Sprite;
      
      public function SevenDayTargetConditionCell(param1:NewTargetQuestionInfo)
      {
         super();
         this._todayQuestInfo = param1;
      }
      
      public function setView(param1:String, param2:Boolean, param3:Boolean = true) : void
      {
         this.conditionText = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.view.conditionText");
         this.conditionText.text = param1;
         if(this.conditionText.text.length > 10)
         {
            PositionUtils.setPos(this.conditionText,"sevenDayTarget.view.conditiontextPos1");
         }
         else
         {
            PositionUtils.setPos(this.conditionText,"sevenDayTarget.view.conditiontextPos2");
         }
         addChild(this.conditionText);
         this.linkSp = new Sprite();
         this.linkSp.graphics.beginFill(65280,0);
         if(param3)
         {
            this.linkSp.addEventListener(MouseEvent.CLICK,this.__clickLinkText);
            this.linkSp.buttonMode = true;
            this.linkText = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.view.linktxt");
         }
         else
         {
            this.linkText = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.view.linktxt2");
         }
         this.linkText.text = LanguageMgr.GetTranslation("sevenDayTarget.view.link");
         this.linkSp.graphics.drawRect(0,0,this.linkText.width,this.linkText.height);
         this.linkSp.graphics.endFill();
         PositionUtils.setPos(this.linkSp,"sevenDayTarget.view.linkPos1");
         PositionUtils.setPos(this.linkText,"sevenDayTarget.view.linkPos1");
         addChild(this.linkText);
         addChild(this.linkSp);
         this.conditionComplete = ComponentFactory.Instance.creat("sevenDayTarget.finish");
         PositionUtils.setPos(this.conditionComplete,"sevenDayTarget.view.finishPos");
         addChild(this.conditionComplete);
         this.conditionUnComplete = ComponentFactory.Instance.creat("sevenDayTarget.unfinish");
         PositionUtils.setPos(this.conditionUnComplete,"sevenDayTarget.view.finishPos");
         addChild(this.conditionUnComplete);
         if(param2)
         {
            this.conditionComplete.visible = true;
            this.conditionUnComplete.visible = false;
         }
         else
         {
            this.conditionComplete.visible = false;
            this.conditionUnComplete.visible = true;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.linkSp))
         {
            this.linkSp.removeEventListener(MouseEvent.CLICK,this.__clickLinkText);
         }
         if(Boolean(this.conditionText))
         {
            this.conditionText.dispose();
            this.conditionText = null;
         }
         if(Boolean(this.conditionUnComplete))
         {
            this.conditionUnComplete.bitmapData.dispose();
            this.conditionUnComplete = null;
         }
         if(Boolean(this.linkText))
         {
            this.linkText.dispose();
            this.linkText = null;
         }
         if(Boolean(this.conditionComplete))
         {
            this.conditionComplete.bitmapData.dispose();
            this.conditionComplete = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      private function __clickLinkText(param1:MouseEvent) : void
      {
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("clickLink"));
      }
   }
}

