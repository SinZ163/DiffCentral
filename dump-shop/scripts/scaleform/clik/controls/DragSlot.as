package scaleform.clik.controls
{
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.interfaces.IDragSlot;
   import flash.display.Sprite;
   import flash.display.Stage;
   import scaleform.clik.managers.DragManager;
   import flash.events.MouseEvent;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.events.DragEvent;
   import scaleform.clik.events.ButtonEvent;
   
   public class DragSlot extends UIComponent implements IDragSlot
   {
      
      public function DragSlot()
      {
         this._stateMap = {
            "up":["up"],
            "over":["over"],
            "down":["down"],
            "release":["release","over"],
            "out":["out","up"],
            "disabled":["disabled"],
            "selecting":["selecting","over"]
         };
         super();
         if(!this.contentCanvas)
         {
            this.contentCanvas = new Sprite();
            addChild(this.contentCanvas);
         }
         if(stage)
         {
            DragManager.init(stage);
         }
         trackAsMenu = true;
      }
      
      protected var _mouseDownX:Number;
      
      protected var _mouseDownY:Number;
      
      protected var _content:Sprite;
      
      protected var _data:Object;
      
      protected var _stageRef:Stage = null;
      
      protected var _newFrame:String;
      
      protected var _stateMap:Object;
      
      protected var _state:String;
      
      public var contentCanvas:Sprite;
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : §void§
      {
         this._data = value;
         invalidateData();
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      public function set content(value:Sprite) : §void§
      {
         if(value != this._content)
         {
            if(this._content)
            {
               if(this.contentCanvas.contains(this._content))
               {
                  this.contentCanvas.removeChild(this._content);
               }
            }
            this._content = value;
            if(this._content == null)
            {
               return;
            }
            if(this._content != this)
            {
               this.contentCanvas.addChild(this._content);
               this._content.x = 0;
               this._content.y = 0;
               this._content.mouseChildren = false;
            }
         }
      }
      
      public function setStage(value:Stage) : §void§
      {
         if(this._stageRef == null && !(value == null))
         {
            this._stageRef = value;
            DragManager.init(value);
         }
      }
      
      override protected function configUI() : §void§
      {
         super.configUI();
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver,true,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOut,false,0,true);
      }
      
      override protected function draw() : §void§
      {
         super.draw();
         if(isInvalid(InvalidationType.STATE))
         {
            if(this._newFrame)
            {
               gotoAndPlay(this._newFrame);
               this._newFrame = null;
            }
         }
      }
      
      override public function toString() : String
      {
         return "[CLIK DragSlot " + name + "]";
      }
      
      protected function handleMouseOver(e:MouseEvent) : §void§
      {
         if(!DragManager.inDrag())
         {
            if(this.content != null)
            {
            }
         }
      }
      
      protected function handleMouseDown(e:MouseEvent) : §void§
      {
         if((DragManager.inDrag()) || !enabled)
         {
            return;
         }
         if(this._content != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
            this._mouseDownX = mouseX;
            this._mouseDownY = mouseY;
         }
      }
      
      protected function handleMouseRollOver(event:MouseEvent) : §void§
      {
         if(!enabled)
         {
            return;
         }
         this.setState("over");
      }
      
      protected function handleMouseRollOut(event:MouseEvent) : §void§
      {
         if(!enabled)
         {
            return;
         }
         this.setState("out");
      }
      
      protected function cleanupDragListeners() : §void§
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false);
         this._mouseDownX = undefined;
         this._mouseDownY = undefined;
      }
      
      protected function handleMouseMove(e:MouseEvent) : §void§
      {
         var dragStartEvent:DragEvent = null;
         if(mouseX > this._mouseDownX + 3 || mouseX < this._mouseDownX - 3 || mouseY > this._mouseDownY + 3 || mouseY < this._mouseDownY - 3)
         {
            this.cleanupDragListeners();
            dragStartEvent = new DragEvent(DragEvent.DRAG_START,this._data,this,null,this._content);
            dispatchEvent(dragStartEvent);
            this.handleDragStartEvent(dragStartEvent);
         }
      }
      
      protected function handleMouseUp(e:MouseEvent) : §void§
      {
         this.cleanupDragListeners();
         this._content.x = 0;
         this._content.y = 0;
         dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
      }
      
      public function handleDragStartEvent(e:DragEvent) : §void§
      {
      }
      
      public function handleDropEvent(e:DragEvent) : Boolean
      {
         var acceptDrop:* = true;
         if(acceptDrop)
         {
            this.content = e.dragSprite;
         }
         return acceptDrop;
      }
      
      public function handleDragEndEvent(e:DragEvent, wasValidDrop:Boolean) : §void§
      {
         if(wasValidDrop)
         {
            this.content = null;
         }
         else
         {
            this.contentCanvas.addChild(e.dragSprite);
            e.dragSprite.x = 0;
            e.dragSprite.y = 0;
         }
      }
      
      protected function setState(state:String) : §void§
      {
         var thisLabel:String = null;
         this._state = state;
         var states:Array = this._stateMap[state];
         if(states == null || states.length == 0)
         {
            return;
         }
         var sl:uint = states.length;
         var j:uint = 0;
         while(j < sl)
         {
            thisLabel = states[j];
            if(_labelHash[thisLabel])
            {
               this._newFrame = thisLabel;
               invalidateState();
               return;
            }
            j++;
         }
      }
   }
}
