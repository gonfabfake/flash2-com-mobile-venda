package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _cb6a80a7adc8f3e6dd3da6624b713d056d8ba7e3aadf3d5eda2dfa1c98a29810_flash_display_Sprite extends Sprite
   {
      
      public function _cb6a80a7adc8f3e6dd3da6624b713d056d8ba7e3aadf3d5eda2dfa1c98a29810_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

