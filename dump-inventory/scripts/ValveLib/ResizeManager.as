package ValveLib
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ResizeManager extends Object
   {
      
      public function ResizeManager()
      {
         this.ScalingFactors = new Array();
         this.ReferencePositions = new Array();
         this.Listeners = new Array();
         super();
         var i:* = 0;
         while(i <= SCALE_USING_HORIZONTAL)
         {
            this.ScalingFactors.push(1);
            i++;
         }
         var j:* = 0;
         while(j <= REFERENCE_CENTER_Y)
         {
            this.ReferencePositions.push(0);
            j++;
         }
      }
      
      public static var ALIGN_NONE:Number = 0;
      
      public static var ALIGN_LEFT:Number = 0;
      
      public static var ALIGN_RIGHT:Number = 1;
      
      public static var ALIGN_TOP:Number = 0;
      
      public static var ALIGN_BOTTOM:Number = 1;
      
      public static var ALIGN_CENTER:Number = 0.5;
      
      public static var POSITION_LEFT:Number = 0;
      
      public static var POSITION_SAFE_LEFT:Number = 0.075;
      
      public static var POSITION_RIGHT:Number = 1;
      
      public static var POSITION_SAFE_RIGHT:Number = 0.925;
      
      public static var POSITION_TOP:Number = 0;
      
      public static var POSITION_SAFE_TOP:Number = 0.075;
      
      public static var POSITION_BOTTOM:Number = 1;
      
      public static var POSITION_SAFE_BOTTOM:Number = 0.925;
      
      public static var POSITION_CENTER:Number = 0.5;
      
      public static var REFERENCE_LEFT:Number = 0;
      
      public static var REFERENCE_TOP:Number = 1;
      
      public static var REFERENCE_SAFE_LEFT:Number = 2;
      
      public static var REFERENCE_SAFE_TOP:Number = 3;
      
      public static var REFERENCE_RIGHT:Number = 4;
      
      public static var REFERENCE_BOTTOM:Number = 5;
      
      public static var REFERENCE_SAFE_RIGHT:Number = 6;
      
      public static var REFERENCE_SAFE_BOTTOM:Number = 7;
      
      public static var REFERENCE_CENTER_X:Number = 8;
      
      public static var REFERENCE_CENTER_Y:Number = 9;
      
      public static var SCALE_NONE:Number = 0;
      
      public static var SCALE_BIGGEST:Number = 1;
      
      public static var SCALE_SMALLEST:Number = 2;
      
      public static var SCALE_USING_VERTICAL:Number = 3;
      
      public static var SCALE_USING_HORIZONTAL:Number = 4;
      
      public static var PC_BORDER_SIZE:Number = 10;
      
      public var ScalingFactors:Array;
      
      public var ReferencePositions:Array;
      
      public var ScreenWidth:Number = -1;
      
      public var ScreenHeight:Number = -1;
      
      public var ScreenX:Number = -1;
      
      public var ScreenY:Number = -1;
      
      public var AuthoredWidth:Number;
      
      public var AuthoredHeight:Number;
      
      public var Hidden:Boolean;
      
      public var LayoutVersion:int = 4;
      
      public var Listeners:Array;
      
      public function UpdateReferencePositions() : *
      {
         this.ReferencePositions[REFERENCE_LEFT] = this.ScreenX;
         this.ReferencePositions[REFERENCE_RIGHT] = this.ScreenX + this.ScreenWidth;
         this.ReferencePositions[REFERENCE_TOP] = this.ScreenY;
         this.ReferencePositions[REFERENCE_BOTTOM] = this.ScreenY + this.ScreenHeight;
         this.ReferencePositions[REFERENCE_CENTER_X] = Math.floor((this.ReferencePositions[REFERENCE_LEFT] + this.ReferencePositions[REFERENCE_RIGHT]) / 2);
         this.ReferencePositions[REFERENCE_CENTER_Y] = Math.floor((this.ReferencePositions[REFERENCE_TOP] + this.ReferencePositions[REFERENCE_BOTTOM]) / 2);
         if(Globals.instance.IsPC())
         {
            this.ReferencePositions[REFERENCE_SAFE_LEFT] = this.ReferencePositions[REFERENCE_LEFT] + PC_BORDER_SIZE;
            this.ReferencePositions[REFERENCE_SAFE_TOP] = this.ReferencePositions[REFERENCE_TOP] + PC_BORDER_SIZE;
            this.ReferencePositions[REFERENCE_SAFE_RIGHT] = this.ReferencePositions[REFERENCE_RIGHT] - PC_BORDER_SIZE;
            this.ReferencePositions[REFERENCE_SAFE_BOTTOM] = this.ReferencePositions[REFERENCE_BOTTOM] - PC_BORDER_SIZE;
         }
         else
         {
            this.ReferencePositions[REFERENCE_SAFE_LEFT] = this.ScreenX + Math.ceil(POSITION_SAFE_LEFT * this.ScreenWidth);
            this.ReferencePositions[REFERENCE_SAFE_TOP] = this.ScreenY + Math.ceil(POSITION_SAFE_TOP * this.ScreenHeight);
            this.ReferencePositions[REFERENCE_SAFE_RIGHT] = this.ScreenX + Math.floor(POSITION_SAFE_RIGHT * this.ScreenWidth);
            this.ReferencePositions[REFERENCE_SAFE_BOTTOM] = this.ScreenY + Math.floor(POSITION_SAFE_BOTTOM * this.ScreenHeight);
         }
      }
      
      public function SetScaling(param1:MovieClip, param2:Number) : *
      {
         if(param1["originalXScale"] == null)
         {
            param1["originalXScale"] = param1.scaleX;
            param1["originalYScale"] = param1.scaleY;
         }
         var param2:Number = this.ScalingFactors[param2];
         param1.scaleX = param1.originalXScale * param2;
         param1.scaleY = param1.originalYScale * param2;
      }
      
      public function GetPctPosition(position:Number, anchor:Number, rectDim:Number, stageDim:Number) : Number
      {
         return Math.floor(stageDim * position - rectDim * anchor);
      }
      
      public function ResetPosition(obj:MovieClip, scaling:Number, positiony:Number, positionx:Number, anchory:Number, anchorx:Number) : *
      {
         this.SetScaling(obj,scaling);
         var x:Number = this.GetPctPosition(positionx,anchorx,obj.width,this.ScreenWidth);
         var y:Number = this.GetPctPosition(positiony,anchory,obj.height,this.ScreenHeight);
         obj.x = this.ScreenX + x;
         obj.y = this.ScreenY + y;
      }
      
      public function GetPixelPosition(screenReference:Number, screenOffset:Number, elementAlignment:Number, elementSize:Number) : *
      {
         return Math.floor(this.ReferencePositions[screenReference] + screenOffset - elementSize * elementAlignment);
      }
      
      public function ResetPositionByPixel(obj:MovieClip, scaling:Number, xScreenReference:Number, xScreenOffset:Number, xElementAlign:Number, yScreenReference:Number, yScreenOffset:Number, yElementAlign:Number) : *
      {
         this.SetScaling(obj,scaling);
         obj.x = this.GetPixelPosition(xScreenReference,xScreenOffset * this.ScalingFactors[scaling],xElementAlign,obj.width);
         obj.y = this.GetPixelPosition(yScreenReference,yScreenOffset * this.ScalingFactors[scaling],yElementAlign,obj.height);
      }
      
      public function ResetPositionByPercentage(obj:MovieClip, scaling:Number, xScreenReference:Number, xScreenOffset:Number, xElementAlign:Number, yScreenReference:Number, yScreenOffset:Number, yElementAlign:Number) : *
      {
         this.SetScaling(obj,scaling);
         obj.x = this.GetPixelPosition(xScreenReference,xScreenOffset * this.ScreenWidth,xElementAlign,obj.width);
         obj.y = this.GetPixelPosition(yScreenReference,yScreenOffset * this.ScreenHeight,yElementAlign,obj.height);
      }
      
      public function PositionDashboardPage(obj:MovieClip) : *
      {
         this.SetScaling(obj,SCALE_USING_VERTICAL);
         var middle:Number = this.ScreenWidth * 0.5;
         if(this.LayoutVersion == 5)
         {
            if(this.Is16by9())
            {
               obj.x = middle - 625 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            else if(this.Is16by10())
            {
               obj.x = middle - 570 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            else
            {
               obj.x = middle - 484 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            
            obj.y = 88 * this.ScalingFactors[SCALE_USING_VERTICAL];
         }
         else
         {
            if(this.Is16by9())
            {
               obj.x = middle - 625 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            else if(this.Is16by10())
            {
               obj.x = middle - 540 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            else
            {
               obj.x = middle - 484 * this.ScalingFactors[SCALE_USING_VERTICAL];
            }
            
            obj.y = 96 * this.ScalingFactors[SCALE_USING_VERTICAL];
         }
      }
      
      public function IsWidescreen() : Boolean
      {
         return this.ScreenWidth / this.ScreenHeight > 1.5;
      }
      
      public function Is16by9() : Boolean
      {
         return this.ScreenWidth / this.ScreenHeight > 1.7;
      }
      
      public function Is16by10() : Boolean
      {
         return this.ScreenWidth / this.ScreenHeight < 1.7 && this.ScreenWidth / this.ScreenHeight > 1.5;
      }
      
      public function OnStageResize() : *
      {
         var listener:Object = null;
         var w:Number = Globals.instance.Level0.stage.stageWidth;
         var h:Number = Globals.instance.Level0.stage.stageHeight;
         Globals.instance.Level0.transform.perspectiveProjection.projectionCenter = new Point(w * 0.5,h * 0.5);
         this.ScreenX = 0;
         this.ScreenY = 0;
         if(this.ScreenWidth == w && this.ScreenHeight == h)
         {
            return;
         }
         this.ScreenWidth = w;
         this.ScreenHeight = h;
         var scalex:Number = this.ScreenWidth / this.AuthoredWidth;
         var scaley:Number = this.ScreenHeight / this.AuthoredHeight;
         if(w == 1280 && h == 1024)
         {
            scaley = 960 / this.AuthoredHeight;
         }
         if(scalex >= scaley)
         {
            this.ScalingFactors[SCALE_BIGGEST] = scalex;
            this.ScalingFactors[SCALE_SMALLEST] = scaley;
         }
         else
         {
            this.ScalingFactors[SCALE_BIGGEST] = scaley;
            this.ScalingFactors[SCALE_SMALLEST] = scalex;
         }
         this.ScalingFactors[SCALE_USING_VERTICAL] = scaley;
         this.ScalingFactors[SCALE_USING_HORIZONTAL] = scalex;
         this.UpdateReferencePositions();
         var len:Number = this.Listeners.length;
         var i:* = 0;
         while(i < len)
         {
            listener = this.Listeners[i];
            if(listener["onResize"] != undefined)
            {
               this.Listeners[i].onResize(this);
            }
            i = i + 1;
         }
      }
      
      public function GetListenerIndex(listener:Object, l:Number) : Number
      {
         var i:Number = 0;
         if(l == -1)
         {
            var l:Number = this.Listeners.length - 1;
         }
         while(i <= l)
         {
            if(this.Listeners[i] == listener)
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      public function AddListener(listener:Object) : *
      {
         if(this.GetListenerIndex(listener,-1) == -1)
         {
            this.Listeners.push(listener);
            if(listener.hasOwnProperty("onResize"))
            {
               listener.onResize(this);
            }
            else
            {
               listener.scaleY = listener.stage.stageHeight / 768;
               listener.scaleX = listener.scaleY;
               listener.x = listener.stage.stageWidth * 0.5 - 1024 * listener.scaleX * 0.5;
               listener.y = listener.stage.stageHeight * 0.5 - 768 * listener.scaleY * 0.5;
            }
            if(listener.hasOwnProperty("onScreenSizeChanged"))
            {
               listener.onScreenSizeChanged();
            }
         }
      }
      
      public function RemoveListener(listener:Object) : *
      {
         var l:Number = this.Listeners.length - 1;
         var i:Number = this.GetListenerIndex(listener,l);
         if(i == -1)
         {
            return;
         }
         if(i == l)
         {
            this.Listeners.length = l;
         }
         else if(i == 0)
         {
            this.Listeners.shift();
         }
         else
         {
            this.Listeners = this.Listeners.slice(0,i).concat(this.Listeners.slice(i + 1,l + 1));
         }
         
      }
      
      private function Remove() : *
      {
         this.Listeners.length = 0;
         Globals.instance.resizeManager = null;
      }
      
      public function SetLayoutVersionNumber(version:int) : *
      {
         this.LayoutVersion = version;
      }
   }
}
