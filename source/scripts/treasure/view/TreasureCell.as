package treasure.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureCell extends Sprite implements Disposeable
   {
      
      public var cell:TreasureFieldCell;
      
      private var _field:MovieClip;
      
      private var _tbxCount:FilterFrameText;
      
      public var cartoon:MovieClip;
      
      public var _fieldPos:int;
      
      private var cartoon_dig:MovieClip;
      
      private var cursor:Bitmap;
      
      public function TreasureCell(param1:int, param2:Boolean = true)
      {
         super();
         this.cursor = ComponentFactory.Instance.creatBitmap("asset.treasure.cursor");
         this._fieldPos = param1;
         this._field = ComponentFactory.Instance.creat("asset.treasure.field");
         if(TreasureModel.instance.itemList[this._fieldPos - 1].pos > 0)
         {
            this._field.gotoAndStop(2);
         }
         else
         {
            this._field.gotoAndStop(1);
         }
         this._field.alpha = 0;
         addChild(this._field);
         if(param2 || TreasureModel.instance.itemList[this._fieldPos - 1].pos > 0)
         {
            this.creatCartoon();
         }
         addChild(this.cursor);
         this.cursor.visible = false;
      }
      
      public function creatCartoon(param1:String = "show") : void
      {
         var _loc2_:Sprite = null;
         if(Boolean(this.cartoon))
         {
            ObjectUtils.disposeObject(this.cartoon);
         }
         this.cartoon = null;
         if(param1 == "end")
         {
            this.removeEvent();
            this.outHandler(new MouseEvent("mouseMove"));
         }
         this.cartoon = ComponentFactory.Instance.creat("asset.treasure.cartoon1");
         _loc2_ = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,78,78);
         _loc2_.graphics.endFill();
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("treasure.CountText");
         this._tbxCount.mouseEnabled = false;
         PositionUtils.setPos(this._tbxCount,"treasure.cell.numTf.pos");
         this.cell = new TreasureFieldCell(_loc2_,TreasureModel.instance.itemList[this._fieldPos - 1]);
         this.cartoon.mc.addChild(this.cell);
         this.cartoon.mc.addChild(this._tbxCount);
         this.cartoon.gotoAndPlay(param1);
         if(param1 == "end")
         {
            this.cartoon.addEventListener("enterFrame",this.__allOverHandler);
         }
         this._tbxCount.text = String(TreasureModel.instance.itemList[this._fieldPos - 1].Count);
         PositionUtils.setPos(this.cell,"treasure.cell.pos");
         addChild(this.cartoon);
         this.cartoon.visible = true;
         PositionUtils.setPos(this.cartoon,"cartoon1.pos");
      }
      
      private function __allOverHandler(param1:Event) : void
      {
         if(this.cartoon.currentFrame == this.cartoon.totalFrames)
         {
            this.cartoon.removeEventListener("enterFrame",this.__allOverHandler);
            TreasureModel.instance.isClick = true;
            if(!TreasureModel.instance.isEndTreasure && PlayerManager.Instance.Self.treasure + PlayerManager.Instance.Self.treasureAdd == 0 && TreasureModel.instance.friendHelpTimes >= PathManager.treasureHelpTimes)
            {
               SocketManager.Instance.out.endTreasure();
            }
         }
      }
      
      public function removeCell() : void
      {
         if(Boolean(this.cartoon))
         {
            this.cartoon.mc.removeChild(this.cell);
            this.cartoon.mc.removeChild(this._tbxCount);
         }
      }
      
      public function digBackHandler() : void
      {
         this.removeEvent();
         this.outHandler(new MouseEvent("mouseMove"));
         if(Boolean(this.cartoon_dig))
         {
            this.cartoon_dig.visible = true;
         }
         else
         {
            this.cartoon_dig = ComponentFactory.Instance.creat("asset.treasure.cartoon3");
            addChild(this.cartoon_dig);
         }
         PositionUtils.setPos(this.cartoon_dig,"cartoon3.pos");
         this.cartoon_dig.addEventListener("enterFrame",this.cartoon_digHandler);
      }
      
      private function cartoon_digHandler(param1:Event) : void
      {
         if(this.cartoon_dig.currentFrame == this.cartoon_dig.totalFrames)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.fightLib.Award.GetMessage") + TreasureModel.instance.itemList[this._fieldPos - 1].Name + "*" + String(TreasureModel.instance.itemList[this._fieldPos - 1].Count));
            this.cartoon_dig.removeEventListener("enterFrame",this.cartoon_digHandler);
            this.cartoon_dig.visible = false;
            TreasureManager.instance.dispatchEvent(new TreasureEvents("fieldChange",{"pos":this._fieldPos}));
            this.creatCartoon("end");
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener("click",this.clickHandler);
         this.removeEventListener("mouseOver",this.overHandler);
         this.removeEventListener("mouseOut",this.outHandler);
      }
      
      public function addEvent() : void
      {
         if(TreasureModel.instance.itemList[this._fieldPos - 1].pos == 0 && TreasureModel.instance.isBeginTreasure && !TreasureModel.instance.isEndTreasure)
         {
            this.addEventListener("click",this.clickHandler);
            this.addEventListener("mouseOver",this.overHandler);
            this.addEventListener("mouseOut",this.outHandler);
         }
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         Mouse.hide();
         this.addEventListener("mouseMove",this.mouseMoveHandler);
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         Mouse.show();
         this.cursor.visible = false;
         this.removeEventListener("mouseMove",this.mouseMoveHandler);
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         this.cursor.x = param1.localX;
         this.cursor.y = param1.localY - 18;
         param1.updateAfterEvent();
         this.cursor.visible = true;
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         if(TreasureModel.instance.isClick)
         {
            if(PlayerManager.Instance.Self.treasure + PlayerManager.Instance.Self.treasureAdd > 0)
            {
               TreasureModel.instance.isClick = false;
               this.mouseEnabled = false;
               SocketManager.Instance.out.doTreasure(this._fieldPos);
            }
            else if(TreasureModel.instance.friendHelpTimes < PathManager.treasureHelpTimes)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning1"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.warning1"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.cell))
         {
            ObjectUtils.disposeObject(this.cell);
         }
         this.cell = null;
         if(Boolean(this._field))
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

