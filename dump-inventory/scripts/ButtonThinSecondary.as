package
{
   import scaleform.clik.controls.Button;
   
   public dynamic class ButtonThinSecondary extends Button
   {
      
      public function ButtonThinSecondary()
      {
         super();
         addFrameScript(0,this.frame1,2,this.frame3,7,this.frame8,11,this.frame12,14,this.frame15,19,this.frame20,23,this.frame24,24,this.frame25,33,this.frame34,43,this.frame44);
      }
      
      function frame1() : *
      {
         this.constraintsDisabled = true;
      }
      
      function frame3() : *
      {
         stop();
      }
      
      function frame8() : *
      {
         stop();
      }
      
      function frame12() : *
      {
         stop();
      }
      
      function frame15() : *
      {
         stop();
      }
      
      function frame20() : *
      {
         stop();
      }
      
      function frame24() : *
      {
         stop();
      }
      
      function frame25() : *
      {
      }
      
      function frame34() : *
      {
         stop();
      }
      
      function frame44() : *
      {
         stop();
      }
   }
}
