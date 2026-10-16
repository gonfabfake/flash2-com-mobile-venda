package luckStar.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarAwardView extends Sprite implements Disposeable
   {
      
      private var bg:Bitmap;
      
      private var _closeBtn:BaseButton;
      
      private var _list:Vector.<BaseCell>;
      
      private var _countList:Vector.<FilterFrameText>;
      
      public function LuckStarAwardView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._countList = new Vector.<FilterFrameText>();
         this.bg = ComponentFactory.Instance.creat("luckyStar.view.AwardListBG");
         this._closeBtn = ComponentFactory.Instance.creat("luckyStar.view.RankBtn");
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.__onClose);
         addChild(this.bg);
         addChild(this._closeBtn);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc3_:int = 0;
         var _loc4_:FilterFrameText = null;
         var _loc1_:Vector.<InventoryItemInfo> = null;
         var _loc2_:int = 0;
         _loc3_ = 0;
         _loc4_ = null;
         var _loc5_:Array = [11,12,13,14,15,16];
         _loc1_ = LuckStarManager.Instance.model.reward;
         var _loc6_:int = int(_loc1_.length);
         var _loc7_:int = 0;
         this._list = new Vector.<BaseCell>(_loc6_);
         while(Boolean(_loc5_.length))
         {
            _loc2_ = _loc5_.shift();
            _loc7_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc6_)
            {
               if(_loc1_[_loc3_].Quality == _loc2_)
               {
                  this._list[_loc3_] = new BaseCell(new Sprite(),_loc1_[_loc3_]);
                  this._list[_loc3_].setContentSize(45,45);
                  this._list[_loc3_].info = _loc1_[_loc3_];
                  this._list[_loc3_].info.Quality = ItemManager.Instance.getTemplateById(_loc1_[_loc3_].TemplateID).Quality;
                  PositionUtils.setPos(this._list[_loc3_],"luckyStar.view.awardPos" + _loc2_ + _loc7_);
                  addChild(this._list[_loc3_]);
                  if(_loc1_[_loc3_].Count > 1)
                  {
                     _loc4_ = ComponentFactory.Instance.creat("luckyStar.view.cellCount");
                     _loc4_.text = _loc1_[_loc3_].Count.toString();
                     _loc4_.x = this._list[_loc3_].x - 12;
                     _loc4_.y = this._list[_loc3_].y + 25;
                     addChild(_loc4_);
                     this._countList.push(_loc4_);
                  }
                  _loc7_++;
               }
               _loc3_++;
            }
         }
      }
      
      private function __onClose(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.parent.removeChild(this);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this.bg);
         this.bg = null;
         this._closeBtn.removeEventListener(MouseEvent.CLICK,this.__onClose);
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         while(Boolean(this._list.length))
         {
            ObjectUtils.disposeObject(this._list.pop());
         }
         this._list = null;
         while(Boolean(this._countList.length))
         {
            ObjectUtils.disposeObject(this._countList.pop());
         }
         this._countList = null;
      }
   }
}

