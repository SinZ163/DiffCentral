package scaleform.gfx
{
   import flash.events.FocusEvent;
   
   public final class FocusEventEx extends FocusEvent
   {
      
      public function FocusEventEx(type:String)
      {
         super(type);
      }
      
      public var controllerIdx:uint = 0;
   }
}
