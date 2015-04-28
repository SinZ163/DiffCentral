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
      
      public function set itemData(param1:Object) : §void§
      {
         this._itemData = param1;
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
         var _loc1_:* = new MovieClip();
         _loc1_.height = 32;
         _loc1_.width = 48;
         _loc1_.scaleX = 1;
         _loc1_.scaleY = 1;
         Globals.instance.LoadItemImage(this._itemData.itemImageName,_loc1_);
         _loc1_.visible = false;
         content = _loc1_;
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
      
      private function baseButtonPress(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx == 1)
         {
            root["onBuyButtonPressShopItem"](this.itemName);
            return;
         }
         root["onSetQuickBuy"](this.itemName,1);
      }
      
      override protected function handleMouseRollOver(param1:MouseEvent) : §void§
      {
         super.handleMouseRollOver(param1);
         root["onShowShopItemTooltip"](this);
         this.rowHighlight.visible = true;
      }
      
      var mouseDown:Boolean;
      
      override protected function handleMouseRollOut(param1:MouseEvent) : §void§
      {
         var _loc2_:Object = null;
         var _loc3_:DragEvent = null;
         root["onHideShopItemTooltip"](this);
         super.handleMouseRollOut(param1);
         this.rowHighlight.visible = false;
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
         if(currentFrame == 2)
         {
            gotoAndStop(1);
            this.setDisabled(this.itemDisabled);
            this.itemErrorLabel.visible = false;
            this.itemStockLabel.visible = false;
         }
      }
      
      override protected function handleMouseMove(param1:MouseEvent) : §void§
      {
      }
      
      override public function handleDropEvent(param1:DragEvent) : Boolean
      {
         return false;
      }
      
      override public function handleDragStartEvent(param1:DragEvent) : §void§
      {
         content.visible = true;
      }
      
      override public function handleDragEndEvent(param1:DragEvent, param2:Boolean) : §void§
      {
         content.visible = false;
         content.x = 0;
         content.y = 0;
         addChild(content);
      }
      
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
      
      public function setDisabled(param1:Boolean) : §void§
      {
         var _loc2_:ColorMatrixFilter = null;
         if(param1)
         {
            _loc2_ = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.0,0.0,0.0,1,0]);
            this.itemImage.filters = [_loc2_];
            this.itemNameLabel.textColor = 7829367;
         }
         else
         {
            this.itemImage.filters = [];
            this.itemNameLabel.textColor = 16777215;
         }
         this.itemDisabled = param1;
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
