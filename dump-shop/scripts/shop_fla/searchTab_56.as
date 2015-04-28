package shop_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class searchTab_56 extends MovieClip
   {
      
      public function searchTab_56()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public var category_name:TextField;
      
      public var searchQueryLabel:TextField;
      
      function frame1() : *
      {
         visible = false;
         stop();
      }
   }
}
