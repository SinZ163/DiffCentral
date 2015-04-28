package inventory_fla
{
   import ValveLib.Globals;
   import flash.display.*;
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
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
   import scaleform.gfx.MouseEventEx;
   import ValveLib.ResizeManager;
   import ValveLib.Managers.DragManager;
   import scaleform.clik.events.DragEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.interfaces.IDataProvider;
   import scaleform.gfx.TextFieldEx;
   import scaleform.gfx.InteractiveObjectEx;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public var inventory:MovieClip;
      
      public var userMenuScalar:MovieClip;
      
      public var gameAPI:Object;
      
      public var g_bFlippedHUD:Boolean;
      
      public function onHUDFlipChanged(bFlipped:Boolean) : *
      {
         this.g_bFlippedHUD = bFlipped;
         this.onResize(Globals.instance.resizeManager);
         this.initStashSlots();
      }
      
      public var i:int;
      
      public var HUDReplacementData:Array;
      
      public function loadHUDSkinImage(imageParent:String, imageName:String) : *
      {
         var mcParent:MovieClip = null;
         var i:* = 0;
         while(i < this.HUDReplacementData.length)
         {
            if(this.HUDReplacementData[i][0] == imageParent)
            {
               mcParent = this.HUDReplacementData[i][1];
               if(mcParent)
               {
                  Globals.instance.LoadImage(imageName,mcParent,true);
               }
            }
            i++;
         }
      }
      
      public function courierButtonClick(event:MouseEvent) : *
      {
         this.gameAPI.OnCourierButtonPress();
      }
      
      public function courierAbsentClick(event:MouseEvent) : *
      {
         this.gameAPI.OnCourierAbsentClick();
      }
      
      public function courierHasteClick(event:MouseEvent) : *
      {
         this.gameAPI.OnCourierHasteClick();
      }
      
      public function courierButtonRollOver(event:MouseEvent) : *
      {
         var mc:MovieClip = this.inventory.courierState;
         var ipt:Point = new Point(mc.x,mc.y + 5);
         if(this.g_bFlippedHUD)
         {
            ipt.x = ipt.x + this.inventory.courierState.selectButtonWide.width;
         }
         ipt = this.inventory.localToGlobal(ipt);
         this.gameAPI.OnShowCourierTooltip(ipt.x,ipt.y);
         this.inventory.courierState.selectButton.gotoAndStop(2);
      }
      
      public function courierButtonRollOut(event:MouseEvent) : *
      {
         this.gameAPI.OnHideCourierTooltip();
         this.inventory.courierState.selectButton.gotoAndStop(1);
      }
      
      public function setCourierDeliverTarget(heroName:String) : *
      {
         Globals.instance.LoadHeroImage(heroName,this.inventory.courierState.delivering.deliverTargetHero);
      }
      
      public function courierDeliverButtonClick(event:MouseEvent) : *
      {
         this.gameAPI.OnCourierDeliverButtonPress();
      }
      
      public function courierDeliverButtonRollOver(event:MouseEvent) : *
      {
         var mc:MovieClip = this.inventory.courierState.deliverButton;
         var ipt:Point = new Point(mc.x,mc.y + 5);
         if(this.g_bFlippedHUD)
         {
            ipt.x = ipt.x + mc.width;
         }
         ipt = this.inventory.courierState.localToGlobal(ipt);
         this.gameAPI.OnShowCourierDeliveryTooltip(ipt.x,ipt.y);
         this.inventory.courierState.deliverButton.gotoAndStop(2);
      }
      
      public function courierDeliverButtonRollOut(event:MouseEvent) : *
      {
         this.gameAPI.OnHideCourierDeliveryTooltip();
         this.inventory.courierState.deliverButton.gotoAndStop(1);
      }
      
      public function glyphButtonClick(event:MouseEventEx) : *
      {
         if(event.buttonIdx != 0)
         {
            return;
         }
         this.gameAPI.OnGlyphButtonPress();
      }
      
      public function glyphButtonRollOver(event:MouseEvent) : *
      {
         var mc:MovieClip = this.inventory.glyphButton;
         var ipt:Point = new Point(mc.x,mc.y + mc.height / 2 - 6);
         if(this.g_bFlippedHUD)
         {
            ipt.x = ipt.x + mc.width;
         }
         ipt = this.inventory.localToGlobal(ipt);
         this.gameAPI.OnShowGlyphTooltip(ipt.x,ipt.y);
      }
      
      public function glyphButtonRollOut(event:MouseEvent) : *
      {
         this.gameAPI.OnHideGlyphTooltip();
      }
      
      public function shopButtonClick(event:MouseEventEx) : *
      {
         if(event.buttonIdx != 0)
         {
            return;
         }
         this.gameAPI.OnShopButtonPress();
      }
      
      public function showGoldTooltip(event:MouseEvent) : *
      {
         this.gameAPI.OnMouseOverShopButton(true);
      }
      
      public function hideGoldTooltip(event:MouseEvent) : *
      {
         this.inventory.goldTooltip.visible = false;
         this.gameAPI.OnMouseOverShopButton(false);
      }
      
      public function onGoldClicked(event:MouseEvent) : *
      {
         this.gameAPI.OnGoldClicked();
      }
      
      public function onLoaded() : *
      {
         Globals.instance.resizeManager.AddListener(this);
         this.gameAPI.OnReady();
         Globals.instance.GameInterface.AddMouseInputConsumer();
         this.userMenuScalar.visible = false;
         this.initInventorySlots();
         this.initStashSlots();
      }
      
      public function forceResize() : *
      {
         this.onResize(Globals.instance.resizeManager);
      }
      
      public function onResize(rm:ResizeManager) : *
      {
         var frame:* = 0;
         var aspectRatio:Number = rm.ScreenWidth / rm.ScreenHeight;
         var aspect16by9:* = aspectRatio > 1.7;
         var aspectWide:* = aspectRatio > 1.4;
         var scaleAdjust:Number = 1;
         if(aspectRatio < 1.5)
         {
            frame = 1;
            scaleAdjust = aspectRatio / 1.333;
         }
         else if(aspectRatio > 1.7)
         {
            frame = 2;
            scaleAdjust = aspectRatio / 1.7778;
         }
         else
         {
            frame = 3;
            scaleAdjust = aspectRatio / 1.6;
         }
         
         if(this.g_bFlippedHUD)
         {
            frame = frame + 3;
         }
         this.inventory.gotoAndStop(frame);
         var obj:MovieClip = this.inventory;
         if(obj["originalXScale"] == null)
         {
            obj["originalXScale"] = obj.scaleX;
            obj["originalYScale"] = obj.scaleY;
         }
         var screenHeight:Number = Globals.instance.Level0.stage.stageHeight;
         var authoredHeight:Number = 768;
         var scale:Number = screenHeight / authoredHeight * scaleAdjust;
         obj.scaleX = obj.originalXScale * scale;
         obj.scaleY = obj.originalYScale * scale;
         this.inventory.x = rm.ScreenWidth;
         this.inventory.y = rm.ScreenHeight;
         if(this.g_bFlippedHUD)
         {
            this.inventory.x = 0;
         }
         this.initInventorySlots();
         this.initStashSlots();
      }
      
      public function initInventorySlots() : *
      {
         var i:* = 0;
         var mc:InventorySlot = null;
         var ipt:Point = null;
         i = 0;
         while(i < 6)
         {
            mc = this.inventory.items["Item" + i] as InventorySlot;
            mc.addEventListener(MouseEvent.ROLL_OVER,this.onInventoryRollOver);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.onInventoryRollOut);
            mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onInventoryDown);
            mc.addEventListener(MouseEvent.MOUSE_UP,this.onInventoryUp);
            mc.itemSlot = i;
            mc.stash = false;
            mc.overState.visible = false;
            mc.dragState.visible = false;
            ipt = new Point(mc.x,mc.y);
            ipt = mc.parent.localToGlobal(ipt);
            this.gameAPI.SetupInventoryItemTooltip(ipt.x,ipt.y,i);
            i++;
         }
      }
      
      public function setInventoryItemInSlot(slot:int, itemName:String, empty:Boolean) : *
      {
         var s:MovieClip = null;
         var t:MovieClip = null;
         var u:MovieClip = null;
         var mc:InventorySlot = this.inventory.items["Item" + slot] as InventorySlot;
         if(!mc)
         {
            return;
         }
         if(empty)
         {
            mc.itemName = "";
            Globals.instance.LoadItemImage("emptyitembg",mc.itemArt);
         }
         else
         {
            mc.itemName = itemName;
            if(itemName == "radiance")
            {
               s = new s_Radiance();
               mc.itemArt.addChild(s);
            }
            else if(itemName == "mjollnir")
            {
               t = new s_mjollnir_anim();
               mc.itemArt.addChild(t);
            }
            else if(itemName == "rapier")
            {
               u = new s_rapier();
               mc.itemArt.addChild(u);
            }
            else
            {
               Globals.instance.LoadItemImage(itemName,mc.itemArt);
            }
            
            
         }
      }
      
      public function onInventoryRollOver(event:MouseEvent) : *
      {
         event.target.overState.visible = true;
         var inventorySlot:InventorySlot = event.currentTarget as InventorySlot;
         if(!inventorySlot)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            this.gameAPI.ShowInventoryItemTooltip(inventorySlot.itemSlot);
         }
      }
      
      public function onInventoryRollOut(event:MouseEvent) : *
      {
         var inventorySlot:InventorySlot = null;
         event.target.overState.visible = false;
         if((event.buttonDown) && !DragManager.inDrag())
         {
            inventorySlot = event.currentTarget as InventorySlot;
            if(inventorySlot)
            {
               if(inventorySlot.itemName.length > 0)
               {
                  inventorySlot.dragStart();
                  inventorySlot.dragState.visible = true;
                  if(this.userMenuScalar.visible == true)
                  {
                     this.hideUserMenu();
                  }
                  this.gameAPI.OnBeginDraggingInventoryItem();
               }
            }
         }
         this.gameAPI.HideInventoryItemTooltip();
      }
      
      public function onInventoryDown(event:MouseEventEx) : *
      {
         var inventorySlot:InventorySlot = null;
         if(event.buttonIdx == 1 && !DragManager.inDrag())
         {
            inventorySlot = event.currentTarget as InventorySlot;
            if(!inventorySlot)
            {
               return;
            }
            this.gameAPI.OnInventoryItemRightClick(inventorySlot.itemSlot);
         }
      }
      
      public function onInventoryUp(event:MouseEventEx) : *
      {
         var inventorySlot:InventorySlot = event.currentTarget as InventorySlot;
         if(!inventorySlot)
         {
            return;
         }
         if(!(event.buttonIdx == 1) && !DragManager.inDrag())
         {
            this.gameAPI.OnInventoryItemPressed(inventorySlot.itemSlot);
         }
      }
      
      public function initStashSlots() : *
      {
         var i:* = 0;
         var mc:InventorySlot = null;
         var ipt:Point = null;
         var ipt2:Point = null;
         i = 0;
         while(i < 6)
         {
            mc = this.inventory.stash_anim.stash["Item" + i] as InventorySlot;
            mc.addEventListener(MouseEvent.ROLL_OVER,this.onStashRollOver);
            mc.addEventListener(MouseEvent.ROLL_OUT,this.onStashRollOut);
            mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onStashDown);
            mc.itemSlot = i;
            mc.stash = true;
            mc.overState.visible = false;
            mc.dragState.visible = false;
            ipt = new Point(mc.x,mc.y);
            ipt = mc.parent.localToGlobal(ipt);
            if(this.g_bFlippedHUD)
            {
               this.inventory.stash_anim.gotoAndStop(28);
            }
            else
            {
               this.inventory.stash_anim.gotoAndStop(6);
            }
            ipt2 = new Point(mc.x,mc.y);
            ipt2 = mc.parent.localToGlobal(ipt2);
            if(this.g_bFlippedHUD)
            {
               this.inventory.stash_anim.gotoAndStop(23);
            }
            else
            {
               this.inventory.stash_anim.gotoAndStop(1);
            }
            this.gameAPI.SetupStashItemTooltip(ipt.x,ipt.y,ipt2.x,ipt2.y,i);
            i++;
         }
      }
      
      public function setStashItemInSlot(slot:int, itemName:String, empty:Boolean) : *
      {
         var mc:InventorySlot = this.inventory.stash_anim.stash["Item" + slot] as InventorySlot;
         if(!mc)
         {
            return;
         }
         if(!empty)
         {
            mc.itemName = itemName;
            Globals.instance.LoadItemImage(itemName,mc.itemArt);
         }
         else
         {
            mc.itemName = "";
            Globals.instance.LoadItemImage("emptyitembg",mc.itemArt);
         }
      }
      
      public function onStashRollOver(event:MouseEvent) : *
      {
         event.target.overState.visible = true;
         var inventorySlot:InventorySlot = event.currentTarget as InventorySlot;
         if(!inventorySlot)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            this.gameAPI.ShowStashItemTooltip(inventorySlot.itemSlot);
         }
      }
      
      public function onStashRollOut(event:MouseEvent) : *
      {
         var inventorySlot:InventorySlot = null;
         event.target.overState.visible = false;
         if((event.buttonDown) && !DragManager.inDrag())
         {
            inventorySlot = event.currentTarget as InventorySlot;
            if(inventorySlot)
            {
               inventorySlot.dragStart();
               inventorySlot.dragState.visible = true;
               if(this.userMenuScalar.visible == true)
               {
                  this.hideUserMenu();
               }
               this.gameAPI.OnBeginDraggingInventoryItem();
            }
         }
         this.gameAPI.HideStashItemTooltip();
      }
      
      public function onStashDown(event:MouseEventEx) : *
      {
         var stashSlot:* = 0;
         var inventorySlot:InventorySlot = event.currentTarget as InventorySlot;
         if(!inventorySlot)
         {
            return;
         }
         if(event.buttonIdx == 1 && !DragManager.inDrag())
         {
            stashSlot = inventorySlot.itemSlot + 6;
            this.gameAPI.OnInventoryItemRightClick(stashSlot);
         }
      }
      
      public function grabAllStash(event:Object) : *
      {
         this.gameAPI.OnGrabAllStash();
      }
      
      public function updateStash(stashVisible:Boolean, stashActive:Boolean) : *
      {
         if(stashVisible == false)
         {
            this.inventory.stash_anim.stash.gotoAndStop(1);
         }
         else if(stashActive == true)
         {
            this.inventory.stash_anim.stash.gotoAndStop(10);
         }
         else
         {
            this.inventory.stash_anim.stash.gotoAndStop(5);
         }
         
      }
      
      public function OnInventoryItemDraggedToSlot(e:DragEvent) : *
      {
         var srcSlot:InventorySlot = e.dragTarget as InventorySlot;
         if(srcSlot == null)
         {
            return;
         }
         var nSrc:* = 0;
         var nDest:* = 0;
         var destSlot:InventorySlot = e.dropTarget as InventorySlot;
         if(destSlot == null)
         {
            if(srcSlot.stash == true)
            {
               nSrc = 6;
            }
            nSrc = nSrc + srcSlot.itemSlot;
            this.gameAPI.OnInventoryItemDraggedToWorld(nSrc);
         }
         else
         {
            if(srcSlot.stash == true)
            {
               nSrc = 6;
            }
            if(destSlot.stash == true)
            {
               nDest = 6;
            }
            nSrc = nSrc + srcSlot.itemSlot;
            nDest = nDest + destSlot.itemSlot;
            this.gameAPI.OnInventoryItemDraggedToSlot(nSrc,nDest);
         }
         srcSlot.dragState.visible = false;
      }
      
      public var ignoreClick:Boolean;
      
      public function handleStageClick(event:MouseEvent) : §void§
      {
         if(this.userMenuScalar.visible)
         {
            if(this.ignoreClick)
            {
               this.ignoreClick = false;
               return;
            }
            if(this.userMenuScalar.hitTestPoint(root.mouseX,root.mouseY,false))
            {
               return;
            }
            this.hideUserMenu();
            stage.removeEventListener(MouseEvent.CLICK,this.handleStageClick);
            this.userMenuScalar.userMenu.removeEventListener(ListEvent.ITEM_CLICK,this.onUserMenuItemClick);
         }
      }
      
      public function showItemMenu(bSell:Boolean, bDisassemble:Boolean, bShopInfo:Boolean, bDropFromStash:Boolean) : *
      {
         var menuItems:Array = [];
         if(bShopInfo)
         {
            menuItems.push({
               "label":"#DOTA_InventoryMenu_ShowInShop",
               "option":3
            });
         }
         if(bDropFromStash)
         {
            menuItems.push({
               "label":"#DOTA_InventoryMenu_DropFromStash",
               "option":4
            });
         }
         if(bSell)
         {
            menuItems.push({
               "label":"#DOTA_InventoryMenu_Sell",
               "option":1
            });
         }
         if(bDisassemble)
         {
            menuItems.push({
               "label":"#DOTA_InventoryMenu_Disassemble",
               "option":2
            });
         }
         var menuContents:IDataProvider = new DataProvider(menuItems);
         this.userMenuScalar.userMenu.dataProvider = menuContents;
         this.userMenuScalar.userMenu.rowCount = menuItems.length;
         this.userMenuScalar.visible = true;
         this.userMenuScalar.x = root.mouseX;
         this.userMenuScalar.y = root.mouseY + 10;
         this.ignoreClick = true;
         if(this.userMenuScalar.x + this.userMenuScalar.width > Globals.instance.resizeManager.ScreenWidth)
         {
            this.userMenuScalar.x = Globals.instance.resizeManager.ScreenWidth - this.userMenuScalar.width;
         }
         if(this.userMenuScalar.y + this.userMenuScalar.userMenu.y + this.userMenuScalar.userMenu.height > Globals.instance.resizeManager.ScreenHeight)
         {
            this.userMenuScalar.y = Globals.instance.resizeManager.ScreenHeight - this.userMenuScalar.userMenu.height;
         }
         stage.addEventListener(MouseEvent.CLICK,this.handleStageClick);
         this.userMenuScalar.userMenu.addEventListener(ListEvent.ITEM_CLICK,this.onUserMenuItemClick);
      }
      
      public function hideUserMenu() : *
      {
         this.userMenuScalar.visible = false;
         this.gameAPI.OnRightClickMenuClosed();
      }
      
      public function closeItemMenu() : *
      {
         this.userMenuScalar.visible = false;
      }
      
      public function onUserMenuItemClick(e:ListEvent) : *
      {
         var option:int = e.itemRenderer["data"]["option"];
         switch(option)
         {
            case 1:
               this.gameAPI.OnSellItem();
               break;
            case 2:
               this.gameAPI.OnDisassembleItem();
               break;
            case 3:
               this.gameAPI.OnShowItemInShop();
               break;
            case 4:
               this.gameAPI.OnDropItemFromStash();
               break;
         }
         this.userMenuScalar.visible = false;
      }
      
      public function onClearQuickBuyPressed(event:MouseEvent) : *
      {
         this.gameAPI.OnClearQuickBuy();
      }
      
      public function setQuickBuyItem(slot:uint, itemName:String, color:Number, secretShop:Boolean) : *
      {
         var itemMC:CombineTreeItem = this.inventory.quickbuy["quickBuy" + slot];
         if(!itemMC)
         {
            return;
         }
         var data:Object = itemMC.data;
         if(!data)
         {
            data = new Object();
            data.owned = false;
            data.purchasable = false;
         }
         data.itemName = itemName;
         data.itemColor = color;
         data.secretShop = secretShop;
         data.itemSlot = slot;
         itemMC.itemData = data;
         itemMC.visible = true;
      }
      
      public function setQuickBuyStockTimer(timerText:String) : *
      {
         this.inventory.quickbuy.stockTimer.text = timerText;
      }
      
      public function onQuickBuyClick(event:MouseEvent) : *
      {
         this.gameAPI.OnQuickBuyClick();
      }
      
      public function onBuyButtonPress(itemName:String, itemSlot:uint, purchaseOrigin:int) : *
      {
         this.gameAPI.OnQuickBuyButtonClick(itemSlot);
      }
      
      public function onSetQuickBuy(itemName:String) : *
      {
      }
      
      public function onShowShopItemTooltip(itemMC:MovieClip) : *
      {
         var itemName:String = itemMC.itemName;
         if(itemName.length == 0)
         {
            return;
         }
         var ipt:Point = new Point(itemMC.x,itemMC.y);
         if(this.g_bFlippedHUD)
         {
            ipt.x = ipt.x + itemMC.width * 0.75;
         }
         ipt = itemMC.parent.localToGlobal(ipt);
         this.gameAPI.ShowQuickBuyItemTooltip(ipt.x,ipt.y,itemName);
      }
      
      public function onHideShopItemTooltip(itemMC:MovieClip) : *
      {
         this.gameAPI.HideQuickBuyItemTooltip();
      }
      
      public function onShopItemDraggedToQuickBuy(dragTarget:MovieClip, itemName:String) : *
      {
         if(!itemName || itemName.length == 0)
         {
            return;
         }
         if(dragTarget == this.inventory.quickBuyDragTarget)
         {
            this.gameAPI.OnAddQuickBuyItem(itemName);
         }
         else
         {
            this.gameAPI.OnAddStickySlotItem(itemName);
         }
      }
      
      public var inQuickBuyDrag:Boolean;
      
      public function onDragStart(e:DragEvent) : *
      {
         if((e.dragData) && (e.dragData.shopItemName))
         {
            this.gameAPI.OnBeginDraggingQuickBuyItem();
            this.inQuickBuyDrag = true;
         }
      }
      
      public function onDragEnd(e:DragEvent) : *
      {
         if(this.inQuickBuyDrag)
         {
            this.gameAPI.OnEndDraggingQuickBuyItem();
            this.inQuickBuyDrag = false;
         }
      }
      
      public function onReceivedXmasGift(slot:int) : *
      {
         var mc:MovieClip = this.inventory.items["Item" + slot];
         if(mc == null || mc.greevilingGift == null)
         {
            return;
         }
         mc.greevilingGift.gotoAndPlay(2);
         mc.greevilingGift.visible = true;
      }
      
      public function setEconItemInActionItemSlot(econItemImage:String) : *
      {
         var slotMC:MovieClip = this.inventory.actionItem.actionItem;
         if(!slotMC)
         {
            return;
         }
         if(econItemImage.length <= 0)
         {
            slotMC.visible = false;
            return;
         }
         slotMC.visible = true;
         var filename:* = "images/" + econItemImage + ".png";
         Globals.instance.LoadImage(filename,slotMC.AbilityArt,true);
      }
      
      public function onActionItemRollOver(event:MouseEvent) : *
      {
         event.target.overState.visible = true;
         var ipt:Point = new Point(event.target.x,event.target.y + event.target.height * 0.3);
         if(this.g_bFlippedHUD)
         {
            ipt.x = ipt.x + event.target.width;
         }
         ipt = event.currentTarget.parent.localToGlobal(ipt);
         this.gameAPI.OnShowActionItemTooltip(ipt.x,ipt.y);
      }
      
      public function onActionItemRollOut(event:MouseEvent) : *
      {
         event.target.overState.visible = false;
         this.gameAPI.OnHideActionItemTooltip();
      }
      
      public function onActionItemClicked(event:MouseEventEx) : *
      {
         this.gameAPI.OnActionItemClicked(event.buttonIdx);
      }
      
      public function getHighlightRectForElement(elementName:String) : *
      {
         var childName:* = undefined;
         var ipt:Point = null;
         var w:* = NaN;
         var h:* = NaN;
         var splitString:Array = elementName.split(".");
         var mc:MovieClip = this.inventory;
         while(splitString.length > 0)
         {
            childName = splitString.shift();
            mc = mc[childName];
            if(!mc)
            {
               return;
            }
         }
         if(mc)
         {
            ipt = new Point(mc.x,mc.y);
            ipt = mc.parent.localToGlobal(ipt);
            w = mc.getRect(stage).width;
            h = mc.getRect(stage).height;
            this.gameAPI.OnHighlightElement(ipt.x,ipt.y,w,h);
         }
      }
      
      function frame1() : *
      {
         TextFieldEx.setTextAutoSize(this.inventory.shopbutton.shopLabel,"shrink");
         this.inventory.shopbutton.shopLabel.text = "#DOTA_HUDShop";
         this.g_bFlippedHUD = true;
         this.inventory.gotoAndStop(2);
         InteractiveObjectEx.setHitTestDisable(this.inventory.background_4_3,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.background_wide,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.light_4_3,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.light_16_9,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.light_16_10,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.rocks_4_3,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.rocks_16_9,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.rocks_16_10,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.rightCobwebs,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.spacer,true);
         InteractiveObjectEx.setHitTestDisable(this.inventory.stash_anim.stash.glow,true);
         this.i = 0;
         while(this.i < 6)
         {
            InteractiveObjectEx.setHitTestDisable(this.inventory.items["Item" + this.i].greevilingGift,true);
            this.inventory.items["Item" + this.i].greevilingGift.visible = false;
            this.i++;
         }
         this.HUDReplacementData = [["background_4_3",this.inventory.background_4_3],["background_wide",this.inventory.background_wide],["spacer",this.inventory.spacer],["rocks_4_3",this.inventory.rocks_4_3],["rocks_16_9",this.inventory.rocks_16_9],["rocks_16_10",this.inventory.rocks_16_10],["light_4_3",this.inventory.light_4_3.content],["light_16_9",this.inventory.light_16_9.content],["light_right_16_10",this.inventory.light_16_10.content],["stash_active_lower",this.inventory.stash_anim.stash.activeLower],["stash_upper",this.inventory.stash_anim.stash.bg.bg.upper],["stash_lower",this.inventory.stash_anim.stash.bg.bg.lower]];
         this.inventory.courierState.selectButton.addEventListener(MouseEvent.CLICK,this.courierButtonClick);
         this.inventory.courierState.selectButtonWide.addEventListener(MouseEvent.CLICK,this.courierButtonClick);
         this.inventory.courierState.returning.addEventListener(MouseEvent.CLICK,this.courierButtonClick);
         this.inventory.courierState.returningWide.addEventListener(MouseEvent.CLICK,this.courierButtonClick);
         this.inventory.courierState.noCourier.addEventListener(MouseEvent.MOUSE_DOWN,this.courierAbsentClick);
         this.inventory.courierState.hasteReady.addEventListener(MouseEvent.MOUSE_DOWN,this.courierHasteClick);
         this.inventory.courierState.delivering.mouseEnabled = false;
         this.inventory.courierState.selectButton.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.selectButton_down.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.selectButtonWide.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.selectButtonWide_down.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.returning.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.returningSelected.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.returningWide.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.returningWideSelected.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.dead.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOver);
         this.inventory.courierState.selectButton.addEventListener(MouseEvent.ROLL_OUT,this.courierButtonRollOut);
         this.inventory.courierState.selectButton_down.addEventListener(MouseEvent.ROLL_OUT,this.courierButtonRollOut);
         this.inventory.courierState.selectButtonWide.addEventListener(MouseEvent.ROLL_OUT,this.courierButtonRollOut);
         this.inventory.courierState.selectButtonWide_down.addEventListener(MouseEvent.ROLL_OUT,this.courierButtonRollOut);
         this.inventory.courierState.returning.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOut);
         this.inventory.courierState.returningSelected.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOut);
         this.inventory.courierState.returningWide.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOut);
         this.inventory.courierState.returningWideSelected.addEventListener(MouseEvent.ROLL_OVER,this.courierButtonRollOut);
         this.inventory.courierState.dead.addEventListener(MouseEvent.ROLL_OUT,this.courierButtonRollOut);
         this.inventory.courierState.delivering.deliverTargetHero.addEventListener(MouseEvent.CLICK,this.courierDeliverButtonClick);
         this.inventory.courierState.deliverButton.addEventListener(MouseEvent.CLICK,this.courierDeliverButtonClick);
         this.inventory.courierState.deliverButton.addEventListener(MouseEvent.ROLL_OVER,this.courierDeliverButtonRollOver);
         this.inventory.courierState.deliverButton.addEventListener(MouseEvent.ROLL_OUT,this.courierDeliverButtonRollOut);
         this.inventory.glyphButton.addEventListener(MouseEvent.CLICK,this.glyphButtonClick);
         this.inventory.glyphButton.addEventListener(MouseEvent.ROLL_OVER,this.glyphButtonRollOver);
         this.inventory.glyphButton.addEventListener(MouseEvent.ROLL_OUT,this.glyphButtonRollOut);
         this.inventory.shopbutton.shopLabel.mouseEnabled = false;
         this.inventory.shopbutton.shopButton.addEventListener(MouseEvent.CLICK,this.shopButtonClick);
         this.inventory.goldTooltip.visible = false;
         this.inventory.gold.goldLabelDisabled.mouseEnabled = false;
         this.inventory.gold.addEventListener(MouseEvent.ROLL_OVER,this.showGoldTooltip);
         this.inventory.gold.addEventListener(MouseEvent.ROLL_OUT,this.hideGoldTooltip);
         this.inventory.gold.addEventListener(MouseEvent.MOUSE_DOWN,this.onGoldClicked);
         DragManager.init(stage);
         this.inventory.stash_anim.stash.grabAll.addEventListener(MouseEvent.CLICK,this.grabAllStash);
         this.ignoreClick = false;
         this.inventory.quickBuyDragTarget.visible = false;
         this.inventory.stickySlotDragTarget.visible = false;
         this.inventory.quickbuy.clearButton.addEventListener(MouseEvent.CLICK,this.onClearQuickBuyPressed);
         this.inventory.quickbuy.stockTimer.text = "";
         this.inventory.quickbuy.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuickBuyClick);
         this.inventory.addEventListener(DragEvent.DRAG_START,this.onDragStart);
         this.inventory.addEventListener(DragEvent.DRAG_END,this.onDragEnd);
         this.inQuickBuyDrag = false;
         this.inventory.actionItem.actionItem.addEventListener(MouseEvent.ROLL_OVER,this.onActionItemRollOver);
         this.inventory.actionItem.actionItem.addEventListener(MouseEvent.ROLL_OUT,this.onActionItemRollOut);
         this.inventory.actionItem.actionItem.addEventListener(MouseEvent.MOUSE_DOWN,this.onActionItemClicked);
         stop();
      }
   }
}
