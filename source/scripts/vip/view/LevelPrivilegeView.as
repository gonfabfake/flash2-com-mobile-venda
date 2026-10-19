package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class LevelPrivilegeView extends Sprite implements Disposeable
   {
      
      private static const MAX_LEVEL:int = 15;
      
      private static const VIP_SETTINGS_FIELD:Array = ["ShopVipScore","VIPRateForGP","VIPStrengthenEx","VIPQuestStar","VIPBruiedStar","VIPLotteryCountMaxPerDay","VIPExtraBindMoneyUpper","VIPTakeCardDisCount","VIPLotteryNoTime","VIPBossBattle","CanBuyFert","FarmAssistant","PetFifthSkill","LoginSysNotice","VIPMetalRelieve","VIPWeekly","HotSpringBathrobe","VIPBenediction","VIPCrytBoss","LoginSysNotice2","VIPGradePackage","FireworksWeekPacks"];
      
      private var _bg:Image;
      
      private var _titleBg:Image;
      
      private var _titleSeperators:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _titleIcons:Vector.<Image>;
      
      private var _itemScrollPanel:ScrollPanel;
      
      private var _itemContainer:VBox;
      
      private var _seperator:Image;
      
      private var _currentVip:Image;
      
      private var _units:Dictionary;
      
      private var _minPrivilegeLevel:Dictionary = new Dictionary();
      
      public function LevelPrivilegeView()
      {
         super();
         this._units = new Dictionary();
         this._units[2] = "%";
         this._units[5] = this._units[6] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.TimesUnit");
         this._units[7] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.DiscountUnit");
         this.initView();
         this.initItem();
      }
      
      private function initItem() : void
      {
         var item:PrivilegeViewItem = null;
         var data:Vector.<String> = null;
         var item2:PrivilegeViewItem = null;
         var j:int = 0;
         for(; j <= 7; j++)
         {
            item = null;
            if(j == 3 || j == 4)
            {
               item = new PrivilegeViewItem(2,"asset.vip.star");
            }
            else
            {
               if(j == 4)
               {
                  continue;
               }
               if(this._units[j] != null)
               {
                  item = new PrivilegeViewItem(1,this._units[j]);
               }
               else
               {
                  item = new PrivilegeViewItem();
               }
            }
            item.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[j]);
            if(j == 1)
            {
               item.contentInterceptor = function(param1:String):String
               {
                  return Number(param1).toFixed(1);
               };
            }
            else if(j == 7)
            {
               item.crossFilter = "100";
               item.contentInterceptor = function(param1:String):String
               {
                  return (Number(param1) / 10).toString();
               };
            }
            if(j == 4)
            {
               item.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData("VIPQuestStar"));
            }
            else
            {
               item.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData(VIP_SETTINGS_FIELD[j]));
            }
            if(j != 5)
            {
               this._itemContainer.addChild(item);
            }
         }
         this.parsePrivilegeItem(11,9);
         this.parsePrivilegeItem(8,10);
         this.parsePrivilegeItem(10,11);
         this.parsePrivilegeItem(9,12);
         this.parsePrivilegeItem(12,13);
         this.parsePrivilegeItem(15,19);
         data = Vector.<String>(["1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"]);
         j = 14;
         while(j <= 16)
         {
            item2 = new PrivilegeViewItem(0);
            item2.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[j]);
            item2.itemContent = data;
            this._itemContainer.addChild(item2);
            j++;
         }
         this.parseBenediction();
         this.parseVIPCryptBoss();
         this.parseRewardTaskItem();
         this.parsePrivilegeItem(12,21);
         this.parsePrivilegeItem(12,20);
         this._itemScrollPanel.invalidateViewport();
      }
      
      private function parseRewardTaskItem() : void
      {
         var _loc1_:Vector.<String> = Vector.<String>(["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]);
         var _loc2_:PrivilegeViewItem = new PrivilegeViewItem(3);
         _loc2_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPRewardTask");
         _loc2_.itemContent = _loc1_;
         this._itemContainer.addChild(_loc2_);
      }
      
      private function parseVIPCryptBoss() : void
      {
         var _loc1_:Vector.<String> = ServerConfigManager.instance.VIPRewardCryptCount;
         var _loc2_:PrivilegeViewItem = new PrivilegeViewItem(3);
         _loc2_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[18]);
         _loc2_.itemContent = _loc1_;
         this._itemContainer.addChild(_loc2_);
      }
      
      private function parseVipIconItem() : void
      {
         var _loc1_:Array = GiveYourselfOpenView.getVipinfo();
         var _loc2_:PrivilegeViewItem = new PrivilegeViewItem(4);
         _loc2_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPRwardInfo");
         _loc2_.itemContentForIcontype = _loc1_;
         this._itemContainer.addChild(_loc2_);
      }
      
      private function parsePrivilegeItem(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Array = [];
         var _loc6_:int = ServerConfigManager.instance.getPrivilegeMinLevel(param1.toString());
         _loc3_ = 1;
         while(_loc3_ <= 15)
         {
            _loc5_.push(_loc3_ >= _loc6_ ? "1" : "0");
            _loc3_++;
         }
         if(param2 == 20)
         {
            _loc4_ = new PrivilegeViewItem(5);
            _loc4_.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData("VIPLevelGiftID"));
         }
         else if(param2 == 21)
         {
            _loc4_ = new PrivilegeViewItem(5);
            _loc4_.itemContent = Vector.<String>(ServerConfigManager.instance.analyzeData("VIPSendFireRed"));
         }
         else
         {
            _loc4_ = new PrivilegeViewItem(0);
            _loc4_.itemContent = Vector.<String>(_loc5_);
         }
         _loc4_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[param2]);
         this._itemContainer.addChild(_loc4_);
      }
      
      private function parseBenediction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 17;
         var _loc5_:Vector.<String> = Vector.<String>(["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]);
         _loc1_ = 1;
         while(_loc1_ <= 6)
         {
            _loc5_[ServerConfigManager.instance.getPrivilegeMinLevel(_loc1_.toString()) - 1] = _loc1_.toString();
            _loc1_++;
         }
         _loc3_ = ServerConfigManager.instance.getPrivilegeMinLevel("6");
         _loc2_ = _loc3_;
         while(_loc2_ < 15)
         {
            _loc5_[_loc2_] = "All";
            _loc2_++;
         }
         var _loc6_:PrivilegeViewItem = new PrivilegeViewItem();
         _loc6_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem." + VIP_SETTINGS_FIELD[_loc4_]);
         _loc6_.analyzeFunction = this.benedictionAnalyzer;
         _loc6_.itemContent = _loc5_;
         this._itemContainer.addChild(_loc6_);
      }
      
      private function benedictionAnalyzer(param1:Vector.<String>) : Vector.<DisplayObject>
      {
         var _loc6_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         var _loc5_:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeBenedctionItemTxtStartPos");
         for each(_loc6_ in param1)
         {
            if(_loc6_ != "0")
            {
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewBenedctionItemTxt");
               _loc2_.text = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.MayneRand" + _loc6_);
               PositionUtils.setPos(_loc2_,_loc5_);
               _loc2_.x += 6;
               _loc2_.y -= 5;
               _loc5_.x += 45;
               _loc4_.push(_loc2_);
               this.autoText(_loc2_);
            }
            else
            {
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
               PositionUtils.setPos(_loc3_,_loc5_);
               _loc3_.x = _loc5_.x + (40 - _loc3_.width);
               _loc5_.x += 45;
               _loc4_.push(_loc3_);
            }
         }
         return _loc4_;
      }
      
      private function autoText(param1:FilterFrameText) : void
      {
         var _loc2_:* = null;
         if(param1.numLines >= 2)
         {
            param1.width = 45;
            param1.x -= 8;
            _loc2_ = param1.getTextFormat();
            _loc2_.size = 8;
            param1.setTextFormat(_loc2_);
         }
      }
      
      private function parseRingStation(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = ServerConfigManager.instance.getPrivilegeMinLevel(param1.toString());
         _loc2_ = 1;
         while(_loc2_ <= 15)
         {
            _loc3_.push(_loc2_ >= _loc4_ ? "1" : "0");
            _loc2_++;
         }
         var _loc5_:PrivilegeViewItem = new PrivilegeViewItem(0);
         _loc5_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.VIPRingStation");
         _loc5_.itemContent = Vector.<String>(_loc3_);
         this._itemContainer.addChild(_loc5_);
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeViewBg");
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeTitleBg");
         this._titleSeperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewTitleItemSeperators");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.TitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.vip.LevelPrivilegeView.TitleTxt");
         this._seperator = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeSeperator");
         this._currentVip = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.currentVip");
         this._currentVip.x += (PlayerManager.Instance.Self.VIPLevel - 1) * 45;
         this._currentVip.visible = PlayerManager.Instance.Self.IsVIP;
         addChild(this._bg);
         addChild(this._titleBg);
         addChild(this._titleSeperators);
         addChild(this._titleTxt);
         addChild(this._seperator);
         this._titleIcons = new Vector.<Image>();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = 1;
         while(_loc1_ <= 15)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.VipIcon" + _loc1_);
            this._titleIcons.push(_loc2_);
            addChild(_loc2_);
            if(_loc1_ == 1)
            {
               _loc3_ = int(_loc2_.x);
               _loc4_ = int(_loc2_.y);
            }
            else
            {
               _loc3_ += 45;
               _loc2_.x = _loc3_;
               _loc2_.y = _loc4_;
            }
            _loc1_++;
         }
         addChild(this._currentVip);
         this._itemScrollPanel = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.ItemScrollPanel");
         addChild(this._itemScrollPanel);
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemContainer");
         this._itemScrollPanel.setView(this._itemContainer);
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._titleIcons)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._titleIcons = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._titleBg);
         ObjectUtils.disposeObject(this._titleSeperators);
         ObjectUtils.disposeObject(this._titleTxt);
         ObjectUtils.disposeObject(this._itemContainer);
         ObjectUtils.disposeObject(this._itemScrollPanel);
         ObjectUtils.disposeObject(this._seperator);
         ObjectUtils.disposeObject(this._currentVip);
         this._bg = null;
         this._titleBg = null;
         this._titleSeperators = null;
         this._titleTxt = null;
         this._itemScrollPanel = null;
         this._itemContainer = null;
         this._seperator = null;
         this._currentVip = null;
      }
   }
}

