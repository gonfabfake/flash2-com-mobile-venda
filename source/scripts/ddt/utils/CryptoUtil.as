package ddt.utils
{
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.util.Base64;
   import com.hurlant.util.Hex;
   import flash.utils.ByteArray;
   
   public class CryptoUtil
   {
      
      private static const KEY:String = "7A8B9C2D15F01E381F91A0B6C6D68E4F";
      
      public function CryptoUtil()
      {
         super();
      }
      
      public static function encrypt(param1:String) : String
      {
         var _loc2_:ByteArray = Hex.toArray(Hex.fromString(KEY));
         var _loc3_:ICipher = Crypto.getCipher("aes-ecb",_loc2_,Crypto.getPad("pkcs5"));
         var _loc4_:ByteArray = Hex.toArray(Hex.fromString(param1));
         _loc3_.encrypt(_loc4_);
         return Base64.encodeByteArray(_loc4_);
      }
      
      public static function decrypt(param1:String) : String
      {
         var _loc2_:ByteArray = Hex.toArray(Hex.fromString(KEY));
         var _loc3_:ICipher = Crypto.getCipher("aes-ecb",_loc2_,Crypto.getPad("pkcs5"));
         var _loc4_:ByteArray = Base64.decodeToByteArray(param1);
         _loc3_.decrypt(_loc4_);
         return Hex.toString(Hex.fromArray(_loc4_));
      }
   }
}

