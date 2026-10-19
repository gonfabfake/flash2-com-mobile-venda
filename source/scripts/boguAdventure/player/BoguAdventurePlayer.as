package boguAdventure.player
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import ddt.manager.PathManager;
   import ddt.view.sceneCharacter.SceneCharacterActionItem;
   import ddt.view.sceneCharacter.SceneCharacterActionSet;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterItem;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.sceneCharacter.SceneCharacterSet;
   import ddt.view.sceneCharacter.SceneCharacterStateItem;
   import ddt.view.sceneCharacter.SceneCharacterStateSet;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BoguAdventurePlayer extends SceneCharacterPlayerBase
   {
      
      public static const STOP:String = "bogustop";
      
      public static const WALK:String = "boguwalk";
      
      public static const WEEP:String = "boguweep";
      
      public static const LAUGH:String = "bogulaugh";
      
      private var _playerStateSet:SceneCharacterStateSet;
      
      private var _playerSetNatural:SceneCharacterSet;
      
      private var _playerActionSetNatural:SceneCharacterActionSet;
      
      public var playerWitdh:Number = 114;
      
      public var playerHeight:Number = 95;
      
      private var _callBack:Function;
      
      private var _dir:SceneCharacterDirection = SceneCharacterDirection.RB;
      
      private var _focusArr:Array;
      
      private var _focus:Point;
      
      public function BoguAdventurePlayer(param1:Function = null)
      {
         super(param1);
         this._callBack = param1;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._playerStateSet = new SceneCharacterStateSet();
         this._playerSetNatural = new SceneCharacterSet();
         this._playerActionSetNatural = new SceneCharacterActionSet();
         this.sceneCharacterStateNatural();
         this._focusArr = [new Point(68,82),new Point(-73,82)];
         this._focus = this._focusArr[0];
      }
      
      private function sceneCharacterStateNatural() : void
      {
         var _loc1_:BitmapLoader = LoaderManager.Instance.creatLoader(PathManager.solveBoguAdventurePath(),BaseLoader.BITMAP_LOADER);
         _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__onLoaderPlayerStateImageComplete);
         LoaderManager.Instance.startLoad(_loc1_);
      }
      
      private function __onLoaderPlayerStateImageComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BitmapData = null;
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoaderPlayerStateImageComplete);
         var _loc3_:BitmapData = (param1.loader as BitmapLoader).bitmapData;
         if(!_loc3_)
         {
            if(this._callBack != null)
            {
               this._callBack(this,false);
            }
            return;
         }
         var _loc4_:Rectangle = new Rectangle(0,0,_loc3_.width,_loc3_.height);
         _loc2_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
         _loc2_.copyPixels(_loc3_,_loc4_,new Point(0,0));
         this._playerSetNatural.push(new SceneCharacterItem("NaturalBody","NaturalAction",_loc2_,3,11,this.playerWitdh,this.playerHeight,3));
         var _loc5_:SceneCharacterActionItem = new SceneCharacterActionItem(STOP,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,7,7,8,8,9,9,9,9,8,8,7,7,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,10,10,10,10,0,0,0,0],true);
         this._playerActionSetNatural.push(_loc5_);
         var _loc6_:SceneCharacterActionItem = new SceneCharacterActionItem(WALK,[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6],true);
         this._playerActionSetNatural.push(_loc6_);
         var _loc7_:SceneCharacterActionItem = new SceneCharacterActionItem(WEEP,[14,14,14,15,15,15,16,16,16],true);
         this._playerActionSetNatural.push(_loc7_);
         var _loc8_:SceneCharacterActionItem = new SceneCharacterActionItem(LAUGH,[11,11,12,12,13,13],true);
         this._playerActionSetNatural.push(_loc8_);
         var _loc9_:SceneCharacterStateItem = new SceneCharacterStateItem("natural",this._playerSetNatural,this._playerActionSetNatural);
         this._playerStateSet.push(_loc9_);
         super.sceneCharacterStateSet = this._playerStateSet;
      }
      
      public function set dir(param1:SceneCharacterDirection) : void
      {
         if(param1 == null || this._dir == param1)
         {
            return;
         }
         this._dir = param1;
         if(this._dir == SceneCharacterDirection.LB)
         {
            if(this.scaleX == -1)
            {
               return;
            }
            this.scaleX = -1;
            this.x += this.width;
            this._focus = this._focusArr[1];
         }
         else
         {
            if(this.scaleX == 1)
            {
               return;
            }
            this.scaleX = 1;
            this.x -= this.width;
            this._focus = this._focusArr[0];
         }
      }
      
      public function get dir() : SceneCharacterDirection
      {
         return this._dir;
      }
      
      public function get focusPos() : Point
      {
         return this._focus;
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._playerSetNatural))
         {
            this._playerSetNatural.dispose();
         }
         this._playerSetNatural = null;
         if(Boolean(this._playerActionSetNatural))
         {
            this._playerActionSetNatural.dispose();
         }
         this._playerActionSetNatural = null;
         if(Boolean(this._playerStateSet))
         {
            this._playerStateSet.dispose();
         }
         this._playerStateSet = null;
         this._dir = null;
         this._focusArr = null;
         this._focus = null;
         super.dispose();
      }
   }
}

