package
{
   import scaleform.clik.controls.DragSlot;
   import scaleform.clik.controls.Button;
   import flash.display.MovieClip;
   import ValveLib.Globals;
   import flash.events.MouseEvent;
   import scaleform.clik.events.DragEvent;
   import scaleform.gfx.MouseEventEx;
   
   public dynamic class ItemBuildItem extends DragSlot
   {
      
      public function ItemBuildItem()
      {
         super();
         this._itemData = null;
      }
      
      public static const PURCHASE_LOCATION_SUGGESTED_ITEMS:int = 4;
      
      public function get itemData() : Object
      {
         return this._itemData;
      }
      
      public function set itemData(param1:Object) : §void§
      {
         this._itemData = param1;
         this.update();
      }
      
      public function get purchaseLocation() : int
      {
         return PURCHASE_LOCATION_SUGGESTED_ITEMS;
      }
      
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
      
      public function get itemSlot() : int
      {
         return this._itemData.itemSlot;
      }
      
      private var _itemData:Object;
      
      public var button:Button;
      
      public var itemImage:MovieClip;
      
      public var secretShopMC:MovieClip;
      
      public var ownedMC:MovieClip;
      
      public var purchasableMC:MovieClip;
      
      public var dragImage:MovieClip;
      
      public function get purchasable() : Boolean
      {
         return this._itemData.purchasable;
      }
      
      public function set purchasable(param1:Boolean) : §void§
      {
         this._itemData.purchasable = param1;
         this.purchasableMC.visible = param1;
      }
      
      public function set owned(param1:Boolean) : §void§
      {
         this._itemData.owned = param1;
         this.ownedMC.visible = param1;
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
         var _loc1_:* = new MovieClip();
         _loc1_.height = 32;
         _loc1_.width = 48;
         _loc1_.scaleX = 1;
         _loc1_.scaleY = 1;
         this.itemImage.visible = true;
         if(this._itemData.itemName.substring(0,6) == "recipe")
         {
            Globals.instance.LoadItemImage("recipe",this.itemImage);
            Globals.instance.LoadItemImage("recipe",_loc1_);
         }
         else
         {
            Globals.instance.LoadItemImage(this._itemData.itemName,this.itemImage);
            Globals.instance.LoadItemImage(this._itemData.itemName,_loc1_);
         }
         _loc1_.visible = false;
         content = _loc1_;
         this.itemImage.mouseEnabled = false;
         this.itemImage.mouseChildren = false;
         this.secretShopMC.visible = this._itemData.secretShop;
         this.ownedMC.visible = this._itemData.owned;
         this.purchasableMC.visible = this._itemData.purchasable;
      }
      
      override protected function configUI() : §void§
      {
         this.itemImage.mouseEnabled = false;
         this.itemImage.visible = false;
         super.configUI();
         this.mouseDown = false;
         addEventListener(MouseEvent.CLICK,this.baseButtonPress);
         this.update();
      }
      
      override protected function handleMouseMove(param1:MouseEvent) : §void§
      {
      }
      
      override protected function handleMouseRollOver(param1:MouseEvent) : §void§
      {
         super.handleMouseRollOver(param1);
         root["onShowShopItemTooltip"](this);
      }
      
      override protected function handleMouseRollOut(param1:MouseEvent) : §void§
      {
         var _loc2_:Object = null;
         var _loc3_:DragEvent = null;
         root["onHideShopItemTooltip"](this);
         super.handleMouseRollOut(param1);
         if(this.mouseDown)
         {
            cleanupDragListeners();
            _loc2_ = {"shopItemName":this.itemName};
            content.x = 0;
            content.y = 0;
            _loc3_ = new DragEvent(DragEvent.DRAG_START,_loc2_,this,null,content);
            dispatchEvent(new DragEvent(DragEvent.DRAG_START,_loc2_,this,null,content));
            this.handleDragStartEvent(_loc3_);
            this.mouseDown = false;
         }
      }
      
      private function baseButtonPress(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == 1)
         {
            root["onBuyButtonPress"](this.itemName,this.itemSlot,this.purchaseLocation);
            return;
         }
         root["onSetQuickBuy"](this.itemName,1);
      }
      
      override public function handleDragStartEvent(param1:DragEvent) : §void§
      {
         content.visible = true;
         root["onSuggestedItemDragStart"](this,this.itemSlot);
      }
      
      override public function handleDragEndEvent(param1:DragEvent, param2:Boolean) : §void§
      {
         content.visible = false;
         content.x = 0;
         content.y = 0;
         addChild(content);
      }
      
      var mouseDown:Boolean;
      
      override protected function handleMouseDown(param1:MouseEvent) : §void§
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if((_loc2_) && _loc2_.buttonIdx == 0)
         {
            this.mouseDown = true;
         }
         super.handleMouseDown(param1);
      }
      
      override protected function handleMouseUp(param1:MouseEvent) : §void§
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if((_loc2_) && _loc2_.buttonIdx == 0)
         {
            this.mouseDown = false;
         }
         super.handleMouseUp(param1);
      }
      
      override public function handleDropEvent(param1:DragEvent) : Boolean
      {
         return false;
      }
      
      override protected function draw() : §void§
      {
         _newFrame = null;
         super.draw();
      }
   }
}
