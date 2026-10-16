package magicHouse.magicCollection
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   
   public class MagicHouseCollectionItemTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _titleTxt:FilterFrameText;
      
      private var _typeNameTxt:FilterFrameText;
      
      private var _typeValueTxt:FilterFrameText;
      
      private var _activityStatusTxt:FilterFrameText;
      
      private var _detailTxt:FilterFrameText;
      
      private var _placeTxt:FilterFrameText;
      
      private var _activityTxt:FilterFrameText;
      
      private var _notActivityTxt:FilterFrameText;
      
      public function MagicHouseCollectionItemTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
         this._bg.width = 270;
         addChild(this._bg);
         this._line = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         this._line.width = 110;
         this._line.x = 42;
         this._line.y = 51;
         addChild(this._line);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.titleTxt");
         this._typeNameTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.typeNameTxt");
         this._typeValueTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.typeValueTxt");
         this._activityStatusTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.nameTxt");
         PositionUtils.setPos(this._activityStatusTxt,"magicHouse.collectionItemTip.activityStatusTxtPos");
         this._activityTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.nameTxt");
         PositionUtils.setPos(this._activityTxt,"magicHouse.collectionItemTip.activityTxtPos");
         addChild(this._activityTxt);
         this._detailTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.detailTxt");
         PositionUtils.setPos(this._detailTxt,"magicHouse.collectionItemTip.detailTxtPos");
         this._placeTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.nameTxt");
         PositionUtils.setPos(this._placeTxt,"magicHouse.collectionItemTip.placeTxtPos");
         this._notActivityTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.notActivityTxt");
         this._notActivityTxt.visible = false;
         addChild(this._titleTxt);
         addChild(this._typeNameTxt);
         addChild(this._typeValueTxt);
         addChild(this._activityStatusTxt);
         addChild(this._detailTxt);
         addChild(this._placeTxt);
         addChild(this._notActivityTxt);
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         this._titleTxt.text = param1.titleName;
         this._typeNameTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.typeNameTxt");
         this._typeValueTxt.text = param1.type;
         this._placeTxt.text = param1.placed;
         var _loc2_:Array = LanguageMgr.GetTranslation("avatarCollection.itemTip.activityTxt").split(",");
         if(Boolean(param1.activate))
         {
            this._activityTxt.text = _loc2_[0];
            this._notActivityTxt.visible = false;
            this._activityTxt.visible = true;
         }
         else
         {
            this._notActivityTxt.text = _loc2_[1];
            this._notActivityTxt.visible = true;
            this._activityTxt.visible = false;
         }
         this._activityStatusTxt.text = LanguageMgr.GetTranslation("avatarCollection.itemTip.activityStatusTxt");
         this._detailTxt.text = param1.datail;
         this._bg.height = this._placeTxt.y + 32;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._line = null;
         this._titleTxt = null;
         this._typeNameTxt = null;
         this._typeValueTxt = null;
         this._activityStatusTxt = null;
         this._detailTxt = null;
         this._placeTxt = null;
         this._activityTxt = null;
         this._notActivityTxt = null;
         super.dispose();
      }
   }
}

