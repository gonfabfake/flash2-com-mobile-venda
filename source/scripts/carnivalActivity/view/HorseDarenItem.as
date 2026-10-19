package carnivalActivity.view
{
   import carnivalActivity.CarnivalActivityManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.PlayerCurInfo;
   
   public class HorseDarenItem extends CarnivalActivityItem
   {
      
      private var _horseGrade:int;
      
      private var _horseStar:int;
      
      private var _horseSkillType:int;
      
      private var _horseSkillGrade:int;
      
      private var _reallyHorseGrade:int;
      
      public function HorseDarenItem(param1:int, param2:GiftBagInfo, param3:int)
      {
         super(param1,param2,param3);
      }
      
      override protected function initItem() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < _info.giftConditionArr.length)
         {
            if(CarnivalActivityManager.instance.currentChildType == 0)
            {
               if(_info.giftConditionArr[_loc2_].conditionIndex == 0)
               {
                  this._horseGrade = _info.giftConditionArr[_loc2_].conditionValue;
                  this._reallyHorseGrade = _info.giftConditionArr[_loc2_].remain1;
               }
               else
               {
                  this._horseStar = _info.giftConditionArr[_loc2_].conditionValue;
               }
            }
            else if(_info.giftConditionArr[_loc2_].conditionIndex == 0)
            {
               this._horseSkillType = _info.giftConditionArr[_loc2_].conditionValue;
            }
            else
            {
               this._horseSkillGrade = _info.giftConditionArr[_loc2_].conditionValue;
            }
            _loc2_++;
         }
         if(_sumCount != 0)
         {
            _awardCountTxt = ComponentFactory.Instance.creatComponentByStylename("carnivalAct.countTxt");
            addChild(_awardCountTxt);
         }
         else
         {
            _descTxt.y += 9;
         }
         if(CarnivalActivityManager.instance.currentChildType == 0)
         {
            _descTxt.text = LanguageMgr.GetTranslation("horseDaren.grade.descTxt",this._horseGrade,this._horseStar);
         }
         else
         {
            _loc1_ = "";
            _descTxt.text = LanguageMgr.GetTranslation("horseDaren.skill.descTxt",_loc1_);
         }
      }
      
      override public function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PlayerCurInfo = null;
         _giftCurInfo = WonderfulActivityManager.Instance.activityInitData[_info.activityId].giftInfoDic[_info.giftbagId];
         _statusArr = WonderfulActivityManager.Instance.activityInitData[_info.activityId].statusArr;
         for each(_loc5_ in _statusArr)
         {
            if(CarnivalActivityManager.instance.currentChildType == 0)
            {
               if(_loc5_.statusID == 0)
               {
                  _loc1_ = _loc5_.statusValue;
               }
               else if(_loc5_.statusID == 1)
               {
                  _loc2_ = _loc5_.statusValue;
               }
            }
            else if(_loc5_.statusID == this._horseSkillType)
            {
               _loc3_ = _loc5_.statusValue;
            }
            else if(_loc5_.statusID == this._horseSkillType + 100)
            {
               _loc4_ = _loc5_.statusValue;
            }
         }
         if(CarnivalActivityManager.instance.currentChildType == 0)
         {
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && this._reallyHorseGrade > _loc1_ && this._reallyHorseGrade <= _loc2_;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         else
         {
            _getBtn.enable = CarnivalActivityManager.instance.canGetAward() && _giftCurInfo.times == 0 && this._horseSkillGrade > _loc3_ && this._horseSkillGrade <= _loc4_;
            _alreadyGetBtn.visible = _giftCurInfo.times > 0;
            _getBtn.visible = !_alreadyGetBtn.visible;
         }
         if(Boolean(_awardCountTxt))
         {
            _awardCountTxt.text = LanguageMgr.GetTranslation("carnival.awardCountTxt") + (_sumCount - _giftCurInfo.allGiftGetTimes);
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(_alreadyGetBtn);
         _alreadyGetBtn = null;
         super.dispose();
      }
   }
}

