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
   
   public class IndianaResoultSuccess extends Sprite implements Disposeable
   {
      
      private var _luckBg:Bitmap;
      
      private var _luckNum:GradientBitmapText;
      
      private var _nameitem:AttributeItem;
      
      private var _severitem:AttributeItem;
      
      private var _timesnumitem:AttributeItem;
      
      private var _timeitem:AttributeItem;
      
      private var _resoultitem:AttributeItem;
      
      private var _lookNum:FilterFrameText;
      
      private var _lookNumself:FilterFrameText;
      
      private var _lookNumselfII:FilterFrameText;
      
      private var _line:MutipleImage;
      
      private var _data:IndianaShowData;
      
      private var _info:IndianaShopItemInfo;
      
      public function IndianaResoultSuccess()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._luckBg = ComponentFactory.Instance.creatBitmap("asset.LuckNum.bg");
         this._luckNum = new GradientBitmapText();
         this._luckNum.FilterTxtStyle = "indiana.gradient.Txt";
         this._luckNum.BitMapStyle = "asset.gradient.bg";
         PositionUtils.setPos(this._luckNum,"indiana.resoultluckNum.pos");
         this._nameitem = new AttributeItem("indiana.itemDis.Txt");
         this._nameitem.setWidth(160);
         PositionUtils.setPos(this._nameitem,"indiana.resoultname.pos");
         this._severitem = new AttributeItem("indiana.itemDis.Txt");
         this._severitem.setWidth(160);
         PositionUtils.setPos(this._severitem,"indiana.resoultsever.pos");
         this._timesnumitem = new AttributeItem("indiana.itemDis.Txt");
         this._timesnumitem.setWidth(160);
         PositionUtils.setPos(this._timesnumitem,"indiana.resoultjoin.pos");
         this._timeitem = new AttributeItem("indiana.itemDis.Txt");
         this._timeitem.setWidth(200);
         PositionUtils.setPos(this._timeitem,"indiana.resoulttime.pos");
         this._resoultitem = new AttributeItem("indiana.itemDis.Txt");
         this._resoultitem.setWidth(200);
         PositionUtils.setPos(this._resoultitem,"indiana.resoultvalue.pos");
         this._lookNum = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._lookNum.mouseEnabled = true;
         PositionUtils.setPos(this._lookNum,"indiana.resoultlookplayer.pos");
         this._lookNumself = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._lookNumselfII = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._lookNumselfII.mouseEnabled = true;
         PositionUtils.setPos(this._lookNumselfII,"indiana.resoultsuccess.lookself.pos");
         PositionUtils.setPos(this._lookNumself,"indiana.resoultlookself.pos");
         this._line = ComponentFactory.Instance.creatComponentByStylename("indiana.line_2");
         addChild(this._luckBg);
         addChild(this._luckNum);
         addChild(this._nameitem);
         addChild(this._severitem);
         addChild(this._timeitem);
         addChild(this._timesnumitem);
         addChild(this._resoultitem);
         addChild(this._lookNum);
         addChild(this._lookNumself);
         addChild(this._lookNumselfII);
         addChild(this._line);
      }
      
      private function initEvent() : void
      {
         this._lookNumselfII.addEventListener("link",this.__linkHandler);
         this._lookNum.addEventListener("link",this.__linkHandler);
      }
      
      private function removeEvent() : void
      {
         this._lookNumselfII.removeEventListener("link",this.__linkHandler);
         this._lookNum.removeEventListener("link",this.__linkHandler);
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
      
      private function setShowData() : void
      {
         this._data = IndianaDataManager.instance.currentShowData;
         if(Boolean(this._data))
         {
            this._luckNum.setText(LanguageMgr.GetTranslation("Indiana.resoult.code",this._info.PeriodName,this._data.luckCode));
            this._nameitem.setDis(LanguageMgr.GetTranslation("Indiana.resoult.nickName",this._data.nickName));
            this._severitem.setDis(LanguageMgr.GetTranslation("Indiana.resoult.severName",this._data.areaName));
            this._timeitem.setDis(LanguageMgr.GetTranslation("Indiana.resoult.joinTime",DateUtils.dateFormat(this._data.joinTime)));
            this._resoultitem.setDis(LanguageMgr.GetTranslation("Indiana.resoult.annTime",DateUtils.dateFormat(this._data.annTime)));
            this._timesnumitem.setDis(LanguageMgr.GetTranslation("Indiana.resoult.hasJoinCount",this._data.buyTimes));
            if(this._data.joinCount > 0)
            {
               this._lookNumself.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCodeII",this._data.joinCount);
               this._lookNumselfII.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCode");
               this._lookNumselfII.x = this._lookNumself.textWidth + this._lookNumself.x + 3;
            }
            else
            {
               this._lookNumself.htmlText = LanguageMgr.GetTranslation("Indiana.infopanel.disIII");
               this._lookNumselfII.htmlText = "";
            }
            this._lookNum.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkOtherCode",this._data.useId);
         }
      }
      
      public function setInfo(param1:IndianaShopItemInfo) : void
      {
         this._info = param1;
         this.setShowData();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._luckBg = null;
         this._luckNum = null;
         this._nameitem = null;
         this._severitem = null;
         this._timesnumitem = null;
         this._resoultitem = null;
         this._lookNum = null;
         this._lookNumself = null;
         this._line = null;
      }
   }
}

