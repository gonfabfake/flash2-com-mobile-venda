package pvePowerBuff
{
   import baglocked.BaglockedManager;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PvePowerBuffMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _otherForeAtk:FilterFrameText;
      
      private var _otherForeDef:FilterFrameText;
      
      private var _otherForeAgl:FilterFrameText;
      
      private var _otherForeLuck:FilterFrameText;
      
      private var _otherForeHp:FilterFrameText;
      
      private var _otherForeMAtk:FilterFrameText;
      
      private var _otherForeMDef:FilterFrameText;
      
      private var _otherForeDmg:FilterFrameText;
      
      private var _otherForeAr:FilterFrameText;
      
      private var _otherRearAtk:FilterFrameText;
      
      private var _otherRearDef:FilterFrameText;
      
      private var _otherRearAgl:FilterFrameText;
      
      private var _otherRearLuck:FilterFrameText;
      
      private var _otherRearHp:FilterFrameText;
      
      private var _otherRearMAtk:FilterFrameText;
      
      private var _otherRearMDef:FilterFrameText;
      
      private var _otherRearDmg:FilterFrameText;
      
      private var _otherRearAr:FilterFrameText;
      
      private var _atkIconBm:Bitmap;
      
      private var _defIconBm:Bitmap;
      
      private var _aglIconBm:Bitmap;
      
      private var _luckIconBm:Bitmap;
      
      private var _hpIconBm:Bitmap;
      
      private var _matkIconBm:Bitmap;
      
      private var _mdefIconBm:Bitmap;
      
      private var _dmgIconBm:Bitmap;
      
      private var _arIconBm:Bitmap;
      
      private var _selfForeAtk:FilterFrameText;
      
      private var _selfForeDef:FilterFrameText;
      
      private var _selfForeAgl:FilterFrameText;
      
      private var _selfForeLuck:FilterFrameText;
      
      private var _selfForeHp:FilterFrameText;
      
      private var _selfForeMAtk:FilterFrameText;
      
      private var _selfForeMDef:FilterFrameText;
      
      private var _selfForeDmg:FilterFrameText;
      
      private var _selfForeAr:FilterFrameText;
      
      private var _selfRearAtk:FilterFrameText;
      
      private var _selfRearDef:FilterFrameText;
      
      private var _selfRearAgl:FilterFrameText;
      
      private var _selfRearLuck:FilterFrameText;
      
      private var _selfRearHp:FilterFrameText;
      
      private var _selfRearMAtk:FilterFrameText;
      
      private var _selfRearMDef:FilterFrameText;
      
      private var _selfRearDmg:FilterFrameText;
      
      private var _selfRearAr:FilterFrameText;
      
      private var _refreshBtn:SimpleBitmapButton;
      
      private var _getBuffBtn:SimpleBitmapButton;
      
      private var _getAgainBtn:SimpleBitmapButton;
      
      private var _btnHelp:BaseButton;
      
      private var _lefttime:FilterFrameText;
      
      private var _huafeiMc:MovieClip;
      
      private var _shuziMc:MovieClip;
      
      private var _others:Vector.<PvePowerBuffPerson>;
      
      private var _selectedPlayer:PvePowerBuffPerson;
      
      private var _arBmArr:Array;
      
      public function PvePowerBuffMainView()
      {
         super();
         this._initView();
         this._initEvent();
      }
      
      private function _initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this._bg = ComponentFactory.Instance.creat("asset.pvepowerbuff.frame.bg");
         this._bg.width = 828;
         this._bg.height = 442;
         addChild(this._bg);
         this._others = new Vector.<PvePowerBuffPerson>();
         this._refreshOthers();
         this._otherForeAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeAtk);
         PositionUtils.setPos(this._otherForeAtk,"pvePowerBuff.mainView.otherForeAtk.pos");
         this._otherForeAtk.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact") + ":";
         this._otherForeDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeDef);
         PositionUtils.setPos(this._otherForeDef,"pvePowerBuff.mainView.otherForeDef.pos");
         this._otherForeDef.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense") + ":";
         this._otherForeAgl = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeAgl);
         PositionUtils.setPos(this._otherForeAgl,"pvePowerBuff.mainView.otherForeAgl.pos");
         this._otherForeAgl.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility") + ":";
         this._otherForeLuck = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeLuck);
         PositionUtils.setPos(this._otherForeLuck,"pvePowerBuff.mainView.otherForeLuck.pos");
         this._otherForeLuck.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck") + ":";
         this._otherForeHp = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeHp);
         PositionUtils.setPos(this._otherForeHp,"pvePowerBuff.mainView.otherForeHp.pos");
         this._otherForeHp.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp") + ":";
         this._otherForeMAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeMAtk);
         PositionUtils.setPos(this._otherForeMAtk,"pvePowerBuff.mainView.otherForeMAtk.pos");
         this._otherForeMAtk.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicAttack") + ":";
         this._otherForeMDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeMDef);
         PositionUtils.setPos(this._otherForeMDef,"pvePowerBuff.mainView.otherForeMDef.pos");
         this._otherForeMDef.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicDefence") + ":";
         this._otherForeDmg = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeDmg);
         PositionUtils.setPos(this._otherForeDmg,"pvePowerBuff.mainView.otherForeDmg.pos");
         this._otherForeDmg.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage") + ":";
         this._otherForeAr = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherForeTxt");
         addChild(this._otherForeAr);
         PositionUtils.setPos(this._otherForeAr,"pvePowerBuff.mainView.otherForeAr.pos");
         this._otherForeAr.text = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery") + ":";
         this._otherRearAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearAtk);
         PositionUtils.setPos(this._otherRearAtk,"pvePowerBuff.mainView.otherRearAtk.pos");
         this._otherRearDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearDef);
         PositionUtils.setPos(this._otherRearDef,"pvePowerBuff.mainView.otherRearDef.pos");
         this._otherRearAgl = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearAgl);
         PositionUtils.setPos(this._otherRearAgl,"pvePowerBuff.mainView.otherRearAgl.pos");
         this._otherRearLuck = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearLuck);
         PositionUtils.setPos(this._otherRearLuck,"pvePowerBuff.mainView.otherRearLuck.pos");
         this._otherRearHp = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearHp);
         PositionUtils.setPos(this._otherRearHp,"pvePowerBuff.mainView.otherRearHp.pos");
         this._otherRearMAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearMAtk);
         PositionUtils.setPos(this._otherRearMAtk,"pvePowerBuff.mainView.otherRearMAtk.pos");
         this._otherRearMDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearMDef);
         PositionUtils.setPos(this._otherRearMDef,"pvePowerBuff.mainView.otherRearMDef.pos");
         this._otherRearDmg = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearDmg);
         PositionUtils.setPos(this._otherRearDmg,"pvePowerBuff.mainView.otherRearDmg.pos");
         this._otherRearAr = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.otherRearTxt");
         addChild(this._otherRearAr);
         PositionUtils.setPos(this._otherRearAr,"pvePowerBuff.mainView.otherRearAr.pos");
         this._arBmArr = [];
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            _loc2_ = ComponentFactory.Instance.creat("asset.pvepowerbuff.attribute.item.bg");
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainview.item.TipContent");
            switch(int(_loc1_))
            {
               case 0:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.attact");
                  break;
               case 1:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.defense");
                  break;
               case 2:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.agility");
                  break;
               case 3:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.luck");
                  break;
               case 4:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.hp");
                  break;
               case 5:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicAttack");
                  break;
               case 6:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.magicDefence");
                  break;
               case 7:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.damage");
                  break;
               case 8:
                  _loc3_.tipData = LanguageMgr.GetTranslation("tank.view.personalinfoII.recovery");
            }
            _loc3_.addChild(_loc2_);
            addChild(_loc3_);
            _loc3_.x = 646;
            _loc3_.y = 34 + 28 * _loc1_;
            _loc4_ = ComponentFactory.Instance.creat("asset.pvepowerbuff.uparrow");
            _loc4_.visible = false;
            addChild(_loc4_);
            _loc4_.x = 750;
            _loc4_.y = 37 + 28 * _loc1_;
            this._arBmArr[_loc1_] = _loc4_;
            _loc1_++;
         }
         this._atkIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.atk");
         addChild(this._atkIconBm);
         this._defIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.def");
         addChild(this._defIconBm);
         this._aglIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.agile");
         addChild(this._aglIconBm);
         this._luckIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.luck");
         addChild(this._luckIconBm);
         this._hpIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.hp");
         addChild(this._hpIconBm);
         this._matkIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.matk");
         addChild(this._matkIconBm);
         this._mdefIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.mdef");
         addChild(this._mdefIconBm);
         this._dmgIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.damage");
         addChild(this._dmgIconBm);
         this._arIconBm = ComponentFactory.Instance.creat("asset.pvepowerbuff.icon.armor");
         addChild(this._arIconBm);
         this._selfForeAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeAtk);
         PositionUtils.setPos(this._selfForeAtk,"pvePowerBuff.mainView.selfForeAtk.pos");
         this._selfForeAtk.text = PlayerManager.Instance.Self.Attack.toString();
         this._selfForeDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeDef);
         PositionUtils.setPos(this._selfForeDef,"pvePowerBuff.mainView.selfForeDef.pos");
         this._selfForeDef.text = PlayerManager.Instance.Self.Defence.toString();
         this._selfForeAgl = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeAgl);
         PositionUtils.setPos(this._selfForeAgl,"pvePowerBuff.mainView.selfForeAgl.pos");
         this._selfForeAgl.text = PlayerManager.Instance.Self.Agility.toString();
         this._selfForeLuck = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeLuck);
         PositionUtils.setPos(this._selfForeLuck,"pvePowerBuff.mainView.selfForeLuck.pos");
         this._selfForeLuck.text = PlayerManager.Instance.Self.Luck.toString();
         this._selfForeHp = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeHp);
         PositionUtils.setPos(this._selfForeHp,"pvePowerBuff.mainView.selfForeHp.pos");
         this._selfForeHp.text = PlayerManager.Instance.Self.hp.toString();
         this._selfForeMAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeMAtk);
         PositionUtils.setPos(this._selfForeMAtk,"pvePowerBuff.mainView.selfForeMAtk.pos");
         this._selfForeMAtk.text = "???";
         this._selfForeMDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeMDef);
         PositionUtils.setPos(this._selfForeMDef,"pvePowerBuff.mainView.selfForeMDef.pos");
         this._selfForeMDef.text = "???";
         this._selfForeDmg = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeDmg);
         PositionUtils.setPos(this._selfForeDmg,"pvePowerBuff.mainView.selfForeDmg.pos");
         this._selfForeDmg.text = Math.round(StaticFormula.getDamage(PlayerManager.Instance.Self)).toString();
         this._selfForeAr = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfForeTxt");
         addChild(this._selfForeAr);
         PositionUtils.setPos(this._selfForeAr,"pvePowerBuff.mainView.selfForeAr.pos");
         this._selfForeAr.text = StaticFormula.getRecovery(PlayerManager.Instance.Self).toString();
         this._selfRearAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearAtk);
         PositionUtils.setPos(this._selfRearAtk,"pvePowerBuff.mainView.selfRearAtk.pos");
         this._selfRearAtk.text = "88888888";
         this._selfRearDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearDef);
         PositionUtils.setPos(this._selfRearDef,"pvePowerBuff.mainView.selfRearDef.pos");
         this._selfRearDef.text = "88888888";
         this._selfRearAgl = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearAgl);
         PositionUtils.setPos(this._selfRearAgl,"pvePowerBuff.mainView.selfRearAgl.pos");
         this._selfRearAgl.text = "88888888";
         this._selfRearLuck = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearLuck);
         PositionUtils.setPos(this._selfRearLuck,"pvePowerBuff.mainView.selfRearLuck.pos");
         this._selfRearLuck.text = "88888888";
         this._selfRearHp = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearHp);
         PositionUtils.setPos(this._selfRearHp,"pvePowerBuff.mainView.selfRearHp.pos");
         this._selfRearHp.text = "88888888";
         this._selfRearMAtk = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearMAtk);
         PositionUtils.setPos(this._selfRearMAtk,"pvePowerBuff.mainView.selfRearMAtk.pos");
         this._selfRearMAtk.text = "88888888";
         this._selfRearMDef = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearMDef);
         PositionUtils.setPos(this._selfRearMDef,"pvePowerBuff.mainView.selfRearMDef.pos");
         this._selfRearMDef.text = "88888888";
         this._selfRearDmg = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearDmg);
         PositionUtils.setPos(this._selfRearDmg,"pvePowerBuff.mainView.selfRearDmg.pos");
         this._selfRearDmg.text = "88888888";
         this._selfRearAr = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.selfRearTxt");
         addChild(this._selfRearAr);
         PositionUtils.setPos(this._selfRearAr,"pvePowerBuff.mainView.selfRearAr.pos");
         this._selfRearAr.text = "88888888";
         if(PvePowerBuffManager.instance.getBuffIndex < 0)
         {
            this._setSelfRearTxt();
            this._setSelfRearTextVisible(false);
            this._setOtherPower();
         }
         else
         {
            this._setSelfRearTxt(true);
            this._setSelfRearTextVisible(true);
            this._selectedPlayer = this._others[PvePowerBuffManager.instance.getBuffIndex];
            this._selectedPlayer.setLightMcVisible(true);
            this._setOtherPower(this._selectedPlayer.playerInfo);
            this._showArrows(true);
         }
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.refreshBtn");
         addChild(this._refreshBtn);
         this._getBuffBtn = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.getBuffBtn");
         this._getBuffBtn.tipData = LanguageMgr.GetTranslation("ddt.pvePowerBuff.getBuffBtn.free");
         addChild(this._getBuffBtn);
         this._getAgainBtn = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.getAgainBtn");
         this._getAgainBtn.tipData = LanguageMgr.GetTranslation("ddt.pvePowerBuff.getBuffBtn.pay",ServerConfigManager.instance.pvePowerBuffGetBuffPrice);
         addChild(this._getAgainBtn);
         this._refreshButtonTipsData();
         if(PvePowerBuffManager.instance.getBuffCount < 1)
         {
            this._getBuffBtn.visible = true;
            this._getAgainBtn.visible = false;
         }
         else
         {
            this._getBuffBtn.visible = false;
            this._getAgainBtn.visible = true;
         }
         this._lefttime = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.mainView.leftTimeTxt");
         addChild(this._lefttime);
         this._lefttime.visible = false;
         this._setTimeText();
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"coreii.helpBtn",{
            "x":762,
            "y":-80
         },LanguageMgr.GetTranslation("ddt.pvePowerBuff.helpFrame.title"),"pvePowerBuff.help.content",408,488);
      }
      
      private function _refreshButtonTipsData() : void
      {
         if(PvePowerBuffManager.instance.refreshCount < 2)
         {
            this._refreshBtn.tipData = LanguageMgr.GetTranslation("ddt.pvePowerBuff.refreshBtn.free");
         }
         else
         {
            this._refreshBtn.tipData = LanguageMgr.GetTranslation("ddt.pvePowerBuff.refreshBtn.pay",ServerConfigManager.instance.pvePowerBuffRefreshPrice);
         }
      }
      
      private function _setOtherPower(param1:PlayerInfo = null) : void
      {
         if(Boolean(param1))
         {
            this._otherRearAtk.text = param1.Attack.toString();
            this._otherRearDef.text = param1.Defence.toString();
            this._otherRearAgl.text = param1.Agility.toString();
            this._otherRearLuck.text = param1.Luck.toString();
            this._otherRearHp.text = param1.hp.toString();
            this._otherRearMAtk.text = "???";
            this._otherRearMDef.text = "???";
            this._otherRearDmg.text = param1.Damage.toString();
            this._otherRearAr.text = param1.Guard.toString();
         }
         else
         {
            this._otherRearAtk.text = "????";
            this._otherRearDef.text = "????";
            this._otherRearAgl.text = "????";
            this._otherRearLuck.text = "????";
            this._otherRearHp.text = "????";
            this._otherRearMAtk.text = "????";
            this._otherRearMDef.text = "????";
            this._otherRearDmg.text = "????";
            this._otherRearAr.text = "????";
         }
      }
      
      private function _setSelfRearTxt(param1:Boolean = false) : void
      {
         if(param1 == true)
         {
            this._selfRearAtk.text = Math.floor(PvePowerBuffManager.instance.getBuffAtk * 0.2).toString();
            this._selfRearDef.text = Math.floor(PvePowerBuffManager.instance.getBuffDef * 0.2).toString();
            this._selfRearAgl.text = Math.floor(PvePowerBuffManager.instance.getBuffAgl * 0.2).toString();
            this._selfRearLuck.text = Math.floor(PvePowerBuffManager.instance.getBuffLuck * 0.2).toString();
            this._selfRearHp.text = Math.floor(PvePowerBuffManager.instance.getBuffHp * 0.2).toString();
            this._selfRearMAtk.text = Math.floor(PvePowerBuffManager.instance.getBuffMAtk * 0.2).toString();
            this._selfRearMDef.text = Math.floor(PvePowerBuffManager.instance.getBuffMDef * 0.2).toString();
            this._selfRearDmg.text = Math.floor(PvePowerBuffManager.instance.getBuffDmg * 0.2).toString();
            this._selfRearAr.text = Math.floor(PvePowerBuffManager.instance.getBuffAr * 0.2).toString();
         }
      }
      
      private function _setSelfRearTextVisible(param1:Boolean) : void
      {
         this._selfRearAtk.visible = this._selfRearDef.visible = this._selfRearAgl.visible = this._selfRearLuck.visible = this._selfRearHp.visible = this._selfRearMAtk.visible = this._selfRearMDef.visible = this._selfRearDmg.visible = this._selfRearAr.visible = param1;
      }
      
      private function _setTimeText() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(PvePowerBuffManager.instance.getBuffCount > 0 && PvePowerBuffManager.instance.getBuffDate != null)
         {
            _loc1_ = PvePowerBuffManager.instance.getBuffDate;
            _loc2_ = TimeManager.Instance.Now();
            _loc3_ = _loc2_.getTime() - _loc1_.getTime();
            _loc4_ = 30 - Math.floor(_loc3_ / 60000);
            this._lefttime.text = LanguageMgr.GetTranslation("ddt.pvePowerBuff.buff.left.time.text",_loc4_ < 0 ? 0 : Number(_loc4_));
            this._lefttime.visible = true;
         }
      }
      
      private function _refreshOthers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         while(Boolean(this._others.length))
         {
            removeChild(this._others[0]);
            this._others[0] = null;
            this._others.shift();
         }
         var _loc3_:Vector.<PlayerInfo> = PvePowerBuffManager.instance.playerInfoVc;
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc2_ = new PvePowerBuffPerson(_loc1_);
            _loc2_.updatePlayer(_loc3_[_loc1_]);
            addChild(_loc2_);
            PositionUtils.setPos(_loc2_,"pvePowerBuff.mainView.character." + _loc1_ + ".pos");
            this._others.push(_loc2_);
            _loc1_++;
         }
         PvePowerBuffManager.instance.isInRefresh = false;
      }
      
      private function _removeOthers() : void
      {
      }
      
      private function _initEvent() : void
      {
         PvePowerBuffControl.instance.addEventListener("select_player",this.__selectPlayerHandler);
         PvePowerBuffManager.instance.addEventListener("pvepowerbuff_refresh",this.__refreshBuffHandler);
         PvePowerBuffManager.instance.addEventListener("pvepowerbuff_getbuff",this.__getBuffHandler);
         this._refreshBtn.addEventListener("click",this.__refreshBtnClickHandler);
         this._getBuffBtn.addEventListener("click",this.__getBuffBtnClickHandler);
         this._getAgainBtn.addEventListener("click",this.__getAgainBtnClickHandler);
      }
      
      private function __selectPlayerHandler(param1:PvePowerBuffEvent) : void
      {
         if(Boolean(this._selectedPlayer))
         {
            this._selectedPlayer.setLightMcVisible(false);
         }
         this._selectedPlayer = param1.info;
         this._selectedPlayer.setLightMcVisible(true);
         this._setOtherPower(this._selectedPlayer.playerInfo);
      }
      
      private function __refreshBuffHandler(param1:PvePowerBuffEvent) : void
      {
         this._selectedPlayer = null;
         this._refreshButtonTipsData();
         this._refreshOthers();
      }
      
      private function __getBuffHandler(param1:PvePowerBuffEvent) : void
      {
         PvePowerBuffManager.instance.isInGetBuff = true;
         if(Boolean(this._huafeiMc))
         {
            this._huafeiMc = null;
         }
         this._huafeiMc = ClassUtils.CreatInstance("asset.pvepowerbuff.hua.fei.mc");
         PositionUtils.setPos(this._huafeiMc,"pvePowerBuff.mainView.huafei." + PvePowerBuffManager.instance.getBuffIndex + ".pos");
         addChild(this._huafeiMc);
         var _loc2_:TimelineLite = new TimelineLite({"onComplete":this._tweenCompleteHua});
         _loc2_.append(TweenLite.to(this._huafeiMc,1,{
            "scaleX":1,
            "scaleY":1,
            "x":this._huafeiMc.x,
            "y":this._huafeiMc.y
         }));
         _loc2_.append(TweenLite.to(this._huafeiMc,2,{
            "scaleX":1,
            "scaleY":1,
            "x":670,
            "y":255
         }));
      }
      
      private function _tweenCompleteHua() : void
      {
         removeChild(this._huafeiMc);
         this._huafeiMc = null;
         this._shuziMc = ClassUtils.CreatInstance("asset.pvepowerbuff.quare.light.mc");
         PositionUtils.setPos(this._shuziMc,"pvePowerBuff.character.shuzi.mc.pos");
         addChild(this._shuziMc);
         var _loc1_:TimelineLite = new TimelineLite({"onComplete":this._shuziKuang});
         _loc1_.append(TweenLite.to(this._shuziMc,1,{
            "scaleX":1,
            "scaleY":1,
            "x":this._shuziMc.x,
            "y":this._shuziMc.y
         }));
      }
      
      private function _shuziKuang() : void
      {
         removeChild(this._shuziMc);
         this._shuziMc = null;
         this._setSelfRearTextVisible(true);
         this._showArrows(true);
         this._setSelfRearTxt(true);
         this._setTimeText();
         if(this._getBuffBtn.visible == true)
         {
            this._getBuffBtn.visible = false;
            this._getAgainBtn.visible = true;
         }
         else
         {
            this._getAgainBtn.enable = true;
         }
         PvePowerBuffManager.instance.isInGetBuff = false;
      }
      
      private function _showArrows(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._arBmArr.length)
         {
            this._arBmArr[_loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      private function __onRefreshResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__onRefreshResponse);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            SocketManager.Instance.out.pvePowerBuffRefresh();
         }
         _loc2_.dispose();
      }
      
      private function __refreshBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PvePowerBuffManager.instance.refreshCount < 2)
         {
            SocketManager.Instance.out.pvePowerBuffRefresh();
         }
         else
         {
            if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.pvePowerBuffRefreshPrice)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pvePowerBuff.refreshBtn.pay",ServerConfigManager.instance.pvePowerBuffRefreshPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
            _loc2_.addEventListener("response",this.__onRefreshResponse);
         }
      }
      
      private function __getBuffBtnClickHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._selectedPlayer == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pvePowerBuff.getBuff.noIndex"));
            return;
         }
         this._getBuffBtn.enable = false;
         SocketManager.Instance.out.pvePowerBuffGetBuff(this._selectedPlayer.index);
      }
      
      private function __getAgainBtnClickHandler(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._selectedPlayer == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.pvePowerBuff.getBuff.noIndex"));
            return;
         }
         if(PlayerManager.Instance.Self.Money < ServerConfigManager.instance.pvePowerBuffGetBuffPrice)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._getAgainBtn.enable = false;
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.pvePowerBuff.getBuffBtn.pay",ServerConfigManager.instance.pvePowerBuffGetBuffPrice),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _loc2_.addEventListener("response",this.__onGetAgainResponse);
      }
      
      private function __onGetAgainResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__onGetAgainResponse);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            SocketManager.Instance.out.pvePowerBuffGetBuff(this._selectedPlayer.index);
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            this._getAgainBtn.enable = true;
         }
         _loc2_.dispose();
      }
      
      private function _removeEvent() : void
      {
         PvePowerBuffControl.instance.removeEventListener("select_player",this.__selectPlayerHandler);
         PvePowerBuffManager.instance.removeEventListener("pvepowerbuff_refresh",this.__refreshBuffHandler);
         PvePowerBuffManager.instance.removeEventListener("pvepowerbuff_getbuff",this.__getBuffHandler);
         this._refreshBtn.removeEventListener("click",this.__refreshBtnClickHandler);
         this._getBuffBtn.removeEventListener("click",this.__getBuffBtnClickHandler);
         this._getAgainBtn.removeEventListener("click",this.__getAgainBtnClickHandler);
      }
      
      public function dispose() : void
      {
         this._removeEvent();
         this._removeOthers();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._otherForeAtk);
         this._otherForeAtk = null;
         ObjectUtils.disposeObject(this._otherForeDef);
         this._otherForeDef = null;
         ObjectUtils.disposeObject(this._otherForeAgl);
         this._otherForeAgl = null;
         ObjectUtils.disposeObject(this._otherForeLuck);
         this._otherForeLuck = null;
         ObjectUtils.disposeObject(this._otherForeHp);
         this._otherForeHp = null;
         ObjectUtils.disposeObject(this._otherForeMAtk);
         this._otherForeMAtk = null;
         ObjectUtils.disposeObject(this._otherForeMDef);
         this._otherForeMDef = null;
         ObjectUtils.disposeObject(this._otherForeDmg);
         this._otherForeDmg = null;
         ObjectUtils.disposeObject(this._otherForeAr);
         this._otherForeAr = null;
         ObjectUtils.disposeObject(this._otherRearAtk);
         this._otherRearAtk = null;
         ObjectUtils.disposeObject(this._otherRearDef);
         this._otherRearDef = null;
         ObjectUtils.disposeObject(this._otherRearAgl);
         this._otherRearAgl = null;
         ObjectUtils.disposeObject(this._otherRearLuck);
         this._otherRearLuck = null;
         ObjectUtils.disposeObject(this._otherRearHp);
         this._otherRearHp = null;
         ObjectUtils.disposeObject(this._otherRearMAtk);
         this._otherRearMAtk = null;
         ObjectUtils.disposeObject(this._otherRearMDef);
         this._otherRearMDef = null;
         ObjectUtils.disposeObject(this._otherRearDmg);
         this._otherRearDmg = null;
         ObjectUtils.disposeObject(this._otherRearAr);
         this._otherRearAr = null;
         ObjectUtils.disposeObject(this._atkIconBm);
         this._atkIconBm = null;
         ObjectUtils.disposeObject(this._defIconBm);
         this._defIconBm = null;
         ObjectUtils.disposeObject(this._aglIconBm);
         this._aglIconBm = null;
         ObjectUtils.disposeObject(this._luckIconBm);
         this._luckIconBm = null;
         ObjectUtils.disposeObject(this._hpIconBm);
         this._hpIconBm = null;
         ObjectUtils.disposeObject(this._matkIconBm);
         this._matkIconBm = null;
         ObjectUtils.disposeObject(this._mdefIconBm);
         this._mdefIconBm = null;
         ObjectUtils.disposeObject(this._dmgIconBm);
         this._dmgIconBm = null;
         ObjectUtils.disposeObject(this._arIconBm);
         this._arIconBm = null;
         ObjectUtils.disposeObject(this._selfForeAtk);
         this._selfForeAtk = null;
         ObjectUtils.disposeObject(this._selfForeDef);
         this._selfForeDef = null;
         ObjectUtils.disposeObject(this._selfForeAgl);
         this._selfForeAgl = null;
         ObjectUtils.disposeObject(this._selfForeLuck);
         this._selfForeLuck = null;
         ObjectUtils.disposeObject(this._selfForeHp);
         this._selfForeHp = null;
         ObjectUtils.disposeObject(this._selfForeMAtk);
         this._selfForeMAtk = null;
         ObjectUtils.disposeObject(this._selfForeMDef);
         this._selfForeMDef = null;
         ObjectUtils.disposeObject(this._selfForeDmg);
         this._selfForeDmg = null;
         ObjectUtils.disposeObject(this._selfForeAr);
         this._selfForeAr = null;
         ObjectUtils.disposeObject(this._selfRearAtk);
         this._selfRearAtk = null;
         ObjectUtils.disposeObject(this._selfRearDef);
         this._selfRearDef = null;
         ObjectUtils.disposeObject(this._selfRearAgl);
         this._selfRearAgl = null;
         ObjectUtils.disposeObject(this._selfRearLuck);
         this._selfRearLuck = null;
         ObjectUtils.disposeObject(this._selfRearHp);
         this._selfRearHp = null;
         ObjectUtils.disposeObject(this._selfRearMAtk);
         this._selfRearMAtk = null;
         ObjectUtils.disposeObject(this._selfRearMDef);
         this._selfRearMDef = null;
         ObjectUtils.disposeObject(this._selfRearDmg);
         this._selfRearDmg = null;
         ObjectUtils.disposeObject(this._selfRearAr);
         this._selfRearAr = null;
         ObjectUtils.disposeObject(this._refreshBtn);
         this._refreshBtn = null;
         ObjectUtils.disposeObject(this._getBuffBtn);
         this._getBuffBtn = null;
         ObjectUtils.disposeObject(this._getAgainBtn);
         this._getAgainBtn = null;
         ObjectUtils.disposeObject(this._lefttime);
         this._lefttime = null;
         ObjectUtils.disposeObject(this._btnHelp);
         this._btnHelp = null;
         if(Boolean(this._huafeiMc))
         {
            removeChild(this._huafeiMc);
            this._huafeiMc = null;
         }
         if(Boolean(this._shuziMc))
         {
            removeChild(this._shuziMc);
            this._shuziMc = null;
         }
      }
   }
}

