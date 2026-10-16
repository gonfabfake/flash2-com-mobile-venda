package welfareCenter.callBackLotteryDraw
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import welfareCenter.callBackLotteryDraw.view.FilterFrameTextMiddleLine;
   
   public class CallBackLotteryDrawController extends EventDispatcher
   {
      
      private static var _instance:CallBackLotteryDrawController;
      
      private var _frame:Frame;
      
      public function CallBackLotteryDrawController(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : CallBackLotteryDrawController
      {
         if(_instance == null)
         {
            _instance = new CallBackLotteryDrawController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         CallBackLotteryDrawManager.instance.addEventListener("event_open_frame",this.onOpenView);
         CallBackLotteryDrawManager.instance.addEventListener("event_zero_fresh",this.onZeroFresh);
      }
      
      protected function onOpenView(param1:Event) : void
      {
         this.disposeFrame();
         if(CallBackLotteryDrawManager.instance.type == 1)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("luckeylotterydraw.LuckeyLotteryDrawFrame");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
      }
      
      private function onZeroFresh(param1:Event) : void
      {
         if(Boolean(this._frame))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("callbacklotterdraw.zeroFresh"));
         }
         this.disposeFrame();
      }
      
      public function getCardShowFont(param1:Object, param2:String) : Sprite
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Sprite = null;
         var _loc5_:String = null;
         var _loc6_:BagCell = null;
         var _loc8_:FilterFrameText = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:FilterFrameTextMiddleLine = null;
         var _loc13_:Bitmap = null;
         var _loc14_:Bitmap = null;
         _loc3_ = param1["InventoryItemInfo"];
         _loc4_ = new Sprite();
         UICreatShortcut.creatAndAdd(param2 + ".pic6",_loc4_);
         _loc5_ = _loc3_.Name;
         if(_loc5_.length > 10)
         {
            _loc5_ = _loc5_.slice(0,8) + "...";
         }
         UICreatShortcut.creatTextAndAdd(param2 + ".goodNameTf",_loc5_,_loc4_);
         _loc6_ = new BagCell(1);
         _loc6_.BGVisible = false;
         _loc6_.setContentSize(60,60);
         _loc6_.info = _loc3_;
         _loc6_.setCount(_loc3_.Count);
         _loc6_.x = 30;
         _loc6_.y = 38;
         _loc4_.addChild(_loc6_);
         UICreatShortcut.creatAndAdd(param2 + ".pic8",_loc4_);
         var _loc7_:String = LanguageMgr.GetTranslation("callbacklotterdraw.discoutTxt",100 - param1["LimitCount"]);
         UICreatShortcut.creatTextAndAdd(param2 + ".discountTf",_loc7_,_loc4_);
         _loc8_ = ComponentFactory.Instance.creat(param2 + ".priceTf");
         _loc8_.text = LanguageMgr.GetTranslation("callbacklotterdraw.priceTxt",param1["Cost"]);
         _loc9_ = _loc8_.x;
         _loc10_ = _loc8_.y;
         _loc8_.x = 0;
         _loc8_.y = 0;
         _loc11_ = new FilterFrameTextMiddleLine(_loc8_);
         _loc11_.x = _loc9_;
         _loc11_.y = _loc10_;
         _loc11_.drawMiddleLine(1,_loc8_.textColor,1,4,_loc8_.text.length - 1);
         _loc4_.addChild(_loc11_);
         var _loc12_:int = param1["Cost"] * param1["LimitCount"] / 100;
         UICreatShortcut.creatTextAndAdd(param2 + ".newPriceTf",LanguageMgr.GetTranslation("callbacklotterdraw.newPriceTxt",_loc12_),_loc4_);
         _loc13_ = UICreatShortcut.creatAndAdd("asset.ddtshop.PayTypeLabelTicket",_loc4_);
         _loc13_.scaleX = 0.6;
         _loc13_.scaleY = 0.6;
         PositionUtils.setPos(_loc13_,param2 + ".ticketIcon1");
         _loc14_ = UICreatShortcut.creatAndAdd("asset.ddtshop.PayTypeLabelTicket",_loc4_);
         _loc14_.scaleX = 0.6;
         _loc14_.scaleY = 0.6;
         PositionUtils.setPos(_loc14_,param2 + ".ticketIcon2");
         return _loc4_;
      }
      
      public function disposeFrame() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.dispose();
            this._frame = null;
         }
      }
   }
}

