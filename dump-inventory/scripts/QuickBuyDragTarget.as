package
{
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.interfaces.IDragSlot;
   import flash.display.Sprite;
   import scaleform.clik.events.DragEvent;
   
   public class QuickBuyDragTarget extends UIComponent implements IDragSlot
   {
      
      public function QuickBuyDragTarget()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : §void§
      {
      }
      
      protected var _data:Object;
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function set content(value:Sprite) : §void§
      {
      }
      
      protected var _content:Sprite;
      
      public function handleDropEvent(e:DragEvent) : Boolean
      {
         var data:* = e.dragData;
         if((data) && (data.shopItemName))
         {
            root["onShopItemDraggedToQuickBuy"](this,data.shopItemName);
            return true;
         }
         return false;
      }
      
      public function handleDragStartEvent(e:DragEvent) : §void§
      {
      }
      
      public function handleDragEndEvent(e:DragEvent, wasValidDrop:Boolean) : §void§
      {
      }
   }
}
