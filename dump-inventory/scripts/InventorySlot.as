package
{
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.interfaces.IDragSlot;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import ValveLib.Globals;
   import scaleform.clik.events.DragEvent;
   
   public dynamic class InventorySlot extends UIComponent implements IDragSlot
   {
      
      public function InventorySlot()
      {
         addFrameScript(0,this.frame1);
         super();
         this._content = new MovieClip();
         this._content.height = 32;
         this._content.width = 48;
         this._content.scaleX = 1;
         this._content.scaleY = 1;
      }
      
      public function get itemSlot() : int
      {
         return this._itemSlot;
      }
      
      public function set itemSlot(value:int) : §void§
      {
         this._itemSlot = value;
      }
      
      private var _itemSlot:int;
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function set itemName(value:String) : §void§
      {
         this._itemName = value;
      }
      
      private var _itemName:String;
      
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
         return this._content as Sprite;
      }
      
      public function set content(value:Sprite) : §void§
      {
      }
      
      protected var _content:MovieClip;
      
      public function get stash() : Boolean
      {
         return this._stash;
      }
      
      public function set stash(value:Boolean) : §void§
      {
         this._stash = value;
      }
      
      private var _stash:Boolean;
      
      public function dragStart() : §void§
      {
         Globals.instance.LoadItemImage(this.itemName,this._content);
         this._data = {
            "type":"inventoryItem",
            "itemSlot":this.itemSlot,
            "itemName":this.itemName
         };
         dispatchEvent(new DragEvent(DragEvent.DRAG_START,this._data,this,null,this._content));
      }
      
      public function handleDropEvent(e:DragEvent) : Boolean
      {
         return true;
      }
      
      public function handleDragStartEvent(e:DragEvent) : §void§
      {
         this.content.visible = true;
      }
      
      public function handleDragEndEvent(e:DragEvent, wasValidDrop:Boolean) : §void§
      {
         root["OnInventoryItemDraggedToSlot"](e);
         this.content = null;
      }
      
      override public function toString() : String
      {
         return "[InventorySlot " + name + "]";
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
