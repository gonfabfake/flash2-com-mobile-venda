package magicHouse.magicCollection
{
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseControl;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   
   public class MagicHouseCollectionMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _typeWeaponBtn:SimpleBitmapButton;
      
      private var _freeBtn:SimpleBitmapButton;
      
      private var _goldenBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _upgradeBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _promoteDamageAtrb:FilterFrameText;
      
      private var _promoteArmorAtrb:FilterFrameText;
      
      private var _promoteBloodAtrb:FilterFrameText;
      
      private var _valueMagicAttack:FilterFrameText;
      
      private var _valueMagicDefense:FilterFrameText;
      
      private var _valueCritDamage:FilterFrameText;
      
      private var _juniorItem:MagicHouseCollectionItemView;
      
      private var _midItem:MagicHouseCollectionItemView;
      
      private var _seniorItem:MagicHouseCollectionItemView;
      
      private var _freeCell:Bitmap;
      
      private var _freeCellBtn:RichesButton;
      
      private var _freeCountTxt:FilterFrameText;
      
      private var _potionCell:BagCell;
      
      public function MagicHouseCollectionMainView()
      {
         super();
         MagicHouseControl.instance.selectEquipFromBag();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.collectionviewbg");
         addChild(this._bg);
         this._typeWeaponBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.typeWeaponBtn");
         addChild(this._typeWeaponBtn);
         this._freeBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.freeBtn");
         addChild(this._freeBtn);
         this._goldenBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.goldenBtn");
         addChild(this._goldenBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.helpBtn");
         addChild(this._helpBtn);
         this._promoteDamageAtrb = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteArmorAtrb = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteBloodAtrb = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.promoteTotleAbilityTxt");
         this._promoteDamageAtrb.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDamage");
         this._promoteArmorAtrb.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDefense");
         this._promoteBloodAtrb.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addCritDamage");
         PositionUtils.setPos(this._promoteDamageAtrb,"magicHouse.promoteMagicAttackPos");
         PositionUtils.setPos(this._promoteArmorAtrb,"magicHouse.promoteMagicDefensePos");
         PositionUtils.setPos(this._promoteBloodAtrb,"magicHouse.promoteCritDamagePos");
         addChild(this._promoteDamageAtrb);
         addChild(this._promoteArmorAtrb);
         addChild(this._promoteBloodAtrb);
         this._valueMagicAttack = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         this._valueMagicDefense = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         this._valueCritDamage = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.valueTotleAbilityTxt");
         PositionUtils.setPos(this._valueMagicAttack,"magicHouse.valueMagicAttackPos");
         PositionUtils.setPos(this._valueMagicDefense,"magicHouse.valueMagicDefensePos");
         PositionUtils.setPos(this._valueCritDamage,"magicHouse.valueCritDamagePos");
         addChild(this._valueMagicAttack);
         addChild(this._valueMagicDefense);
         addChild(this._valueCritDamage);
         this._juniorItem = new MagicHouseCollectionItemView(1);
         this._midItem = new MagicHouseCollectionItemView(2);
         this._seniorItem = new MagicHouseCollectionItemView(3);
         addChild(this._juniorItem);
         addChild(this._midItem);
         addChild(this._seniorItem);
         PositionUtils.setPos(this._midItem,"magicHouse.collection.miditemPos");
         PositionUtils.setPos(this._seniorItem,"magicHouse.collection.senioritemPos");
         this._freeCell = ComponentFactory.Instance.creatBitmap("magichouse.collection.freeCell");
         addChild(this._freeCell);
         this._freeCellBtn = ComponentFactory.Instance.creatCustomObject("magichouse.collectionView.freeBtn");
         this._freeCellBtn.tipData = LanguageMgr.GetTranslation("magichouse.collectionView.freeGetTips");
         addChild(this._freeCellBtn);
         this._freeCountTxt = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.freeCountTxt");
         this._freeCountTxt.text = "(" + (5 - MagicHouseModel.instance.freeGetCount) + ")";
         addChild(this._freeCountTxt);
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(201489);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(61440,0);
         _loc2_.graphics.drawRect(0,0,49,49);
         _loc2_.graphics.endFill();
         this._potionCell = new BagCell(0,_loc1_,false,_loc2_,false);
         this._potionCell.width = this._potionCell.height = 47;
         addChild(this._potionCell);
         PositionUtils.setPos(this._potionCell,"magichouse.collectionview.potioncell.pos");
         if(MagicHouseControl.instance.checkGetFreeBoxTime())
         {
            this._freeCountTxt.text = "(5)";
         }
         this.setData();
      }
      
      private function setData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = MagicHouseModel.instance.activityWeapons;
         var _loc8_:Array = MagicHouseModel.instance.juniorAddAttribute;
         var _loc9_:int = MagicHouseModel.instance.magicJuniorLv;
         var _loc10_:Array = MagicHouseModel.instance.midAddAttribute;
         var _loc11_:int = MagicHouseModel.instance.magicMidLv;
         var _loc12_:Array = MagicHouseModel.instance.seniorAddAttribute;
         var _loc13_:int = MagicHouseModel.instance.magicSeniorLv;
         if(Boolean(_loc7_[0]) && Boolean(_loc7_[1]) && Boolean(_loc7_[2]))
         {
            _loc1_ = 0;
            while(_loc1_ <= _loc9_)
            {
               _loc4_ += int(_loc8_[_loc1_].split(",")[0]);
               _loc5_ += int(_loc8_[_loc1_].split(",")[1]);
               _loc6_ += int(_loc8_[_loc1_].split(",")[2]);
               _loc1_++;
            }
         }
         if(Boolean(_loc7_[3]) && Boolean(_loc7_[4]) && Boolean(_loc7_[5]))
         {
            _loc2_ = 0;
            while(_loc2_ <= _loc11_)
            {
               _loc4_ += int(_loc10_[_loc2_].split(",")[0]);
               _loc5_ += int(_loc10_[_loc2_].split(",")[1]);
               _loc6_ += int(_loc10_[_loc2_].split(",")[2]);
               _loc2_++;
            }
         }
         if(Boolean(_loc7_[6]) && Boolean(_loc7_[7]) && Boolean(_loc7_[8]))
         {
            _loc3_ = 0;
            while(_loc3_ <= _loc13_)
            {
               _loc4_ += int(_loc12_[_loc3_].split(",")[0]);
               _loc5_ += int(_loc12_[_loc3_].split(",")[1]);
               _loc6_ += int(_loc12_[_loc3_].split(",")[2]);
               _loc3_++;
            }
         }
         this._valueMagicAttack.text = _loc4_ + "%";
         this._valueMagicDefense.text = _loc5_ + "%";
         this._valueCritDamage.text = _loc6_ + "%";
         this._freeCountTxt.text = "(" + (5 - MagicHouseModel.instance.freeGetCount) + ")";
         if(MagicHouseControl.instance.checkGetFreeBoxTime())
         {
            this._freeCountTxt.text = "(5)";
         }
      }
      
      private function initEvent() : void
      {
         this._freeBtn.addEventListener("click",this.__freeGet);
         this._goldenBtn.addEventListener("click",this.__chargeGet);
         this._helpBtn.addEventListener("click",this.__helpClick);
         MagicHouseManager.instance.addEventListener("magichouse_updata",this.__messageUpdate);
      }
      
      private function removeEvent() : void
      {
         this._freeBtn.removeEventListener("click",this.__freeGet);
         this._goldenBtn.removeEventListener("click",this.__chargeGet);
         this._helpBtn.removeEventListener("click",this.__helpClick);
         MagicHouseManager.instance.removeEventListener("magichouse_updata",this.__messageUpdate);
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("magichouse.mainview.frametitletext");
            this._helpFrame.addEventListener("response",this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("magichouse.collection.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener("click",this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,3,true,2);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      private function __messageUpdate(param1:Event) : void
      {
         this.setData();
      }
      
      private function __freeGet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(TimeManager.Instance.Now().getDate() != MagicHouseModel.instance.freeGetTime.getDate())
         {
            SocketManager.Instance.out.magicLibFreeGet(5);
         }
         else if(5 - MagicHouseModel.instance.freeGetCount > 0)
         {
            SocketManager.Instance.out.magicLibFreeGet(5);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxCountLess"));
         }
      }
      
      private function __chargeGet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:QuickBuyFrame = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         _loc2_.setTitleText(LanguageMgr.GetTranslation("magichouse.collectionView.quickbuypotionframe.titletxt"));
         _loc2_.itemID = EquipType.MAGICHOUSE_MAGICPOTION;
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:MagicHouseChargeBoxCountFrame = param1.currentTarget as MagicHouseChargeBoxCountFrame;
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
            case 4:
               _loc2_.dispose();
               break;
            case 2:
            case 3:
               if(TimeManager.Instance.Now().getDate() != MagicHouseModel.instance.chargeGetTime.getDate())
               {
                  SocketManager.Instance.out.magicLibChargeGet(_loc2_.openCount);
               }
               else if(20 - MagicHouseModel.instance.chargeGetCount >= _loc2_.openCount)
               {
                  SocketManager.Instance.out.magicLibChargeGet(_loc2_.openCount);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxCountLess"));
               }
               _loc2_.dispose();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._typeWeaponBtn))
         {
            this._typeWeaponBtn.dispose();
         }
         this._typeWeaponBtn = null;
         if(Boolean(this._freeBtn))
         {
            this._freeBtn.dispose();
         }
         this._freeBtn = null;
         if(Boolean(this._goldenBtn))
         {
            this._goldenBtn.dispose();
         }
         this._goldenBtn = null;
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
         }
         this._helpBtn = null;
         if(Boolean(this._upgradeBtn))
         {
            this._upgradeBtn.dispose();
         }
         this._upgradeBtn = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.dispose();
         }
         this._helpFrame = null;
         if(Boolean(this._bgHelp))
         {
            this._bgHelp.dispose();
         }
         this._bgHelp = null;
         if(Boolean(this._content))
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(Boolean(this._btnOk))
         {
            this._btnOk.dispose();
         }
         this._btnOk = null;
         if(Boolean(this._promoteDamageAtrb))
         {
            this._promoteDamageAtrb.dispose();
         }
         this._promoteDamageAtrb = null;
         if(Boolean(this._promoteArmorAtrb))
         {
            this._promoteArmorAtrb.dispose();
         }
         this._promoteArmorAtrb = null;
         if(Boolean(this._promoteBloodAtrb))
         {
            this._promoteBloodAtrb.dispose();
         }
         this._promoteBloodAtrb = null;
         if(Boolean(this._valueMagicAttack))
         {
            this._valueMagicAttack.dispose();
         }
         this._valueMagicAttack = null;
         if(Boolean(this._valueMagicDefense))
         {
            this._valueMagicDefense.dispose();
         }
         this._valueMagicDefense = null;
         if(Boolean(this._valueCritDamage))
         {
            this._valueCritDamage.dispose();
         }
         this._valueCritDamage = null;
         if(Boolean(this._freeCell))
         {
            ObjectUtils.disposeObject(this._freeCell);
         }
         this._freeCell = null;
         if(Boolean(this._freeCellBtn))
         {
            ObjectUtils.disposeObject(this._freeCellBtn);
         }
         this._freeCellBtn = null;
         if(Boolean(this._freeCountTxt))
         {
            ObjectUtils.disposeObject(this._freeCountTxt);
         }
         this._freeCountTxt = null;
         if(Boolean(this._juniorItem))
         {
            this._juniorItem.dispose();
         }
         this._juniorItem = null;
         if(Boolean(this._midItem))
         {
            this._midItem.dispose();
         }
         this._midItem = null;
         if(Boolean(this._seniorItem))
         {
            this._seniorItem.dispose();
         }
         this._seniorItem = null;
         if(Boolean(this._potionCell))
         {
            ObjectUtils.disposeObject(this._potionCell);
         }
         this._potionCell = null;
      }
   }
}

