package scaleform.clik.controls
{
   import scaleform.clik.core.UIComponent;
   import flash.text.TextFormat;
   import flash.text.TextField;
   import scaleform.clik.utils.Constraints;
   import scaleform.clik.constants.ConstrainMode;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   import scaleform.clik.constants.InputValue;
   import flash.events.FocusEvent;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.events.ComponentEvent;
   import flash.events.Event;
   import scaleform.clik.managers.FocusHandler;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.FocusManager;
   import scaleform.gfx.MouseEventEx;
   
   public class TextInput extends UIComponent
   {
      
      public function TextInput()
      {
         super();
      }
      
      public var defaultTextFormat:TextFormat;
      
      public var constraintsDisabled:Boolean = false;
      
      protected var _text:String = "";
      
      protected var _displayAsPassword:Boolean = false;
      
      protected var _maxChars:uint = 0;
      
      protected var _editable:Boolean = true;
      
      protected var _actAsButton:Boolean = false;
      
      protected var _alwaysShowSelection:Boolean = false;
      
      protected var _isHtml:Boolean = false;
      
      protected var _state:String = "default";
      
      protected var _newFrame:String;
      
      protected var _textFormat:TextFormat;
      
      protected var _usingDefaultTextFormat:Boolean = true;
      
      protected var _defaultText:String = "";
      
      private var hscroll:Number = 0;
      
      public var textField:TextField;
      
      override protected function preInitialize() : §void§
      {
         if(!this.constraintsDisabled)
         {
            constraints = new Constraints(this,ConstrainMode.COUNTER_SCALE);
         }
      }
      
      override protected function initialize() : §void§
      {
         super.tabEnabled = false;
         mouseEnabled = mouseChildren = this.enabled;
         super.initialize();
         this._textFormat = this.textField.getTextFormat();
         this.defaultTextFormat = new TextFormat();
         this.defaultTextFormat.italic = true;
         this.defaultTextFormat.color = 11184810;
      }
      
      override public function get enabled() : Boolean
      {
         return super.enabled;
      }
      
      override public function set enabled(value:Boolean) : §void§
      {
         super.enabled = value;
         mouseChildren = value;
         super.tabEnabled = false;
         tabChildren = _focusable;
         this.setState(this.defaultState);
      }
      
      override public function get focusable() : Boolean
      {
         return _focusable;
      }
      
      override public function set focusable(value:Boolean) : §void§
      {
         _focusable = value;
         if(!_focusable && (this.enabled))
         {
            tabChildren = false;
         }
         this.changeFocus();
         if((_focusable) && (this.editable))
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false);
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(value:String) : §void§
      {
         this._isHtml = false;
         this._text = value;
         invalidateData();
      }
      
      public function get htmlText() : String
      {
         return this._text;
      }
      
      public function set htmlText(value:String) : §void§
      {
         this._isHtml = true;
         this._text = value;
         invalidateData();
      }
      
      public function get defaultText() : String
      {
         return this._defaultText;
      }
      
      public function set defaultText(value:String) : §void§
      {
         this._defaultText = value;
         invalidateData();
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(value:Boolean) : §void§
      {
         this._displayAsPassword = value;
         if(this.textField != null)
         {
            this.textField.displayAsPassword = value;
         }
      }
      
      public function get maxChars() : uint
      {
         return this._maxChars;
      }
      
      public function set maxChars(value:uint) : §void§
      {
         this._maxChars = value;
         if(this.textField != null)
         {
            this.textField.maxChars = value;
         }
      }
      
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : §void§
      {
         this._editable = value;
         if(this.textField != null)
         {
            this.textField.type = (this._editable) && (this.enabled)?TextFieldType.INPUT:TextFieldType.DYNAMIC;
         }
         this.focusable = value;
      }
      
      override public function get tabEnabled() : Boolean
      {
         return this.textField.tabEnabled;
      }
      
      override public function set tabEnabled(value:Boolean) : §void§
      {
         this.textField.tabEnabled = value;
      }
      
      override public function get tabIndex() : int
      {
         return this.textField.tabIndex;
      }
      
      override public function set tabIndex(value:int) : §void§
      {
         this.textField.tabIndex = value;
      }
      
      public function get actAsButton() : Boolean
      {
         return this._actAsButton;
      }
      
      public function set actAsButton(value:Boolean) : §void§
      {
         if(this._actAsButton == value)
         {
            return;
         }
         this._actAsButton = value;
         if(value)
         {
            addEventListener(MouseEvent.ROLL_OVER,this.handleRollOver,false,0,true);
            addEventListener(MouseEvent.ROLL_OUT,this.handleRollOut,false,0,true);
         }
         else
         {
            removeEventListener(MouseEvent.ROLL_OVER,this.handleRollOver,false);
            removeEventListener(MouseEvent.ROLL_OUT,this.handleRollOut,false);
         }
      }
      
      public function get alwaysShowSelection() : Boolean
      {
         return this._alwaysShowSelection;
      }
      
      public function set alwaysShowSelection(value:Boolean) : §void§
      {
         this._alwaysShowSelection = value;
         if(this.textField != null)
         {
            this.textField.alwaysShowSelection = value;
         }
      }
      
      public function get length() : uint
      {
         return this.textField.length;
      }
      
      public function get defaultState() : String
      {
         return !this.enabled?"disabled":focused?"focused":"default";
      }
      
      public function appendText(value:String) : §void§
      {
         this._text = this._text + value;
         this._isHtml = false;
         invalidateData();
      }
      
      public function appendHtml(value:String) : §void§
      {
         this._text = this._text + value;
         this._isHtml = true;
         invalidateData();
      }
      
      override public function handleInput(event:InputEvent) : §void§
      {
         if(event.handled)
         {
            return;
         }
         var details:InputDetails = event.details;
         if(details.value == InputValue.KEY_DOWN || details.value == InputValue.KEY_HOLD)
         {
            return;
         }
      }
      
      override public function toString() : String
      {
         return "[CLIK TextInput " + name + "]";
      }
      
      override protected function configUI() : §void§
      {
         super.configUI();
         if(!this.constraintsDisabled)
         {
            constraints.addElement("textField",this.textField,Constraints.ALL);
         }
         addEventListener(InputEvent.INPUT,this.handleInput,false,0,true);
         this.textField.addEventListener(FocusEvent.FOCUS_IN,this.handleTextFieldFocusIn,false,0,true);
         if((this.focusable) && (this.editable))
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         }
         this.setState(this.defaultState,"default");
      }
      
      override protected function draw() : §void§
      {
         if(isInvalid(InvalidationType.STATE))
         {
            if(this._newFrame)
            {
               gotoAndPlay(this._newFrame);
               this._newFrame = null;
            }
            this.updateAfterStateChange();
            this.updateTextField();
            dispatchEvent(new ComponentEvent(ComponentEvent.STATE_CHANGE));
            invalidate(InvalidationType.SIZE);
         }
         else if(isInvalid(InvalidationType.DATA))
         {
            this.updateText();
         }
         
         if(isInvalid(InvalidationType.SIZE))
         {
            setActualSize(_width,_height);
            if(!this.constraintsDisabled)
            {
               constraints.update(_width,_height);
            }
         }
      }
      
      override protected function changeFocus() : §void§
      {
         this.setState(this.defaultState);
      }
      
      protected function updateTextField() : §void§
      {
         if(this.textField == null)
         {
            trace(">>> Error :: " + this + ", textField is NULL.");
            return;
         }
         this.updateText();
         this.textField.maxChars = this._maxChars;
         this.textField.alwaysShowSelection = this._alwaysShowSelection;
         this.textField.selectable = this.enabled?this._editable:this.enabled;
         this.textField.type = (this._editable) && (this.enabled)?TextFieldType.INPUT:TextFieldType.DYNAMIC;
         this.textField.tabEnabled = (this._editable) && (this.enabled) && (_focusable);
         this.textField.addEventListener(Event.CHANGE,this.handleTextChange,false,0,true);
         if(this.textField.hasEventListener(FocusEvent.FOCUS_IN))
         {
            this.textField.removeEventListener(FocusEvent.FOCUS_IN,this.handleTextFieldFocusIn,false);
         }
         this.textField.addEventListener(FocusEvent.FOCUS_IN,this.handleTextFieldFocusIn,false,0,true);
      }
      
      protected function handleTextFieldFocusIn(e:FocusEvent) : §void§
      {
         FocusHandler.getInstance().setFocus(this);
      }
      
      protected function updateText() : §void§
      {
         if((_focused) && (this._usingDefaultTextFormat))
         {
            this.textField.defaultTextFormat = this._textFormat;
            this._usingDefaultTextFormat = false;
            if((this._displayAsPassword) && !this.textField.displayAsPassword)
            {
               this.textField.displayAsPassword = true;
            }
         }
         if(this._text != "")
         {
            if(this._isHtml)
            {
               this.textField.htmlText = this._text;
            }
            else
            {
               this.textField.text = this._text;
            }
         }
         else
         {
            this.textField.text = "";
            if(!_focused && !(this._defaultText == ""))
            {
               if(this._displayAsPassword)
               {
                  this.textField.displayAsPassword = false;
               }
               this.textField.text = this._defaultText;
               this._usingDefaultTextFormat = true;
               if(this.defaultTextFormat != null)
               {
                  this.textField.setTextFormat(this.defaultTextFormat);
               }
            }
         }
      }
      
      protected function setState(... states) : §void§
      {
         var onlyState:String = null;
         var thisState:String = null;
         if(states.length == 1)
         {
            onlyState = states[0].toString();
            if(!(this._state == onlyState) && (_labelHash[onlyState]))
            {
               this._state = this._newFrame = onlyState;
               invalidateState();
            }
            return;
         }
         var l:uint = states.length;
         var i:uint = 0;
         while(i < l)
         {
            thisState = states[i].toString();
            if(_labelHash[thisState])
            {
               this._state = this._newFrame = thisState;
               invalidateState();
               break;
            }
            i++;
         }
      }
      
      protected function updateAfterStateChange() : §void§
      {
         var numControllers:uint = 0;
         var i:uint = 0;
         if(!initialized)
         {
            return;
         }
         constraints.updateElement("textField",this.textField);
         if(_focused)
         {
            if(Extensions.isScaleform)
            {
               numControllers = Extensions.numControllers;
               i = 0;
               while(i < numControllers)
               {
                  if(FocusManager.getFocus(i) == this)
                  {
                     FocusManager.setFocus(this.textField,i);
                  }
                  i++;
               }
            }
            else
            {
               stage.focus = this.textField;
            }
         }
      }
      
      protected function handleRollOver(event:MouseEvent) : §void§
      {
         if((focused) || !this.enabled)
         {
            return;
         }
         this.setState("over");
      }
      
      protected function handleRollOut(event:MouseEvent) : §void§
      {
         if((focused) || !this.enabled)
         {
            return;
         }
         this.setState("out","default");
      }
      
      protected function handleMouseDown(event:MouseEvent) : §void§
      {
         if((focused) || !this.enabled)
         {
            return;
         }
         if(event is MouseEventEx)
         {
            FocusManager.setFocus(this.textField,(event as MouseEventEx).mouseIdx);
         }
         else
         {
            stage.focus = this.textField;
         }
      }
      
      protected function handleTextChange(event:Event) : §void§
      {
         this._text = this._isHtml?this.textField.htmlText:this.textField.text;
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
