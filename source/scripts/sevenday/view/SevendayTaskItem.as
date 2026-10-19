package sevenday.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SevendayTaskItem extends Sprite implements Disposeable
   {
      
      private var _taskText:FilterFrameText;
      
      private var _gotoBtn:FilterFrameText;
      
      private var _icon:ScaleFrameImage;
      
      private var _taskSprite:Sprite;
      
      private var _num:int;
      
      private var _iteminfo:ItemTemplateInfo;
      
      private var _lastCreatTime:int;
      
      private var _info:QuestInfo;
      
      public function SevendayTaskItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._icon = ComponentFactory.Instance.creatComponentByStylename("sevendayTaskCell.icon");
         PositionUtils.setPos(this._icon,"ddt.sevendayTaskCell.iconPos");
         this._icon.setFrame(1);
         addChild(this._icon);
         this._gotoBtn = ComponentFactory.Instance.creatComponentByStylename("sevendayTaskCell.goto");
         this._gotoBtn.text = LanguageMgr.GetTranslation("tank.sevenday.woyaotisheng");
         this._taskSprite = new Sprite();
         this._taskSprite.addChild(this._gotoBtn);
         this._taskSprite.mouseEnabled = true;
         this._taskSprite.buttonMode = true;
         addChild(this._taskSprite);
         this._taskSprite.addEventListener("click",this.gotowhere);
         this._taskText = ComponentFactory.Instance.creatComponentByStylename("sevendayTaskCell.task");
         addChild(this._taskText);
      }
      
      private function complete(param1:int) : void
      {
         this._gotoBtn.setFrame(2);
         this._icon.setFrame(2);
      }
      
      private function uncomplete(param1:int) : void
      {
         this._gotoBtn.setFrame(1);
         this._icon.setFrame(1);
      }
      
      private function gotowhere(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
      }
      
      public function update(param1:QuestInfo, param2:int) : void
      {
         this._info = param1;
         this._num = param2;
         this._taskText.text = param1.conditions[param2].description;
         if(Boolean(param1.conditionStatusBoolean[param2]) || !this._info.data)
         {
            this.complete(param2);
         }
         else
         {
            this.uncomplete(param2);
         }
      }
      
      public function dispose() : void
      {
         this._taskSprite.removeEventListener("click",this.gotowhere);
         ObjectUtils.disposeObject(this._taskText);
         this._taskText = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._gotoBtn);
         this._gotoBtn = null;
         ObjectUtils.disposeObject(this._taskSprite);
         this._taskSprite = null;
      }
   }
}

