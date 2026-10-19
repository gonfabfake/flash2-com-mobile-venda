package ddt.manager
{
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.GypsyShopPackageType;
   import ddt.data.socket.WorshipTheMoonPackageType;
   import ddt.data.socket.ePackageType;
   import flash.geom.Point;
   import pyramid.PyramidPackageType;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   import sanXiao.model.SXCellData;
   
   public class GameInSocketOut
   {
      
      private static var _socket:ByteSocket = SocketManager.Instance.socket;
      
      public function GameInSocketOut()
      {
         super();
      }
      
      public static function sendGetScenePlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_USERS_LIST);
         _loc2_.writeByte(param1);
         _loc2_.writeByte(6);
         sendPackage(_loc2_);
      }
      
      public static function sendInviteGame(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendBuyProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendSellProp(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendGameRoomSetUp(param1:int, param2:int, param3:String = "", param4:String = "", param5:int = 2, param6:int = 0, param7:int = 0, param8:Boolean = false) : void
      {
         var _loc9_:int = PlayerManager.Instance.Self.Grade < 5 ? int(4) : int(param5);
         var _loc10_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc10_.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         _loc10_.writeInt(param1);
         _loc10_.writeByte(param2);
         _loc10_.writeUTF(param3);
         _loc10_.writeUTF(param4);
         _loc10_.writeByte(_loc9_);
         _loc10_.writeByte(param6);
         _loc10_.writeInt(param7);
         _loc10_.writeBoolean(param8);
         sendPackage(_loc10_);
      }
      
      public static function sendCreateRoom(param1:String, param2:int, param3:int = 2, param4:String = "") : void
      {
         var _loc5_:int = PlayerManager.Instance.Self.Grade < 5 ? int(4) : int(param3);
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc6_.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         _loc6_.writeByte(param2);
         _loc6_.writeByte(_loc5_);
         _loc6_.writeUTF(param1);
         _loc6_.writeUTF(param4);
         sendPackage(_loc6_);
      }
      
      public static function sendGameRoomPlaceState(param1:int, param2:int, param3:Boolean = false, param4:int = -100) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.GAME_ROOM_UPDATE_PLACE);
         _loc5_.writeByte(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeInt(param4);
         sendPackage(_loc5_);
      }
      
      public static function sendGameRoomKick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_ROOM_KICK);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendExitScene() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         sendPackage(_loc1_);
      }
      
      public static function sendGamePlayerExit() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_ROOM_REMOVEPLAYER);
         sendPackage(_loc1_);
      }
      
      public static function sendGameTeam(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_TEAM);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendFlagMode(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.WANNA_LEADER);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_START);
         sendPackage(_loc1_);
      }
      
      public static function sendGameMissionStart(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(CrazyTankPackageType.GAME_MISSION_START);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameMissionPrepare(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.GAME_MISSION_PREPARE);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendLoadingProgress(param1:Number) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.LOAD);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendPlayerState(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PLAYER_STATE_CHANGE);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDBlast(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc5_.writeByte(CrazyTankPackageType.BLAST);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         sendPackage(_loc5_);
      }
      
      public static function sendGameCMDChange(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc6_.writeByte(CrazyTankPackageType.CHANGEBALL);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         sendPackage(_loc6_);
      }
      
      public static function sendGameCMDDirection(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.DIRECTION);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDStunt(param1:int = 0) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.STUNT);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDShoot(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc5_.writeByte(CrazyTankPackageType.FIRE);
         _loc5_.writeInt(int(param1));
         _loc5_.writeInt(int(param2));
         _loc5_.writeInt(int(param3));
         _loc5_.writeInt(int(param4));
         sendPackage(_loc5_);
      }
      
      public static function sendGameSkipNext(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.SKIPNEXT);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameStartMove(param1:Number, param2:int, param3:int, param4:Number, param5:Boolean, param6:Number) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc7_.writeByte(CrazyTankPackageType.MOVESTART);
         _loc7_.writeBoolean(true);
         _loc7_.writeByte(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeByte(param4);
         _loc7_.writeBoolean(param5);
         _loc7_.writeShort(param6);
         sendPackage(_loc7_);
      }
      
      public static function sendGameStopMove(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.MOVESTOP);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendGameTakeOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendBossTakeOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.BOSS_TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGetTropToBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendShootTag(param1:Boolean, param2:int = 0) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.FIRE_TAG);
         _loc3_.writeBoolean(param1);
         if(param1)
         {
            _loc3_.writeByte(param2);
         }
         sendPackage(_loc3_);
      }
      
      public static function sendBeat(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.BEAT);
         _loc4_.writeShort(param1);
         _loc4_.writeShort(param2);
         _loc4_.writeShort(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendThrowProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(CrazyTankPackageType.PROP_DELETE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendUseProp(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.PROP);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendCancelWait() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_PICKUP_CANCEL);
         sendPackage(_loc1_);
      }
      
      public static function sendGameStyle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGhostTarget(param1:Point) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.GHOST_TARGET);
         _loc2_.writeInt(param1.x);
         _loc2_.writeInt(param1.y);
         sendPackage(_loc2_);
      }
      
      public static function sendPaymentTakeCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PAYMENT_TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendMissionTryAgain(param1:int, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.GAME_MISSION_TRY_AGAIN);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendFightLibInfoChange(param1:int, param2:int = -1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendPassStory() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.PASS_STORY);
         _loc1_.writeBoolean(true);
         sendPackage(_loc1_);
      }
      
      public static function sendClientScriptStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(3);
         sendPackage(_loc1_);
      }
      
      public static function sendClientScriptEnd() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(2);
         sendPackage(_loc1_);
      }
      
      public static function sendFightLibAnswer(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc3_.writeInt(4);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendFightLibReanswer() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(5);
         sendPackage(_loc1_);
      }
      
      public static function sendUpdatePlayStep(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.MISSION_CMD);
         _loc2_.writeInt(6);
         _loc2_.writeUTF(param1);
         sendPackage(_loc2_);
      }
      
      private static function sendPackage(param1:PackageOut) : void
      {
         _socket.send(param1);
      }
      
      public static function sendFirstRechargeGetAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FIRSTRECHARGE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendNoviceActivityGetAward(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.NOVICEACTIVITY);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendTransmissionGate(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.DELIVER);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendRequestEnterPyramidSystem() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc1_.writeByte(PyramidPackageType.PYRAMID_ENTER);
         sendPackage(_loc1_);
      }
      
      public static function sendPyramidStartOrstop(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(PyramidPackageType.PYRAMID_STARTORSTOP);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendPyramidTurnCard(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc3_.writeByte(PyramidPackageType.PYRAMID_RESULT);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendPyramidRevive(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.ACTIVITY_SYSTEM);
         _loc2_.writeByte(PyramidPackageType.PYRAMID_DIEEVENT);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendWorshipTheMoon(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         _loc3_.writeByte(WorshipTheMoonPackageType.WORSHIP_THE_MOON);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendWorshipTheMoonIsActivityOpen() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         _loc1_.writeByte(WorshipTheMoonPackageType.IS_ACTIVITY_OPEN);
         sendPackage(_loc1_);
      }
      
      public static function sendWorshipTheMoonFreeCount() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         _loc1_.writeByte(WorshipTheMoonPackageType.FREE_COUNT);
         sendPackage(_loc1_);
      }
      
      public static function sendWorshipTheMoonAwardsList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         _loc1_.writeByte(WorshipTheMoonPackageType.AWARDS_LIST);
         sendPackage(_loc1_);
      }
      
      public static function sendGainThe200timesAwardBox() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.WORSHIP_THE_MOON_MID_AUTUMN);
         _loc1_.writeByte(WorshipTheMoonPackageType.RECEIVE_MOON_REWARD);
         sendPackage(_loc1_);
      }
      
      public static function sendGodOfWealthPay() : void
      {
         var _loc1_:PackageOut = new PackageOut(341);
         _loc1_.writeByte(2);
         sendPackage(_loc1_);
      }
      
      public static function sendGodOfWealthInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(341);
         _loc1_.writeByte(3);
         sendPackage(_loc1_);
      }
      
      public static function sendGypsyBuy(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         _loc3_.writeByte(GypsyShopPackageType.BUY);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendGypsyRefreshItemList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         _loc1_.writeByte(GypsyShopPackageType.PLAYER_INFO);
         sendPackage(_loc1_);
      }
      
      public static function sendGypsyManualRefreshItemList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         _loc1_.writeByte(GypsyShopPackageType.REFRESH);
         sendPackage(_loc1_);
      }
      
      public static function sendGypsyRefreshRareList() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         _loc1_.writeByte(GypsyShopPackageType.RARE_ITEM_INFO);
         sendPackage(_loc1_);
      }
      
      public static function sendRequestGypsyNPCState() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.MYSTERY_SHOP);
         _loc1_.writeByte(GypsyShopPackageType.OPEN_INFO);
         sendPackage(_loc1_);
      }
      
      public static function sendGoldmineInfoAttribute() : void
      {
         var _loc1_:PackageOut = new PackageOut(624);
         _loc1_.writeByte(3);
         sendPackage(_loc1_);
      }
      
      public static function sendGoldmineUse() : void
      {
         var _loc1_:PackageOut = new PackageOut(624);
         _loc1_.writeByte(2);
         sendPackage(_loc1_);
      }
      
      public static function sendSXCreateMap(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(1);
         _loc3_.writeInt(param1.length / 3);
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_.writeInt(param1[_loc2_]);
            _loc3_.writeInt(param1[_loc2_ + 1]);
            _loc3_.writeInt(param1[_loc2_ + 2]);
            _loc2_ += 3;
         }
         sendPackage(_loc3_);
      }
      
      public static function sendSXRequireMapInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(2);
         sendPackage(_loc1_);
      }
      
      public static function sendSXPropCrossBomb(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(41);
         _loc3_.writeBoolean(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendSXPropSquareBomb(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(48);
         _loc3_.writeBoolean(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendSXPropClearColor(param1:Boolean, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(49);
         _loc3_.writeBoolean(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendSXPropChangeColor(param1:Boolean, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = null;
         _loc5_ = new PackageOut(329);
         _loc5_.writeByte(50);
         _loc5_.writeBoolean(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         sendPackage(_loc5_);
      }
      
      public static function sendSXBoom(param1:int, param2:int, param3:int, param4:int, param5:Array) : void
      {
         var _loc11_:PackageOut = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc11_ = new PackageOut(329);
         _loc11_.writeByte(3);
         _loc11_.writeInt(param1);
         _loc11_.writeInt(param2);
         _loc11_.writeInt(param3);
         _loc11_.writeInt(param4);
         _loc6_ = int(param5.length);
         _loc11_.writeInt(_loc6_);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param5[_loc7_];
            _loc9_ = int((_loc8_ as Array).length);
            _loc11_.writeInt(int(_loc9_ / 2));
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc11_.writeInt(_loc8_[_loc10_]);
               _loc11_.writeInt(_loc8_[_loc10_ + 1]);
               _loc10_ += 2;
            }
            _loc7_++;
         }
         sendPackage(_loc11_);
      }
      
      public static function sendSXFillCellList(param1:Vector.<SXCellData>) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(4);
         var _loc4_:int = int(param1.length);
         _loc3_.writeInt(_loc4_);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_.writeInt(param1[_loc2_].row);
            _loc3_.writeInt(param1[_loc2_].column);
            _loc3_.writeInt(param1[_loc2_].type);
            _loc2_++;
         }
         sendPackage(_loc3_);
      }
      
      public static function sendSXRequireViewData() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(5);
         sendPackage(_loc1_);
      }
      
      public static function sendSXGainPrise(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(329);
         _loc2_.writeByte(7);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendSXBuyItem(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(8);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendSXHitsEnd() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(9);
         sendPackage(_loc1_);
      }
      
      public static function sendSXBuyOneTimes(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(15);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendSXRewardsData() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(17);
         sendPackage(_loc1_);
      }
      
      public static function sendSXStoreData() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(18);
         sendPackage(_loc1_);
      }
      
      public static function sendGodCardInfoAttribute() : void
      {
         var _loc1_:PackageOut = new PackageOut(329);
         _loc1_.writeByte(20);
         sendPackage(_loc1_);
      }
      
      public static function sendGodCardOpenCard(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(21);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendGodCardOperateCard(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = null;
         _loc4_ = new PackageOut(329);
         _loc4_.writeByte(22);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendGodCardExchange(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:PackageOut = new PackageOut(329);
         _loc3_.writeByte(23);
         _loc3_.writeInt(param1);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendGodCardPointAwardAttribute(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(329);
         _loc2_.writeByte(24);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendMoneyTreeSpeedUp(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:PackageOut = null;
         _loc4_ = new PackageOut(296);
         _loc4_.writeByte(2);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendMoneyTreeSendRedPackage(param1:Array) : void
      {
         var _loc8_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:int = int(param1.length);
         var _loc7_:int = 80;
         _loc2_ = 0;
         while(_loc2_ < _loc6_)
         {
            _loc3_ = Math.min(_loc6_,_loc2_ + _loc7_);
            _loc4_ = param1.slice(_loc2_,_loc3_);
            _loc5_ = new PackageOut(296);
            _loc5_.writeByte(3);
            _loc5_.writeInt(_loc4_.length);
            for each(_loc8_ in _loc4_)
            {
               _loc5_.writeInt(_loc8_);
            }
            sendPackage(_loc5_);
            _loc2_ += _loc7_;
         }
      }
      
      public static function sendMoneyTreePick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(296);
         _loc2_.writeByte(4);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendMoneyTreeRequireInfo() : void
      {
         var _loc1_:PackageOut = new PackageOut(296);
         _loc1_.writeByte(1);
         sendPackage(_loc1_);
      }
      
      public static function sendMaxBtnState(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(538);
         _loc2_.writeByte(2);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendRequireMaxBtnState() : void
      {
         var _loc1_:PackageOut = new PackageOut(538);
         _loc1_.writeByte(1);
         sendPackage(_loc1_);
      }
   }
}

