package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import flash.display.Sprite;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   public class SuperWinnerPlayerListView extends Sprite implements Disposeable
   {
      
      private var _data:DictionaryData;
      
      private var _playerList:ListPanel;
      
      public function SuperWinnerPlayerListView(param1:DictionaryData)
      {
         this._data = param1;
         super();
         this.initbg();
         this.initView();
         this.initEvent();
      }
      
      private function initbg() : void
      {
         var _loc1_:Image = ComponentFactory.Instance.creat("superWinner.playerList.bg");
         addChild(_loc1_);
      }
      
      private function initView() : void
      {
         this._playerList = ComponentFactory.Instance.creatComponentByStylename("asset.superWinner.PlayerList");
         this._playerList.vScrollbar.visible = false;
         addChild(this._playerList);
         this._playerList.list.updateListView();
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.addEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
      }
      
      private function __addPlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
      }
      
      private function __removePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
      }
      
      private function __updatePlayer(param1:DictionaryEvent) : void
      {
         var _loc2_:PlayerInfo = param1.data as PlayerInfo;
         this._playerList.vectorListModel.remove(_loc2_);
         this._playerList.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc2_));
         this._playerList.list.updateListView();
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc2_:PlayerInfo = null;
         var _loc3_:int = 0;
         var _loc4_:Array = this._playerList.vectorListModel.elements;
         if(_loc4_.length == 0)
         {
            return 0;
         }
         var _loc5_:int = _loc4_.length - 1;
         while(_loc5_ >= 0)
         {
            _loc2_ = _loc4_[_loc5_] as PlayerInfo;
            if(!(param1.IsVIP && !_loc2_.IsVIP))
            {
               if(!param1.IsVIP && _loc2_.IsVIP)
               {
                  return _loc5_ + 1;
               }
               if(param1.IsVIP == _loc2_.IsVIP)
               {
                  if(param1.Grade <= _loc2_.Grade)
                  {
                     return _loc5_ + 1;
                  }
                  _loc3_ = _loc5_ - 1;
               }
            }
            _loc5_--;
         }
         return _loc3_ < 0 ? int(0) : int(_loc3_);
      }
      
      public function dispose() : void
      {
         this._data.removeEventListener(DictionaryEvent.ADD,this.__addPlayer);
         this._data.removeEventListener(DictionaryEvent.REMOVE,this.__removePlayer);
         this._data.removeEventListener(DictionaryEvent.UPDATE,this.__updatePlayer);
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

