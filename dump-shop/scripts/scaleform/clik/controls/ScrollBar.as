package scaleform.clik.controls
{
   import flash.geom.Point;
   import scaleform.clik.utils.Constraints;
   import scaleform.clik.constants.ConstrainMode;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.constants.ScrollBarTrackMode;
   import flash.events.MouseEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.core.UIComponent;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class ScrollBar extends ScrollIndicator
   {
      
      public function ScrollBar()
      {
         super();
      }
      
      public var trackScrollPageSize:Number = 1;
      
      protected var _dragOffset:Point;
      
      protected var _trackMode:String = "scrollPage";
      
      protected var _trackScrollPosition:Number = -1;
      
      protected var _trackDragMouseIndex:Number = -1;
      
      public var upArrow:Button;
      
      public var downArrow:Button;
      
      override protected function initialize() : §void§
      {
         super.initialize();
         var r:Number = rotation;
         rotation = 0;
         if(this.downArrow)
         {
            constraints.addElement("downArrow",this.downArrow,Constraints.BOTTOM);
         }
         constraints.addElement("track",track,Constraints.TOP | Constraints.BOTTOM);
         rotation = r;
      }
      
      override protected function preInitialize() : §void§
      {
         constraints = new Constraints(this,ConstrainMode.REFLOW);
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(value:Boolean) : §void§
      {
         if(this.enabled == value)
         {
            return;
         }
         super.enabled = value;
         gotoAndPlay(this.enabled?"default":"disabled");
         invalidate(InvalidationType.STATE);
      }
      
      override public function get position() : Number
      {
         return _position;
      }
      
      override public function set position(value:Number) : §void§
      {
         var value:Number = Math.round(value);
         if(value == this.position)
         {
            return;
         }
         super.position = value;
         this.updateScrollTarget();
      }
      
      public function get trackMode() : String
      {
         return this._trackMode;
      }
      
      public function set trackMode(value:String) : §void§
      {
         if(value == this._trackMode)
         {
            return;
         }
         this._trackMode = value;
         if(initialized)
         {
            track.autoRepeat = this.trackMode == ScrollBarTrackMode.SCROLL_PAGE;
         }
      }
      
      override public function get availableHeight() : Number
      {
         return track.height - thumb.height + offsetBottom + offsetTop;
      }
      
      override public function toString() : String
      {
         return "[CLIK ScrollBar " + name + "]";
      }
      
      override protected function configUI() : §void§
      {
         super.configUI();
         mouseEnabled = mouseChildren = this.enabled;
         tabEnabled = tabChildren = _focusable;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel,false,0,true);
         addEventListener(InputEvent.INPUT,handleInput,false,0,true);
         if(this.upArrow)
         {
            this.upArrow.addEventListener(ButtonEvent.CLICK,this.handleUpArrowClick,false,0,true);
            this.upArrow.addEventListener(ButtonEvent.PRESS,this.handleUpArrowPress,false,0,true);
            this.upArrow.focusTarget = this;
            this.upArrow.autoRepeat = true;
         }
         if(this.downArrow)
         {
            this.downArrow.addEventListener(ButtonEvent.CLICK,this.handleDownArrowClick,false,0,true);
            this.downArrow.addEventListener(ButtonEvent.PRESS,this.handleDownArrowPress,false,0,true);
            this.downArrow.focusTarget = this;
            this.downArrow.autoRepeat = true;
         }
         thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.handleThumbPress,false,0,true);
         thumb.focusTarget = this;
         thumb.lockDragStateChange = true;
         track.addEventListener(MouseEvent.MOUSE_DOWN,this.handleTrackPress,false,0,true);
         track.addEventListener(ButtonEvent.CLICK,this.handleTrackClick,false,0,true);
         if(track is UIComponent)
         {
            (track as UIComponent).focusTarget = this;
         }
         track.autoRepeat = this.trackMode == ScrollBarTrackMode.SCROLL_PAGE;
      }
      
      protected function scrollUp() : §void§
      {
         this.position = this.position - _pageScrollSize;
      }
      
      protected function scrollDown() : §void§
      {
         this.position = this.position + _pageScrollSize;
      }
      
      override protected function drawLayout() : §void§
      {
         var yScaleFix:* = NaN;
         thumb.y = track.y - offsetTop;
         if(isHorizontal)
         {
            constraints.update(_height,_width);
         }
         else
         {
            constraints.update(_width,_height);
         }
         if((isHorizontal) && !(actualWidth == width))
         {
            yScaleFix = width / actualWidth;
            scaleY = yScaleFix;
         }
      }
      
      override protected function updateThumb() : §void§
      {
         var per:Number = Math.max(1,_maxPosition - _minPosition + _pageSize);
         var trackHeight:Number = track.height + offsetTop + offsetBottom;
         thumb.height = Math.max(_minThumbSize,Math.min(trackHeight,_pageSize / per * trackHeight));
         if(thumb is UIComponent)
         {
            (thumb as UIComponent).validateNow();
         }
         this.updateThumbPosition();
      }
      
      override protected function updateThumbPosition() : §void§
      {
         var percent:Number = (_position - _minPosition) / (_maxPosition - _minPosition);
         var top:Number = track.y - offsetTop;
         var yPos:Number = Math.round(percent * this.availableHeight + top);
         thumb.y = Math.max(top,Math.min(track.y + track.height - thumb.height + offsetBottom,yPos));
         thumb.visible = !((isNaN(percent)) || (isNaN(_pageSize)) || _maxPosition <= 0 || _maxPosition == Infinity);
         var showThumb:Boolean = (thumb.visible) && (this.enabled);
         if(this.upArrow)
         {
            this.upArrow.enabled = (showThumb) && _position > _minPosition;
            this.upArrow.validateNow();
         }
         if(this.downArrow)
         {
            this.downArrow.enabled = (showThumb) && _position < _maxPosition;
            this.downArrow.validateNow();
         }
         track.enabled = track.mouseEnabled = showThumb;
      }
      
      protected function handleUpArrowClick(event:ButtonEvent) : §void§
      {
         if(event.isRepeat)
         {
            this.scrollUp();
         }
      }
      
      protected function handleUpArrowPress(event:ButtonEvent) : §void§
      {
         this.scrollUp();
      }
      
      protected function handleDownArrowClick(event:ButtonEvent) : §void§
      {
         if(event.isRepeat)
         {
            this.scrollDown();
         }
      }
      
      protected function handleDownArrowPress(event:ButtonEvent) : §void§
      {
         this.scrollDown();
      }
      
      protected function handleThumbPress(event:Event) : §void§
      {
         if(_isDragging)
         {
            return;
         }
         _isDragging = true;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.doDrag,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.endDrag,false,0,true);
         this._dragOffset = new Point(0,mouseY - thumb.y);
      }
      
      protected function doDrag(event:MouseEvent) : §void§
      {
         var percent:Number = (mouseY - this._dragOffset.y - track.y) / this.availableHeight;
         this.position = _minPosition + percent * (_maxPosition - _minPosition);
      }
      
      protected function endDrag(event:MouseEvent) : §void§
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.doDrag);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         _isDragging = false;
      }
      
      protected function handleTrackPress(event:MouseEvent) : §void§
      {
         var percent:* = NaN;
         if((event.shiftKey) || this.trackMode == ScrollBarTrackMode.SCROLL_TO_CURSOR)
         {
            percent = (mouseY - thumb.height / 2 - track.y) / this.availableHeight;
            this.position = Math.round(percent * (_maxPosition - _minPosition) + _minPosition);
            thumb.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            thumb.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            this.handleThumbPress(event);
            this._dragOffset = new Point(0,thumb.height / 2);
         }
         if((_isDragging) || this.position == this._trackScrollPosition)
         {
            return;
         }
         if(mouseY > thumb.y && mouseY < thumb.y + thumb.height)
         {
            return;
         }
         this.position = this.position + (thumb.y < mouseY?this.trackScrollPageSize:-this.trackScrollPageSize);
      }
      
      protected function handleTrackClick(event:ButtonEvent) : §void§
      {
         if(event.isRepeat)
         {
            if((_isDragging) || this.position == this._trackScrollPosition)
            {
               return;
            }
            if(mouseY > thumb.y && mouseY < thumb.y + thumb.height)
            {
               return;
            }
            this.position = this.position + (thumb.y < mouseY?this.trackScrollPageSize:-this.trackScrollPageSize);
         }
      }
      
      protected function updateScrollTarget() : §void§
      {
         if(_scrollTarget == null || !this.enabled)
         {
            return;
         }
         var target:TextField = _scrollTarget as TextField;
         if(target != null)
         {
            _scrollTarget.scrollV = _position;
         }
      }
      
      protected function handleMouseWheel(event:MouseEvent) : §void§
      {
         this.position = this.position - (event.delta > 0?1:-1) * _pageScrollSize;
      }
      
      override protected function changeFocus() : §void§
      {
         thumb.displayFocus = _focused || _displayFocus;
      }
   }
}
