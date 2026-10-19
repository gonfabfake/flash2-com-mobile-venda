package AvatarCollection.data
{
   public class AvatarCollectionSelectData
   {
      
      public var value:AvatarCollectionUnitVo;
      
      public var selected:Boolean = false;
      
      public function AvatarCollectionSelectData(param1:AvatarCollectionUnitVo, param2:Boolean)
      {
         super();
         this.value = param1;
         this.selected = param2;
      }
   }
}

