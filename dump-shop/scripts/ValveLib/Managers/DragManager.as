package ValveLib.Managers
{
   import flash.display.Stage;
   import flash.display.Sprite;
   import scaleform.clik.interfaces.IDragSlot;
   import scaleform.clik.events.DragEvent;
   import flash.geom.Point;
   import flash.events.MouseEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.display.DisplayObject;
   
   public class DragManager extends Object
   {
      
      public function DragManager()
      {
         super();
      }
      
      protected static var _stage:Stage;
      
      protected static var _dragCanvas:Sprite;
      
      protected static var _initialized:Boolean = false;
      
      protected static var _inDrag:Boolean = false;
      
      protected static var _dragData:Object;
      
      protected static var _dragTarget:Sprite;
      
      protected static var _origDragSlot:IDragSlot;
      
      protected static var _dragOffsetX:int;
      
      protected static var _dragOffsetY:int;
      
      public static function init(stage:Stage) : §void§
      {
         if(_initialized)
         {
            return;
         }
         _initialized = true;
         DragManager._stage = stage;
         _dragCanvas = new Sprite();
         _dragCanvas.mouseEnabled = _dragCanvas.mouseChildren = false;
         _stage.addChild(_dragCanvas);
         _stage.addEventListener(DragEvent.DRAG_START,DragManager.handleStartDragEvent,false,0,true);
      }
      
      public static function inDrag() : Boolean
      {
         return _inDrag;
      }
      
      public static function setDragOffset(x:int, y:int) : §void§
      {
         _dragOffsetX = x;
         _dragOffsetY = y;
      }
      
      public static function handleStartDragEvent(e:DragEvent) : §void§
      {
         var i:* = 0;
         if(e.dragTarget == null || e.dragSprite == null)
         {
            return;
         }
         if(_dragTarget != null)
         {
            trace("\t** hiding stuck icon");
            if(_dragCanvas.contains(_dragTarget))
            {
               trace("\t\t** removing");
               _dragCanvas.removeChild(_dragTarget);
            }
            _dragTarget.visible = false;
            _dragTarget = null;
         }
         i = _dragCanvas.numChildren - 1;
         while(i >= 0)
         {
            trace("\t** removing an extra icon from the drag canvas");
            _dragCanvas.removeChildAt(i);
            i--;
         }
         _dragTarget = e.dragSprite;
         _dragTarget.visible = true;
         _dragData = e.dragData;
         _origDragSlot = e.dragTarget;
         var origin:Point = new Point(_dragTarget.x,_dragTarget.y);
         var dest:Point = _dragTarget.localToGlobal(origin);
         _dragCanvas.addChild(_dragTarget);
         _dragTarget.x = _dragCanvas.mouseX + _dragOffsetX;
         _dragTarget.y = _dragCanvas.mouseY + _dragOffsetY;
         _dragOffsetX = _dragOffsetY = 0;
         _inDrag = true;
         _stage.addEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false,0,true);
         var dragMC:MovieClip = _dragTarget as MovieClip;
         dragMC.startDrag();
         dragMC.mouseEnabled = dragMC.mouseChildren = false;
         dragMC.trackAsMenu = true;
      }
      
      public static function handleEndDragEvent(e:MouseEvent) : §void§
      {
         var dropEvent:DragEvent = null;
         _stage.removeEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false);
         _inDrag = false;
         var isValidDrop:* = false;
         var dropTarget:IDragSlot = findSpriteAncestorOf(_dragTarget.dropTarget) as IDragSlot;
         if(!(dropTarget == null) && dropTarget is IDragSlot)
         {
            dropEvent = new DragEvent(DragEvent.DROP,_dragData,_origDragSlot,dropTarget,_dragTarget);
            isValidDrop = dropTarget.handleDropEvent(dropEvent);
         }
         _dragTarget.stopDrag();
         _dragTarget.mouseEnabled = _dragTarget.mouseChildren = true;
         (_dragTarget as MovieClip).trackAsMenu = false;
         _dragCanvas.removeChild(_dragTarget);
         var dragEndEvent:DragEvent = new DragEvent(DragEvent.DRAG_END,_dragData,_origDragSlot,dropTarget,_dragTarget);
         _origDragSlot.handleDragEndEvent(dragEndEvent,isValidDrop);
         _origDragSlot.dispatchEvent(dragEndEvent);
         _dragTarget.visible = false;
         _dragTarget = null;
         _origDragSlot = null;
      }
      
      protected static function handleStageAddedEvent(e:Event) : §void§
      {
      }
      
      protected static function findSpriteAncestorOf(obj:DisplayObject) : IDragSlot
      {
         while((obj) && !(obj is IDragSlot))
         {
            var obj:DisplayObject = obj.parent;
         }
         return obj as IDragSlot;
      }
   }
}
