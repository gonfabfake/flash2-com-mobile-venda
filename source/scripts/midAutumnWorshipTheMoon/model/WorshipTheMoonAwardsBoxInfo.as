package midAutumnWorshipTheMoon.model
{
   public class WorshipTheMoonAwardsBoxInfo
   {
      
      public var id:int;
      
      public var moonType:int;
      
      public function WorshipTheMoonAwardsBoxInfo(param1:int, param2:int)
      {
         super();
         this.moonType = param1;
         this.id = param2;
      }
      
      public static function getMoonName(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "Lua Nova";
            case 2:
               return "Lua 4°Minguante";
            case 3:
               return "1°trimestre Lunar";
            case 4:
               return "4°Minguante";
            case 5:
               return "Lua Minguante";
            case 6:
               return "Lua Cheia";
            default:
               return "";
         }
      }
      
      public static function getCakeName(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "Bolo da Lua";
            case 2:
               return "Bolo da lua de jujube";
            case 3:
               return "Bolo da lua de café";
            case 4:
               return "Bolo da lua de chá";
            case 5:
               return "Bolo da lua de chocolate";
            case 6:
               return "Pacote Lua Cheia";
            default:
               return "";
         }
      }
   }
}

