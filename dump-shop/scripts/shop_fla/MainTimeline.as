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
      
      public function OnViewModeListClicked(param1:MouseEvent) : *
      {
         this.gameAPI.OnViewModeListClicked();
      }
      
      public function OnViewModeGridClicked(param1:MouseEvent) : *
      {
         this.gameAPI.OnViewModeGridClicked();
      }
      
      public function OnEditSuggestedClicked(param1:MouseEvent) : *
      {
         this.gameAPI.OnEditSuggestedItemClick();
      }
      
      public function OnSuggestedItemSaveAsClicked(param1:MouseEvent) : *
      {
         this.gameAPI.OnSuggestedItemSaveAsClick();
      }
      
      public function loadTabListItemRollOver(param1:MouseEvent) : *
      {
         if(param1.target.slot == 0)
         {
            param1.currentTarget.gotoAndStop(2);
         }
         else
         {
            param1.currentTarget.gotoAndStop(3);
         }
      }
      
      public function loadTabListItemRollOut(param1:MouseEvent) : *
      {
         param1.currentTarget.gotoAndStop(1);
      }
      
      public var bInputConsumer:Boolean;
      
      public var g_bFlippedHUD:Boolean;
      
      public function onHUDFlipChanged(param1:Boolean) : *
      {
         this.g_bFlippedHUD = param1;
         this.onResize(Globals.instance.resizeManager);
      }
      
      public function onLoaded() : *
      {
         Globals.instance.resizeManager.AddListener(this);
         this.gameAPI.OnReady();
         Globals.instance.GameInterface.AddMouseInputConsumer();
      }
      
      public function onResize(param1:ResizeManager) : *
      {
         if(this.g_bFlippedHUD)
         {
            param1.ResetPositionByPixel(this.shop,ResizeManager.SCALE_USING_VERTICAL,ResizeManager.REFERENCE_LEFT,0,ResizeManager.ALIGN_RIGHT,ResizeManager.REFERENCE_TOP,54,ResizeManager.ALIGN_TOP);
            this.shop.x = 0;
         }
         else
         {
            param1.ResetPositionByPixel(this.shop,ResizeManager.SCALE_USING_VERTICAL,ResizeManager.REFERENCE_RIGHT,0,ResizeManager.ALIGN_RIGHT,ResizeManager.REFERENCE_TOP,54,ResizeManager.ALIGN_TOP);
            this.shop.x = param1.ScreenWidth;
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
      
      public function setItemInItemRow(param1:Number, param2:String, param3:String, param4:Number, param5:Boolean) : *
      {
         var _loc6_:MovieClip = this.shop.itemRowsAnimate;
         if(!_loc6_)
         {
            return;
         }
         var _loc7_:ShopItemButton = _loc6_["Item" + param1];
         if(_loc7_.slotIndex == undefined)
         {
            _loc7_.slotIndex = param1;
         }
         _loc7_.visible = true;
         var _loc8_:Object = {
            "itemName":param2,
            "itemImageName":param3,
            "itemColor":param4
         };
         _loc7_.itemData = _loc8_;
         _loc7_.setDisabled(param5);
      }
      
      public function clearItemRow(param1:Number) : *
      {
         var _loc2_:MovieClip = this.shop.itemRowsAnimate;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:MovieClip = _loc2_["Item" + param1];
         _loc3_.visible = false;
      }
      
      public function getGridMC(param1:Number) : MovieClip
      {
         var _loc2_:MovieClip = null;
         switch(param1)
         {
            case 0:
               _loc2_ = this.shop.itemGridBasics;
               break;
            case 1:
               _loc2_ = this.shop.itemGridRecipes;
               break;
            case 2:
               _loc2_ = this.shop.itemGridSideShop;
               break;
            case 3:
               _loc2_ = this.shop.itemGridSecretShop;
               break;
         }
         return _loc2_;
      }
      
      public function setItemInItemGrid(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:Number, param7:Boolean, param8:Boolean) : *
      {
         var _loc12_:ColorMatrixFilter = null;
         var _loc9_:MovieClip = this.getGridMC(param1);
         if(!_loc9_)
         {
            return;
         }
         var _loc10_:ShopItemGridButton = _loc9_["Item_" + param2 + "_" + param3];
         if(!_loc10_)
         {
            return;
         }
         if(_loc10_.slotIndex == undefined)
         {
            _loc10_.rowIndex = param2;
            _loc10_.columnIndex = param3;
         }
         _loc10_.visible = true;
         var _loc11_:Object = {
            "itemName":param4,
            "itemImageName":param5,
            "itemColor":param6,
            "needsCooldown":param7
         };
         _loc10_.itemData = _loc11_;
         _loc10_.disable.visible = param8;
         if(param8)
         {
            _loc12_ = new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.0,0.0,0.0,1,0]);
            _loc10_.filters = [_loc12_];
         }
         else
         {
            _loc10_.filters = [];
         }
      }
      
      public function clearItemGrid(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc4_:MovieClip = this.getGridMC(param1);
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:ShopItemGridButton = _loc4_["Item_" + param2 + "_" + param3];
         if(_loc5_)
         {
            _loc5_.visible = false;
         }
      }
      
      public function getCooldownMovieForGridSlot(param1:Number, param2:Number, param3:Number) : MovieClip
      {
         var _loc4_:MovieClip = this.getGridMC(param1);
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:ShopItemGridButton = _loc4_["Item_" + param2 + "_" + param3];
         if(!_loc5_)
         {
            return null;
         }
         return _loc5_.cooldownMC.cooldown;
      }
      
      public function setItemGridSlotPurchasable(param1:Number, param2:Number, param3:Number, param4:Boolean) : *
      {
         var _loc5_:MovieClip = this.getGridMC(param1);
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:ShopItemGridButton = _loc5_["Item_" + param2 + "_" + param3];
         if(_loc6_)
         {
            _loc6_.purchasableMC.visible = param4;
         }
      }
      
      public function onBuyButtonPress(param1:String, param2:uint, param3:int) : *
      {
         this.gameAPI.OnPurchaseItem(param1,param3);
      }
      
      public function onBuyButtonPressShopItem(param1:String) : *
      {
         var _loc2_:* = NaN;
         var _loc3_:int = CombineTreeItem.PURCHASE_LOCATION_SHOP_ROW;
         if(this.shop.searchTab.visible)
         {
            _loc2_ = -1;
            _loc3_ = CombineTreeItem.PURCHASE_LOCATION_SEARCH_RESULTS;
         }
         else if(this.sideShopOpen)
         {
            _loc2_ = 1;
         }
         else if(this.secretShopOpen)
         {
            _loc2_ = 2;
         }
         else
         {
            _loc2_ = 0;
         }
         
         
         this.gameAPI.OnPurchaseItemFromShop(param1,_loc2_,_loc3_);
      }
      
      public function onSetInventoryQuickBuy(param1:String) : *
      {
         this.gameAPI.OnSetInventoryQuickBuy(param1);
      }
      
      public function onUpgradeButtonPress(param1:String) : *
      {
         this.gameAPI.OnUpgradeItem(param1);
      }
      
      public function onSetQuickBuy(param1:String, param2:int) : *
      {
         if(param2 == 1)
         {
            if(this.shop.searchTab.visible)
            {
               var param2:int = CombineTreeItem.PURCHASE_LOCATION_SEARCH_RESULTS;
            }
         }
         var _loc3_:Number = 0;
         this.gameAPI.OnSetQuickBuy(param1,_loc3_,param2);
      }
      
      public var shopOpen:Boolean;
      
      public var mainShopOpen:Boolean;
      
      public var sideShopOpen:Boolean;
      
      public var secretShopOpen:Boolean;
      
      public function toggleShop(param1:Number) : *
      {
         if(this.shopOpen)
         {
            this.collapseShop();
         }
         else
         {
            this.openShopTab(param1);
         }
      }
      
      public function openShopTab(param1:Number) : *
      {
         if(this.shopOpen)
         {
            this.showShopTabInstant(param1);
         }
         else
         {
            this.showShopTabAnimated(param1);
         }
      }
      
      public function openShopCategory(param1:uint, param2:uint) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:* = false;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         switch(param1)
         {
            case 1:
            case 2:
               this.openShopTab(0);
               _loc4_ = false;
               _loc5_ = this.shop.MainShop.MainShopContents;
               if(param1 != this.activeMainShopTab)
               {
                  _loc5_["tab" + param1 + "Button"].gotoAndStop(3);
                  _loc5_["tab" + param1].visible = true;
                  _loc5_["tab" + this.activeMainShopTab + "Button"].gotoAndStop(1);
                  _loc5_["tab" + this.activeMainShopTab].visible = false;
                  this.activeMainShopTab = param1;
                  _loc4_ = true;
               }
               if(this.activeSubTab[param1 - 1] != param2)
               {
                  _loc6_ = _loc5_["tab" + param1];
                  _loc7_ = _loc6_["subtab" + param2 + "Button"];
                  _loc6_["subtab" + param2 + "Button"].gotoAndStop(3);
                  _loc6_["subtab" + this.activeSubTab[param1 - 1] + "Button"].gotoAndStop(1);
                  this.activeSubTab[param1 - 1] = param2;
                  _loc4_ = true;
               }
               if(_loc4_)
               {
                  this.gameAPI.OnShopTabActivated(this.activeMainShopTab,int(this.activeSubTab[this.activeMainShopTab - 1]));
               }
               break;
            case 3:
               this.openShopTab(1);
               if(this.activeSubTab[param1 - 1] != param2)
               {
                  this.shop.SideShop.SideShopContents["subtab" + param2 + "Button"].gotoAndStop(3);
                  this.shop.SideShop.SideShopContents["subtab" + this.activeSubTab[param1 - 1] + "Button"].gotoAndStop(1);
                  this.activeSubTab[param1 - 1] = param2;
                  this.gameAPI.OnShopTabActivated(param1,int(this.activeSubTab[param1 - 1]));
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
      
      public function showShopTabInstant(param1:Number) : *
      {
         var _loc2_:* = 0;
         this.shop.searchTab.visible = false;
         if(this.isShopTabOpen(param1))
         {
            return;
         }
         if(param1 == 0)
         {
            this.mainShopOpen = true;
            this.shop.MainShop.visible = true;
            _loc2_ = this.activeMainShopTab;
         }
         else
         {
            this.mainShopOpen = false;
            this.shop.MainShop.visible = false;
         }
         if(param1 == 1)
         {
            this.sideShopOpen = true;
            this.shop.SideShop.visible = true;
            _loc2_ = this.activeSideShopTab;
         }
         else
         {
            this.sideShopOpen = false;
            this.shop.SideShop.visible = false;
         }
         if(param1 == 2)
         {
            this.secretShopOpen = true;
            this.shop.SecretShop.visible = true;
            _loc2_ = this.activeSecretShopTab;
         }
         else
         {
            this.secretShopOpen = false;
            this.shop.SecretShop.visible = false;
         }
         this.gameAPI.OnShopTabActivated(_loc2_,int(this.activeSubTab[_loc2_ - 1]));
         this.gameAPI.OnShopOpened();
      }
      
      public function showShopTabAnimated(param1:Number) : *
      {
         var _loc2_:* = 0;
         this.shopOpen = true;
         this.setShopTabOpen(param1,true);
         this.shop.ShopTools.visible = true;
         this.shop.combineTree_container.visible = true;
         switch(param1)
         {
            case 0:
               this.shop.MainShop.visible = true;
               this.mainShopOpen = true;
               this.shop.SideShop.visible = false;
               this.shop.SecretShop.visible = false;
               _loc2_ = this.activeMainShopTab;
               break;
            case 1:
               this.shop.SideShop.visible = true;
               this.sideShopOpen = true;
               this.shop.MainShop.visible = false;
               this.shop.SecretShop.visible = false;
               _loc2_ = this.activeSideShopTab;
               break;
            case 2:
               this.shop.SecretShop.visible = true;
               this.secretShopOpen = true;
               this.shop.MainShop.visible = false;
               this.shop.SideShop.visible = false;
               _loc2_ = this.activeSecretShopTab;
               break;
         }
         this.gameAPI.OnShopTabActivated(_loc2_,int(this.activeSubTab[_loc2_ - 1]));
         this.gameAPI.OnShopOpened();
      }
      
      public function setShopTabOpen(param1:Number, param2:Boolean) : *
      {
         switch(param1)
         {
            case 0:
               this.mainShopOpen = param2;
               break;
            case 1:
               this.sideShopOpen = param2;
               break;
            case 2:
               this.secretShopOpen = param2;
               break;
         }
      }
      
      public function isShopTabOpen(param1:Number) : Boolean
      {
         switch(param1)
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
      
      public function modifySearchBox(param1:String) : *
      {
         this.shop.ShopTools.searchBox.text = param1;
         this.searchTextChanged(param1);
      }
      
      public var mouseOverShopItem:ShopItemButton;
      
      public function onShowShopItemTooltip(param1:MovieClip) : *
      {
         var _loc2_:String = param1.itemName;
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc3_:Point = new Point(param1.x,param1.y);
         if(param1 is CombineTreeItem)
         {
            _loc3_.x = _loc3_.x - 19;
            _loc3_.y = _loc3_.y - 14;
         }
         if(this.g_bFlippedHUD)
         {
            if(param1 is ShopItemGridButton || param1 is CombineTreeItem || param1 is ItemBuildItem)
            {
               _loc3_.x = _loc3_.x + param1.width * 0.75;
            }
            else
            {
               _loc3_.x = _loc3_.x + param1.width;
            }
         }
         _loc3_ = param1.parent.localToGlobal(_loc3_);
         this.gameAPI.ShowItemTooltip(_loc3_.x,_loc3_.y,_loc2_);
         var _loc4_:ShopItemButton = param1 as ShopItemButton;
         if(_loc4_)
         {
            this.mouseOverShopItem = _loc4_;
            this.updatePurchasableState();
         }
      }
      
      public function onHideShopItemTooltip(param1:MovieClip) : *
      {
         this.gameAPI.HideItemTooltip();
         var _loc2_:ShopItemButton = param1 as ShopItemButton;
         if((_loc2_) && this.mouseOverShopItem == _loc2_)
         {
            this.mouseOverShopItem = null;
         }
      }
      
      public function updatePurchasableState() : *
      {
         var _loc1_:int = this.mouseOverShopItem.slotIndex;
         this.gameAPI.OnRequestItemPurchasableState(_loc1_,this.mouseOverShopItem.itemName,this.sideShopOpen);
      }
      
      public var activeMainShopTab:int;
      
      public var activeSideShopTab:int;
      
      public var activeSecretShopTab:int;
      
      public var subTabCounts:Array;
      
      public var activeSubTab:Array;
      
      public var i:uint;
      
      public var mc:MovieClip;
      
      public function tabRollOver(param1:MouseEvent) : *
      {
         var _loc2_:Number = param1.target.tabIndex;
         if(_loc2_ != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + _loc2_ + "Button"].gotoAndStop(2);
         }
      }
      
      public function tabRollOut(param1:MouseEvent) : *
      {
         var _loc2_:Number = param1.target.tabIndex;
         if(_loc2_ != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + _loc2_ + "Button"].gotoAndStop(1);
         }
      }
      
      public function tabPress(param1:Object) : *
      {
         var _loc2_:Number = param1.target.tabIndex;
         if(_loc2_ != this.activeMainShopTab)
         {
            this.shop.MainShop.MainShopContents["tab" + _loc2_ + "Button"].gotoAndStop(3);
            this.shop.MainShop.MainShopContents["tab" + _loc2_].visible = true;
            this.shop.MainShop.MainShopContents["tab" + this.activeMainShopTab + "Button"].gotoAndStop(1);
            this.shop.MainShop.MainShopContents["tab" + this.activeMainShopTab].visible = false;
            this.activeMainShopTab = _loc2_;
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
      
      public function notifyViewMode(param1:int) : *
      {
         if(this.viewMode != param1)
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
         this.viewMode = param1;
      }
      
      public function subTabPress(param1:MouseEvent) : *
      {
         var _loc2_:int = param1.target.tab;
         var _loc3_:Number = param1.target.subtab;
         if(this.activeSubTab[_loc2_ - 1] != _loc3_)
         {
            if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
            {
               param1.target.gotoAndStop(3);
               param1.target.parent["subtab" + this.activeSubTab[_loc2_ - 1] + "Button"].gotoAndStop(1);
            }
            this.activeSubTab[_loc2_ - 1] = _loc3_;
            this.gameAPI.OnShopTabActivated(_loc2_,int(this.activeSubTab[_loc2_ - 1]));
         }
      }
      
      public function subTabRollOver(param1:MouseEvent) : *
      {
         var _loc2_:Number = param1.target.tab;
         var _loc3_:Number = param1.target.subtab;
         if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
         {
            if(this.activeSubTab[_loc2_ - 1] != _loc3_)
            {
               param1.target.gotoAndStop(2);
            }
         }
         this.gameAPI.OnShowCategoryTooltip(_loc2_,_loc3_);
      }
      
      public function subTabRollOut(param1:MouseEvent) : *
      {
         var _loc2_:Number = param1.target.tab;
         var _loc3_:Number = param1.target.subtab;
         if(this.viewMode != this.SHOP_VIEW_MODE_GRID)
         {
            if(this.activeSubTab[_loc2_ - 1] != _loc3_)
            {
               param1.target.gotoAndStop(1);
            }
         }
         this.gameAPI.OnHideCategoryTooltip();
      }
      
      public function searchTextChangedEvent(param1:Object) : *
      {
         this.searchTextChanged(param1.target.text);
      }
      
      public function searchTextChanged(param1:String) : *
      {
         var _loc2_:* = 0;
         this.gameAPI.OnSearchTextChanged(param1);
         if(param1.length > 0)
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
               _loc2_ = this.activeSideShopTab;
            }
            else if(this.secretShopOpen)
            {
               _loc2_ = this.activeSecretShopTab;
            }
            else
            {
               _loc2_ = this.activeMainShopTab;
            }
            
            this.gameAPI.OnShopTabActivated(_loc2_,int(this.activeSubTab[_loc2_ - 1]));
            this.shop.ShopTools.clearSearch.visible = false;
            this.shop.ShopTools.clearSearch.removeEventListener(MouseEvent.CLICK,this.onClearSearchClick);
         }
      }
      
      public function onClearSearchClick(param1:MouseEvent) : *
      {
         this.shop.ShopTools.searchBox.text = "";
         this.searchTextChanged("");
      }
      
      public function onSearchBoxEnterPress(param1:InputBoxEvent) : *
      {
         this.clearSearchFocus();
      }
      
      public function searchBoxGainFocus(param1:Object) : *
      {
         if(!this.bInputConsumer)
         {
            Globals.instance.GameInterface.AddKeyInputConsumer();
            this.bInputConsumer = true;
         }
         if(param1.target.text.length > 0)
         {
            this.shop.searchTab.visible = true;
            this.gameAPI.OnSearchTextChanged(param1.target.text);
         }
         this.gameAPI.OnSearchBoxGainFocus();
      }
      
      public function searchBoxLoseFocus(param1:Object) : *
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
      
      public function onShopItemDraggedToSuggestedItems(param1:MovieClip, param2:String) : *
      {
         var _loc7_:* = 0;
         var _loc9_:MovieClip = null;
         var _loc3_:* = this.shop.recommendedTab.content.mouseX;
         var _loc4_:* = this.shop.recommendedTab.content.mouseY;
         var _loc5_:* = this.shop.recommendedTab.content.height + 50;
         if(_loc3_ < 0 || _loc3_ >= this.shop.recommendedTab.content.width || _loc4_ < 0 || _loc4_ >= _loc5_)
         {
            return;
         }
         var _loc6_:* = -1;
         var _loc8_:int = this.itemBuildContents.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = this.itemBuildContents[_loc7_];
            if(_loc9_)
            {
               if(!(_loc3_ < _loc9_.x || _loc4_ < _loc9_.y))
               {
                  _loc6_ = _loc7_;
               }
            }
            _loc7_++;
         }
         if(_loc6_ > -1)
         {
            this.gameAPI.OnItemDraggedToSuggested(_loc6_,param2);
         }
      }
      
      public function clearItemBuild() : *
      {
         var _loc1_:MovieClip = null;
         var _loc3_:* = NaN;
         var _loc2_:MovieClip = this.shop.recommendedTab.content;
         _loc3_ = 0;
         while(_loc3_ < this.numHeaders)
         {
            _loc1_ = _loc2_["Header" + _loc3_];
            if(_loc1_)
            {
               _loc1_.visible = false;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.numItems)
         {
            _loc1_ = _loc2_["ItemEntry" + _loc3_];
            if(_loc1_)
            {
               _loc1_.visible = false;
            }
            _loc3_++;
         }
         _loc1_ = _loc2_["ItemPlaceholder"];
         if((_loc1_) && (_loc1_.visible))
         {
            _loc1_.visible = false;
         }
         this.numHeaders = 0;
         this.numItems = 0;
         this.itemsInSection = 0;
         this.lastHeaderYBottom = 44;
         this.itemBuildContents = new Array();
      }
      
      public function toggleRecommendedTab() : *
      {
         var _loc1_:* = !this.shop.recommendedTab.visible;
         if(_loc1_)
         {
            this.gameAPI.OnRecommendedItemsTabOpen();
         }
         else
         {
            this.gameAPI.OnRecommendedItemsTabClose();
         }
         this.shop.recommendedTab.visible = _loc1_;
      }
      
      public function setRecommendedTabOpen(param1:Boolean) : §void§
      {
         this.shop.recommendedTab.visible = param1;
      }
      
      public function onSuggestedItemDragStart(param1:ItemBuildItem, param2:int) : *
      {
         if(this.inEditMode)
         {
            this.gameAPI.OnItemBuildItemDragStart(param2);
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
         var _loc5_:* = 0;
         var _loc7_:MovieClip = null;
         if(!this.inEditMode)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            return;
         }
         var _loc1_:* = this.shop.recommendedTab.content.mouseX;
         var _loc2_:* = this.shop.recommendedTab.content.mouseY;
         var _loc3_:* = this.shop.recommendedTab.content.height + 50;
         if(_loc1_ < 0 || _loc1_ >= this.shop.recommendedTab.content.width || _loc2_ < 0 || _loc2_ >= _loc3_)
         {
            this.gameAPI.OnItemDraggedToSuggested(-1,"placeholder");
            return;
         }
         var _loc4_:* = -1;
         var _loc6_:int = this.itemBuildContents.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.itemBuildContents[_loc5_];
            if(_loc7_)
            {
               if(!(_loc1_ < _loc7_.x || _loc2_ < _loc7_.y))
               {
                  _loc4_ = _loc5_;
               }
            }
            _loc5_++;
         }
         if(_loc4_ > -1)
         {
            this.gameAPI.OnItemDraggedToSuggested(_loc4_,"placeholder");
         }
      }
      
      public var itemBuildContents;
      
      public function addItemBuildHeader(param1:String) : §void§
      {
         var _loc2_:* = this.shop.recommendedTab.content;
         var _loc3_:MovieClip = _loc2_["Header" + this.numHeaders];
         if(_loc3_ == null)
         {
            _loc3_ = new RecommendedItemHeader();
            _loc2_["Header" + this.numHeaders] = _loc3_;
            _loc2_.addChild(_loc3_);
         }
         _loc3_.visible = true;
         _loc3_.headerText.text = param1;
         _loc3_.x = 10;
         var _loc4_:int = this.itemsInSection / this.itemsPerRow;
         if(this.itemsInSection % this.itemsPerRow > 0)
         {
            _loc4_++;
         }
         _loc3_.y = this.lastHeaderYBottom + _loc4_ * this.itemHeight + 10;
         this.itemBuildContents.push(_loc3_);
         this.numHeaders = this.numHeaders + 1;
         this.itemsInSection = 0;
         this.lastHeaderYBottom = _loc3_.y + _loc3_.height;
      }
      
      public function addItemBuildPlaceholder(param1:int) : §void§
      {
         var _loc2_:* = this.shop.recommendedTab.content;
         var _loc3_:ItemBuildPlaceholder = _loc2_["ItemPlaceholder"];
         if(_loc3_ == null)
         {
            _loc3_ = new ItemBuildPlaceholder();
            _loc2_["ItemPlaceholder"] = _loc3_;
            _loc2_.addChild(_loc3_);
         }
         _loc3_.visible = true;
         var _loc4_:int = this.itemsInSection / this.itemsPerRow;
         var _loc5_:int = this.itemsInSection % this.itemsPerRow;
         _loc3_.x = 10 + _loc5_ * this.itemWidth;
         _loc3_.y = this.lastHeaderYBottom + _loc4_ * (this.itemHeight + 2);
         this.itemBuildContents.push(_loc3_);
         this.itemsInSection++;
      }
      
      public function addItemBuildItem(param1:String, param2:String, param3:String, param4:Number, param5:Number, param6:Boolean, param7:int) : §void§
      {
         var _loc8_:* = this.shop.recommendedTab.content;
         var _loc9_:ItemBuildItem = _loc8_["ItemEntry" + this.numItems];
         if(_loc9_ == null)
         {
            _loc9_ = new ItemBuildItem();
            _loc8_["ItemEntry" + this.numItems] = _loc9_;
            _loc8_.addChild(_loc9_);
         }
         _loc9_.visible = true;
         var _loc10_:* = (param5 & 255) << 16 | param5 & 65280 | (param5 & 16711680) >> 16;
         var _loc11_:Object = {
            "itemName":param1,
            "itemImageName":param2,
            "itemColor":_loc10_,
            "secretShop":param6,
            "owned":false,
            "purchasable":false,
            "itemSlot":param7
         };
         _loc9_.itemData = _loc11_;
         var _loc12_:int = this.itemsInSection / this.itemsPerRow;
         var _loc13_:int = this.itemsInSection % this.itemsPerRow;
         _loc9_.x = 10 + _loc13_ * this.itemWidth;
         _loc9_.y = this.lastHeaderYBottom + _loc12_ * (this.itemHeight + 2);
         this.itemBuildContents.push(_loc9_);
         this.numItems++;
         this.itemsInSection++;
      }
      
      public function setItemBuildSlotPurchased(param1:Number) : §void§
      {
         var _loc2_:ItemBuildItem = this.shop.recommendedTab.content["ItemEntry" + param1];
         _loc2_.owned = true;
      }
      
      public function clearCombineTree() : *
      {
         this.shop.combineTree_container.combineTree.clear();
      }
      
      public function setCombineTreeItem(param1:String, param2:Number, param3:Boolean, param4:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setItem(param1,param2,param3,param4);
      }
      
      public function updateCombineTreeCenterItemState(param1:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.updateCombineTreeCenterItemState(param1);
      }
      
      public function updateCombineTreeComponentState(param1:Number, param2:Boolean, param3:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.updateCombineTreeComponentState(param1,param2,param3);
      }
      
      public function setCombineTreeComponent(param1:Number, param2:Number, param3:String, param4:Number, param5:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setCombineTreeComponent(param1,param2,param3,param4,param5);
      }
      
      public function setCombineTreeUpcombine(param1:Number, param2:Number, param3:String, param4:Number, param5:Boolean) : *
      {
         this.shop.combineTree_container.combineTree.setCombineTreeUpcombine(param1,param2,param3,param4,param5);
      }
      
      public function layoutCombineTree() : *
      {
         this.shop.combineTree_container.combineTree.doLayout();
      }
      
      public var inShopItemDrag:Boolean;
      
      public function onDragStart(param1:DragEvent) : *
      {
         if((param1.dragData) && (param1.dragData.shopItemName))
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
      
      public function onDragEnd(param1:DragEvent) : *
      {
         if(this.inShopItemDrag)
         {
            this.gameAPI.OnEndShopItemDrag();
            this.inShopItemDrag = false;
            this.shop.combineTree_container.combineTree.dragTarget.visible = false;
            this.shop.recommendedTab.dragTarget.visible = false;
         }
      }
      
      public function onShopItemDraggedToQuickBuy(param1:MovieClip, param2:String) : *
      {
         this.onSetQuickBuy(param2,1);
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
