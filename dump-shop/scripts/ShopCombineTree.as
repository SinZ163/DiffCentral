package
{
   import scaleform.clik.core.UIComponent;
   import flash.display.MovieClip;
   
   public class ShopCombineTree extends UIComponent
   {
      
      public function ShopCombineTree()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      override protected function configUI() : §void§
      {
         this.clear();
         this.dragTarget.visible = false;
      }
      
      public function onShopOpened() : *
      {
         this.doLayout();
      }
      
      public function onShopCollapsed() : *
      {
         this.doLayout();
      }
      
      public function setItem(itemName:String, color:Number, secretShop:Boolean, purchasable:Boolean) : *
      {
         this.setItemData(this.centerItem,itemName,color,secretShop,false,purchasable);
         this.upcombineItem0.visible = false;
         this.upcombineItem1.visible = false;
         this.upcombineItem2.visible = false;
         this.upcombineItem3.visible = false;
         this.upcombineItem4.visible = false;
         this.upcombineItem5.visible = false;
         this.componentItem0.visible = false;
         this.componentItem1.visible = false;
         this.componentItem2.visible = false;
         this.componentItem3.visible = false;
         this.componentItem4.visible = false;
         this.visibleComponents = 0;
         this.visibleUpcombines = 0;
      }
      
      public function updateCombineTreeCenterItemState(purchasable:Boolean) : *
      {
         var itemData:* = this.centerItem.itemData;
         if(!itemData)
         {
            return;
         }
         itemData.purchasable = purchasable;
         this.centerItem.itemData = itemData;
      }
      
      public function setCombineTreeComponent(componentSlot:Number, numComponents:Number, itemName:String, color:Number, secretShop:Boolean) : *
      {
         if(componentSlot < 0 || componentSlot > 4)
         {
            return;
         }
         var item:CombineTreeItem = this["componentItem" + componentSlot];
         this.setItemData(item,itemName,color,secretShop,false,false);
         this.visibleComponents = numComponents;
      }
      
      public function updateCombineTreeComponentState(componentSlot:Number, owned:Boolean, purchasable:Boolean) : *
      {
         if(componentSlot < 0 || componentSlot > 4)
         {
            return;
         }
         var item:CombineTreeItem = this["componentItem" + componentSlot];
         item.owned = owned;
         item.purchasable = purchasable;
      }
      
      public function setCombineTreeUpcombine(upcombineSlot:Number, numUpcombines:Number, itemName:String, color:Number, purchasable:Boolean) : *
      {
         if(upcombineSlot < 0 || upcombineSlot > 5)
         {
            return;
         }
         var item:CombineTreeItem = this["upcombineItem" + upcombineSlot];
         this.setItemData(item,itemName,color,false,false,false);
         this.visibleUpcombines = numUpcombines;
      }
      
      public function doLayout() : *
      {
         var i:* = 0;
         var item:CombineTreeItem = null;
         this.lineDrawingMC.graphics.clear();
         var itemHeight:int = this.centerItem.height;
         var halfHeight:int = itemHeight * 0.5;
         i = 0;
         while(i < this.visibleUpcombines)
         {
            item = this["upcombineItem" + i];
            this.lineDrawingMC.graphics.lineStyle(1,12566463,item.alpha);
            this.lineDrawingMC.graphics.moveTo(item.x,item.y + halfHeight - 5);
            this.lineDrawingMC.graphics.lineTo(this.centerItem.x,this.centerItem.y - halfHeight + 5);
            i++;
         }
         i = 0;
         while(i < this.visibleComponents)
         {
            item = this["componentItem" + i];
            this.lineDrawingMC.graphics.lineStyle(1,12566463,item.alpha);
            this.lineDrawingMC.graphics.moveTo(this.centerItem.x,this.centerItem.y + halfHeight - 10);
            this.lineDrawingMC.graphics.lineTo(item.x,item.y - halfHeight + 5);
            i++;
         }
      }
      
      public function setItemData(item:CombineTreeItem, itemName:String, color:Number, secretShop:Boolean, owned:Boolean, purchasable:Boolean) : *
      {
         var BGRColor:* = (color & 255) << 16 | color & 65280 | (color & 16711680) >> 16;
         var data:Object = {
            "itemName":itemName,
            "itemColor":BGRColor,
            "secretShop":secretShop,
            "owned":owned,
            "purchasable":purchasable
         };
         item.visible = true;
         item.itemData = data;
         item.purchaseLocation = CombineTreeItem.PURCHASE_LOCATION_COMBINE_TREE;
      }
      
      public function clear() : *
      {
         this.centerItem.visible = false;
         this.upcombineItem0.visible = false;
         this.upcombineItem1.visible = false;
         this.upcombineItem2.visible = false;
         this.upcombineItem3.visible = false;
         this.upcombineItem4.visible = false;
         this.upcombineItem5.visible = false;
         this.componentItem0.visible = false;
         this.componentItem1.visible = false;
         this.componentItem2.visible = false;
         this.componentItem3.visible = false;
         this.componentItem4.visible = false;
         this.lineDrawingMC.graphics.clear();
         this.visibleComponents = 0;
         this.visibleUpcombines = 0;
      }
      
      private var activeRecipePage:Number;
      
      private var visibleUpcombines:Number;
      
      private var visibleComponents:Number;
      
      public var lineDrawingMC:MovieClip;
      
      public var centerItem:CombineTreeItem;
      
      public var upcombineItem0:CombineTreeItem;
      
      public var upcombineItem1:CombineTreeItem;
      
      public var upcombineItem2:CombineTreeItem;
      
      public var upcombineItem3:CombineTreeItem;
      
      public var upcombineItem4:CombineTreeItem;
      
      public var upcombineItem5:CombineTreeItem;
      
      public var componentItem0:CombineTreeItem;
      
      public var componentItem1:CombineTreeItem;
      
      public var componentItem2:CombineTreeItem;
      
      public var componentItem3:CombineTreeItem;
      
      public var componentItem4:CombineTreeItem;
      
      public var dragTarget:QuickBuyDragTarget;
      
      function frame1() : *
      {
         stop();
      }
   }
}
