package halloween
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import halloween.info.HalloweenRankInfo;
   
   public class HalloweenRankView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _rank:FilterFrameText;
      
      private var _name:FilterFrameText;
      
      private var _number:FilterFrameText;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      public function HalloweenRankView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.halloween.rank.bg");
         this._rank = ComponentFactory.Instance.creat("asset.halloween.titleName");
         this._name = ComponentFactory.Instance.creat("asset.halloween.titleName");
         this._number = ComponentFactory.Instance.creat("asset.halloween.titleName");
         PositionUtils.setPos(this._rank,"asset.pos.title3");
         PositionUtils.setPos(this._name,"asset.pos.title4");
         PositionUtils.setPos(this._number,"asset.pos.title5");
         this._rank.text = LanguageMgr.GetTranslation("ddt.halloween.titleName1");
         this._name.text = LanguageMgr.GetTranslation("ddt.halloween.titleName3");
         this._number.text = LanguageMgr.GetTranslation("ddt.halloween.titleName4");
         addChild(this._bg);
         this._list = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.rank.vbox");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.scrollpanel");
         this._panel.setView(this._list);
         addChild(this._panel);
      }
      
      public function setData() : void
      {
         var _loc1_:HalloweenRankInfo = null;
         var _loc2_:HalloweenRankItem = null;
         this._list.disposeAllChildren();
         var _loc3_:int = 1;
         while(_loc3_ <= HalloweenManager.instance.rankArr.length)
         {
            _loc1_ = HalloweenManager.instance.rankArr[_loc3_ - 1] as HalloweenRankInfo;
            _loc2_ = new HalloweenRankItem(_loc3_,_loc1_);
            this._list.addChild(_loc2_);
            _loc3_++;
         }
         this._panel.invalidateViewport();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._rank);
         }
         this._rank = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._number);
         }
         this._number = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
      }
   }
}

