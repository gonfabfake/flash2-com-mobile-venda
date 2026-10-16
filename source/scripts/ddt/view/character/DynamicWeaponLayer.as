package ddt.view.character
{
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DynamicWeaponLayer extends Sprite implements ILayer
   {
      
      protected var _weapon:MovieClip;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _colors:Array;
      
      protected var _hairType:String;
      
      protected var _currentEdit:uint;
      
      private var _callBack:Function;
      
      protected var _color:String;
      
      protected var _defaultLayer:uint;
      
      protected var _gunBack:Boolean;
      
      protected var _pic:String;
      
      protected var _loader:ModuleLoader;
      
      private var _isComplete:Boolean;
      
      public function DynamicWeaponLayer(param1:ItemTemplateInfo, param2:String = "", param3:Boolean = false, param4:int = 1, param5:String = null)
      {
         this._info = param1;
         this._color = param2 == null ? "" : param2;
         this._gunBack = param3;
         this._hairType = param4 == 1 ? "B" : "A";
         this._pic = param5 == null || String(param5) == "undefined" ? this._info.Pic : param5;
         super();
      }
      
      protected function initLoader() : void
      {
         if(!ClassUtils.uiSourceDomain.hasDefinition("game_weapon_" + this.info.TemplateID))
         {
            this._loader = LoadResourceManager.Instance.createLoader(this.getUrl(),4);
            this._loader.addEventListener("complete",this.__sourceComplete);
            LoadResourceManager.Instance.startLoad(this._loader);
         }
         else
         {
            this.__sourceComplete();
         }
      }
      
      protected function __sourceComplete(param1:LoaderEvent = null) : void
      {
         var _loc2_:* = null;
         if(this.info == null)
         {
            return;
         }
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener("complete",this.__sourceComplete);
         }
         if(param1 != null && !param1.loader.isSuccess)
         {
            this._weapon = null;
         }
         else
         {
            _loc2_ = ClassUtils.uiSourceDomain.getDefinition("game_weapon_" + this.info.TemplateID) as Class;
            this._weapon = new _loc2_();
         }
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
      }
      
      public function setColor(param1:*) : Boolean
      {
         return false;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._info = param1;
      }
      
      public function getContent() : DisplayObject
      {
         return this._weapon;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener("complete",this.__sourceComplete);
            this._loader = null;
         }
         this._weapon = null;
         this._callBack = null;
         this._info = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function load(param1:Function) : void
      {
         this._callBack = param1;
         this.initLoader();
      }
      
      private function loadLayerComplete() : void
      {
      }
      
      public function set currentEdit(param1:int) : void
      {
      }
      
      public function get currentEdit() : int
      {
         return 0;
      }
      
      override public function get width() : Number
      {
         return 0;
      }
      
      override public function get height() : Number
      {
         return 0;
      }
      
      protected function getUrl() : String
      {
         return PathManager.SITE_MAIN + "image/arm/" + this._pic + "/1/1/" + "game" + ".swf";
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}

