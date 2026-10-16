package regularEventSystem
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.states.BaseStateView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class regularEventSystemView extends BaseStateView
   {
      
      private static var _instance:regularEventSystemView;
      
      public static var _regularEventValue_wander_new_active:int;
      
      public static var _regularEventStatus:int;
      
      public static var _regularEventStatus_Active_1:int;
      
      public static var _regularEventValue_stats_1:int;
      
      public static var _regularEventValue_stats_2:int;
      
      public static var _regularEventValue_stats_3:int;
      
      public static var _regularEventValue_stats_4:int;
      
      public static var _regularEventValue_Count_1:int;
      
      public static var _regularEventValue_Count_2:int;
      
      public static var _regularEventValue_Count_3:int;
      
      public static var _regularEventValue_Count_4:int;
      
      public static var _regularEventValue_Count_5:int;
      
      public static var _regularEventValue_Count_6:int;
      
      public static var _regularEventValue_Count_7:int;
      
      public static var _regularEventValue_Count_8:int;
      
      public static var _regularEventValue_Count_9:int;
      
      public static var _regularEventValue_Count_10:int;
      
      public static var _regularEventValue_Count_11:int;
      
      public static var _regularEventValue_Count_12:int;
      
      public static var _regularEventValue_2:int;
      
      public static var _regularEventValue_3:int;
      
      public static var _regularEventValue_4:int;
      
      public static var _regularEventValue_5:int;
      
      public static var _regularEventValue_6:int;
      
      public static var _regularEventValue_7:int;
      
      public static var _regularEventValue_8:int;
      
      public static var _regularEventValue_9:int;
      
      public static var _regularEventValue_10:int;
      
      public static var _regularEventValue_11:int;
      
      public static var _regularEventValue_12:int;
      
      public static var _regularEventValue_13:int;
      
      public static var _regularEventValue_wander_deger_1:String;
      
      public static var _regularEventValue_wander_deger_2:String;
      
      public static var _regularEventValue_wander_deger_3:String;
      
      public static var _regularEventValue_wander_deger_4:String;
      
      public static var _regularEventValue_wander_deger_5:String;
      
      public static var _regularEventValue_wander_deger_6:String;
      
      public static var _regularEventValue_wander_deger_7:String;
      
      public static var _regularEventValue_wander_deger_8:String;
      
      public var _regularEventExplainBg:Bitmap;
      
      public var _regularEventExplainBg_1:Bitmap;
      
      public var _regularEventExplainBg_2:Bitmap;
      
      public var _regularEventExplainBg_3:Bitmap;
      
      public var _regularEventItemCellBg_1:Bitmap;
      
      public var _regularEventItemCellBg_2:Bitmap;
      
      public var _regularEventItemCellBg_3:Bitmap;
      
      public var _regularEventItemCellBg_4:Bitmap;
      
      public var _regularEventItemCellBg_5:Bitmap;
      
      public var _regularEventItemCellBg_6:Bitmap;
      
      public var _regularEventItemCellBg_7:Bitmap;
      
      public var _regularEventItemCellBg_8:Bitmap;
      
      public var _regularEventItemCellBg_9:Bitmap;
      
      public var _regularEventItemCellBg_10:Bitmap;
      
      public var _regularEventItemCellBg_11:Bitmap;
      
      public var _regularEventItemCellBg_12:Bitmap;
      
      public var _regularEventPic:ScaleFrameImage;
      
      public var _regularEventSmallPic:ScaleFrameImage;
      
      public var _regularEventShufflePic:ScaleFrameImage;
      
      public var _regularEventTimeLeftPic:ScaleFrameImage;
      
      public var _regularEventTitleText:FilterFrameText;
      
      public var _regularEventContentText:FilterFrameText;
      
      public var _regularEventTitleText_1:FilterFrameText;
      
      public var _regularEventContentText_1:FilterFrameText;
      
      public var _regularEventTitleText_2:FilterFrameText;
      
      public var _regularEventContentText_2:FilterFrameText;
      
      public var _regularEventTitleText_3:FilterFrameText;
      
      public var _regularEventContentText_3:FilterFrameText;
      
      public var _hideEventHolderBtn:SimpleBitmapButton;
      
      public var _showEventHolderBtn:SimpleBitmapButton;
      
      public var _shuffleRateAlert:BaseAlerFrame;
      
      public var _shuffleRateMoney:int;
      
      public var _shuffleRate:int;
      
      public var _nextEventTimer:Timer;
      
      public var _startEventTime:Number;
      
      public var _nextEventTimeLeft:int;
      
      private var _loc3_:ItemTemplateInfo = null;
      
      private var _loc4_:RegularEventItemCell = null;
      
      private var _loc5_:ItemTemplateInfo = null;
      
      private var _loc6_:RegularEventItemCell = null;
      
      private var _loc7_:ItemTemplateInfo = null;
      
      private var _loc8_:RegularEventItemCell = null;
      
      private var _loc9_:ItemTemplateInfo = null;
      
      private var _loc10_:RegularEventItemCell = null;
      
      private var _loc11_:ItemTemplateInfo = null;
      
      private var _loc12_:RegularEventItemCell = null;
      
      private var _loc13_:ItemTemplateInfo = null;
      
      private var _loc14_:RegularEventItemCell = null;
      
      private var _loc15_:ItemTemplateInfo = null;
      
      private var _loc16_:RegularEventItemCell = null;
      
      private var _loc17_:ItemTemplateInfo = null;
      
      private var _loc18_:RegularEventItemCell = null;
      
      private var _loc19_:ItemTemplateInfo = null;
      
      private var _loc20_:RegularEventItemCell = null;
      
      private var _loc21_:ItemTemplateInfo = null;
      
      private var _loc22_:RegularEventItemCell = null;
      
      private var _loc23_:ItemTemplateInfo = null;
      
      private var _loc24_:RegularEventItemCell = null;
      
      private var _loc25_:ItemTemplateInfo = null;
      
      private var _loc26_:RegularEventItemCell = null;
      
      public function regularEventSystemView()
      {
         super();
      }
      
      public static function get instance() : regularEventSystemView
      {
         if(_instance == null)
         {
            _instance = new regularEventSystemView();
         }
         return _instance;
      }
      
      public function __updateRegularEventStatus(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _regularEventStatus = _loc2_.readInt();
         this._shuffleRateMoney = _loc2_.readInt();
         this._nextEventTimeLeft = _loc2_.readInt();
         _regularEventStatus_Active_1 = _loc2_.readInt();
         _regularEventValue_stats_1 = _loc2_.readInt();
         _regularEventValue_2 = _loc2_.readInt();
         _regularEventValue_3 = _loc2_.readInt();
         _regularEventValue_4 = _loc2_.readInt();
         _regularEventValue_Count_1 = _loc2_.readInt();
         _regularEventValue_Count_2 = _loc2_.readInt();
         _regularEventValue_Count_3 = _loc2_.readInt();
         _regularEventValue_wander_deger_1 = _loc2_.readUTF();
         _regularEventValue_wander_deger_2 = _loc2_.readUTF();
      }
      
      public function showRegularEvent(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         _loc2_ = 0;
         SocketManager.Instance.out.chkRegularEventStatus(1);
         _loc2_ = param1;
         this._regularEventPic = ComponentFactory.Instance.creatComponentByStylename("core.regularEventIcon");
         this._regularEventSmallPic = ComponentFactory.Instance.creatComponentByStylename("core.regularEventSmallIcon");
         LayerManager.Instance.addToLayer(this._regularEventPic,LayerManager.GAME_DYNAMIC_LAYER);
         LayerManager.Instance.addToLayer(this._regularEventSmallPic,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventPic.buttonMode = false;
         this._regularEventExplainBg = ComponentFactory.Instance.creatBitmap("asset.core.regularEventExplainBG");
         LayerManager.Instance.addToLayer(this._regularEventExplainBg,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventExplainBg.x = 65;
         this._regularEventExplainBg.y = 8;
         this._regularEventTitleText = ComponentFactory.Instance.creatComponentByStylename("asset.core.regularEventTitleText");
         LayerManager.Instance.addToLayer(this._regularEventTitleText,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventTitleText.x = 95;
         this._regularEventTitleText.y = 17;
         this._regularEventContentText = ComponentFactory.Instance.creatComponentByStylename("asset.core.regularEventContentText");
         LayerManager.Instance.addToLayer(this._regularEventContentText,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventContentText.x = this._regularEventTitleText.x;
         this._regularEventContentText.y = this._regularEventTitleText.y + 20;
         this._regularEventExplainBg.visible = false;
         this._regularEventTitleText.visible = false;
         this._regularEventPic.setFrame(1);
         this._regularEventSmallPic.setFrame(1);
         this._regularEventPic.x = 18;
         this._regularEventPic.y = 16;
         this._regularEventSmallPic.x = this._regularEventPic.x + 15;
         this._regularEventSmallPic.y = this._regularEventPic.y + 9;
         if(_loc2_ == 1)
         {
            this._regularEventSmallPic.addEventListener(MouseEvent.MOUSE_OVER,this.__showRegularEventInfo);
            this._regularEventSmallPic.addEventListener(MouseEvent.MOUSE_OUT,this.__hideRegularEventInfo);
            this._regularEventPic.visible = false;
            this._regularEventSmallPic.visible = true;
         }
         else
         {
            this._regularEventPic.addEventListener(MouseEvent.MOUSE_OVER,this.__showRegularEventInfo);
            this._regularEventPic.addEventListener(MouseEvent.MOUSE_OUT,this.__hideRegularEventInfo);
            this._regularEventSmallPic.visible = false;
            this._regularEventPic.visible = true;
         }
      }
      
      private function createItemCellBG_1() : void
      {
         this._regularEventItemCellBg_1 = ComponentFactory.Instance.creatBitmap("asset.core.regularEventItemCellBackground");
         LayerManager.Instance.addToLayer(this._regularEventItemCellBg_1,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventItemCellBg_1.x = 352;
         this._regularEventItemCellBg_1.y = 16;
         this._regularEventItemCellBg_1.visible = false;
      }
      
      private function createItemCellBG_2() : void
      {
         this._regularEventItemCellBg_2 = ComponentFactory.Instance.creatBitmap("asset.core.regularEventItemCellBackground");
         LayerManager.Instance.addToLayer(this._regularEventItemCellBg_2,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventItemCellBg_2.x = 422;
         this._regularEventItemCellBg_2.y = 16;
         this._regularEventItemCellBg_2.visible = false;
      }
      
      private function createItemCellBG_3() : void
      {
         this._regularEventItemCellBg_3 = ComponentFactory.Instance.creatBitmap("asset.core.regularEventItemCellBackground");
         LayerManager.Instance.addToLayer(this._regularEventItemCellBg_3,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventItemCellBg_3.x = 492;
         this._regularEventItemCellBg_3.y = 16;
         this._regularEventItemCellBg_3.visible = false;
      }
      
      public function showRegularEventTimeLeft() : void
      {
         this._regularEventTimeLeftPic = ComponentFactory.Instance.creatComponentByStylename("core.regularEventTimeLeftIcon");
         LayerManager.Instance.addToLayer(this._regularEventTimeLeftPic,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventTimeLeftPic.addEventListener(MouseEvent.MOUSE_OVER,this.__onHovRegularTimeLeft);
         this._regularEventTimeLeftPic.x = 58;
         this._regularEventTimeLeftPic.y = 47;
      }
      
      public function __onHovRegularTimeLeft(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.chkRegularEventStatus(1);
         this._regularEventTimeLeftPic.tipData;
         this._regularEventTimeLeftPic.tipData = "Bir sonraki etkinliğe " + this._nextEventTimeLeft + " dakika kaldı";
      }
      
      public function showRegularEventShuffle() : void
      {
         this._regularEventShufflePic = ComponentFactory.Instance.creatComponentByStylename("core.regularEventShuffleRateIcon");
         LayerManager.Instance.addToLayer(this._regularEventShufflePic,LayerManager.GAME_DYNAMIC_LAYER);
         this._regularEventShufflePic.addEventListener(MouseEvent.CLICK,this.__onClickRegularEventShuffle);
         this._regularEventShufflePic.addEventListener(MouseEvent.MOUSE_OVER,this.__onHovRegularEventShuffle);
         this._regularEventShufflePic.addEventListener(MouseEvent.MOUSE_OUT,this.__onOutRegularEventShuffle);
         this._regularEventShufflePic.setFrame(1);
         this._regularEventShufflePic.x = 58;
         this._regularEventShufflePic.y = 18;
         this._regularEventShufflePic.buttonMode = true;
      }
      
      public function __onClickRegularEventShuffle(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function __onHovRegularEventShuffle(param1:MouseEvent) : void
      {
         this._regularEventShufflePic.setFrame(2);
         this._regularEventShufflePic.tipData = "Şu anki etkinliğin oranını yükselt";
      }
      
      public function __onOutRegularEventShuffle(param1:MouseEvent) : void
      {
         this._regularEventShufflePic.setFrame(1);
      }
      
      public function __onShuffleRegularEventResponse(param1:FrameEvent) : void
      {
         (param1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onShuffleRegularEventResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.target == this._shuffleRateAlert)
         {
            this._shuffleRateAlert = null;
         }
         else if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.chkRegularEventStatus(2);
         }
      }
      
      public function __showRegularEventInfo(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.chkRegularEventStatus(1);
         this._regularEventPic.setFrame(2);
         this._regularEventSmallPic.setFrame(2);
         this._regularEventExplainBg.visible = true;
         this._regularEventTitleText.visible = true;
         this._regularEventContentText.visible = true;
         switch(_regularEventStatus)
         {
            case 1:
               switch(_regularEventStatus_Active_1)
               {
                  case 1:
                     if(_regularEventValue_2 != 0)
                     {
                        this._loc3_ = ItemManager.Instance.getTemplateById(_regularEventValue_2);
                        this._loc4_ = new RegularEventItemCell(_regularEventValue_Count_1,this._loc3_,true,"asset.core.regularEventItemCellBgAsset");
                        LayerManager.Instance.addToLayer(this._loc4_,LayerManager.GAME_DYNAMIC_LAYER);
                        this.createItemCellBG_1();
                        this._loc4_.x = this._regularEventItemCellBg_1.x + 29;
                        this._loc4_.y = this._regularEventItemCellBg_1.y + 6;
                        this._regularEventItemCellBg_1.visible = true;
                     }
                     if(_regularEventValue_3 != 0)
                     {
                        this._loc5_ = ItemManager.Instance.getTemplateById(_regularEventValue_3);
                        this._loc6_ = new RegularEventItemCell(_regularEventValue_Count_2,this._loc5_,true,"asset.core.regularEventItemCellBgAsset");
                        LayerManager.Instance.addToLayer(this._loc6_,LayerManager.GAME_DYNAMIC_LAYER);
                        this.createItemCellBG_2();
                        this._loc6_.x = this._regularEventItemCellBg_2.x + 29;
                        this._loc6_.y = this._regularEventItemCellBg_2.y + 6;
                        this._regularEventItemCellBg_2.visible = true;
                     }
                     if(_regularEventValue_4 != 0)
                     {
                        this._loc7_ = ItemManager.Instance.getTemplateById(_regularEventValue_4);
                        this._loc8_ = new RegularEventItemCell(_regularEventValue_Count_3,this._loc7_,true,"asset.core.regularEventItemCellBgAsset");
                        LayerManager.Instance.addToLayer(this._loc8_,LayerManager.GAME_DYNAMIC_LAYER);
                        this.createItemCellBG_3();
                        this._loc8_.x = this._regularEventItemCellBg_3.x + 29;
                        this._loc8_.y = this._regularEventItemCellBg_3.y + 6;
                        this._regularEventItemCellBg_3.visible = true;
                     }
                     this._regularEventTitleText.htmlText = String("<font SIZE=\'12\'>" + _regularEventValue_wander_deger_1 + "</font>");
                     this._regularEventContentText.htmlText = _regularEventValue_wander_deger_2 + "[<font COLOR=\'#fcec03\'><strong>" + _regularEventValue_stats_1 + "%</strong></font>] ";
                     break;
                  case 2:
                     this._regularEventTitleText.htmlText = String("Şu Anda Etkinlik Yok - 1");
                     this._regularEventContentText.htmlText = String("Şu anda yürürlükte etkinlik bulunmuyor, lütfen sonra tekrar kontrol et.");
               }
         }
      }
      
      public function __hideRegularEventInfo(param1:MouseEvent) : void
      {
         this._regularEventPic.setFrame(1);
         this._regularEventSmallPic.setFrame(1);
         this._regularEventExplainBg.visible = false;
         this._regularEventTitleText.visible = false;
         this._regularEventContentText.visible = false;
         if(Boolean(this._regularEventItemCellBg_1))
         {
            this._regularEventItemCellBg_1.visible = false;
         }
         if(Boolean(this._regularEventItemCellBg_2))
         {
            this._regularEventItemCellBg_2.visible = false;
         }
         if(Boolean(this._regularEventItemCellBg_3))
         {
            this._regularEventItemCellBg_3.visible = false;
         }
         if(Boolean(this._loc4_))
         {
            this._loc4_.visible = false;
         }
         if(Boolean(this._loc6_))
         {
            this._loc6_.visible = false;
         }
         if(Boolean(this._loc8_))
         {
            this._loc8_.visible = false;
         }
      }
   }
}

