package rank.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import rank.RankManager;
   import rank.data.RankInfo;
   
   public class RankRewardView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var vbox:VBox;
      
      private var _checkBtn:BaseButton;
      
      private var type:int;
      
      private var _frame:RankInfoFrame;
      
      public function RankRewardView()
      {
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.rank.reward.bg");
         addChild(this._bg);
         this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("rank.checkRankBtn");
         addChild(this._checkBtn);
         this._checkBtn.addEventListener("click",this.checkBtnHandler);
      }
      
      private function checkBtnHandler(param1:MouseEvent) : void
      {
         if(Boolean(RankManager.instance.reweadDataList) && RankManager.instance.reweadDataList.length > 0)
         {
            this._frame = ComponentFactory.Instance.creatCustomObject("rank.RankInfoFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.rankFrame.title");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
      }
      
      public function setData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         ObjectUtils.disposeObject(this.vbox);
         this.vbox = null;
         this.vbox = ComponentFactory.Instance.creatComponentByStylename("rank.ActivityState.Vbox");
         addChild(this.vbox);
         _loc1_ = 1;
         while(_loc1_ <= RankManager.instance.model.currentInfo.giftbagArray.length)
         {
            _loc2_ = new RankInfo();
            _loc2_ = RankManager.instance.rankData(RankManager.instance.model.currentInfo.giftbagArray,_loc1_);
            if((Boolean(_loc2_)) && Boolean(_loc2_.giftRewardArr))
            {
               _loc3_ = new HBox();
               _loc4_ = 0;
               while(_loc4_ < _loc2_.giftRewardArr.length)
               {
                  _loc5_ = new InventoryItemInfo();
                  _loc5_.TemplateID = _loc2_.giftRewardArr[_loc4_].templateId;
                  _loc5_ = ItemManager.fill(_loc5_);
                  _loc5_.IsBinds = _loc2_.giftRewardArr[_loc4_].isBind;
                  _loc5_.ValidDate = _loc2_.giftRewardArr[_loc4_].validDate;
                  _loc6_ = _loc2_.giftRewardArr[_loc4_].property.split(",");
                  _loc5_.StrengthenLevel = parseInt(_loc6_[0]);
                  _loc5_.AttackCompose = parseInt(_loc6_[1]);
                  _loc5_.DefendCompose = parseInt(_loc6_[2]);
                  _loc5_.AgilityCompose = parseInt(_loc6_[3]);
                  _loc5_.LuckCompose = parseInt(_loc6_[4]);
                  _loc5_.Count = _loc2_.giftRewardArr[_loc4_].count;
                  _loc7_ = new BagCell(0,_loc5_,false,ComponentFactory.Instance.creatBitmap("asset.rank.cellBg"));
                  if(_loc5_.MaxCount == 1 && _loc5_.Count > _loc5_.MaxCount)
                  {
                     _loc8_ = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
                     _loc8_.text = String(_loc5_.Count);
                     _loc8_.x = 34;
                     _loc8_.y = 31;
                     _loc7_.addChild(_loc8_);
                  }
                  _loc7_.x = _loc4_ * _loc7_.width;
                  _loc7_.refreshTbxPos();
                  _loc3_.addChild(_loc7_);
                  _loc4_++;
               }
               _loc3_.y = _loc1_ * 50;
               this.vbox.addChild(_loc3_);
            }
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._checkBtn))
         {
            this._checkBtn.removeEventListener("click",this.checkBtnHandler);
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this.vbox);
         this.vbox = null;
         ObjectUtils.disposeObject(this._checkBtn);
         this._checkBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

