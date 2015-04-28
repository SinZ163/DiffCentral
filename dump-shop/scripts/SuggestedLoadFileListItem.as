package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class SuggestedLoadFileListItem extends MovieClip
   {
      
      public function SuggestedLoadFileListItem()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
      }
      
      public var deleteButton:MovieClip;
      
      public var loadButton:MovieClip;
      
      public var fileNameText:TextField;
      
      function frame1() : *
      {
         this.deleteButton.visible = false;
         this.loadButton.visible = false;
         stop();
      }
      
      function frame2() : *
      {
         this.deleteButton.visible = false;
         this.loadButton.visible = true;
         stop();
      }
      
      function frame3() : *
      {
         this.deleteButton.visible = true;
         this.loadButton.visible = true;
         stop();
      }
   }
}
