package ValveLib.Events
{
   import flash.events.Event;
   
   public class InputBoxEvent extends Event
   {
      
      public function InputBoxEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public static const TEXT_SUBMITTED:String = "textSubmitted";
      
      public static const TAB_PRESSED:String = "tabPressed";
      
      override public function clone() : Event
      {
         return new InputBoxEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ButtonEvent","type","bubbles","cancelable");
      }
   }
}
