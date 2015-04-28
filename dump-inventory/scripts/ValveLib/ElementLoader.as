package ValveLib
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.display.DisplayObjectContainer;
   
   public class ElementLoader extends Object
   {
      
      public function ElementLoader()
      {
         super();
      }
      
      public var gameAPI:Object;
      
      public var level:Number;
      
      public var loader:Loader;
      
      public var elementName:String;
      
      public var slot:Number;
      
      public var channel:Number;
      
      public var movieClip:MovieClip;
      
      public function Init(mcParent:MovieClip, newElementGameAPI:Object, level:Number, newElementName:String) : *
      {
         var targetChildIndex:* = NaN;
         var numChild:* = NaN;
         var i:* = NaN;
         var otherLoader:Loader = null;
         var url:* = newElementName + ".swf";
         if(this.loader == null)
         {
            this.loader = new Loader();
            this.loader.name = newElementName + "_loader";
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.OnLoadProgress);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadingComplete);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            targetChildIndex = -1;
            this.loader.tabIndex = level;
            numChild = mcParent.numChildren;
            i = 0;
            while(i < numChild)
            {
               if(mcParent.getChildAt(i) is Loader)
               {
                  otherLoader = mcParent.getChildAt(i) as Loader;
                  if(otherLoader.tabIndex > level)
                  {
                     targetChildIndex = i;
                     break;
                  }
               }
               i++;
            }
            mcParent.addChild(this.loader);
            this.loader.visible = false;
            if(targetChildIndex != -1)
            {
               mcParent.setChildIndex(this.loader,targetChildIndex);
            }
            this.gameAPI = newElementGameAPI;
            this.elementName = newElementName;
         }
         this.loader.load(new URLRequest(url));
      }
      
      public function onLoadingComplete(evt:Event) : *
      {
         this.loader.visible = true;
         this.movieClip = this.loader.content as MovieClip;
         this.movieClip["gameAPI"] = this.gameAPI;
         this.movieClip["elementName"] = this.elementName;
         if(this.movieClip.hasOwnProperty("globals"))
         {
            this.movieClip["globals"] = Globals.instance;
         }
         this.gameAPI.OnLoadFinished(this.movieClip,Globals.instance.UISlot);
         this.movieClip.onLoaded();
         if(!this.movieClip.hasOwnProperty("onResize"))
         {
            Globals.instance.resizeManager.AddListener(this.movieClip);
         }
      }
      
      public function OnLoadProgress(evt:ProgressEvent) : *
      {
         this.gameAPI.OnLoadProgress(this.loader.content,evt.bytesLoaded,evt.bytesTotal);
      }
      
      public function onIOError(evt:IOErrorEvent) : *
      {
         trace("onIOError " + this.elementName);
         this.gameAPI.OnLoadError(this.loader.content,0);
      }
      
      public function Unload() : *
      {
         var p:DisplayObjectContainer = this.loader.parent;
         this.movieClip = this.loader.content as MovieClip;
         if(!(this.movieClip == null) && (this.movieClip.hasOwnProperty("onUnloaded")))
         {
            this.movieClip.onUnloaded();
         }
         Globals.instance.resizeManager.RemoveListener(this.movieClip);
         if(this.loader.contentLoaderInfo != null)
         {
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.OnLoadProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadingComplete);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         }
         p.removeChild(this.loader);
         this.movieClip = null;
         this.loader.unload();
         this.loader = null;
      }
   }
}
