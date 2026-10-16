package com.hurlant.util.asn1.type
{
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   
   public class BooleanType extends ASN1Type
   {
      
      registerClassAlias("com.hurlant.util.asn1.BooleanType",BooleanType);
      
      public function BooleanType()
      {
         super(ASN1Type.BOOLEAN);
      }
      
      override protected function fromDERContent(param1:ByteArray, param2:int) : *
      {
         return param1.readBoolean();
      }
   }
}

