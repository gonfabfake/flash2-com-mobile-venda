package treasurePuzzle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TreasurePuzzleHelpContentItem extends Sprite
   {
      
      private var bg:Bitmap;
      
      private var titleText:FilterFrameText;
      
      private var contentText:FilterFrameText;
      
      public function TreasurePuzzleHelpContentItem(param1:int, param2:String, param3:String)
      {
         super();
         if(param1 == 0)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.redTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.redTitle");
         }
         else if(param1 == 1)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.blueTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.blueTitle");
         }
         else if(param1 == 2)
         {
            this.bg = ComponentFactory.Instance.creat("treasurePuzzle.yellowTitleBg");
            this.titleText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.yellowTitle");
         }
         this.contentText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.rewardContentText");
         this.titleText.text = param2;
         this.contentText.text = param3;
         addChild(this.bg);
         addChild(this.titleText);
         addChild(this.contentText);
      }
   }
}

