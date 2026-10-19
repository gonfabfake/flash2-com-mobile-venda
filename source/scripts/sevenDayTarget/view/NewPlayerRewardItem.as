package sevenDayTarget.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   
   public class NewPlayerRewardItem extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _titleText:FilterFrameText;
      
      private var _getRewardBnt:BaseButton;
      
      private var _rewardList:SimpleTileList;
      
      private var _info:NewPlayerRewardInfo;
      
      public function NewPlayerRewardItem()
      {
         super();
      }
      
      public function setInfo(param1:NewPlayerRewardInfo) : void
      {
         var _loc2_:NewPlayerRewardCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = param1.rewardArr;
         var _loc5_:int = param1.bgType;
         var _loc6_:int = int(_loc4_.length);
         var _loc7_:Boolean = param1.finished;
         var _loc8_:Boolean = param1.getRewarded;
         this._info = param1;
         if(!_loc7_)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt");
            this._getRewardBnt.enable = false;
         }
         else if(_loc7_ && !_loc8_)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt");
            this._getRewardBnt.enable = true;
         }
         else if(_loc8_)
         {
            this._getRewardBnt = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.newplayerRewardItemRewardBnt2");
            this._getRewardBnt.enable = false;
         }
         this._getRewardBnt.addEventListener(MouseEvent.CLICK,this.__getReward);
         if(_loc6_ <= 4 && _loc6_ > 0 && _loc5_ == NewPlayerRewardMainView.CHONGZHI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.chongzhi");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.chongzhitext",param1.num);
         }
         else if(_loc6_ > 4 && _loc6_ <= 8 && _loc5_ == NewPlayerRewardMainView.CHONGZHI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.chongzhibig");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext1");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.chongzhitext",param1.num);
         }
         else if(_loc6_ <= 4 && _loc6_ > 0 && _loc5_ == NewPlayerRewardMainView.XIAOFEI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.xiaofei");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.xiaofeitext",param1.num);
         }
         else if(_loc6_ > 4 && _loc6_ <= 8 && _loc5_ == NewPlayerRewardMainView.XIAOFEI)
         {
            this._bg = ComponentFactory.Instance.creat("newSevenDayAndNewPlayer.xiaofeiibig");
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext2");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.xiaofeitext",param1.num);
         }
         else
         {
            this._titleText = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.titletext3");
            this._titleText.text = LanguageMgr.GetTranslation("newSevenDayAndNewPlayer.hunlitext");
         }
         PositionUtils.setPos(this._titleText,"newSevenDayAndNewPlayer.newplayerRewardItemTitlePos");
         if(_loc6_ <= 4 && _loc6_ > 0)
         {
            PositionUtils.setPos(this._getRewardBnt,"newSevenDayAndNewPlayer.newplayerRewardItemRewardBntPos");
         }
         else
         {
            PositionUtils.setPos(this._getRewardBnt,"newSevenDayAndNewPlayer.newplayerRewardItemRewardBntPos2");
         }
         this._rewardList = ComponentFactory.Instance.creat("newPlayerReward.simpleTileList.rewardList",[4]);
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         addChild(this._titleText);
         addChild(this._getRewardBnt);
         addChild(this._rewardList);
         var _loc9_:int = 0;
         while(_loc9_ < _loc4_.length)
         {
            _loc2_ = new NewPlayerRewardCell();
            _loc3_ = _loc4_[_loc9_] as InventoryItemInfo;
            _loc2_.info = ItemManager.Instance.getTemplateById(_loc3_.ItemID);
            _loc2_.itemNum = _loc3_.Count + "";
            this._rewardList.addChild(_loc2_);
            _loc9_++;
         }
      }
      
      private function __getReward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._getRewardBnt))
         {
            this._getRewardBnt.backStyle = "newSevenDayAndNewPlayer.getRewardBG1";
            this._getRewardBnt.enable = false;
         }
         var _loc2_:int = this._info.questId;
         SocketManager.Instance.out.newPlayerReward_getReward(_loc2_);
      }
      
      private function initView(param1:int) : void
      {
      }
   }
}

