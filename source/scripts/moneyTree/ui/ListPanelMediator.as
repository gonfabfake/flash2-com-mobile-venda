package moneyTree.ui
{
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.cell.IListCell;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   import invite.data.InvitePlayerInfo;
   
   public class ListPanelMediator
   {
      
      private var _listPanel:ListPanel;
      
      private var _invitePlayerInfos:Array;
      
      public function ListPanelMediator()
      {
         super();
      }
      
      public function setPanel(param1:ListPanel) : void
      {
         this._listPanel = param1;
      }
      
      public function refresh(param1:int, param2:int = 0) : void
      {
         var type:int = param1;
         var count:int = param2;
         var hasMounts:* = function(param1:*, param2:int, param3:Array):Boolean
         {
            return param1.Grade >= 25;
         };
         var titleList:Array = PlayerManager.Instance.friendList.slice();
         titleList = titleList.filter(hasMounts);
         titleList.sortOn("Grade",2);
         this.updateList(0,titleList);
      }
      
      private function updateList(param1:int, param2:Array) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = this._listPanel.list.viewPosition.y;
         this.clearList();
         this._invitePlayerInfos = [];
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param2[_loc4_] as BasePlayer;
            if(_loc5_.ID != PlayerManager.Instance.Self.ID)
            {
               _loc3_ = new InvitePlayerInfo();
               _loc3_.NickName = _loc5_.NickName;
               _loc3_.typeVIP = _loc5_.typeVIP;
               _loc3_.Sex = _loc5_.Sex;
               _loc3_.Grade = _loc5_.Grade;
               _loc3_.Repute = _loc5_.Repute;
               _loc3_.WinCount = _loc5_.WinCount;
               _loc3_.TotalCount = _loc5_.TotalCount;
               _loc3_.FightPower = _loc5_.FightPower;
               _loc3_.ID = _loc5_.ID;
               _loc3_.Offer = _loc5_.Offer;
               _loc3_.isOld = _loc5_.isOld;
               _loc3_.titleType = (_loc5_ as FriendListPlayer).titleType;
               _loc3_.type = (_loc5_ as FriendListPlayer).type;
               _loc3_.titleText = (_loc5_ as FriendListPlayer).titleText;
               _loc3_.titleNumText = (_loc5_ as FriendListPlayer).titleNumText;
               this._invitePlayerInfos.push(_loc3_);
            }
            _loc4_++;
         }
         var _loc7_:Array = this._invitePlayerInfos;
         this._listPanel.vectorListModel.clear();
         this._listPanel.vectorListModel.appendAll(_loc7_);
         this._listPanel.list.updateListView();
         var _loc8_:IntPoint = new IntPoint(0,_loc6_);
         this._listPanel.list.viewPosition = _loc8_;
      }
      
      private function clearList() : void
      {
         this._listPanel.vectorListModel.clear();
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<IListCell> = this._listPanel.list.cell;
         var _loc3_:int = int(_loc2_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            (_loc2_[_loc1_] as MoneyTreeSendRedPkgCell).reset();
            _loc1_++;
         }
      }
   }
}

