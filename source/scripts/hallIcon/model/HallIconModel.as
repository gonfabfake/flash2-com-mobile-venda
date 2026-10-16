package hallIcon.model
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.event.HallIconEvent;
   
   public class HallIconModel extends EventDispatcher
   {
      
      public var expblessedIsOpen:Boolean;
      
      public var expblessedValue:int;
      
      public var activityIsOpen:Boolean;
      
      public var wonderFulPlayIsOpen:Boolean;
      
      public var _loginToal:Boolean = false;
      
      public var cacheRightIconDic:Dictionary;
      
      public var cacheRightIconTask:Object;
      
      public var cacheRightIconLevelLimit:Dictionary;
      
      public function HallIconModel(param1:IEventDispatcher = null)
      {
         super(param1);
         this.cacheRightIconDic = new Dictionary();
         this.cacheRightIconLevelLimit = new Dictionary();
      }
      
      public function get loginToal() : Boolean
      {
         return this._loginToal;
      }
      
      public function set loginToal(param1:Boolean) : void
      {
         this._loginToal = param1;
      }
      
      public function dataChange(param1:String, param2:Object = null) : void
      {
         dispatchEvent(new HallIconEvent(param1,param2));
      }
   }
}

