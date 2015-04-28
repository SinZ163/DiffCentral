package
{
   import scaleform.clik.controls.DragSlot;
   import scaleform.clik.controls.Button;
   import flash.display.MovieClip;
   import ValveLib.Globals;
   import flash.events.MouseEvent;
   import scaleform.clik.events.DragEvent;
   import scaleform.gfx.MouseEventEx;
   
   public dynamic class CombineTreeItem extends DragSlot
   {
      
      public function CombineTreeItem()
      {
         super();
         this._itemData = null;
         this.purchaseLocation = 0;
      }
      
      public static const PURCHASE_LOCATION_SHOP_ROW:int = 1;
      
      public static const PURCHASE_LOCATION_COMBINE_TREE:int = 2;
      
      public static const PURCHASE_LOCATION_SEARCH_RESULTS:int = 3;
      
      public static const PURCHASE_LOCATION_SUGGESTED_ITEMS:int = 4;
      
      public static const PURCHASE_LOCATION_QUICKBUY:int = 5;
      
      public static const PURCHASE_LOCATION_QUICKBUY_STICKSLOT:int = 6;
      
      public function get itemData() : Object
      {
         return this._itemData;
      }
      
      public function set itemData(value:Object) : §void§
      {
         this._itemData = value;
         this.update();
      }
      
      public function get purchaseLocation() : int
      {
         return this._purchaseLocation;
      }
      
      public function set purchaseLocation(value:int) : §void§
      {
         this._purchaseLocation = value;
      }
      
      private var _purchaseLocation:int;
      
      public function get itemName() : String
      {
         return this._itemData.itemName;
      }
      
      public function get itemColor() : Number
      {
         return this._itemData.itemColor;
      }
      
      public function get itemCost() : Number
      {
         return this._itemData.itemCost;
      }
      
      public function get itemSlot() : uint
      {
         return this._itemData.itemSlot;
      }
      
      private var _itemData:Object;
      
      public var button:Button;
      
      public var itemImage:MovieClip;
      
      public var secretShopMC:MovieClip;
      
      public var ownedMC:MovieClip;
      
      public var purchasableMC:MovieClip;
      
      public var almostPurchasableMC:MovieClip;
      
      public var dragImage:MovieClip;
      
      public function get purchasable() : Boolean
      {
         return this._itemData.purchasable;
      }
      
      public function set purchasable(purchasable:Boolean) : §void§
      {
         this._itemData.purchasable = purchasable;
         this.purchasableMC.visible = purchasable;
      }
      
      public function set almostPurchasable(almostPurchasable:Boolean) : §void§
      {
         this._itemData.almostPurchasable = almostPurchasable;
         this.almostPurchasableMC.visible = almostPurchasable;
      }
      
      public function set owned(owned:Boolean) : §void§
      {
         this._itemData.owned = owned;
         this.ownedMC.visible = owned;
      }
      
      private function update() : §void§
      {
         if(!this._itemData)
         {
            return;
         }
         if(this._itemData.itemName == undefined)
         {
            this.itemImage.visible = false;
            return;
         }
         var contentMC:* = new MovieClip();
         contentMC.height = 32;
         contentMC.width = 48;
         contentMC.scaleX = 1;
         contentMC.scaleY = 1;
         this.itemImage.visible = true;
         if(this._itemData.itemName.substring(0,6) == "recipe")
         {
            Globals.instance.LoadItemImage("recipe",this.itemImage);
            Globals.instance.LoadItemImage("recipe",contentMC);
         }
         else
         {
            Globals.instance.LoadItemImage(this._itemData.itemName,this.itemImage);
            Globals.instance.LoadItemImage(this._itemData.itemName,contentMC);
         }
         contentMC.visible = false;
         content = contentMC;
         this.itemImage.mouseEnabled = false;
         this.itemImage.mouseChildren = false;
         this.secretShopMC.visible = this._itemData.secretShop;
         this.ownedMC.visible = this._itemData.owned;
         this.purchasableMC.visible = this._itemData.purchasable;
         this.almostPurchasableMC.visible = this._itemData.almostPurchasable;
      }
      
      override protected function configUI() : §void§
      {
         this.itemImage.mouseEnabled = false;
         this.itemImage.visible = false;
         super.configUI();
         this.mouseDown = false;
         this.update();
      }
      
      override protected function handleMouseMove(e:MouseEvent) : §void§
      {
      }
      
      override protected function handleMouseRollOver(e:MouseEvent) : §void§
      {
         super.handleMouseRollOver(e);
         root["onShowShopItemTooltip"](this);
      }
      
      override protected function handleMouseRollOut(e:MouseEvent) : §void§
      {
         var dragData:Object = null;
         var dragStartEvent:DragEvent = null;
         root["onHideShopItemTooltip"](this);
         super.handleMouseRollOut(e);
         if(this.mouseDown)
         {
            cleanupDragListeners();
            dragData = {"shopItemName":this.itemName};
            content.x = 0;
            content.y = 0;
            dragStartEvent = new DragEvent(DragEvent.DRAG_START,dragData,this,null,content);
            dispatchEvent(new DragEvent(DragEvent.DRAG_START,dragData,this,null,content));
            this.handleDragStartEvent(dragStartEvent);
            this.mouseDown = false;
         }
      }
      
      override public function handleDragStartEvent(e:DragEvent) : §void§
      {
         content.visible = true;
      }
      
      override public function handleDragEndEvent(e:DragEvent, wasValidDrop:Boolean) : §void§
      {
         content.visible = false;
         content.x = 0;
         content.y = 0;
         addChild(content);
      }
      
      var mouseDown:Boolean;
      
      override protected function handleMouseDown(e:MouseEvent) : §void§
      {
         var ex:MouseEventEx = e as MouseEventEx;
         if((ex) && ex.buttonIdx == 0)
         {
            this.mouseDown = true;
         }
         super.handleMouseDown(e);
      }
      
      override protected function handleMouseUp(e:MouseEvent) : §void§
      {
         super.handleMouseUp(e);
         this.mouseDown = false;
         var ex:MouseEventEx = e as MouseEventEx;
         if((ex) && ex.buttonIdx == 1)
         {
            root["onBuyButtonPress"](this.itemName,this.itemSlot,this.purchaseLocation);
            return;
         }
         root["onSetQuickBuy"](this.itemName,this.purchaseLocation);
      }
      
      override public function handleDropEvent(e:DragEvent) : Boolean
      {
         return false;
      }
   }
}
