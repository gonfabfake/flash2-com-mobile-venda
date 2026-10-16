package farm.viewx.poultry
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.PNGHitAreaFactory;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FarmTree extends Sprite implements Disposeable
   {
      
      private var _tree:MovieClip;
      
      private var _leaf:MovieClip;
      
      private var _level:FilterFrameText;
      
      private var _levelNum:int;
      
      private var _treeName:FilterFrameText;
      
      private var _area:Sprite;
      
      public function FarmTree()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._tree = ComponentFactory.Instance.creat("asset.farm.tree");
         addChild(this._tree);
         this._leaf = ComponentFactory.Instance.creat("asset.farm.treeLeaf");
         PositionUtils.setPos(this._leaf,"asset.farm.treeLeafPos");
         addChild(this._leaf);
         this._level = ComponentFactory.Instance.creatComponentByStylename("farm.tree.levelTxt");
         this._level.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + this._levelNum;
         addChild(this._level);
         this._treeName = ComponentFactory.Instance.creatComponentByStylename("farm.tree.nameTxt");
         this._treeName.text = LanguageMgr.GetTranslation("farm.tree.nameText");
         addChild(this._treeName);
         this._area = PNGHitAreaFactory.drawHitArea(Bitmap(ComponentFactory.Instance.creat("asset.farm.treeArea")).bitmapData);
         this._area.buttonMode = true;
         this._area.alpha = 0;
         addChild(this._area);
      }
      
      private function initEvent() : void
      {
         this._area.addEventListener("click",this.__onTreeClick);
         this._area.addEventListener("mouseOver",this.__onTreeOver);
         this._area.addEventListener("mouseOut",this.__onTreeOut);
         FarmModelController.instance.addEventListener("farmTree_updateTreeLevel",this.__onUpdateFarmTreeLevel);
      }
      
      protected function __onUpdateFarmTreeLevel(param1:FarmEvent) : void
      {
         this._levelNum = FarmModelController.instance.model.FarmTreeLevel;
         this._level.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + this._levelNum;
      }
      
      public function setLevel(param1:int) : void
      {
         FarmModelController.instance.model.FarmTreeLevel = param1;
         this._levelNum = param1;
         this._level.text = LanguageMgr.GetTranslation("ddt.cardSystem.CardEquipView.levelText") + this._levelNum;
      }
      
      protected function __onTreeClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            SoundManager.instance.playButtonSound();
            _loc2_ = ComponentFactory.Instance.creatCustomObject("farm.poultry.treeUpgrade");
            LayerManager.Instance.addToLayer(_loc2_,3,true,1);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.farmTree.others"));
         }
      }
      
      protected function __onTreeOver(param1:MouseEvent) : void
      {
         this._tree.gotoAndStop(2);
      }
      
      protected function __onTreeOut(param1:MouseEvent) : void
      {
         this._tree.gotoAndStop(1);
      }
      
      private function removeEvent() : void
      {
         this._area.removeEventListener("click",this.__onTreeClick);
         this._area.removeEventListener("mouseOver",this.__onTreeOver);
         this._area.removeEventListener("mouseOut",this.__onTreeOut);
         FarmModelController.instance.removeEventListener("farmTree_updateTreeLevel",this.__onUpdateFarmTreeLevel);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._tree))
         {
            this._tree = null;
         }
         if(Boolean(this._leaf))
         {
            this._leaf = null;
         }
         if(Boolean(this._treeName))
         {
            this._treeName.dispose();
            this._treeName = null;
         }
         if(Boolean(this._level))
         {
            this._level.dispose();
            this._level = null;
         }
      }
   }
}

