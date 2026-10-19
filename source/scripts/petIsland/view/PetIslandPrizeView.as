package petIsland.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import ddt.manager.ItemManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petIsland.PetIslandManager;
   
   public class PetIslandPrizeView extends Sprite
   {
      
      private var _line1_2:Bitmap;
      
      private var _line2_3:Bitmap;
      
      private var _line3_4:Bitmap;
      
      private var _line4_5:Bitmap;
      
      private var _prize1:MovieClip;
      
      private var _prize2:MovieClip;
      
      private var _prize3:MovieClip;
      
      private var _prize4:MovieClip;
      
      private var _prize5:MovieClip;
      
      private var _contain1:Component;
      
      private var _contain2:Component;
      
      private var _contain3:Component;
      
      private var _contain4:Component;
      
      private var _contain5:Component;
      
      private var lineArr:Array = [];
      
      private var prizeArr:Array = [];
      
      public function PetIslandPrizeView()
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         super();
         this._line1_2 = ComponentFactory.Instance.creatBitmap("asset.petIsland.prizeLine1_2");
         this._line2_3 = ComponentFactory.Instance.creatBitmap("asset.petIsland.prizeLine2_3");
         this._line3_4 = ComponentFactory.Instance.creatBitmap("asset.petIsland.prizeLine3_4");
         this._line4_5 = ComponentFactory.Instance.creatBitmap("asset.petIsland.prizeLine4_5");
         this.lineArr.push(this._line1_2);
         this.lineArr.push(this._line2_3);
         this.lineArr.push(this._line3_4);
         this.lineArr.push(this._line4_5);
         this._line1_2.alpha = this._line2_3.alpha = this._line3_4.alpha = this._line4_5.alpha = 0.5;
         this._prize1 = ComponentFactory.Instance.creat("asset.petIsland.prize1");
         this._prize2 = ComponentFactory.Instance.creat("asset.petIsland.prize2");
         this._prize3 = ComponentFactory.Instance.creat("asset.petIsland.prize3");
         this._prize4 = ComponentFactory.Instance.creat("asset.petIsland.prize4");
         this._prize5 = ComponentFactory.Instance.creat("asset.petIsland.prize5");
         this.prizeArr.push(this._prize1);
         this.prizeArr.push(this._prize2);
         this.prizeArr.push(this._prize3);
         this.prizeArr.push(this._prize4);
         this.prizeArr.push(this._prize5);
         this._prize2.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._prize3.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._prize4.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._prize5.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._prize1["round"].visible = this._prize2["round"].visible = this._prize3["round"].visible = this._prize4["round"].visible = this._prize5["round"].visible = false;
         this._prize1.gotoAndStop(1);
         this._prize2.gotoAndStop(1);
         this._prize3.gotoAndStop(1);
         this._prize4.gotoAndStop(1);
         this._prize5.gotoAndStop(1);
         this._prize1.addEventListener("click",this.clickHandler);
         this._prize2.addEventListener("click",this.clickHandler);
         this._prize3.addEventListener("click",this.clickHandler);
         this._prize4.addEventListener("click",this.clickHandler);
         this._prize5.addEventListener("click",this.clickHandler);
         addChild(this._line1_2);
         addChild(this._line2_3);
         addChild(this._line3_4);
         addChild(this._line4_5);
         this._contain1 = ComponentFactory.Instance.creatComponentByStylename("petIsland.collectionItem.itemTipContent");
         this._contain2 = ComponentFactory.Instance.creatComponentByStylename("petIsland.collectionItem.itemTipContent");
         this._contain3 = ComponentFactory.Instance.creatComponentByStylename("petIsland.collectionItem.itemTipContent");
         this._contain4 = ComponentFactory.Instance.creatComponentByStylename("petIsland.collectionItem.itemTipContent");
         this._contain5 = ComponentFactory.Instance.creatComponentByStylename("petIsland.collectionItem.itemTipContent");
         this._contain1.addChild(this._prize1);
         this._contain2.addChild(this._prize2);
         this._contain3.addChild(this._prize3);
         this._contain4.addChild(this._prize4);
         this._contain5.addChild(this._prize5);
         PositionUtils.setPos(this._contain1,"asset.petIsland.prize1.position");
         PositionUtils.setPos(this._contain2,"asset.petIsland.prize2.position");
         PositionUtils.setPos(this._contain3,"asset.petIsland.prize3.position");
         PositionUtils.setPos(this._contain4,"asset.petIsland.prize4.position");
         PositionUtils.setPos(this._contain5,"asset.petIsland.prize5.position");
         _loc1_ = ItemManager.Instance.getTemplateById(201623);
         _loc2_ = new BagCell(0,_loc1_);
         this._contain1.buttonMode = true;
         this._contain1.tipData = _loc2_.tipData;
         _loc1_ = ItemManager.Instance.getTemplateById(201624);
         _loc2_ = new BagCell(0,_loc1_);
         this._contain2.buttonMode = true;
         this._contain2.tipData = _loc2_.tipData;
         _loc1_ = ItemManager.Instance.getTemplateById(201625);
         _loc2_ = new BagCell(0,_loc1_);
         this._contain3.buttonMode = true;
         this._contain3.tipData = _loc2_.tipData;
         _loc1_ = ItemManager.Instance.getTemplateById(201626);
         _loc2_ = new BagCell(0,_loc1_);
         this._contain4.buttonMode = true;
         this._contain4.tipData = _loc2_.tipData;
         _loc1_ = ItemManager.Instance.getTemplateById(201627);
         _loc2_ = new BagCell(0,_loc1_);
         this._contain5.buttonMode = true;
         this._contain5.tipData = _loc2_.tipData;
         addChild(this._contain1);
         addChild(this._contain2);
         addChild(this._contain3);
         addChild(this._contain4);
         addChild(this._contain5);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         switch(param1.currentTarget)
         {
            case this._prize1:
               _loc2_ = 1;
               break;
            case this._prize2:
               _loc2_ = 2;
               break;
            case this._prize3:
               _loc2_ = 3;
               break;
            case this._prize4:
               _loc2_ = 4;
               break;
            case this._prize5:
               _loc2_ = 5;
         }
         if(_loc2_ >= PetIslandManager.instance.model.currentLevel)
         {
            return;
         }
         SocketManager.Instance.out.petIslandPrize(_loc2_);
      }
      
      public function setPrizeView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = PetIslandManager.instance.model.rewardRecord.split("|");
         _loc1_ = 0;
         while(_loc1_ < PetIslandManager.instance.model.currentLevel)
         {
            if(_loc1_ == ServerConfigManager.instance.petDisappearMaxLevel)
            {
               break;
            }
            if(_loc1_ != 0)
            {
               this.lineArr[_loc1_ - 1].alpha = 1;
            }
            this.prizeArr[_loc1_].filters = null;
            _loc1_++;
         }
         if(PetIslandManager.instance.model.currentLevel <= ServerConfigManager.instance.petDisappearMaxLevel)
         {
            this.prizeArr[PetIslandManager.instance.model.currentLevel - 1]["round"].visible = true;
         }
         _loc2_ = 1;
         while(_loc2_ <= this.prizeArr.length)
         {
            if(_loc3_.indexOf(String(_loc2_)) == -1)
            {
               if(_loc2_ < PetIslandManager.instance.model.currentLevel)
               {
                  this.prizeArr[_loc2_ - 1].gotoAndStop(2);
               }
               else
               {
                  this.prizeArr[_loc2_ - 1].gotoAndStop(1);
               }
            }
            else
            {
               this.prizeArr[_loc2_ - 1].gotoAndStop(3);
            }
            _loc2_++;
         }
      }
   }
}

