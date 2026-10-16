package cloudBuyLottery.view
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.events.EventDispatcher;
   
   public class WinningLogItemInfo extends EventDispatcher
   {
      
      public var TemplateID:int;
      
      private var _templateInfo:ItemTemplateInfo;
      
      private var _logNameArr:Array;
      
      public var nickName:String;
      
      public var count:int;
      
      public var validate:int;
      
      public var property:Array;
      
      public function WinningLogItemInfo(param1:int = 0)
      {
         super();
         this.TemplateID = param1;
      }
      
      public function get TemplateInfo() : ItemTemplateInfo
      {
         if(this._templateInfo == null)
         {
            return ItemManager.Instance.getTemplateById(this.TemplateID);
         }
         return this._templateInfo;
      }
      
      public function get logNameArr() : Array
      {
         return this._logNameArr;
      }
      
      public function set logNameArr(param1:Array) : void
      {
         this._logNameArr = param1;
      }
   }
}

