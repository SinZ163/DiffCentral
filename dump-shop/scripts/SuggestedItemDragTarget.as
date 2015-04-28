package
{
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.interfaces.IDragSlot;
   import flash.display.Sprite;
   import scaleform.clik.events.DragEvent;
   
   public class SuggestedItemDragTarget extends UIComponent implements IDragSlot
   {
      
      public function SuggestedItemDragTarget()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : §void§
      {
      }
      
      protected var _data:Object;
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function set content(param1:Sprite) : §void§
      {
      }
      
      protected var _content:Sprite;
      
      public function handleDropEvent(param1:DragEvent) : Boolean
      {
         var _loc2_:* = param1.dragData;
         if(_loc2_)
         {
            root["onShopItemDraggedToSuggestedItems"](this,_loc2_.shopItemName);
            return true;
         }
         return false;
      }
      
      public function handleDragStartEvent(param1:DragEvent) : §void§
      {
      }
      
      public function handleDragEndEvent(param1:DragEvent, param2:Boolean) : §void§
      {
      }
   }
}
