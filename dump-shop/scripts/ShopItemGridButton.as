package
{
   import scaleform.clik.controls.DragSlot;
   import scaleform.clik.controls.Button;
   import flash.display.MovieClip;
   import ValveLib.Globals;
   import flash.events.MouseEvent;
   import scaleform.gfx.MouseEventEx;
   import scaleform.clik.events.DragEvent;
   
   public dynamic class ShopItemGridButton extends DragSlot
   {
      
      public function ShopItemGridButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
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
      
      public var purchasableMC:MovieClip;
      
      public var cooldownMC:s_GridItemCooldown;
      
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
         var contentMC:* = new MovieClip();
         contentMC.height = 32;
         contentMC.width = 48;
         contentMC.scaleX = 1;
         contentMC.scaleY = 1;
         Globals.instance.LoadItemImage(this._itemData.itemImageName,contentMC);
         if(this.cooldownMC == null && (this._itemData.needsCooldown))
         {
            this.cooldownMC = new s_GridItemCooldown();
            this.addChild(this.cooldownMC);
            this.cooldownMC.mouseEnabled = false;
            this.cooldownMC.mouseChildren = false;
         }
         contentMC.visible = false;
         content = contentMC;
      }
      
      override protected function configUI() : §void§
      {
         this.itemImage.mouseChildren = false;
         this.itemImage.mouseEnabled = false;
         this.purchasableMC.mouseEnabled = false;
         super.configUI();
         this.button.addEventListener(MouseEvent.CLICK,this.baseButtonPress);
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
      }
      
      var mouseDown:Boolean;
      
      override protected function handleMouseRollOut(event:MouseEvent) : §void§
      {
         var dragData:Object = null;
         var dragStartEvent:DragEvent = null;
         root["onHideShopItemTooltip"](this);
         super.handleMouseRollOut(event);
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
      
      function frame1() : *
      {
         stop();
      }
   }
}
