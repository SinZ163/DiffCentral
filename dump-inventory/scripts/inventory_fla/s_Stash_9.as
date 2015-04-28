package inventory_fla
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
   
   public dynamic class s_Stash_9 extends MovieClip
   {
      
      public function s_Stash_9()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,9,this.frame10);
         this.__setProp_grabAll_s_Stash_Layer4_0();
      }
      
      public var Item3:InventorySlot;
      
      public var grabAll:ButtonThinSecondary;
      
      public var Item4:InventorySlot;
      
      public var Item5:InventorySlot;
      
      public var bg:MovieClip;
      
      public var Item0:InventorySlot;
      
      public var glow:MovieClip;
      
      public var Item1:InventorySlot;
      
      public var activeLower:MovieClip;
      
      public var Item2:InventorySlot;
      
      function __setProp_grabAll_s_Stash_Layer4_0() : *
      {
         try
         {
            this.grabAll["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.grabAll.autoRepeat = false;
         this.grabAll.autoSize = "none";
         this.grabAll.data = "";
         this.grabAll.enabled = true;
         this.grabAll.focusable = false;
         this.grabAll.label = "#DOTA_Inventory_Grab_All";
         this.grabAll.selected = false;
         this.grabAll.toggle = false;
         this.grabAll.visible = true;
         try
         {
            this.grabAll["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function frame1() : *
      {
         this.grabAll.visible = false;
         this.Item0.visible = false;
         this.Item1.visible = false;
         this.Item2.visible = false;
         this.Item3.visible = false;
         this.Item4.visible = false;
         this.Item5.visible = false;
         this.bg.visible = false;
         this.activeLower.visible = false;
         this.glow.visible = false;
         stop();
      }
      
      function frame5() : *
      {
         this.grabAll.visible = false;
         this.Item0.visible = true;
         this.Item1.visible = true;
         this.Item2.visible = true;
         this.Item3.visible = true;
         this.Item4.visible = true;
         this.Item5.visible = true;
         this.bg.visible = true;
         this.activeLower.visible = false;
         this.glow.visible = false;
         stop();
      }
      
      function frame10() : *
      {
         this.grabAll.visible = true;
         this.Item0.visible = true;
         this.Item1.visible = true;
         this.Item2.visible = true;
         this.Item3.visible = true;
         this.Item4.visible = true;
         this.Item5.visible = true;
         this.bg.visible = true;
         this.activeLower.visible = true;
         this.glow.visible = true;
         stop();
      }
   }
}
