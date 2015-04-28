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
   
   public dynamic class ShopToolsContents_15 extends MovieClip
   {
      
      public function ShopToolsContents_15()
      {
         super();
         this.__setProp_searchBox_ShopToolsContents_Layer1_0();
      }
      
      public var viewModeList:MovieClip;
      
      public var clearSearch:MovieClip;
      
      public var suggestedDisable:MovieClip;
      
      public var viewModeGrid:MovieClip;
      
      public var suggestedButton:MovieClip;
      
      public var searchBox:InputBoxSkinned;
      
      function __setProp_searchBox_ShopToolsContents_Layer1_0() : *
      {
         try
         {
            this.searchBox["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.searchBox.actAsButton = false;
         this.searchBox.displayAsPassword = false;
         this.searchBox.editable = true;
         this.searchBox.enabled = true;
         this.searchBox.focusable = true;
         this.searchBox.maxChars = 32;
         this.searchBox.text = "";
         this.searchBox.visible = true;
         try
         {
            this.searchBox["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
