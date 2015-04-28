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
   
   public dynamic class inventory_1 extends MovieClip
   {
      
      public function inventory_1()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4,4,this.frame5,5,this.frame6);
      }
      
      public var shopbutton:MovieClip;
      
      public var items:MovieClip;
      
      public var stickySlotDragTarget:slot_Over;
      
      public var quickBuyDragTarget:slot_Over;
      
      public var background_4_3:MovieClip;
      
      public var goldTooltip:MovieClip;
      
      public var stash_anim:MovieClip;
      
      public var spacer:MovieClip;
      
      public var gold:MovieClip;
      
      public var quickbuy:MovieClip;
      
      public var light_16_9:MovieClip;
      
      public var light_4_3:MovieClip;
      
      public var rocks_4_3:MovieClip;
      
      public var actionItem:MovieClip;
      
      public var quickstats:MovieClip;
      
      public var background_wide:MovieClip;
      
      public var rocks_16_10:MovieClip;
      
      public var glyphButton:MovieClip;
      
      public var rocks_16_9:MovieClip;
      
      public var courierState:MovieClip;
      
      public var light_16_10:MovieClip;
      
      function frame1() : *
      {
         this.light_4_3.visible = true;
         this.light_16_9.visible = false;
         this.light_16_10.visible = false;
         this.rocks_4_3.visible = true;
         this.rocks_16_9.visible = false;
         this.rocks_16_10.visible = false;
         this.spacer.visible = false;
         this.courierState.gotoAndStop(1);
         this.courierState.dead.gotoAndStop(1);
         this.quickstats.visible = false;
         this.background_4_3.visible = true;
         this.background_wide.visible = false;
         this.glyphButton.gotoAndStop(1);
         this.goldTooltip.gotoAndStop(1);
         stop();
      }
      
      function frame2() : *
      {
         this.light_4_3.visible = false;
         this.light_16_9.visible = true;
         this.light_16_10.visible = false;
         this.rocks_4_3.visible = false;
         this.rocks_16_9.visible = true;
         this.rocks_16_10.visible = false;
         this.spacer.visible = true;
         this.courierState.gotoAndStop(2);
         this.courierState.dead.gotoAndStop(2);
         this.quickstats.visible = true;
         this.background_4_3.visible = false;
         this.background_wide.visible = true;
         this.glyphButton.gotoAndStop(1);
         this.goldTooltip.gotoAndStop(1);
         stop();
      }
      
      function frame3() : *
      {
         this.light_4_3.visible = false;
         this.light_16_9.visible = false;
         this.light_16_10.visible = true;
         this.rocks_4_3.visible = false;
         this.rocks_16_9.visible = false;
         this.rocks_16_10.visible = true;
         this.spacer.visible = false;
         this.courierState.gotoAndStop(2);
         this.courierState.dead.gotoAndStop(2);
         this.quickstats.visible = true;
         this.background_4_3.visible = false;
         this.background_wide.visible = true;
         this.glyphButton.gotoAndStop(1);
         this.goldTooltip.gotoAndStop(1);
         stop();
      }
      
      function frame4() : *
      {
         this.light_4_3.visible = false;
         this.light_16_9.visible = false;
         this.light_16_10.visible = false;
         this.rocks_4_3.visible = false;
         this.rocks_16_9.visible = false;
         this.rocks_16_10.visible = false;
         this.spacer.visible = false;
         this.courierState.gotoAndStop(1);
         this.courierState.dead.gotoAndStop(1);
         this.quickstats.visible = false;
         this.background_4_3.visible = true;
         this.background_wide.visible = false;
         this.glyphButton.gotoAndStop(2);
         this.goldTooltip.gotoAndStop(1);
         stop();
      }
      
      function frame5() : *
      {
         this.light_4_3.visible = false;
         this.light_16_9.visible = true;
         this.light_16_10.visible = false;
         this.rocks_4_3.visible = false;
         this.rocks_16_9.visible = true;
         this.rocks_16_10.visible = false;
         this.spacer.visible = true;
         this.courierState.gotoAndStop(2);
         this.courierState.dead.gotoAndStop(2);
         this.quickstats.visible = true;
         this.background_4_3.visible = false;
         this.background_wide.visible = true;
         this.glyphButton.gotoAndStop(2);
         this.goldTooltip.gotoAndStop(2);
         stop();
      }
      
      function frame6() : *
      {
         this.light_4_3.visible = false;
         this.light_16_9.visible = false;
         this.light_16_10.visible = true;
         this.rocks_4_3.visible = false;
         this.rocks_16_9.visible = false;
         this.rocks_16_10.visible = false;
         this.spacer.visible = false;
         this.courierState.gotoAndStop(2);
         this.courierState.dead.gotoAndStop(2);
         this.quickstats.visible = true;
         this.background_4_3.visible = false;
         this.background_wide.visible = true;
         this.glyphButton.gotoAndStop(2);
         this.goldTooltip.gotoAndStop(2);
         stop();
      }
   }
}
