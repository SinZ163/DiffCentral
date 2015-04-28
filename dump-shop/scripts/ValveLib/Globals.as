package ValveLib
{
   import flash.display.MovieClip;
   import scaleform.clik.managers.InputDelegate;
   import flash.display.StageScaleMode;
   import flash.display.StageAlign;
   import flash.events.Event;
   import scaleform.clik.core.UIComponent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.Bitmap;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;
   import flash.display.Scene;
   import scaleform.gfx.InteractiveObjectEx;
   
   public dynamic class Globals extends Object
   {
      
      public function Globals()
      {
         this.cachedImageData = {};
         super();
      }
      
      public static var instance:Globals = null;
      
      public static function Create(level:MovieClip) : *
      {
         if(instance == null)
         {
            instance = new Globals();
            instance.Init(level);
         }
         return instance;
      }
      
      public var UISlot:Number = 0;
      
      public var noInvisibleAdvance:Boolean = true;
      
      public var Level0:MovieClip = null;
      
      public var ElementDepths;
      
      public var GameInterface:Object = null;
      
      public var PlatformCode:Number;
      
      public var resizeManager:ResizeManager = null;
      
      public var cachedImageData:Object;
      
      public function Init(level:MovieClip) : *
      {
         InputDelegate.getInstance().externalInputHandler = this.customInputHandler;
         this.Level0 = level;
         level.stage.scaleMode = StageScaleMode.NO_SCALE;
         level.stage.align = StageAlign.TOP_LEFT;
         if(this.resizeManager == null)
         {
            this.resizeManager = new ResizeManager();
            this.resizeManager.AuthoredWidth = level.stage.stageWidth;
            this.resizeManager.AuthoredHeight = level.stage.stageHeight;
            this.resizeManager.OnStageResize();
            level.stage.addEventListener(Event.RESIZE,this.onStageResize);
         }
         if(UIComponent.sdkVersion != "4.2.23")
         {
            trace("Warning: UI file compiled with incorrect SDK version");
         }
      }
      
      public function onStageResize(evt:Event) : *
      {
         if(this.resizeManager)
         {
            this.resizeManager.OnStageResize();
         }
      }
      
      public function debugPrintChildren(mc:*, recurse:Boolean = true, tabDepth:Number = 0) : *
      {
         var i:* = NaN;
         var child:DisplayObject = null;
         if(mc == null)
         {
            return;
         }
         i = 0;
         while(i < mc.numChildren)
         {
            child = mc.getChildAt(i);
            trace(this.debugTabs(tabDepth),child.name,child,"(",child.visible,child.x,child.y,child.width,child.height,")");
            if((recurse) && child is DisplayObjectContainer)
            {
               this.debugPrintChildren(child,true,tabDepth + 1);
            }
            i++;
         }
      }
      
      public function parentFrontpageCellToFrontpage(frontpageCell:MovieClip) : *
      {
         var frontpageMovie:DisplayObjectContainer = null;
         var frontpage:MovieClip = null;
         var contentMC:MovieClip = null;
         var i:* = 0;
         var frontpageLoader:* = Globals.instance.Level0.getChildByName("frontpage_loader");
         if(frontpageLoader != null)
         {
            frontpageMovie = frontpageLoader.getChildAt(0) as DisplayObjectContainer;
            if(frontpageMovie != null)
            {
               frontpage = frontpageMovie.getChildByName("frontpage") as MovieClip;
               if((frontpage) && !(frontpage.ScrollViewContainer.content.getChildByName(frontpageCell.name) == null))
               {
                  contentMC = frontpage.ScrollViewContainer.content.getChildByName(frontpageCell.name).content;
                  i = contentMC.numChildren - 1;
                  while(i >= 0)
                  {
                     contentMC.removeChildAt(i);
                     i--;
                  }
                  contentMC.addChild(frontpageCell);
                  frontpageCell.x = 0;
                  frontpageCell.y = 0;
               }
            }
         }
      }
      
      public function debugPrintParent(mc:*) : *
      {
         if(mc == null)
         {
            return;
         }
         var tabDepth:* = 0;
         while(mc != null)
         {
            trace(this.debugTabs(tabDepth),mc.name,mc + " (width,height " + mc.width + ", " + mc.height + " - (scale " + mc.scaleX + ", " + mc.scaleY + ")");
            var mc:* = mc.parent;
            tabDepth++;
         }
      }
      
      public function debugTabs(tabDepth:Number) : String
      {
         var i:* = NaN;
         var s:String = "";
         i = 0;
         while(i < tabDepth)
         {
            s = s + "   ";
            i++;
         }
         return s;
      }
      
      public function RequestElement(elementID:String, depth:Number, gameAPI:Object) : *
      {
         var elementLoader:ElementLoader = null;
         if(depth != 0.0)
         {
            this.ElementDepths[elementID] = depth;
         }
         if((this.ElementDepths) && (this.ElementDepths[elementID]))
         {
            elementLoader = this["Loader_" + elementID] as ElementLoader;
            if(elementLoader == null)
            {
               elementLoader = new ElementLoader();
               this["Loader_" + elementID] = elementLoader;
            }
            elementLoader.Init(this.Level0,gameAPI,this.ElementDepths[elementID],elementID);
         }
      }
      
      public function RemoveElement(mc:MovieClip) : *
      {
         var loaderName:String = null;
         var elementLoader:ElementLoader = null;
         if(mc == null)
         {
            trace("RemoveElement: mc is null");
            return;
         }
         trace("RemoveElement " + mc + " ID = " + mc["elementName"]);
         if(mc["gameAPI"].OnUnload(mc))
         {
            loaderName = "Loader_" + mc["elementName"];
            trace(" Looking up element loader: " + loaderName);
            elementLoader = this[loaderName] as ElementLoader;
            if(elementLoader != null)
            {
               elementLoader.Unload();
               this[loaderName] = null;
               elementLoader = null;
            }
            else
            {
               trace("  Failed to find element loader");
            }
         }
         else
         {
            trace(" OnUnload failed");
         }
      }
      
      public function SetElementDepth(element:MovieClip, depth:Number) : *
      {
         var otherLoader:Loader = null;
         if(element == null || !element.hasOwnProperty("elementName"))
         {
            trace("SetElementDepth failed. First argument has no elementName: " + element);
            return;
         }
         var elementID:String = element["elementID"];
         var loaderName:String = "Loader_" + elementID;
         var elementLoader:ElementLoader = this[loaderName] as ElementLoader;
         if(elementLoader == null || elementLoader.loader == null)
         {
            trace("SetElementDepth failed. Couldn\'t find elementLoader called " + loaderName);
            return;
         }
         if(elementLoader.loader.parent != this.Level0)
         {
            trace("SetElementDepth failed. Loader " + loaderName + " is not a child of Level0");
            return;
         }
         this.ElementDepths[elementID] = depth;
         var targetChildIndex:Number = -1;
         var numChild:Number = this.Level0.numChildren;
         var i:Number = 0;
         while(i < numChild)
         {
            if(this.Level0.getChildAt(i) is Loader)
            {
               otherLoader = this.Level0.getChildAt(i) as Loader;
               if(otherLoader.tabIndex > depth)
               {
                  targetChildIndex = i;
                  break;
               }
            }
            i++;
         }
         if(targetChildIndex == -1)
         {
            trace("SetElementDepth failed. Couldn\'t find an appropriate index to achieve the specified depth.");
            return;
         }
         this.Level0.setChildIndex(elementLoader.loader,targetChildIndex);
      }
      
      public function SetConvars(vars:Object) : *
      {
         var name:String = null;
         var val:* = undefined;
         for(name in vars)
         {
            val = vars[name];
            if(val != undefined)
            {
               switch(typeof val)
               {
                  case "string":
                  case "number":
                  case "boolean":
                     this.GameInterface.SetConvar(name,val);
                     continue;
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
      }
      
      public function TraceObject(o:Object, whitespace:String) : *
      {
         var count:* = NaN;
         var len:* = NaN;
         var name:String = null;
         if(!whitespace)
         {
            var whitespace:String = "";
         }
         var newwhitespace:* = whitespace + "  ";
         if(typeof o == "object")
         {
            if(o is Array)
            {
               trace(whitespace + "[");
               count = 0;
               len = o.length;
               while(count < len)
               {
                  this.TraceObject(o[count],newwhitespace);
                  count = count + 1;
               }
               trace(whitespace + "]");
            }
            else
            {
               trace(whitespace + "{");
               for(name in o)
               {
                  trace(newwhitespace + name + "=");
                  this.TraceObject(o[name],newwhitespace);
               }
               trace(whitespace + "}");
            }
         }
         else
         {
            trace(whitespace + "  " + o.toString());
         }
      }
      
      public function IsPC() : Boolean
      {
         return this.PlatformCode == 0;
      }
      
      public function IsXbox() : Boolean
      {
         return this.PlatformCode == 1;
      }
      
      public function IsPS3() : Boolean
      {
         return this.PlatformCode == 2;
      }
      
      public function LoadMiniHeroImage(heroName:String, targetMC:MovieClip) : *
      {
         if(heroName == null || heroName.length == 0)
         {
            return;
         }
         this.LoadImage("images/miniheroes/" + heroName + ".png",targetMC,false);
      }
      
      public function LoadEconBrandImage(brandName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(brandName == null || brandName.length == 0)
         {
            return;
         }
         this.LoadImage("images/" + brandName + ".png",targetMC,false);
      }
      
      public function LoadHeroImage(heroName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(heroName == null || heroName.length == 0)
         {
            return;
         }
         this.LoadImage("images/heroes/" + heroName + ".png",targetMC,false);
      }
      
      public function LoadItemImage(itemName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(itemName == null || itemName.length == 0)
         {
            return;
         }
         this.LoadImage("images/items/" + itemName + ".png",targetMC,false);
      }
      
      public function LoadEconItemImage(itemName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(itemName == null || itemName.length == 0)
         {
            return;
         }
         this.LoadImage("images/" + itemName + ".png",targetMC,false);
      }
      
      public function LoadHeroModelImage(heroName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(heroName == null || heroName.length == 0)
         {
            return;
         }
         this.LoadImage("images/heroes_full/" + heroName + ".png",targetMC,false);
      }
      
      public var NumAvatars = 11;
      
      public function LoadAvatarImage(avatarNum:Number, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         var imageName:String = "images/dashboard/avatars/avatar_puck.png";
         switch(avatarNum)
         {
            case 0:
               imageName = "images/dashboard/avatars/avatar_creep.png";
               break;
            case 1:
               imageName = "images/dashboard/avatars/avatar_crystal_maiden.png";
               break;
            case 2:
               imageName = "images/dashboard/avatars/avatar_kunkka.png";
               break;
            case 3:
               imageName = "images/dashboard/avatars/avatar_faceless_void.png";
               break;
            case 4:
               imageName = "images/dashboard/avatars/avatar_furion.png";
               break;
            case 5:
               imageName = "images/dashboard/avatars/avatar_juggernaut.png";
               break;
            case 6:
               imageName = "images/dashboard/avatars/avatar_bloodseeker.png";
               break;
            case 7:
               imageName = "images/dashboard/avatars/avatar_lich.png";
               break;
            case 8:
               imageName = "images/dashboard/avatars/avatar_axe.png";
               break;
            case 9:
               imageName = "images/dashboard/avatars/avatar_pudge.png";
               break;
            case 10:
               imageName = "images/dashboard/avatars/avatar_puck.png";
               break;
         }
         this.LoadImage(imageName,targetMC,false);
      }
      
      public function LoadAbilityImage(abilityName:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(abilityName == null || abilityName.length == 0)
         {
            return;
         }
         this.LoadImage("images/spellicons/" + abilityName + ".png",targetMC,false);
      }
      
      public function LoadTeamLogo(image:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         if(image == null || image.length == 0)
         {
            var image:String = "team_radiant";
         }
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         this.LoadImage("images/teams/" + image + ".png",targetMC,false);
      }
      
      public function LoadTournamentPlayerImage(playerImage:String, targetMC:MovieClip) : *
      {
         var i:* = 0;
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(playerImage == null || playerImage.length == 0)
         {
            return;
         }
         this.LoadImage("images/players/" + playerImage + ".png",targetMC,false);
      }
      
      public function LoadImage(imageName:String, targetMC:MovieClip, bResize:Boolean) : *
      {
         this.LoadImageWithCallback(imageName,targetMC,bResize,null);
      }
      
      public function RemoveImageFromCache(imageName:String) : *
      {
         if(this.cachedImageData[imageName] != null)
         {
            this.cachedImageData[imageName] = null;
         }
      }
      
      public function LoadImageWithFallback(imageName:String, targetMC:MovieClip, bResize:Boolean, fallbackImageName:String) : *
      {
         targetMC["fallback_image"] = fallbackImageName;
         targetMC["fallback_resize"] = bResize;
         this.LoadImageWithCallback(imageName,targetMC,bResize,null);
      }
      
      public function imageLoadError(e:Event) : *
      {
         var targetMC:MovieClip = e.target.loader.parent as MovieClip;
         if(!(targetMC == null) && !(targetMC["fallback_image"] == undefined) && targetMC["fallback_image"].length > 0)
         {
            this.LoadImageWithCallback(targetMC["fallback_image"],targetMC,targetMC["fallback_resize"],null);
         }
      }
      
      public function LoadImageWithCallback(imageName:String, targetMC:MovieClip, bResize:Boolean, callbackFunc:Function) : *
      {
         var i:* = 0;
         var loader:Loader = null;
         var img:Bitmap = null;
         if((bResize) && targetMC["originalWidth"] == null)
         {
            targetMC["originalWidth"] = targetMC.width / targetMC.scaleX;
            targetMC["originalHeight"] = targetMC.height / targetMC.scaleY;
         }
         i = targetMC.numChildren - 1;
         while(i >= 0)
         {
            targetMC.removeChildAt(i);
            i--;
         }
         if(imageName == null || imageName.length == 0)
         {
            return;
         }
         if(this.cachedImageData[imageName] == null)
         {
            loader = new Loader();
            loader["imageName"] = imageName;
            loader["resize"] = bResize;
            loader["callbackfunc"] = callbackFunc;
            loader.load(new URLRequest(imageName));
            loader.visible = false;
            targetMC.addChild(loader);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.imageLoadComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.imageLoadError);
         }
         else
         {
            img = new Bitmap(this.cachedImageData[imageName],"auto",true);
            img.smoothing = true;
            targetMC.addChild(img);
            if(bResize)
            {
               img.width = targetMC["originalWidth"];
               img.height = targetMC["originalHeight"];
            }
            if(callbackFunc != null)
            {
               callbackFunc(img);
            }
         }
      }
      
      public function PrecacheImage(imageName:String) : *
      {
         if(imageName == null || imageName.length == 0)
         {
            return true;
         }
         if(this.cachedImageData[imageName] != null)
         {
            trace(imageName + " already precached");
            return true;
         }
         var loader:Loader = new Loader();
         loader["imageName"] = imageName;
         loader.load(new URLRequest(imageName));
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.precacheImageComplete);
         trace(imageName + " was NOT precached");
         return false;
      }
      
      public function precacheImageComplete(e:Event) : *
      {
         e.target.removeEventListener(Event.COMPLETE,this.precacheImageComplete);
         var img:Bitmap = e.target.content as Bitmap;
         this.cachedImageData[e.target.loader["imageName"]] = img.bitmapData;
      }
      
      public function imageLoadComplete(e:Event) : *
      {
         var callback:Function = null;
         e.target.removeEventListener(Event.COMPLETE,this.imageLoadComplete);
         var img:Bitmap = e.target.content as Bitmap;
         this.cachedImageData[e.target.loader["imageName"]] = img.bitmapData;
         img.smoothing = true;
         if(e.target.loader["resize"])
         {
            if(!(e.target.loader.parent == null) && !(e.target.content == null))
            {
               e.target.content.width = e.target.loader.parent["originalWidth"];
               e.target.content.height = e.target.loader.parent["originalHeight"];
            }
         }
         e.target.loader.visible = true;
         if(e.target.loader["callbackfunc"])
         {
            callback = e.target.loader["callbackfunc"];
            callback(e.target.content);
         }
      }
      
      public function customInputHandler(type:String, code:Number, value:* = null) : *
      {
      }
      
      public function getFrameNumberFromLabel(targetMC:MovieClip, labelName:String) : int
      {
         var scene:Scene = targetMC.currentScene;
         var i:* = 0;
         while(i < scene.labels.length)
         {
            if(scene.labels[i].name == labelName)
            {
               return scene.labels[i].frame;
            }
            i++;
         }
         return -1;
      }
      
      public function setMouseInputEnabled(targetMC:MovieClip, bEnable:Boolean) : §void§
      {
         InteractiveObjectEx.setHitTestDisable(targetMC,!bEnable);
      }
   }
}
