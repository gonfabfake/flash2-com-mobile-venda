package Indiana.item
{
   import Indiana.IndianaDataManager;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.model.IndianaShowData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import road7th.utils.DateUtils;
   
   public class IndianaResoultLose extends Sprite implements Disposeable
   {
      
      private var _prompte:Bitmap;
      
      private var _txt:GradientBitmapText;
      
      private var _dis:FilterFrameText;
      
      private var _disII:FilterFrameText;
      
      private var _lookNum:FilterFrameText;
      
      private var _line:MutipleImage;
      
      private var _info:IndianaShopItemInfo;
      
      private var _endDate:Date;
      
      private var _data:IndianaShowData;
      
      public function IndianaResoultLose()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function setInfo(param1:IndianaShopItemInfo) : void
      {
         this._info = param1;
         if(Boolean(this._info))
         {
            this._endDate = DateUtils.decodeDated(this._info.EndShowTime);
            this._data = IndianaDataManager.instance.currentShowData;
            if(this._data.joinCount > 0)
            {
               this._lookNum.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCode");
               this._disII.text = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCodeII",this._data.joinCount);
            }
            else
            {
               this._disII.text = LanguageMgr.GetTranslation("Indiana.infopanel.disIIII");
            }
         }
      }
      
      private function initView() : void
      {
         this._prompte = ComponentFactory.Instance.creatBitmap("asset.indiana.promp.lose");
         this._txt = new GradientBitmapText();
         this._txt.FilterTxtStyle = "indiana.gradient.Txt";
         this._txt.BitMapStyle = "asset.gradient.bg";
         this._txt.setText(LanguageMgr.GetTranslation("Indiana.resoultLost.dis"));
         PositionUtils.setPos(this._txt,"indiana.resoultloseNum.pos");
         this._dis = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._dis.text = LanguageMgr.GetTranslation("Indiana.resoultLost.disII");
         PositionUtils.setPos(this._dis,"indiana.resoultloseDis.pos");
         this._disII = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         PositionUtils.setPos(this._disII,"indiana.resoultlookself.pos");
         this._lookNum = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._lookNum.mouseEnabled = true;
         PositionUtils.setPos(this._lookNum,"indiana.resoultlose.lookself.pos");
         this._line = ComponentFactory.Instance.creatComponentByStylename("indiana.line_3");
         addChild(this._prompte);
         addChild(this._txt);
         addChild(this._dis);
         addChild(this._disII);
         addChild(this._line);
      }
      
      private function initEvent() : void
      {
         this._lookNum.addEventListener("link",this.__linkHandler);
      }
      
      private function __linkHandler(param1:TextEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.text.split("|");
         _loc4_ = _loc3_[0];
         if(_loc4_ == "clickother")
         {
            _loc2_ = int(_loc3_[1]);
         }
         if(_loc4_ == "clickself")
         {
            _loc2_ = PlayerManager.Instance.Self.ID;
         }
         SocketManager.Instance.out.sendIndianaCode(this._data.per_id,_loc2_);
      }
      
      public function dispose() : void
      {
         this._lookNum.removeEventListener("link",this.__linkHandler);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._txt = null;
         this._prompte = null;
         this._dis = null;
         this._disII = null;
         this._line = null;
         this._lookNum = null;
      }
   }
}

