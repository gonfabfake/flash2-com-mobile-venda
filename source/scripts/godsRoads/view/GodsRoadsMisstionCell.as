package godsRoads.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import godsRoads.data.GodsRoadsMissionVo;
   import godsRoads.manager.GodsRoadsManager;
   import godsRoads.model.GodsRoadsModel;
   
   public class GodsRoadsMisstionCell extends Sprite implements Disposeable, IListCell
   {
      
      private var _data:GodsRoadsMissionVo;
      
      private var _missionTxt:FilterFrameText;
      
      private var _model:GodsRoadsModel;
      
      private var lightIcon:Bitmap;
      
      private var grayIcon:Bitmap;
      
      public function GodsRoadsMisstionCell()
      {
         this._model = GodsRoadsManager.instance._model;
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.godsRoads.underLine");
         addChild(_loc2_);
         this._missionTxt = ComponentFactory.Instance.creat("godsRoads.missionTxt");
         this._missionTxt.mouseEnabled = true;
         addChild(this._missionTxt);
         this.lightIcon = ComponentFactory.Instance.creatBitmap("asset.godsRoads.lightFinishIcon");
         this.grayIcon = ComponentFactory.Instance.creatBitmap("asset.godsRoads.grayFinishIcon");
         addChild(this.lightIcon);
         addChild(this.grayIcon);
         _loc1_ = ComponentFactory.Instance.creat("godsRoads.ghostMask");
         _loc1_.buttonMode = true;
         addChild(_loc1_);
      }
      
      private function updateViewData() : void
      {
         if(this._data.isFinished)
         {
            if(this._data.isGetAwards)
            {
               this._missionTxt.textFormatStyle = "godsRoads.TextFormat3";
               this._missionTxt.filterString = "godsRoads.GF3";
               this.lightIcon.visible = false;
               this.grayIcon.visible = true;
            }
            else
            {
               this._missionTxt.textFormatStyle = "godsRoads.TextFormat2";
               this._missionTxt.filterString = "godsRoads.GF2";
               this.lightIcon.visible = true;
               this.grayIcon.visible = false;
            }
         }
         else
         {
            this._missionTxt.textFormatStyle = "godsRoads.TextFormat1";
            this._missionTxt.filterString = "godsRoads.GF1";
            this.lightIcon.visible = false;
            this.grayIcon.visible = false;
         }
      }
      
      public function dispose() : void
      {
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1 as GodsRoadsMissionVo;
         this._missionTxt.text = this._model.getMissionInfoById(this._data.ID).conditiontTitle;
         this.updateViewData();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

