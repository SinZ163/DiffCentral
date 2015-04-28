package inventory_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class s_CourierState_52 extends MovieClip
   {
      
      public function s_CourierState_52()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      public var hasteCooldownNumber:TextField;
      
      public var noCourier:MovieClip;
      
      public var deliverButton:MovieClip;
      
      public var returningSelected:MovieClip;
      
      public var dead:MovieClip;
      
      public var delivering:MovieClip;
      
      public var returningWide:MovieClip;
      
      public var selectButtonWide:MovieClip;
      
      public var hasteCooldownFade:MovieClip;
      
      public var selectButtonWide_down:MovieClip;
      
      public var hasteUnlearned:MovieClip;
      
      public var returningWideSelected:MovieClip;
      
      public var hasteNotReady:MovieClip;
      
      public var hasteReady:MovieClip;
      
      public var returning:MovieClip;
      
      public var selectButton:MovieClip;
      
      public var selectButton_down:MovieClip;
      
      function frame1() : *
      {
         this.delivering.gotoAndStop(1);
         stop();
      }
      
      function frame2() : *
      {
         this.delivering.gotoAndStop(2);
         stop();
      }
   }
}
