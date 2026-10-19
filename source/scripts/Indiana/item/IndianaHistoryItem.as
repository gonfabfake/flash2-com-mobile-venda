package Indiana.item
{
   import Indiana.model.HistoryIndianaData;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.utils.DateUtils;
   
   public class IndianaHistoryItem extends Sprite implements Disposeable
   {
      
      private var _num_txt:GradientBitmapText;
      
      private var _goodName:FilterFrameText;
      
      private var _playName:FilterFrameText;
      
      private var _luckNumTitle:GradientBitmapText;
      
      private var _luckNum:FilterFrameText;
      
      private var _hasTimesTitle:FilterFrameText;
      
      private var _hasTimes:FilterFrameText;
      
      private var _getTime:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _info:HistoryIndianaData;
      
      public function IndianaHistoryItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.scrolltxt.bg");
         this._num_txt = ComponentFactory.Instance.creatComponentByStylename("indiana.historyitem.noNum");
         this._num_txt.FontSize = 12;
         this._goodName = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         PositionUtils.setPos(this._goodName,"indiana.historyitem.goodName.pos");
         this._playName = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         PositionUtils.setPos(this._playName,"indiana.historyitem.playerName.pos");
         this._luckNumTitle = ComponentFactory.Instance.creatComponentByStylename("indiana.historyitem.luckNumTitle");
         this._num_txt.FontSize = 12;
         this._luckNumTitle.setText(LanguageMgr.GetTranslation("Indiana.history.luckCode"));
         this._luckNum = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisII.Txt");
         PositionUtils.setPos(this._luckNum,"indiana.historyitem.luckNum.pos");
         this._hasTimesTitle = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         this._hasTimesTitle.text = LanguageMgr.GetTranslation("Indiana.history.hasTimes");
         PositionUtils.setPos(this._hasTimesTitle,"indiana.historyitem.hasTimes.pos");
         this._hasTimes = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisII.Txt");
         PositionUtils.setPos(this._hasTimes,"indiana.historyitem.Times.pos");
         this._getTime = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.Txt");
         PositionUtils.setPos(this._getTime,"indiana.historyitem.getGoodTime.pos");
         addChild(this._bg);
         addChild(this._num_txt);
         addChild(this._goodName);
         addChild(this._playName);
         addChild(this._hasTimes);
         addChild(this._luckNumTitle);
         addChild(this._luckNum);
         addChild(this._hasTimesTitle);
         addChild(this._getTime);
      }
      
      public function setInfo(param1:HistoryIndianaData) : void
      {
         var _loc2_:Number = NaN;
         this._info = param1;
         if(Boolean(this._info))
         {
            this._num_txt.setText(LanguageMgr.GetTranslation("Indiana.history.perNum",this._info.per_name));
            this._goodName.text = LanguageMgr.GetTranslation("Indiana.resoult.goods",this._info.goodsName);
            this._playName.text = LanguageMgr.GetTranslation("Indiana.resoult.nickName",this._info.nickName + "(" + this._info.areaName + ")");
            this._luckNum.text = this._info.winningCode.toString();
            this._hasTimes.text = LanguageMgr.GetTranslation("Indiana.history.times",this._info.joinCount);
            this._getTime.text = LanguageMgr.GetTranslation("Indiana.resoult.joinTime",DateUtils.dateFormat5(this._info.AnnTime));
            _loc2_ = this._num_txt.x + this._num_txt.textWidth + 10;
            this._goodName.x = this._playName.x = _loc2_;
         }
      }
      
      override public function get width() : Number
      {
         return 42;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._num_txt = null;
         this._goodName = null;
         this._playName = null;
         this._luckNumTitle = null;
         this._luckNum = null;
         this._hasTimesTitle = null;
         this._getTime = null;
         this._hasTimes = null;
      }
   }
}

