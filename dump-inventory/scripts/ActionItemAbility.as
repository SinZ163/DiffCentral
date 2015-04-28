package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class ActionItemAbility extends MovieClip
   {
      
      public function ActionItemAbility()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public var activeType:MovieClip;
      
      public var quantity:TextField;
      
      public var AbilityArt:MovieClip;
      
      public var overState:MovieClip;
      
      function frame1() : *
      {
         stop;
      }
   }
}
