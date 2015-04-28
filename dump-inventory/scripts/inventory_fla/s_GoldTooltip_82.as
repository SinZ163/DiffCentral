package inventory_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class s_GoldTooltip_82 extends MovieClip
   {
      
      public function s_GoldTooltip_82()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      public var buybackSurplus:TextField;
      
      public var background:MovieClip;
      
      public var deathCost:TextField;
      
      public var reliableGold:TextField;
      
      public var unreliableGold:TextField;
      
      public var buybackState:TextField;
      
      public var buybackCost:TextField;
      
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
