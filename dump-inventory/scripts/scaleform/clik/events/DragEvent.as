package scaleform.clik.events
{
   import flash.events.Event;
   import scaleform.clik.interfaces.IDragSlot;
   import flash.display.Sprite;
   
   public class DragEvent extends Event
   {
      
      public function DragEvent(type:String, data:Object, drag:IDragSlot, drop:IDragSlot, sprite:Sprite, bubbles:Boolean = true, cancelable:Boolean = true)
      {
         this.dragData = data;
         this.dragTarget = drag;
         this.dropTarget = drop;
         this.dragSprite = sprite;
         super(type,bubbles,cancelable);
      }
      
      public static const DROP:String = "drop";
      
      public static const DRAG_START:String = "dragStart";
      
      public static const DRAG_END:String = "dragEnd";
      
      public var dragData:Object;
      
      public var dragTarget:IDragSlot;
      
      public var dropTarget:IDragSlot;
      
      public var dragSprite:Sprite;
   }
}
