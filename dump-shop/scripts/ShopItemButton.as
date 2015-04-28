package
{
   import scaleform.clik.controls.DragSlot;
   import scaleform.clik.controls.Button;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import ValveLib.Globals;
   import flash.events.MouseEvent;
   import scaleform.gfx.MouseEventEx;
   import scaleform.clik.events.DragEvent;
   import flash.filters.ColorMatrixFilter;
   
   public dynamic class ShopItemButton extends DragSlot
   {
      
      public function ShopItemButton()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      public static const PURCHASE_ALLOWED:int = 0;
      
      public static const PURCHASE_UPGRADE:int = 1 << 0;
      
      public static const PURCHASE_DENY_REASON_GOLD:int = 1 << 2;
      
      public static const PURCHASE_DENY_REASON_SIDE_SHOP:int = 1 << 3;
      
      public static const PURCHASE_DENY_REASON_SECRET_SHOP:int = 1 << 4;
      
      public static const PURCHASE_DENY_OUT_OF_STOCK:int = 1 << 5;
      
      public function get itemData() : Object
      {
         return this._itemData;
      }
      
      public function set itemData(value:Object) : §void§
      {
         this._itemData = value;
         this.update();
      }
      
      public function get itemName() : String
      {
         return this._itemData.itemName;
      }
      
      public function get itemImageName() : String
      {
         return this._itemData.itemImageName;
      }
      
      public function get itemColor() : Number
      {
         return this._itemData.itemColor;
      }
      
      private var _itemData:Object;
      
      public var button:Button;
      
      public var itemImage:MovieClip;
      
      public var itemNameLabel:TextField;
      
      public var itemCostLabel:TextField;
      
      public var itemCostCantAfford:TextField;
      
      public var rowHighlight:MovieClip;
      
      public var itemErrorLabel:TextField;
      
      public var itemStockLabel:TextField;
      
      public var itemDisabled:Boolean;
      
      public var purchaseOrigin:int;
      
      private function update() : §void§
      {
         if(this._itemData.itemImageName == undefined)
         {
            this.itemImage.visible = false;
            content = null;
            return;
         }
         this.itemImage.visible = true;
         Globals.instance.LoadItemImage(this._itemData.itemImageName,this.itemImage);
         this.itemDisabled = false;
         var contentMC:* = new MovieClip();
         contentMC.height = 32;
         contentMC.width = 48;
         contentMC.scaleX = 1;
         contentMC.scaleY = 1;
         Globals.instance.LoadItemImage(this._itemData.itemImageName,contentMC);
         contentMC.visible = false;
         content = contentMC;
         if(this.itemNameLabel)
         {
            this.itemNameLabel.textColor = this._itemData.itemColor;
         }
      }
      
      override protected function configUI() : §void§
      {
         if(this.itemNameLabel)
         {
            this.itemNameLabel.mouseEnabled = false;
         }
         this.itemCostLabel.mouseEnabled = false;
         this.itemCostCantAfford.mouseEnabled = false;
         this.itemImage.mouseChildren = false;
         this.itemImage.mouseEnabled = false;
         this.itemErrorLabel.mouseEnabled = false;
         this.itemStockLabel.mouseEnabled = false;
         this.itemErrorLabel.visible = false;
         this.itemStockLabel.visible = false;
         super.configUI();
         this.button.addEventListener(MouseEvent.CLICK,this.baseButtonPress);
         this.rowHighlight.visible = false;
         this.rowHighlight.mouseEnabled = false;
         this.mouseDown = false;
      }
      
      private function baseButtonPress(event:MouseEventEx) : *
      {
         if(event.buttonIdx == 1)
         {
            root["onBuyButtonPressShopItem"](this.itemName);
            return;
         }
         root["onSetQuickBuy"](this.itemName,1);
      }
      
      override protected function handleMouseRollOver(event:MouseEvent) : §void§
      {
         super.handleMouseRollOver(event);
         root["onShowShopItemTooltip"](this);
         this.rowHighlight.visible = true;
      }
      
      var mouseDown:Boolean;
      
      override protected function handleMouseRollOut(event:MouseEvent) : §void§
      {
         var dragData:Object = null;
         var dragStartEvent:DragEvent = null;
         root["onHideShopItemTooltip"](this);
         super.handleMouseRollOut(event);
         this.rowHighlight.visible = false;
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
         if(currentFrame == 2)
         {
            gotoAndStop(1);
            this.setDisabled(this.itemDisabled);
            this.itemErrorLabel.visible = false;
            this.itemStockLabel.visible = false;
         }
      }
      
      override protected function handleMouseMove(e:MouseEvent) : §void§
      {
      }
      
      override public function handleDropEvent(e:DragEvent) : Boolean
      {
         return false;
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
         var ex:MouseEventEx = e as MouseEventEx;
         if((ex) && ex.buttonIdx == 0)
         {
            this.mouseDown = false;
         }
         super.handleMouseUp(e);
      }
      
      public function setDisabled(bDisabled:Boolean) : §void§
      {
         var saturation:ColorMatrixFilter = null;
         if(bDisabled)
         {
            saturation = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.0,0.0,0.0,1,0]);
            this.itemImage.filters = [saturation];
            this.itemNameLabel.textColor = 7829367;
         }
         else
         {
            this.itemImage.filters = [];
            this.itemNameLabel.textColor = 16777215;
         }
         this.itemDisabled = bDisabled;
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
