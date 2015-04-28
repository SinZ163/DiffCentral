package inventory_fla
{
   import flash.display.MovieClip;
   
   public dynamic class s_GlyphButton_48 extends MovieClip
   {
      
      public function s_GlyphButton_48()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      public var cooldown:MovieClip;
      
      public var active:MovieClip;
      
      public var inactive:MovieClip;
      
      public var ready:MovieClip;
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
