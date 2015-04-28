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
      
      public function setItem(param1:String, param2:Number, param3:Boolean, param4:Boolean) : *
      {
         this.setItemData(this.centerItem,param1,param2,param3,false,param4);
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
      
      public function updateCombineTreeCenterItemState(param1:Boolean) : *
      {
         var _loc2_:* = this.centerItem.itemData;
         if(!_loc2_)
         {
            return;
         }
         _loc2_.purchasable = param1;
         this.centerItem.itemData = _loc2_;
      }
      
      public function setCombineTreeComponent(param1:Number, param2:Number, param3:String, param4:Number, param5:Boolean) : *
      {
         if(param1 < 0 || param1 > 4)
         {
            return;
         }
         var _loc6_:CombineTreeItem = this["componentItem" + param1];
         this.setItemData(_loc6_,param3,param4,param5,false,false);
         this.visibleComponents = param2;
      }
      
      public function updateCombineTreeComponentState(param1:Number, param2:Boolean, param3:Boolean) : *
      {
         if(param1 < 0 || param1 > 4)
         {
            return;
         }
         var _loc4_:CombineTreeItem = this["componentItem" + param1];
         _loc4_.owned = param2;
         _loc4_.purchasable = param3;
      }
      
      public function setCombineTreeUpcombine(param1:Number, param2:Number, param3:String, param4:Number, param5:Boolean) : *
      {
         if(param1 < 0 || param1 > 5)
         {
            return;
         }
         var _loc6_:CombineTreeItem = this["upcombineItem" + param1];
         this.setItemData(_loc6_,param3,param4,false,false,false);
         this.visibleUpcombines = param2;
      }
      
      public function doLayout() : *
      {
         var _loc1_:* = 0;
         var _loc2_:CombineTreeItem = null;
         this.lineDrawingMC.graphics.clear();
         var _loc3_:int = this.centerItem.height;
         var _loc4_:int = _loc3_ * 0.5;
         _loc1_ = 0;
         while(_loc1_ < this.visibleUpcombines)
         {
            _loc2_ = this["upcombineItem" + _loc1_];
            this.lineDrawingMC.graphics.lineStyle(1,12566463,_loc2_.alpha);
            this.lineDrawingMC.graphics.moveTo(_loc2_.x,_loc2_.y + _loc4_ - 5);
            this.lineDrawingMC.graphics.lineTo(this.centerItem.x,this.centerItem.y - _loc4_ + 5);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.visibleComponents)
         {
            _loc2_ = this["componentItem" + _loc1_];
            this.lineDrawingMC.graphics.lineStyle(1,12566463,_loc2_.alpha);
            this.lineDrawingMC.graphics.moveTo(this.centerItem.x,this.centerItem.y + _loc4_ - 10);
            this.lineDrawingMC.graphics.lineTo(_loc2_.x,_loc2_.y - _loc4_ + 5);
            _loc1_++;
         }
      }
      
      public function setItemData(param1:CombineTreeItem, param2:String, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean) : *
      {
         var _loc7_:* = (param3 & 255) << 16 | param3 & 65280 | (param3 & 16711680) >> 16;
         var _loc8_:Object = {
            "itemName":param2,
            "itemColor":_loc7_,
            "secretShop":param4,
            "owned":param5,
            "purchasable":param6
         };
         param1.visible = true;
         param1.itemData = _loc8_;
         param1.purchaseLocation = CombineTreeItem.PURCHASE_LOCATION_COMBINE_TREE;
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
