package pvePowerBuff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ICharacter;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PvePowerBuffPerson extends Sprite
   {
      
      private var _bg:Bitmap;
      
      private var _player:ICharacter;
      
      private var _levelIcon:LevelIcon;
      
      private var _nickNameText:FilterFrameText;
      
      private var _lightMC:MovieClip;
      
      private var _index:int;
      
      private var _playerInfo:PlayerInfo;
      
      public function PvePowerBuffPerson(param1:int)
      {
         super();
         this._index = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.pvepowerbuff.lianhua");
         addChild(this._bg);
         this._levelIcon = new LevelIcon();
         PositionUtils.setPos(this._levelIcon,"pvePowerBuff.character.level.icom.pos");
         this._nickNameText = ComponentFactory.Instance.creatComponentByStylename("pvePowerBuff.character.nickNameText");
         this._lightMC = ClassUtils.CreatInstance("asset.pvepowerbuff.selected.mc");
         PositionUtils.setPos(this._lightMC,"pvePowerBuff.character.light.mc.pos");
         this._lightMC.visible = false;
         addChild(this._lightMC);
      }
      
      private function initEvent() : void
      {
         addEventListener("click",this.__clickHandler);
      }
      
      private function removeEvemt() : void
      {
         addEventListener("click",this.__clickHandler);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:PvePowerBuffEvent = new PvePowerBuffEvent("select_player");
         _loc2_.info = this;
         PvePowerBuffControl.instance.dispatchEvent(_loc2_);
      }
      
      public function updatePlayer(param1:PlayerInfo) : void
      {
         this._playerInfo = param1;
         this._levelIcon.setInfo(param1.Grade,param1.Repute,param1.WinCount,param1.TotalCount,param1.FightPower,param1.Offer,true,false);
         this._nickNameText.text = param1.NickName;
         this._player = CharactoryFactory.createCharacter(param1,"room");
         this._player.showGun = true;
         this._player.show();
         this._player.setShowLight(true);
         PositionUtils.setPos(this._player,"pvePowerBuff.character.player.pos");
         addChild(this._player as DisplayObject);
         addChild(this._levelIcon);
         addChild(this._nickNameText);
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._playerInfo;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function setLightMcVisible(param1:Boolean) : void
      {
         this._lightMC.visible = param1;
      }
      
      public function dispose() : void
      {
         this.removeEvemt();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._levelIcon))
         {
            this._levelIcon.dispose();
            this._levelIcon = null;
         }
         if(Boolean(this._nickNameText))
         {
            this._nickNameText.dispose();
            this._nickNameText = null;
         }
         if(Boolean(this._player))
         {
            this._player.dispose();
            this._player = null;
         }
      }
   }
}

