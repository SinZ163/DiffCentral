package scaleform.clik.events
{
   import flash.events.Event;
   
   public class ResizeEvent extends Event
   {
      
      public function ResizeEvent(type:String, scaleX:Number, scaleY:Number)
      {
         super(type,false,false);
         this.scaleX = scaleX;
         this.scaleY = scaleY;
      }
      
      public static const RESIZE:String = "resize";
      
      public static const SCOPE_ORIGINALS_UPDATE:String = "scopeOriginalsUpdate";
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      override public function toString() : String
      {
         return formatToString("ResizeEvent","type","scaleX","scaleY");
      }
      
      override public function clone() : Event
      {
         return new ResizeEvent(type,this.scaleX,this.scaleY);
      }
   }
}
