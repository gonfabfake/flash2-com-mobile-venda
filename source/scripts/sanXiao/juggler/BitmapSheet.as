package sanXiao.juggler
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class BitmapSheet
   {
      
      private var _mTextureRegions:Dictionary;
      
      private var _mTextureFrames:Dictionary;
      
      private var _bmpDataList:Dictionary;
      
      private var _bmpData:BitmapData;
      
      private var _xml:XML;
      
      protected var _bdRegionsList:Vector.<Rectangle>;
      
      public function BitmapSheet(param1:BitmapData, param2:XML)
      {
         super();
         this._bmpData = param1;
         this._xml = param2;
         this._mTextureRegions = new Dictionary();
         this._mTextureFrames = new Dictionary();
         this._bmpDataList = new Dictionary();
         if(Boolean(this._xml))
         {
            this.parseAtlasXml(this._xml);
         }
      }
      
      private function parseAtlasXml(param1:XML) : void
      {
         var _loc13_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:* = null;
         var _loc12_:* = null;
         for each(_loc13_ in param1.SubTexture)
         {
            _loc2_ = _loc13_.attribute("name");
            _loc3_ = parseFloat(_loc13_.attribute("x"));
            _loc4_ = parseFloat(_loc13_.attribute("y"));
            _loc5_ = parseFloat(_loc13_.attribute("width"));
            _loc6_ = parseFloat(_loc13_.attribute("height"));
            _loc7_ = parseFloat(_loc13_.attribute("frameX"));
            _loc8_ = parseFloat(_loc13_.attribute("frameY"));
            _loc9_ = parseFloat(_loc13_.attribute("frameWidth"));
            _loc10_ = parseFloat(_loc13_.attribute("frameHeight"));
            _loc11_ = new Rectangle(_loc3_,_loc4_,_loc5_,_loc6_);
            _loc12_ = _loc9_ > 0 && _loc10_ > 0 ? new Rectangle(_loc7_,_loc8_,_loc9_,_loc10_) : null;
            this.addRegion(_loc2_,_loc11_,_loc12_);
         }
      }
      
      private function addRegion(param1:String, param2:Rectangle, param3:Rectangle = null) : void
      {
         this._mTextureRegions[param1] = param2;
         if(Boolean(param3))
         {
            this._mTextureFrames[param1] = param3;
         }
      }
      
      public function getRegion(param1:String) : Rectangle
      {
         return this._mTextureRegions[param1];
      }
      
      public function getRegionList(param1:String) : Vector.<Rectangle>
      {
         var _loc2_:* = null;
         var _loc3_:Vector.<Rectangle> = new Vector.<Rectangle>(0);
         var _loc4_:Vector.<String> = new Vector.<String>(0);
         for(_loc2_ in this._mTextureRegions)
         {
            if(_loc2_.indexOf(param1) == 0)
            {
               _loc4_.push(_loc2_);
            }
         }
         _loc4_.sort(1);
         for each(_loc2_ in _loc4_)
         {
            _loc3_.push(this._mTextureRegions[_loc2_]);
         }
         return _loc3_;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bmpData;
      }
      
      public function getBitmapData(param1:String) : BitmapData
      {
         var _loc4_:BitmapData = null;
         var _loc2_:* = null;
         var _loc3_:Rectangle = this._mTextureRegions[param1];
         _loc4_ = this._bmpDataList[param1];
         if(!_loc4_)
         {
            _loc4_ = new BitmapData(_loc3_.width,_loc3_.height);
            _loc4_.copyPixels(this._bmpData,_loc3_,new Point(0,0));
            this._bmpDataList[param1] = _loc4_;
         }
         return _loc4_;
      }
   }
}

