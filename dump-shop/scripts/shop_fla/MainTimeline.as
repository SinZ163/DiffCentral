package shop_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.text.engine.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import ValveLib.Globals;
   import ValveLib.ResizeManager;
   import ValveLib.Events.InputBoxEvent;
   import ValveLib.Managers.DragManager;
   import scaleform.clik.events.DragEvent;
   import scaleform.gfx.InteractiveObjectEx;
   import scaleform.clik.events.FocusHandlerEvent;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public var shop:MovieClip;
      
      public var gameAPI:Object;
      
      public var debugCounter:int;
      
      public function DebugPrint() : *
      {
         this.debugCounter++;
         trace("debug",this.debugCounter);
      }
      
      public function OnViewModeListClicked(event:MouseEvent) : *
      {
         this.gameAPI.OnViewModeListClicked();
      }
      
      public function OnViewModeGridClicked(event:MouseEvent) : *
      {
         this.gameAPI.OnViewModeGridClicked();
      }
      
      public function OnEditSuggestedClicked(event:MouseEvent) : *
      {
         this.gameAPI.OnEditSuggestedItemClick();
      }
      
      public function OnSuggestedItemSaveAsClicked(event:MouseEvent) : *
      {
         this.gameAPI.OnSuggestedItemSaveAsClick();
      }
      
      public function loadTabListItemRollOver(event:MouseEvent) : *
      {
         if(event.target.slot == 0)
         {
            event.currentTarget.gotoAndStop(2);
         }
         else
         {
            event.currentTarget.gotoAndStop(3);
         }
      }
      
      public function loadTabListItemRollOut(event:MouseEvent) : *
      {
         event.currentTarget.gotoAndStop(1);
      }
      
      public var bInputConsumer:Boolean;
      
      public var g_bFlippedHUD:Boolean;
      
      public function onHUDFlipChanged(bFlipped:Boolean) : *
      {
         this.g_bFlippedHUD = bFlipped;
         this.onResize(Globals.instance.resizeManager);
      }
      
      public function onLoaded() : *
      {
         Globals.instance.resizeManager.AddListener(this);
         this.gameAPI.OnReady();
         Globals.instance.GameInterface.AddMouseInputConsumer();
      }
      
      public function onResize(rm:ResizeManager) : *
      {
         if(this.g_bFlippedHUD)
         {
            rm.ResetPositionByPixel(this.shop,ResizeManager.SCALE_USING_VERTICAL,ResizeManager.REFERENCE_LEFT,0,ResizeManager.ALIGN_RIGHT,ResizeManager.REFERENCE_TOP,54,ResizeManager.ALIGN_TOP);
            this.shop.x = 0;
         }
         else
         {
            rm.ResetPositionByPixel(this.shop,ResizeManager.SCALE_USING_VERTICAL,ResizeManager.REFERENCE_RIGHT,0,ResizeManager.ALIGN_RIGHT,ResizeManager.REFERENCE_TOP,54,ResizeManager.ALIGN_TOP);
            this.shop.x = rm.ScreenWidth;
         }
      }
      
      public function levelInit() : *
      {
         this.clearCombineTree();
      }
      
      public function onShowPanel() : *
      {
         if(this.g_bFlippedHUD)
         {
            this.shop.gotoAndPlay(11);
         }
         else
         {
            this.shop.gotoAndPlay(1);
         }
      }
      
      public function onHidePanel() : *
      {
         if(this.shop.ShopTools.searchBox.focused)
         {
            this.shop.ShopTools.searchBox.focused = false;
         }
      }
      
      public function onShopAnimatedOpen() : *
      {
         this.shop.ShopTools.visible = true;
         if(this.g_bFlippedHUD)
         {
            this.shop.gotoAndPlay(12);
         }
         else
         {
            this.shop.gotoAndPlay(2);
         }
         this.shop.combineTree_container.visible = true;
      }
      
      public function setItemInItemRow(row:Number, itemName:String, itemImageName:String, color:Number, bDisabled:Boolean) : *
      {
         var gridParentMC:MovieClip = this.shop.itemRowsAnimate;
         if(!gridParentMC)
         {
            return;
         }
         var slotMC:ShopItemButton = gridParentMC["Item" + row];
         if(slotMC.slotIndex == undefined)
         {
            slotMC.slotIndex = row;
         }
         slotMC.visible = true;
         var data:Object = {
            "itemName":itemName,
            "itemImageName":itemImageName,
            "itemColor":color
         };
         slotMC.itemData = data;
         slotMC.setDisabled(bDisabled);
      }
      
      public function clearItemRow(row:Number) : *
      {
         var gridParentMC:MovieClip = this.shop.itemRowsAnimate;
         if(!gridParentMC)
         {
            return;
         }
         var slotMC:MovieClip = gridParentMC["Item" + row];
         slotMC.visible = false;
      }
      
      public function getGridMC(gridNumber:Number) : MovieClip
      {
         var gridParentMC:MovieClip = null;
         switch(gridNumber)
         {
            case 0:
               gridParentMC = this.shop.itemGridBasics;
               break;
            case 1:
               gridParentMC = this.shop.itemGridRecipes;
               break;
            case 2:
               gridParentMC = this.shop.itemGridSideShop;
               break;
            case 3:
               gridParentMC = this.shop.itemGridSecretShop;
               break;
         }
         return gridParentMC;
      }
      
      public function setItemInItemGrid(gridNumber:Number, row:Number, column:Number, itemName:String, itemImageName:String, color:Number, bCooldown:Boolean, bDisabled:Boolean) : *
      {
         var saturation:ColorMatrixFilter = null;
         var gridParentMC:MovieClip = this.getGridMC(gridNumber);
         if(!gridParentMC)
         {
            return;
         }
         var slotMC:ShopItemGridButton = gridParentMC["Item_" + row + "_" + column];
         if(!slotMC)
         {
            return;
         }
         if(slotMC.slotIndex == undefined)
         {
            slotMC.rowIndex = row;
            slotMC.columnIndex = column;
         }
         slotMC.visible = true;
         var data:Object = {
            "itemName":itemName,
            "itemImageName":itemImageName,
            "itemColor":color,
            "needsCooldown":bCooldown
         };
         slotMC.itemData = data;
         slotMC.disable.visible = bDisabled;
         if(bDisabled)
         {
            saturation = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.0,0.0,0.0,1,0]);
            slotMC.filters = [saturation];
         }
         else
         {
            slotMC.filters = [];
         }
      }
      
      public function clearItemGrid(gridNumber:Number, row:Number, column:Number) : *
      {
         var gridParentMC:MovieClip = this.getGridMC(gridNumber);
         if(!gridParentMC)
         {
            return;
         }
         var slotMC:ShopItemGridButton = gridParentMC["Item_" + row + "_" + column];
         if(slotMC)
         {
            slotMC.visible = false;
         }
      }
      
      public function getCooldownMovieForGridSlot(gridNumber:Number, row:Number, column:Number) : MovieClip
      {
         var gridParentMC:MovieClip = this.getGridMC(gridNumber);
         if(!gridParentMC)
         {
            return null;
         }
         var slotMC:ShopItemGridButton = gridParentMC["Item_" + row + "_" + column];
         if(!slotMC)
         {
            return null;
         }
         return slotMC.cooldownMC.cooldown;
      }
      
      public function setItemGridSlotPurchasable(gridNumber:Number, row:Number, column:Number, purchasable:Boolean) : *
      {
         var gridParentMC:MovieClip = this.getGridMC(gridNumber);
         if(!gridParentMC)
         {
            return;
         }
         var slotMC:ShopItemGridButton = gridParentMC["Item_" + row + "_" + column];
         if(slotMC)
         {
            slotMC.purchasableMC.visible = purchasable;
         }
      }
      
      public function onBuyButtonPress(itemName:String, itemSlot:uint, purchaseOrigin:int) : *
      {
         this.gameAPI.OnPurchaseItem(itemName,purchaseOrigin);
      }
      
      public function onBuyButtonPressShopItem(itemName:String) : *
      {
         var shopNumber:* = NaN;
         var purchaseOrigin:int = CombineTreeItem.PURCHASE_LOCATION_SHOP_ROW;
         if(this.shop.searchTab.visible)
         {
            shopNumber = -1;
            purchaseOrigin = CombineTreeItem.PURCHASE_LOCATION_SEARCH_RESULTS;
         }
         else if(this.sideShopOpen)
         {
            shopNumber = 1;
         }
         else if(this.secretShopOpen)
         {
            shopNumber = 2;
         }
         else
         {
            shopNumber = 0;
         }
         
         
         this.gameAPI.OnPurchaseItemFromShop(itemName,shopNumber,purchaseOrigin);
      }
      
      public function onSetInventoryQuickBuy(itemName:String) : *
      {
         this.gameAPI.OnSetInventoryQuickBuy(itemName);
      }
      
      public function onUpgradeButtonPress(itemName:String) : *
      {
         this.gameAPI.OnUpgradeItem(itemName);
      }
      
      public function onSetQuickBuy(itemName:String, purchaseOrigin:int) : *
      {
         if(purchaseOrigin == 1)
         {
            if(this.shop.searchTab.visible)
            {
               var purchaseOrigin:int = CombineTreeItem.PURCHASE_LOCATION_SEARCH_RESULTS;
            }
         }
         var recipe:Number = 0;
         this.gameAPI.OnSetQuickBuy(itemName,recipe,purchaseOrigin);
      }
      
      public var shopOpen:Boolean;
      
      public var mainShopOpen:Boolean;
      
      public var sideShopOpen:Boolean;
      
      public var secretShopOpen:Boolean;
      
      public function toggleShop(shopTab:Number) : *
      {
         if(this.shopOpen)
         {
            this.collapseShop();
         }
         else
         {
            this.openShopTab(shopTab);
         }
      }
      
      public function openShopTab(shopTab:Number) : *
      {
         if(this.shopOpen)
         {
            this.showShopTabInstant(shopTab);
         }
         else
         {
            this.showShopTabAnimated(shopTab);
         }
      }
      
      public function openShopCategory(tabIndex:uint, subtabIndex:uint) : *
      {
         var containingShop:uint = 0;
         var needsUpdating:* = false;
         var MainShopContents:MovieClip = null;
         var tabMC:MovieClip = null;
         var subTabButton:MovieClip = null;
         switch(tabIndex)
         {
            case 1:
            case 2:
               this.openShopTab(0);
               needsUpdating = false;
               MainShopContents = this.shop.MainShop.MainShopContents;
               if(tabIndex != this.activeMainShopTab)
               {
                  MainShopContents["tab" + tabIndex + "Button"].gotoAndStop(3);
                  MainShopContents["tab" + tabIndex].visible = true;
                  MainShopContents["tab" + this.activeMainShopTab + "Button"].gotoAndStop(1);
                  MainShopContents["tab" + this.activeMainShopTab].visible = false;
                  this.activeMainShopTab = tabIndex;
                  needsUpdating = true;
               }
               if(this.activeSubTab[tabIndex - 1] != subtabIndex)
               {
                  tabMC = MainShopContents["tab" + tabIndex];
                  subTabButton = tabMC["subtab" + subtabIndex + "Button"];
                  tabMC["subtab" + subtabIndex + "Button"].gotoAndStop(3);
                  tabMC["subtab" + this.activeSubTab[tabIndex - 1] + "Button"].gotoAndStop(1);
                  this.activeSubTab[tabIndex - 1] = subtabIndex;
                  needsUpdating = true;
               }
               if(needsUpdating)
               {
                  this.gameAPI.OnShopTabActivated(this.activeMainShopTab,int(this.activeSubTab[this.activeMainShopTab - 1]));
               }
               break;
            case 3:
               this.openShopTab(1);
               if(this.activeSubTab[tabIndex - 1] != subtabIndex)
               {
                  this.shop.SideShop.SideShopContents["subtab" + subtabIndex + "Button"].gotoAndStop(3);
                  this.shop.SideShop.SideShopContents["subtab" + this.activeSubTab[tabIndex - 1] + "Button"].gotoAndStop(1);
                  this.activeSubTab[tabIndex - 1] = subtabIndex;
                  this.gameAPI.OnShopTabActivated(tabIndex,int(this.activeSubTab[tabIndex - 1]));
               }
               break;
            case 4:
               this.openShopTab(2);
         }
         this.shop.searchTab.visible = false;
      }
      
      public function collapseShop() : *
      {
         this.shopOpen = false;
         this.shop.searchTab.visible = false;
         this.shop.combineTree_container.visible = false;
         this.shop.stage.focus = null;
         if(this.shop.ShopTools.searchBox.focused)
         {
            this.shop.ShopTools.searchBox.focused = false;
         }
         if(this.bInputConsumer)
         {
            Globals.instance.GameInterface.RemoveKeyInputConsumer();
            this.bInputConsumer = false;
         }
         if(this.mainShopOpen)
         {
            this.mainShopOpen = false;
         }
         if(this.sideShopOpen)
         {
            this.sideShopOpen = false;
         }
         if(this.secretShopOpen)
         {
            this.secretShopOpen = false;
         }
      }
      
      public function showShopTabInstant(shopTab:Number) : *
      {
         var tab:* = 0;
         this.shop.searchTab.visible = false;
         if(this.isShopTabOpen(shopTab))
         {
            return;
         }
         if(shopTab == 0)
         {
            this.mainShopOpen = true;
            this.shop.MainShop.visible = true;
            tab = this.activeMainShopTab;
         }
         else
         {
            this.mainShopOpen = false;
            this.shop.MainShop.visible = false;
         }
         if(shopTab == 1)
         {
            this.sideShopOpen = true;
            this.shop.SideShop.visible = true;
            tab = this.activeSideShopTab;
         }
         else
         {
            this.sideShopOpen = false;
            this.shop.SideShop.visible = false;
         }
         if(shopTab == 2)
         {
            this.secretShopOpen = true;
            this.shop.SecretShop.visible = true;
            tab = this.activeSecretShopTab;
         }
         else
         {
            this.secretShopOpen = false;
            this.shop.SecretShop.visible = false;
         }
         this.gameAPI.OnShopTabActivated(tab,int(this.activeSubTab[tab - 1]));
         this.gameAPI.OnShopOpened();
      }
      
      public function showShopTabAnimated(shopTab:Number) : *
      {
         var tab:* = 0;
         this.shopOpen = true;
         this.setShopTabOpen(shopTab,true);
         this.shop.ShopTools.visible = true;
         this.shop.combineTree_container.visible = true;
         switch(shopTab)
         {
            case 0:
               this.shop.MainShop.visible = true;
               this.mainShopOpen = true;
               this.shop.SideShop.visible = false;
               this.shop.SecretShop.visible = false;
               tab = this.activeMainShopTab;
               break;
            case 1:
               this.shop.SideShop.visible = true;
               this.sideShopOpen = true;
               this.shop.MainShop.visible = false;
               this.shop.SecretShop.visible = false;
               tab = this.activeSideShopTab;
               break;
            case 2:
               this.shop.SecretShop.visible = true;
               this.secretShopOpen = true;
               this.shop.MainShop.visible = false;
               this.shop.SideShop.visible = false;
               tab = this.activeSecretShopTab;
               break;
         }
         this.gameAPI.OnShopTabActivated(tab,int(this.activeSubTab[tab - 1]));
         this.gameAPI.OnShopOpened();
      }
      
      public function setShopTabOpen(shopTab:Number, open:Boolean) : *
      {
         switch(shopTab)
         {
            case 0:
               this.mainShopOpen = open;
               break;
            case 1:
               this.sideShopOpen = open;
               break;
            case 2:
               this.secretShopOpen = open;
               break;
         }
      }
      
      public function isShopTabOpen(shopTab:Number) : Boolean
      {
         switch(shopTab)
         {
            case 0:
               return this.mainShopOpen;
            case 1:
               return this.sideShopOpen;
            case 2:
               return this.secretShopOpen;
            default:
               return false;
         }
      }
      
      public function activateSearch() : *
      {
         if(!this.shopOpen)
         {
            return;
         }
         this.shop.ShopTools.searchBox.focused = true;
         this.shop.ShopTools.searchBox.text = "";
      }
      
      public function modifySearchBox(searchcontents:String) : *
      {
         this.shop.ShopTools.searchBox.text = searchcontents;
         this.searchTextChanged(searchcontents);
      }
      
      public var mouseOverShopItem:ShopItemButton;
      
      public function onShowShopItemTooltip(itemMC:MovieClip) : *
      {
         var itemName:String = itemMC.itemName;
         if(itemName.length == 0)
         {
            return;
         }
         var ipt:Point = new Point(itemMC.x,itemMC.y);
         if(itemMC is CombineTreeItem)
         {
            ipt.x = ipt.x - 19;
            ipt.y = ipt.y - 14;
         }
         if(this.g_bFlippedHUD)
         {
            if(itemMC is ShopItemGridButton || itemMC is CombineTreeItem || itemMC is ItemBuildItem)
            {
               ipt.x = ipt.x + itemMC.width * 0.75;
            }
            else
            {
               ipt.x = ipt.x + itemMC.width;
            }
         }
         ipt = itemMC.parent.localToGlobal(ipt);
         this.gameAPI.ShowItemTooltip(ipt.x,ipt.y,itemName);
         var shopItem:ShopItemButton = itemMC as ShopItemButton;
         if(shopItem)
         {
            this.mouseOverShopItem = shopItem;
            this.updatePurchasableState();
         }
      }
      
      public function onHideShopItemTooltip(itemMC:MovieClip) : *
      {
         this.gameAPI.HideItemTooltip();
         var shopItem:ShopItemButton = itemMC as ShopItemButton;
         if((shopItem) && this.mouseOverShopItem == shopItem)
         {
            this.mouseOverShopItem = null;
         }
      }
      
      public function updatePurchasableState() : *
      {
         var slot:int = this.mouseOverShopItem.slotIndex;
         this.gameAPI.OnRequestItemPurchasableState(slot,this.mouseOverShopItem.itemName,this.sideShopOpen);
      }
      
      public var activeMainShopTab:int;
      
      public var activeSideShopTab:int;
      
      public var activeSecretShopTab:int;
      
      public var subTabCounts:Array;
      
      public var activeSubTab:Array;
      
      public var i:uint;
      
      public var mc:MovieClip;
      
      public function tabRollOver(event:MouseEvent) : *
      {
         var tabIndex:Number = event.target.tabIndex;
         if(tabIndex != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + tabIndex + "Button"].gotoAndStop(2);
         }
      }
      
      public function tabRollOut(event:MouseEvent) : *
      {
         var tabIndex:Number = event.target.tabIndex;
         if(tabIndex != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + tabIndex + "Button"].gotoAndStop(1);
         }
      }
      
      public function tabPress(event:Object) : *
      {
         var tabIndex:Number = event.target.tabIndex;
         if(tabIndex != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + tabIndex + "Button"].gotoAndStop(3);
            this.shop.MainShop.MainShopContents["tab" + tabIndex].visible = true;
            this.shop.MainShop.MainShopContents["tab" + this.activeMainShopTab + "Button"].gotoAndStop(1);
            this.shop.MainShop.MainShopContents["tab" + this.activeMainShopTab].visible = false;
            this.activeMainShopTab = tabIndex;
            this.gameAPI.OnShopTabActivated(this.activeMainShopTab,int(this.activeSubTab[this.activeMainShopTab - 1]));
         }
         this.shop.searchTab.visible = false;
      }
      
      public var mainContents;
      
      public var tab:uint;
      
      public var tabMC:MovieClip;
      
      public var subtab:uint;
      
      public var button:MovieClip;
      
      public var sideShopSubTab:uint;
      
      public var sideShopTabButton:MovieClip;
      
      public var viewMode:int;
      
      public const SHOP_VIEW_MODE_LIST:int = 0;
      
      public const SHOP_VIEW_MODE_GRID:int = 1;
      
      public function notifyViewMode(newViewMode:int) : *
      {
         if(this.viewMode != newViewMode)
         {
            this.shop.MainShop.MainShopContents.tab1.subtab1Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab1.subtab2Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab1.subtab3Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab1.subtab4Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab1Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab2Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab3Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab4Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab5Button.gotoAndStop(1);
            this.shop.MainShop.MainShopContents.tab2.subtab6Button.gotoAndStop(1);
            this.shop.SideShop.SideShopContents.subtab1Button.gotoAndStop(1);
            this.shop.SideShop.SideShopContents.subtab2Button.gotoAndStop(1);
         }
         this.viewMode = newViewMode;
      }
      
      public function subTabPress(event:MouseEvent) : *
      {
         var tab:int = event.target.tab;
         var subtab:Number = event.target.subtab;
         if(this.activeSubTab[tab - 1] != subtab)
         {
            if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
            {
               event.target.gotoAndStop(3);
               event.target.parent["subtab" + this.activeSubTab[tab - 1] + "Button"].gotoAndStop(1);
            }
            this.activeSubTab[tab - 1] = subtab;
            this.gameAPI.OnShopTabActivated(tab,int(this.activeSubTab[tab - 1]));
         }
      }
      
      public function subTabRollOver(event:MouseEvent) : *
      {
         var tab:Number = event.target.tab;
         var subtab:Number = event.target.subtab;
         if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
         {
            if(this.activeSubTab[tab - 1] != subtab)
            {
               event.target.gotoAndStop(2);
            }
         }
         this.gameAPI.OnShowCategoryTooltip(tab,subtab);
      }
      
      public function subTabRollOut(event:MouseEvent) : *
      {
         var tab:Number = event.target.tab;
         var subtab:Number = event.target.subtab;
         if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
         {
            if(this.activeSubTab[tab - 1] != subtab)
            {
               event.target.gotoAndStop(1);
            }
         }
         this.gameAPI.OnHideCategoryTooltip();
      }
      
      public function searchTextChangedEvent(event:Object) : *
      {
         this.searchTextChanged(event.target.text);
      }
      
      public function searchTextChanged(text:String) : *
      {
         var tab:* = 0;
         this.gameAPI.OnSearchTextChanged(text);
         if(text.length > 0)
         {
            this.shop.searchTab.visible = true;
            this.shop.ShopTools.clearSearch.visible = true;
            this.shop.ShopTools.clearSearch.addEventListener(MouseEvent.CLICK,this.onClearSearchClick);
         }
         else
         {
            this.shop.searchTab.visible = false;
            if(this.sideShopOpen)
            {
               tab = this.activeSideShopTab;
            }
            else if(this.secretShopOpen)
            {
               tab = this.activeSecretShopTab;
            }
            else
            {
               tab = this.activeMainShopTab;
            }
            
            this.gameAPI.OnShopTabActivated(tab,int(this.activeSubTab[tab - 1]));
            this.shop.ShopTools.clearSearch.visible = false;
            this.shop.ShopTools.clearSearch.removeEventListener(MouseEvent.CLICK,this.onClearSearchClick);
         }
      }
      
      public function onClearSearchClick(event:MouseEvent) : *
      {
         this.shop.ShopTools.searchBox.text = "";
         this.searchTextChanged("");
      }
      
      public function onSearchBoxEnterPress(event:InputBoxEvent) : *
      {
         this.clearSearchFocus();
      }
      
      public function searchBoxGainFocus(event:Object) : *
      {
         if(!this.bInputConsumer)
         {
            Globals.instance.GameInterface.AddKeyInputConsumer();
            this.bInputConsumer = true;
         }
         if(event.target.text.length > 0)
         {
            this.shop.searchTab.visible = true;
            this.gameAPI.OnSearchTextChanged(event.target.text);
         }
         this.gameAPI.OnSearchBoxGainFocus();
      }
      
      public function searchBoxLoseFocus(event:Object) : *
      {
         if(this.bInputConsumer)
         {
            Globals.instance.GameInterface.RemoveKeyInputConsumer();
            this.bInputConsumer = false;
         }
         this.gameAPI.OnSearchBoxLoseFocus();
      }
      
      public function clearSearchFocus() : *
      {
         this.shop.stage.focus = null;
      }
      
      public var numHeaders:Number;
      
      public var numItems:Number;
      
      public var headerHeight:Number;
      
      public var itemHeight:Number;
      
      public var itemWidth:Number;
      
      public var itemsPerRow:int;
      
      public var itemsInSection:Number;
      
      public var lastHeaderYBottom:Number;
      
      public function onShopItemDraggedToSuggestedItems(dragTarget:MovieClip, itemName:String) : *
      {
         var i:* = 0;
         var mc:MovieClip = null;
         var xpos:* = this.shop.recommendedTab.content.mouseX;
         var ypos:* = this.shop.recommendedTab.content.mouseY;
         var h:* = this.shop.recommendedTab.content.height + 50;
         if(xpos < 0 || xpos >= this.shop.recommendedTab.content.width || ypos < 0 || ypos >= h)
         {
            return;
         }
         var slot:* = -1;
         var len:int = this.itemBuildContents.length;
         i = 0;
         while(i < len)
         {
            mc = this.itemBuildContents[i];
            if(mc)
            {
               if(!(xpos < mc.x || ypos < mc.y))
               {
                  slot = i;
               }
            }
            i++;
         }
         if(slot > -1)
         {
            this.gameAPI.OnItemDraggedToSuggested(slot,itemName);
         }
      }
      
      public function clearItemBuild() : *
      {
         var mc:MovieClip = null;
         var i:* = NaN;
         var baseMC:MovieClip = this.shop.recommendedTab.content;
         i = 0;
         while(i < this.numHeaders)
         {
            mc = baseMC["Header" + i];
            if(mc)
            {
               mc.visible = false;
            }
            i++;
         }
         i = 0;
         while(i < this.numItems)
         {
            mc = baseMC["ItemEntry" + i];
            if(mc)
            {
               mc.visible = false;
            }
            i++;
         }
         mc = baseMC["ItemPlaceholder"];
         if((mc) && (mc.visible))
         {
            mc.visible = false;
         }
         this.numHeaders = 0;
         this.numItems = 0;
         this.itemsInSection = 0;
         this.lastHeaderYBottom = 44;
         this.itemBuildContents = new Array();
      }
      
      public function toggleRecommendedTab() : *
      {
         var vis:* = !this.shop.recommendedTab.visible;
         if(vis)
         {
            this.gameAPI.OnRecommendedItemsTabOpen();
         }
         else
         {
            this.gameAPI.OnRecommendedItemsTabClose();
         }
         this.shop.recommendedTab.visible = vis;
      }
      
      public function setRecommendedTabOpen(open:Boolean) : §void§
      {
         this.shop.recommendedTab.visible = open;
      }
      
      public function onSuggestedItemDragStart(mc:ItemBuildItem, slot:int) : *
      {
         if(this.inEditMode)
         {
            this.gameAPI.OnItemBuildItemDragStart(slot);
         }
      }
      
      public var inEditMode:Boolean;
      
      public function OnLeaveSuggestedEditMode() : *
      {
         this.inEditMode = false;
      }
      
      public function OnEnterSuggestedEditMode() : *
      {
         this.inEditMode = true;
      }
      
      public function SuggestedEditThink() : *
      {
         var i:* = 0;
         var mc:MovieClip = null;
         if(!this.inEditMode)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            return;
         }
         var xpos:* = this.shop.recommendedTab.content.mouseX;
         var ypos:* = this.shop.recommendedTab.content.mouseY;
         var h:* = this.shop.recommendedTab.content.height + 50;
         if(xpos < 0 || xpos >= this.shop.recommendedTab.content.width || ypos < 0 || ypos >= h)
         {
            this.gameAPI.OnItemDraggedToSuggested(-1,"placeholder");
            return;
         }
         var slot:* = -1;
         var len:int = this.itemBuildContents.length;
         i = 0;
         while(i < len)
         {
            mc = this.itemBuildContents[i];
            if(mc)
            {
               if(!(xpos < mc.x || ypos < mc.y))
               {
                  slot = i;
               }
            }
            i++;
         }
         if(slot > -1)
         {
            this.gameAPI.OnItemDraggedToSuggested(slot,"placeholder");
         }
      }
      
      public var itemBuildContents;
      
      public function addItemBuildHeader(headerText:String) : §void§
      {
         var baseMC:* = this.shop.recommendedTab.content;
         var headerMC:MovieClip = baseMC["Header" + this.numHeaders];
         if(headerMC == null)
         {
            headerMC = new RecommendedItemHeader();
            baseMC["Header" + this.numHeaders] = headerMC;
            baseMC.addChild(headerMC);
         }
         headerMC.visible = true;
         headerMC.headerText.text = headerText;
         headerMC.x = 10;
         var rows:int = this.itemsInSection / this.itemsPerRow;
         if(this.itemsInSection % this.itemsPerRow > 0)
         {
            rows++;
         }
         headerMC.y = this.lastHeaderYBottom + rows * this.itemHeight + 10;
         this.itemBuildContents.push(headerMC);
         this.numHeaders = this.numHeaders + 1;
         this.itemsInSection = 0;
         this.lastHeaderYBottom = headerMC.y + headerMC.height;
      }
      
      public function addItemBuildPlaceholder(slot:int) : §void§
      {
         var baseMC:* = this.shop.recommendedTab.content;
         var slotMC:ItemBuildPlaceholder = baseMC["ItemPlaceholder"];
         if(slotMC == null)
         {
            slotMC = new ItemBuildPlaceholder();
            baseMC["ItemPlaceholder"] = slotMC;
            baseMC.addChild(slotMC);
         }
         slotMC.visible = true;
         var row:int = this.itemsInSection / this.itemsPerRow;
         var col:int = this.itemsInSection % this.itemsPerRow;
         slotMC.x = 10 + col * this.itemWidth;
         slotMC.y = this.lastHeaderYBottom + row * (this.itemHeight + 2);
         this.itemBuildContents.push(slotMC);
         this.itemsInSection++;
      }
      
      public function addItemBuildItem(itemName:String, itemImageName:String, localizedName:String, cost:Number, color:Number, secretShop:Boolean, slot:int) : §void§
      {
         var baseMC:* = this.shop.recommendedTab.content;
         var slotMC:ItemBuildItem = baseMC["ItemEntry" + this.numItems];
         if(slotMC == null)
         {
            slotMC = new ItemBuildItem();
            baseMC["ItemEntry" + this.numItems] = slotMC;
            baseMC.addChild(slotMC);
         }
         slotMC.visible = true;
         var BGRColor:* = (color & 255) << 16 | color & 65280 | (color & 16711680) >> 16;
         var data:Object = {
            "itemName":itemName,
            "itemImageName":itemImageName,
            "itemColor":BGRColor,
            "secretShop":secretShop,
            "owned":false,
            "purchasable":false,
            "itemSlot":slot
         };
         slotMC.itemData = data;
         var row:int = this.itemsInSection / this.itemsPerRow;
         var col:int = this.itemsInSection % this.itemsPerRow;
         slotMC.x = 10 + col * this.itemWidth;
         slotMC.y = this.lastHeaderYBottom + row * (this.itemHeight + 2);
         this.itemBuildContents.push(slotMC);
         this.numItems++;
         this.itemsInSection++;
      }
      
      public function setItemBuildSlotPurchased(slot:Number) : §void§
      {
         var slotMC:ItemBuildItem = this.shop.recommendedTab.content["ItemEntry" + slot];
         slotMC.owned = true;
      }
      
      public function clearCombineTree() : *
      {
         this.shop.combineTree_container.combineTree.clear();
      }
      
      public function setCombineTreeItem(itemName:String, color:Number, secretShop:Boolean, purchasable:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setItem(itemName,color,secretShop,purchasable);
      }
      
      public function updateCombineTreeCenterItemState(purchasable:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.updateCombineTreeCenterItemState(purchasable);
      }
      
      public function updateCombineTreeComponentState(componentSlot:Number, owned:Boolean, purchasable:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.updateCombineTreeComponentState(componentSlot,owned,purchasable);
      }
      
      public function setCombineTreeComponent(componentSlot:Number, numComponents:Number, itemName:String, color:Number, secretShop:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setCombineTreeComponent(componentSlot,numComponents,itemName,color,secretShop);
      }
      
      public function setCombineTreeUpcombine(upcombineSlot:Number, numUpcombines:Number, itemName:String, color:Number, purchasable:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setCombineTreeUpcombine(upcombineSlot,numUpcombines,itemName,color,purchasable);
      }
      
      public function layoutCombineTree() : *
      {
         this.shop.combineTree_container.combineTree.doLayout();
      }
      
      public var inShopItemDrag:Boolean;
      
      public function onDragStart(e:DragEvent) : *
      {
         if((e.dragData) && (e.dragData.shopItemName))
         {
            this.gameAPI.OnStartShopItemDrag();
            this.inShopItemDrag = true;
            this.shop.combineTree_container.combineTree.dragTarget.visible = true;
            if(this.inEditMode)
            {
               this.shop.recommendedTab.dragTarget.visible = true;
            }
         }
      }
      
      public function onDragEnd(e:DragEvent) : *
      {
         if(this.inShopItemDrag)
         {
            this.gameAPI.OnEndShopItemDrag();
            this.inShopItemDrag = false;
            this.shop.combineTree_container.combineTree.dragTarget.visible = false;
            this.shop.recommendedTab.dragTarget.visible = false;
         }
      }
      
      public function onShopItemDraggedToQuickBuy(dragTarget:MovieClip, itemName:String) : *
      {
         this.onSetQuickBuy(itemName,1);
      }
      
      function frame1() : *
      {
         this.shop.ShopTools.clearSearch.visible = false;
         InteractiveObjectEx.setHitTestDisable(this.shop.recommendedTab.editMode,true);
         this.debugCounter = 0;
         this.shop.recommendedTab.editMode.visible = false;
         this.shop.recommendedTab.dragTarget.visible = false;
         this.shop.recommendedTab.saveResultPanel.visible = false;
         this.shop.recommendedTab.saveButton.visible = false;
         this.shop.MainShop.MainShopContents.tab1Button.gotoAndStop(3);
         this.shop.MainShop.MainShopContents.tab1Button.textField.text = "#Dota_Shop_Category_Basics";
         this.shop.MainShop.MainShopContents.tab2Button.textField.text = "#DOTA_Shop_Category_Upgrades";
         this.shop.ShopTools.viewModeList.addEventListener(MouseEvent.CLICK,this.OnViewModeListClicked);
         this.shop.ShopTools.viewModeGrid.addEventListener(MouseEvent.CLICK,this.OnViewModeGridClicked);
         this.shop.ShopTools.viewModeList.gotoAndStop(2);
         this.shop.recommendedTab.editButton.addEventListener(MouseEvent.CLICK,this.OnEditSuggestedClicked);
         this.shop.recommendedTab.saveButton.addEventListener(MouseEvent.CLICK,this.OnSuggestedItemSaveAsClicked);
         this.shop.visible = true;
         this.bInputConsumer = false;
         this.g_bFlippedHUD = true;
         this.shopOpen = false;
         this.mainShopOpen = false;
         this.sideShopOpen = false;
         this.secretShopOpen = false;
         this.mouseOverShopItem = null;
         this.activeMainShopTab = 1;
         this.activeSideShopTab = 3;
         this.activeSecretShopTab = 4;
         this.subTabCounts = new Array(4,6,2,1);
         this.activeSubTab = new Array(1,1,1,1);
         this.i = 1;
         while(this.i <= 2)
         {
            this.mc = this.shop.MainShop.MainShopContents["tab" + this.i + "Button"];
            if(this.mc)
            {
               this.mc.addEventListener(MouseEvent.CLICK,this.tabPress);
               this.mc.addEventListener(MouseEvent.ROLL_OVER,this.tabRollOver);
               this.mc.addEventListener(MouseEvent.ROLL_OUT,this.tabRollOut);
               this.mc.mouseChildren = false;
               this.mc.tabIndex = this.i;
            }
            if(this.i != 1)
            {
               this.mc = this.shop.MainShop.MainShopContents["tab" + this.i];
               if(this.mc)
               {
                  this.mc.visible = false;
               }
            }
            this.i++;
         }
         this.mainContents = this.shop.MainShop.MainShopContents;
         this.tab = 1;
         while(this.tab <= 2)
         {
            if(this.subTabCounts[this.tab - 1] > 1)
            {
               this.tabMC = this.mainContents["tab" + this.tab];
               this.tabMC.subtab1Button.gotoAndStop(3);
               this.subtab = 1;
               while(this.subtab <= this.subTabCounts[this.tab - 1])
               {
                  this.button = this.tabMC["subtab" + this.subtab + "Button"];
                  if(this.subtab == 1)
                  {
                     this.button.gotoAndStop(3);
                  }
                  this.button.tab = this.tab;
                  this.button.subtab = this.subtab;
                  this.button.mouseChildren = false;
                  this.button.addEventListener(MouseEvent.CLICK,this.subTabPress);
                  this.button.addEventListener(MouseEvent.ROLL_OVER,this.subTabRollOver);
                  this.button.addEventListener(MouseEvent.ROLL_OUT,this.subTabRollOut);
                  this.subtab++;
               }
            }
            this.tab++;
         }
         this.sideShopSubTab = 1;
         while(this.sideShopSubTab <= 2)
         {
            this.sideShopTabButton = this.shop.SideShop.SideShopContents["subtab" + this.sideShopSubTab + "Button"];
            if(this.sideShopSubTab == 1)
            {
               this.sideShopTabButton.gotoAndStop(3);
            }
            this.sideShopTabButton.addEventListener(MouseEvent.CLICK,this.subTabPress);
            this.sideShopTabButton.addEventListener(MouseEvent.ROLL_OVER,this.subTabRollOver);
            this.sideShopTabButton.addEventListener(MouseEvent.ROLL_OUT,this.subTabRollOut);
            this.sideShopTabButton.tab = this.activeSideShopTab;
            this.sideShopTabButton.subtab = this.sideShopSubTab;
            this.sideShopTabButton.mouseChildren = false;
            this.sideShopSubTab++;
         }
         this.viewMode = 0;
         this.shop.ShopTools.searchBox.addEventListener(Event.CHANGE,this.searchTextChangedEvent);
         this.shop.ShopTools.searchBox.addEventListener(InputBoxEvent.TEXT_SUBMITTED,this.onSearchBoxEnterPress);
         this.shop.ShopTools.searchBox.addEventListener(FocusHandlerEvent.FOCUS_IN,this.searchBoxGainFocus);
         this.shop.ShopTools.searchBox.addEventListener(FocusHandlerEvent.FOCUS_OUT,this.searchBoxLoseFocus);
         this.numHeaders = 0;
         this.numItems = 0;
         this.headerHeight = 20;
         this.itemHeight = 28;
         this.itemWidth = 44;
         this.itemsPerRow = 3;
         this.itemsInSection = 0;
         this.lastHeaderYBottom = 54;
         this.shop.ShopTools.suggestedButton.addEventListener(MouseEvent.CLICK,this.toggleRecommendedTab);
         this.inEditMode = false;
         this.itemBuildContents = new Array();
         this.shop.addEventListener(DragEvent.DRAG_START,this.onDragStart);
         this.shop.addEventListener(DragEvent.DRAG_END,this.onDragEnd);
         stop();
      }
   }
}
