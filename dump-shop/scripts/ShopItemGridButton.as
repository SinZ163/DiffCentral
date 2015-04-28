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
         var _loc1_:* = new MovieClip();
         _loc1_.height = 32;
         _loc1_.width = 48;
         _loc1_.scaleX = 1;
         _loc1_.scaleY = 1;
         Globals.instance.LoadItemImage(this._itemData.itemImageName,_loc1_);
         if(this.cooldownMC == null && (this._itemData.needsCooldown))
         {
            this.cooldownMC = new s_GridItemCooldown();
            this.addChild(this.cooldownMC);
            this.cooldownMC.mouseEnabled = false;
            this.cooldownMC.mouseChildren = false;
         }
         _loc1_.visible = false;
         content = _loc1_;
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
      }
      
      var mouseDown:Boolean;
      
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
      
      function frame1() : *
      {
         stop();
      }
   }
}
