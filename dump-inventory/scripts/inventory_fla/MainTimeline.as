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
      
      public function onHUDFlipChanged(param1:Boolean) : *
      {
         this.g_bFlippedHUD = param1;
         this.onResize(Globals.instance.resizeManager);
         this.initStashSlots();
      }
      
      public var i:int;
      
      public var HUDReplacementData:Array;
      
      public function loadHUDSkinImage(param1:String, param2:String) : *
      {
         var _loc4_:MovieClip = null;
         var _loc3_:* = 0;
         while(_loc3_ < this.HUDReplacementData.length)
         {
            if(this.HUDReplacementData[_loc3_][0] == param1)
            {
               _loc4_ = this.HUDReplacementData[_loc3_][1];
               if(_loc4_)
               {
                  Globals.instance.LoadImage(param2,_loc4_,true);
               }
            }
            _loc3_++;
         }
      }
      
      public function courierButtonClick(param1:MouseEvent) : *
      {
         this.gameAPI.OnCourierButtonPress();
      }
      
      public function courierAbsentClick(param1:MouseEvent) : *
      {
         this.gameAPI.OnCourierAbsentClick();
      }
      
      public function courierHasteClick(param1:MouseEvent) : *
      {
         this.gameAPI.OnCourierHasteClick();
      }
      
      public function courierButtonRollOver(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = this.inventory.courierState;
         var _loc3_:Point = new Point(_loc2_.x,_loc2_.y + 5);
         if(this.g_bFlippedHUD)
         {
            _loc3_.x = _loc3_.x + this.inventory.courierState.selectButtonWide.width;
         }
         _loc3_ = this.inventory.localToGlobal(_loc3_);
         this.gameAPI.OnShowCourierTooltip(_loc3_.x,_loc3_.y);
         this.inventory.courierState.selectButton.gotoAndStop(2);
      }
      
      public function courierButtonRollOut(param1:MouseEvent) : *
      {
         this.gameAPI.OnHideCourierTooltip();
         this.inventory.courierState.selectButton.gotoAndStop(1);
      }
      
      public function setCourierDeliverTarget(param1:String) : *
      {
         Globals.instance.LoadHeroImage(param1,this.inventory.courierState.delivering.deliverTargetHero);
      }
      
      public function courierDeliverButtonClick(param1:MouseEvent) : *
      {
         this.gameAPI.OnCourierDeliverButtonPress();
      }
      
      public function courierDeliverButtonRollOver(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = this.inventory.courierState.deliverButton;
         var _loc3_:Point = new Point(_loc2_.x,_loc2_.y + 5);
         if(this.g_bFlippedHUD)
         {
            _loc3_.x = _loc3_.x + _loc2_.width;
         }
         _loc3_ = this.inventory.courierState.localToGlobal(_loc3_);
         this.gameAPI.OnShowCourierDeliveryTooltip(_loc3_.x,_loc3_.y);
         this.inventory.courierState.deliverButton.gotoAndStop(2);
      }
      
      public function courierDeliverButtonRollOut(param1:MouseEvent) : *
      {
         this.gameAPI.OnHideCourierDeliveryTooltip();
         this.inventory.courierState.deliverButton.gotoAndStop(1);
      }
      
      public function glyphButtonClick(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx != 0)
         {
            return;
         }
         this.gameAPI.OnGlyphButtonPress();
      }
      
      public function glyphButtonRollOver(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = this.inventory.glyphButton;
         var _loc3_:Point = new Point(_loc2_.x,_loc2_.y + _loc2_.height / 2 - 6);
         if(this.g_bFlippedHUD)
         {
            _loc3_.x = _loc3_.x + _loc2_.width;
         }
         _loc3_ = this.inventory.localToGlobal(_loc3_);
         this.gameAPI.OnShowGlyphTooltip(_loc3_.x,_loc3_.y);
      }
      
      public function glyphButtonRollOut(param1:MouseEvent) : *
      {
         this.gameAPI.OnHideGlyphTooltip();
      }
      
      public function shopButtonClick(param1:MouseEventEx) : *
      {
         if(param1.buttonIdx != 0)
         {
            return;
         }
         this.gameAPI.OnShopButtonPress();
      }
      
      public function showGoldTooltip(param1:MouseEvent) : *
      {
         this.gameAPI.OnMouseOverShopButton(true);
      }
      
      public function hideGoldTooltip(param1:MouseEvent) : *
      {
         this.inventory.goldTooltip.visible = false;
         this.gameAPI.OnMouseOverShopButton(false);
      }
      
      public function onGoldClicked(param1:MouseEvent) : *
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
      
      public function onResize(param1:ResizeManager) : *
      {
         var _loc5_:* = 0;
         var _loc2_:Number = param1.ScreenWidth / param1.ScreenHeight;
         var _loc3_:* = _loc2_ > 1.7;
         var _loc4_:* = _loc2_ > 1.4;
         var _loc6_:Number = 1;
         if(_loc2_ < 1.5)
         {
            _loc5_ = 1;
            _loc6_ = _loc2_ / 1.333;
         }
         else if(_loc2_ > 1.7)
         {
            _loc5_ = 2;
            _loc6_ = _loc2_ / 1.7778;
         }
         else
         {
            _loc5_ = 3;
            _loc6_ = _loc2_ / 1.6;
         }
         
         if(this.g_bFlippedHUD)
         {
            _loc5_ = _loc5_ + 3;
         }
         this.inventory.gotoAndStop(_loc5_);
         var _loc7_:MovieClip = this.inventory;
         if(_loc7_["originalXScale"] == null)
         {
            _loc7_["originalXScale"] = _loc7_.scaleX;
            _loc7_["originalYScale"] = _loc7_.scaleY;
         }
         var _loc8_:Number = Globals.instance.Level0.stage.stageHeight;
         var _loc9_:Number = 768;
         var _loc10_:Number = _loc8_ / _loc9_ * _loc6_;
         _loc7_.scaleX = _loc7_.originalXScale * _loc10_;
         _loc7_.scaleY = _loc7_.originalYScale * _loc10_;
         this.inventory.x = param1.ScreenWidth;
         this.inventory.y = param1.ScreenHeight;
         if(this.g_bFlippedHUD)
         {
            this.inventory.x = 0;
         }
         this.initInventorySlots();
         this.initStashSlots();
      }
      
      public function initInventorySlots() : *
      {
         var _loc1_:* = 0;
         var _loc2_:InventorySlot = null;
         var _loc3_:Point = null;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.inventory.items["Item" + _loc1_] as InventorySlot;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onInventoryRollOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onInventoryRollOut);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onInventoryDown);
            _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onInventoryUp);
            _loc2_.itemSlot = _loc1_;
            _loc2_.stash = false;
            _loc2_.overState.visible = false;
            _loc2_.dragState.visible = false;
            _loc3_ = new Point(_loc2_.x,_loc2_.y);
            _loc3_ = _loc2_.parent.localToGlobal(_loc3_);
            this.gameAPI.SetupInventoryItemTooltip(_loc3_.x,_loc3_.y,_loc1_);
            _loc1_++;
         }
      }
      
      public function setInventoryItemInSlot(param1:int, param2:String, param3:Boolean) : *
      {
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc4_:InventorySlot = this.inventory.items["Item" + param1] as InventorySlot;
         if(!_loc4_)
         {
            return;
         }
         if(param3)
         {
            _loc4_.itemName = "";
            Globals.instance.LoadItemImage("emptyitembg",_loc4_.itemArt);
         }
         else
         {
            _loc4_.itemName = param2;
            if(param2 == "radiance")
            {
               _loc5_ = new s_Radiance();
               _loc4_.itemArt.addChild(_loc5_);
            }
            else if(param2 == "mjollnir")
            {
               _loc6_ = new s_mjollnir_anim();
               _loc4_.itemArt.addChild(_loc6_);
            }
            else if(param2 == "rapier")
            {
               _loc7_ = new s_rapier();
               _loc4_.itemArt.addChild(_loc7_);
            }
            else
            {
               Globals.instance.LoadItemImage(param2,_loc4_.itemArt);
            }
            
            
         }
      }
      
      public function onInventoryRollOver(param1:MouseEvent) : *
      {
         param1.target.overState.visible = true;
         var _loc2_:InventorySlot = param1.currentTarget as InventorySlot;
         if(!_loc2_)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            this.gameAPI.ShowInventoryItemTooltip(_loc2_.itemSlot);
         }
      }
      
      public function onInventoryRollOut(param1:MouseEvent) : *
      {
         var _loc2_:InventorySlot = null;
         param1.target.overState.visible = false;
         if((param1.buttonDown) && !DragManager.inDrag())
         {
            _loc2_ = param1.currentTarget as InventorySlot;
            if(_loc2_)
            {
               if(_loc2_.itemName.length > 0)
               {
                  _loc2_.dragStart();
                  _loc2_.dragState.visible = true;
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
      
      public function onInventoryDown(param1:MouseEventEx) : *
      {
         var _loc2_:InventorySlot = null;
         if(param1.buttonIdx == 1 && !DragManager.inDrag())
         {
            _loc2_ = param1.currentTarget as InventorySlot;
            if(!_loc2_)
            {
               return;
            }
            this.gameAPI.OnInventoryItemRightClick(_loc2_.itemSlot);
         }
      }
      
      public function onInventoryUp(param1:MouseEventEx) : *
      {
         var _loc2_:InventorySlot = param1.currentTarget as InventorySlot;
         if(!_loc2_)
         {
            return;
         }
         if(!(param1.buttonIdx == 1) && !DragManager.inDrag())
         {
            this.gameAPI.OnInventoryItemPressed(_loc2_.itemSlot);
         }
      }
      
      public function initStashSlots() : *
      {
         var _loc1_:* = 0;
         var _loc2_:InventorySlot = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.inventory.stash_anim.stash["Item" + _loc1_] as InventorySlot;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onStashRollOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onStashRollOut);
            _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onStashDown);
            _loc2_.itemSlot = _loc1_;
            _loc2_.stash = true;
            _loc2_.overState.visible = false;
            _loc2_.dragState.visible = false;
            _loc3_ = new Point(_loc2_.x,_loc2_.y);
            _loc3_ = _loc2_.parent.localToGlobal(_loc3_);
            if(this.g_bFlippedHUD)
            {
               this.inventory.stash_anim.gotoAndStop(28);
            }
            else
            {
               this.inventory.stash_anim.gotoAndStop(6);
            }
            _loc4_ = new Point(_loc2_.x,_loc2_.y);
            _loc4_ = _loc2_.parent.localToGlobal(_loc4_);
            if(this.g_bFlippedHUD)
            {
               this.inventory.stash_anim.gotoAndStop(23);
            }
            else
            {
               this.inventory.stash_anim.gotoAndStop(1);
            }
            this.gameAPI.SetupStashItemTooltip(_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,_loc1_);
            _loc1_++;
         }
      }
      
      public function setStashItemInSlot(param1:int, param2:String, param3:Boolean) : *
      {
         var _loc4_:InventorySlot = this.inventory.stash_anim.stash["Item" + param1] as InventorySlot;
         if(!_loc4_)
         {
            return;
         }
         if(!param3)
         {
            _loc4_.itemName = param2;
            Globals.instance.LoadItemImage(param2,_loc4_.itemArt);
         }
         else
         {
            _loc4_.itemName = "";
            Globals.instance.LoadItemImage("emptyitembg",_loc4_.itemArt);
         }
      }
      
      public function onStashRollOver(param1:MouseEvent) : *
      {
         param1.target.overState.visible = true;
         var _loc2_:InventorySlot = param1.currentTarget as InventorySlot;
         if(!_loc2_)
         {
            return;
         }
         if(!DragManager.inDrag())
         {
            this.gameAPI.ShowStashItemTooltip(_loc2_.itemSlot);
         }
      }
      
      public function onStashRollOut(param1:MouseEvent) : *
      {
         var _loc2_:InventorySlot = null;
         param1.target.overState.visible = false;
         if((param1.buttonDown) && !DragManager.inDrag())
         {
            _loc2_ = param1.currentTarget as InventorySlot;
            if(_loc2_)
            {
               _loc2_.dragStart();
               _loc2_.dragState.visible = true;
               if(this.userMenuScalar.visible == true)
               {
                  this.hideUserMenu();
               }
               this.gameAPI.OnBeginDraggingInventoryItem();
            }
         }
         this.gameAPI.HideStashItemTooltip();
      }
      
      public function onStashDown(param1:MouseEventEx) : *
      {
         var _loc3_:* = 0;
         var _loc2_:InventorySlot = param1.currentTarget as InventorySlot;
         if(!_loc2_)
         {
            return;
         }
         if(param1.buttonIdx == 1 && !DragManager.inDrag())
         {
            _loc3_ = _loc2_.itemSlot + 6;
            this.gameAPI.OnInventoryItemRightClick(_loc3_);
         }
      }
      
      public function grabAllStash(param1:Object) : *
      {
         this.gameAPI.OnGrabAllStash();
      }
      
      public function updateStash(param1:Boolean, param2:Boolean) : *
      {
         if(param1 == false)
         {
            this.inventory.stash_anim.stash.gotoAndStop(1);
         }
         else if(param2 == true)
         {
            this.inventory.stash_anim.stash.gotoAndStop(10);
         }
         else
         {
            this.inventory.stash_anim.stash.gotoAndStop(5);
         }
         
      }
      
      public function OnInventoryItemDraggedToSlot(param1:DragEvent) : *
      {
         var _loc2_:InventorySlot = param1.dragTarget as InventorySlot;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:InventorySlot = param1.dropTarget as InventorySlot;
         if(_loc5_ == null)
         {
            if(_loc2_.stash == true)
            {
               _loc3_ = 6;
            }
            _loc3_ = _loc3_ + _loc2_.itemSlot;
            this.gameAPI.OnInventoryItemDraggedToWorld(_loc3_);
         }
         else
         {
            if(_loc2_.stash == true)
            {
               _loc3_ = 6;
            }
            if(_loc5_.stash == true)
            {
               _loc4_ = 6;
            }
            _loc3_ = _loc3_ + _loc2_.itemSlot;
            _loc4_ = _loc4_ + _loc5_.itemSlot;
            this.gameAPI.OnInventoryItemDraggedToSlot(_loc3_,_loc4_);
         }
         _loc2_.dragState.visible = false;
      }
      
      public var ignoreClick:Boolean;
      
      public function handleStageClick(param1:MouseEvent) : §void§
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
      
      public function showItemMenu(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : *
      {
         var _loc5_:Array = [];
         if(param3)
         {
            _loc5_.push({
               "label":"#DOTA_InventoryMenu_ShowInShop",
               "option":3
            });
         }
         if(param4)
         {
            _loc5_.push({
               "label":"#DOTA_InventoryMenu_DropFromStash",
               "option":4
            });
         }
         if(param1)
         {
            _loc5_.push({
               "label":"#DOTA_InventoryMenu_Sell",
               "option":1
            });
         }
         if(param2)
         {
            _loc5_.push({
               "label":"#DOTA_InventoryMenu_Disassemble",
               "option":2
            });
         }
         var _loc6_:IDataProvider = new DataProvider(_loc5_);
         this.userMenuScalar.userMenu.dataProvider = _loc6_;
         this.userMenuScalar.userMenu.rowCount = _loc5_.length;
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
      
      public function onUserMenuItemClick(param1:ListEvent) : *
      {
         var _loc2_:int = param1.itemRenderer["data"]["option"];
         switch(_loc2_)
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
      
      public function onClearQuickBuyPressed(param1:MouseEvent) : *
      {
         this.gameAPI.OnClearQuickBuy();
      }
      
      public function setQuickBuyItem(param1:uint, param2:String, param3:Number, param4:Boolean) : *
      {
         var _loc5_:CombineTreeItem = this.inventory.quickbuy["quickBuy" + param1];
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:Object = _loc5_.data;
         if(!_loc6_)
         {
            _loc6_ = new Object();
            _loc6_.owned = false;
            _loc6_.purchasable = false;
         }
         _loc6_.itemName = param2;
         _loc6_.itemColor = param3;
         _loc6_.secretShop = param4;
         _loc6_.itemSlot = param1;
         _loc5_.itemData = _loc6_;
         _loc5_.visible = true;
      }
      
      public function setQuickBuyStockTimer(param1:String) : *
      {
         this.inventory.quickbuy.stockTimer.text = param1;
      }
      
      public function onQuickBuyClick(param1:MouseEvent) : *
      {
         this.gameAPI.OnQuickBuyClick();
      }
      
      public function onBuyButtonPress(param1:String, param2:uint, param3:int) : *
      {
         this.gameAPI.OnQuickBuyButtonClick(param2);
      }
      
      public function onSetQuickBuy(param1:String) : *
      {
      }
      
      public function onShowShopItemTooltip(param1:MovieClip) : *
      {
         var _loc2_:String = param1.itemName;
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc3_:Point = new Point(param1.x,param1.y);
         if(this.g_bFlippedHUD)
         {
            _loc3_.x = _loc3_.x + param1.width * 0.75;
         }
         _loc3_ = param1.parent.localToGlobal(_loc3_);
         this.gameAPI.ShowQuickBuyItemTooltip(_loc3_.x,_loc3_.y,_loc2_);
      }
      
      public function onHideShopItemTooltip(param1:MovieClip) : *
      {
         this.gameAPI.HideQuickBuyItemTooltip();
      }
      
      public function onShopItemDraggedToQuickBuy(param1:MovieClip, param2:String) : *
      {
         if(!param2 || param2.length == 0)
         {
            return;
         }
         if(param1 == this.inventory.quickBuyDragTarget)
         {
            this.gameAPI.OnAddQuickBuyItem(param2);
         }
         else
         {
            this.gameAPI.OnAddStickySlotItem(param2);
         }
      }
      
      public var inQuickBuyDrag:Boolean;
      
      public function onDragStart(param1:DragEvent) : *
      {
         if((param1.dragData) && (param1.dragData.shopItemName))
         {
            this.gameAPI.OnBeginDraggingQuickBuyItem();
            this.inQuickBuyDrag = true;
         }
      }
      
      public function onDragEnd(param1:DragEvent) : *
      {
         if(this.inQuickBuyDrag)
         {
            this.gameAPI.OnEndDraggingQuickBuyItem();
            this.inQuickBuyDrag = false;
         }
      }
      
      public function onReceivedXmasGift(param1:int) : *
      {
         var _loc2_:MovieClip = this.inventory.items["Item" + param1];
         if(_loc2_ == null || _loc2_.greevilingGift == null)
         {
            return;
         }
         _loc2_.greevilingGift.gotoAndPlay(2);
         _loc2_.greevilingGift.visible = true;
      }
      
      public function setEconItemInActionItemSlot(param1:String) : *
      {
         var _loc2_:MovieClip = this.inventory.actionItem.actionItem;
         if(!_loc2_)
         {
            return;
         }
         if(param1.length <= 0)
         {
            _loc2_.visible = false;
            return;
         }
         _loc2_.visible = true;
         var _loc3_:* = "images/" + param1 + ".png";
         Globals.instance.LoadImage(_loc3_,_loc2_.AbilityArt,true);
      }
      
      public function onActionItemRollOver(param1:MouseEvent) : *
      {
         param1.target.overState.visible = true;
         var _loc2_:Point = new Point(param1.target.x,param1.target.y + param1.target.height * 0.3);
         if(this.g_bFlippedHUD)
         {
            _loc2_.x = _loc2_.x + param1.target.width;
         }
         _loc2_ = param1.currentTarget.parent.localToGlobal(_loc2_);
         this.gameAPI.OnShowActionItemTooltip(_loc2_.x,_loc2_.y);
      }
      
      public function onActionItemRollOut(param1:MouseEvent) : *
      {
         param1.target.overState.visible = false;
         this.gameAPI.OnHideActionItemTooltip();
      }
      
      public function onActionItemClicked(param1:MouseEventEx) : *
      {
         this.gameAPI.OnActionItemClicked(param1.buttonIdx);
      }
      
      public function getHighlightRectForElement(param1:String) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:Point = null;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc2_:Array = param1.split(".");
         var _loc3_:MovieClip = this.inventory;
         while(_loc2_.length > 0)
         {
            _loc4_ = _loc2_.shift();
            _loc3_ = _loc3_[_loc4_];
            if(!_loc3_)
            {
               return;
            }
         }
         if(_loc3_)
         {
            _loc5_ = new Point(_loc3_.x,_loc3_.y);
            _loc5_ = _loc3_.parent.localToGlobal(_loc5_);
            _loc6_ = _loc3_.getRect(stage).width;
            _loc7_ = _loc3_.getRect(stage).height;
            this.gameAPI.OnHighlightElement(_loc5_.x,_loc5_.y,_loc6_,_loc7_);
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
