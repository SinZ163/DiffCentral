package
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
   
   public dynamic class MainShopAnimate extends MovieClip
   {
      
      public function MainShopAnimate()
      {
         super();
         this.__setProp_tab2Button_MainShopAnimate_upgradstabbar_0();
         this.__setProp_tab1Button_MainShopAnimate_upgradstabbar_0();
      }
      
      public var tab1Button:MovieClip;
      
      public var tab2Button:MovieClip;
      
      public var tab1:MovieClip;
      
      public var tab2:MovieClip;
      
      function __setProp_tab2Button_MainShopAnimate_upgradstabbar_0() : *
      {
         try
         {
            this.tab2Button["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.tab2Button.autoSize = "none";
         this.tab2Button.disableConstraints = false;
         this.tab2Button.disabled = false;
         this.tab2Button.disableFocus = false;
         this.tab2Button.enableInitCallback = true;
         this.tab2Button.label = "UPGRADES";
         this.tab2Button.soundMap = {
            "theme":"default",
            "focusIn":"focusIn",
            "focusOut":"focusOut",
            "select":"select",
            "rollOver":"rollOver",
            "rollOut":"rollOut",
            "press":"press",
            "doubleClick":"doubleClick",
            "click":"click"
         };
         this.tab2Button.toggle = false;
         this.tab2Button.visible = true;
         try
         {
            this.tab2Button["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_tab1Button_MainShopAnimate_upgradstabbar_0() : *
      {
         try
         {
            this.tab1Button["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.tab1Button.autoSize = "right";
         this.tab1Button.disableConstraints = false;
         this.tab1Button.disabled = false;
         this.tab1Button.disableFocus = false;
         this.tab1Button.enableInitCallback = true;
         this.tab1Button.label = "BASICS";
         this.tab1Button.soundMap = {
            "theme":"default",
            "focusIn":"focusIn",
            "focusOut":"focusOut",
            "select":"select",
            "rollOver":"rollOver",
            "rollOut":"rollOut",
            "press":"press",
            "doubleClick":"doubleClick",
            "click":"click"
         };
         this.tab1Button.toggle = false;
         this.tab1Button.visible = true;
         try
         {
            this.tab1Button["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
