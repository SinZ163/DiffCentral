package scaleform.gfx
{
   import flash.events.KeyboardEvent;
   
   public final class KeyboardEventEx extends KeyboardEvent
   {
      
      public function KeyboardEventEx(type:String)
      {
         super(type);
      }
      
      public var controllerIdx:uint = 0;
   }
}
