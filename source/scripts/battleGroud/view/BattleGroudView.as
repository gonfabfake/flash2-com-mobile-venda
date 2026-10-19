package battleGroud.view
{
   import bagAndInfo.cell.BagCell;
   import battleGroud.BattleGroudControl;
   import battleGroud.data.BatlleData;
   import battleGroud.data.BattleUpdateData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BattleGroudManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BattleGroudView extends BaseAlerFrame
   {
      
      private var _back:Bitmap;
      
      private var _goodBack:Bitmap;
      
      private var _battleSkillBtn:BaseButton;
      
      private var _txt1:FilterFrameText;
      
      private var _txt2:FilterFrameText;
      
      private var _txt3:FilterFrameText;
      
      private var _txt4:FilterFrameText;
      
      private var _txt5:FilterFrameText;
      
      private var _txt7:FilterFrameText;
      
      private var _descripMc:MovieClip;
      
      private var _list:VBox;
      
      private var _miliContent:Component;
      
      private var _miliIcon:Bitmap;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _hBox1:HBox;
      
      private var _hBox2:HBox;
      
      private var _hBox3:HBox;
      
      private var _MiliIconList:Array = ["","battle.junxian.xinbingBig","battle.junxian.xiashiBig","battle.junxian.zhongshiBig","battle.junxian.shangshiBig","battle.junxian.shaoweiBig","battle.junxian.zhongweiBig","battle.junxian.shangweiBig","battle.junxian.shaoxiaoBig","battle.junxian.zhongxiaoBig","battle.junxian.shangxiaoBig","battle.junxian.shaojiangBig","battle.junxian.zhongjiangBig","battle.junxian.shangjiangBig","battle.junxian.cishuaiBig","battle.junxian.yuanshuaiBig","battle.junxian.dayuanshuaiBig"];
      
      private var _scrollPanel:ListPanel;
      
      private var content:Sprite;
      
      public function BattleGroudView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         info = new AlertInfo(LanguageMgr.GetTranslation("ddt.battleGroud"));
         _info.showSubmit = false;
         _info.showCancel = false;
         _info.moveEnable = false;
         this._back = ComponentFactory.Instance.creat("battle.ground");
         addToContent(this._back);
         this._goodBack = ComponentFactory.Instance.creat("battle.goodsContent");
         addToContent(this._goodBack);
         this._txt1 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt1");
         addToContent(this._txt1);
         this._txt7 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt5");
         this._txt7.text = LanguageMgr.GetTranslation("ddt.battleGroud.tips");
         addToContent(this._txt7);
         this._battleSkillBtn = ComponentFactory.Instance.creatComponentByStylename("battle.gotoSkill");
         addToContent(this._battleSkillBtn);
         this._miliContent = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.comp");
         this._miliContent.graphics.beginFill(0);
         this._miliContent.graphics.drawRect(0,0,100,20);
         this._miliContent.graphics.endFill();
         this._miliContent.alpha = 0;
         addToContent(this._miliContent);
         this._txt2 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt2");
         addToContent(this._txt2);
         this._txt3 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt3");
         addToContent(this._txt3);
         this._txt4 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt4");
         addToContent(this._txt4);
         this._txt5 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.txt3");
         PositionUtils.setPos(this._txt5,"battleGroud.txt5Pos");
         addToContent(this._txt5);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("battleGround.scrollPanel");
         this._scrollPanel.vectorListModel.clear();
         this._scrollPanel.vectorListModel.appendAll([{}]);
         this._scrollPanel.list.updateListView();
         this.content = new Sprite();
         this.content.addChild(this._scrollPanel);
         this._scrollPanel.x = 37;
         this._scrollPanel.y = 71;
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",null,LanguageMgr.GetTranslation("store.view.HelpButtonText"),this.content,404,484) as SimpleBitmapButton;
         PositionUtils.setPos(this._helpBtn,"battleGroud.helpBtnPos");
         this.initRewardList();
         this.setTxt(BattleGroudControl.Instance.orderdata);
      }
      
      public function setTxt(param1:BattleUpdateData) : void
      {
         this._txt2.text = String(param1.totalPrestige);
         this._txt3.text = param1.addDayPrestge.toString();
         this._txt1.text = String(param1.rankings);
         this._txt5.text = String(param1.weekPrestige);
         this.setMilitary(param1.totalPrestige);
      }
      
      private function setMilitary(param1:int) : void
      {
         var _loc2_:BatlleData = BattleGroudManager.Instance.getBattleDataByPrestige(param1);
         var _loc3_:BatlleData = BattleGroudManager.Instance.getBattleDataByLevel(_loc2_.Level + 1);
         this._txt4.text = _loc2_.Name;
         if(Boolean(_loc3_.Prestige))
         {
            this._miliContent.tipData = LanguageMgr.GetTranslation("ddt.battleGroud.updataLeavl",_loc3_.Prestige - param1);
         }
         else
         {
            this._miliContent.tipStyle = null;
            ShowTipManager.Instance.removeTip(this._miliContent);
         }
         this.creatIcon(this._MiliIconList[_loc2_.Level]);
      }
      
      private function creatIcon(param1:String) : void
      {
         if(Boolean(this._miliIcon))
         {
            ObjectUtils.disposeObject(this._miliIcon);
            this._miliIcon = null;
         }
         this._miliIcon = ComponentFactory.Instance.creat(param1);
         this._miliIcon.x = this._goodBack.x + (this._goodBack.width - this._miliIcon.width) / 2;
         this._miliIcon.y = this._goodBack.y + (this._goodBack.height - this._miliIcon.height) / 2;
         addToContent(this._miliIcon);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._battleSkillBtn.addEventListener("click",this.skillBtnClick_Handler);
      }
      
      private function skillBtnClick_Handler(param1:MouseEvent) : void
      {
         onResponse(4);
         SoundManager.instance.play("008");
      }
      
      private function initRewardList() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         this._hBox1 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.hBox");
         addToContent(this._hBox1);
         this._hBox2 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.hBox");
         PositionUtils.setPos(this._hBox2,"battleGroud.hBox2Pos");
         addToContent(this._hBox2);
         this._hBox3 = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView.hBox");
         PositionUtils.setPos(this._hBox3,"battleGroud.hBox3Pos");
         addToContent(this._hBox3);
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,53,53);
         _loc4_.graphics.endFill();
         var _loc5_:Array = BattleGroudControl.Instance.awardDataList;
         _loc3_ = 0;
         while(_loc3_ < 12)
         {
            _loc1_ = this["_hBox" + int(_loc3_ / 4 + 1)] as HBox;
            _loc2_ = new BagCell(_loc3_,BattleGroudControl.Instance.awardDataList[_loc3_],true,_loc4_);
            _loc2_.refreshTbxPos();
            _loc1_.addChild(_loc2_);
            _loc3_++;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
            case 4:
         }
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         removeEventListener("response",this.__responseHandler);
         _info = null;
         if(!_container)
         {
            return;
         }
         if(Boolean(this._battleSkillBtn))
         {
            this._battleSkillBtn.removeEventListener("click",this.skillBtnClick_Handler);
            ObjectUtils.disposeObject(this._battleSkillBtn);
         }
         this._battleSkillBtn = null;
         while(Boolean(_container.numChildren))
         {
            ObjectUtils.disposeObject(_container.getChildAt(0));
         }
         super.dispose();
      }
   }
}

