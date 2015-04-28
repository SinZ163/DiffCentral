package ValveLib.Controls
{
   import scaleform.clik.controls.TextInput;
   import scaleform.clik.controls.ScrollingList;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IDataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.gfx.MouseEventEx;
   import scaleform.clik.ui.InputDetails;
   import scaleform.clik.constants.InputValue;
   import flash.ui.Keyboard;
   import flash.events.Event;
   import ValveLib.Events.InputBoxEvent;
   import scaleform.clik.managers.FocusHandler;
   
   public class InputBox extends TextInput
   {
      
      public function InputBox()
      {
         super();
      }
      
      private var _autoCompleteListValue:Object;
      
      protected var _autoCompleteList:ScrollingList;
      
      override public function handleInput(event:InputEvent) : §void§
      {
         var d:IDataProvider = null;
         var sfButtonEvent:ButtonEvent = null;
         var sfButtonEvent2:ButtonEvent = null;
         var sfEvent:MouseEventEx = event as MouseEventEx;
         var mouseIdx:uint = sfEvent == null?0:sfEvent.mouseIdx;
         var btnIdx:uint = sfEvent == null?0:sfEvent.buttonIdx;
         if(event.handled)
         {
            return;
         }
         var details:InputDetails = event.details;
         if(details.value == InputValue.KEY_UP)
         {
            return;
         }
         if(!(this._autoCompleteList == null) && (this._autoCompleteList.visible))
         {
            if(details.code == Keyboard.UP)
            {
               this._autoCompleteList.selectedIndex = Math.max(0,this._autoCompleteList.selectedIndex - 1);
               return;
            }
            if(details.code == Keyboard.DOWN)
            {
               d = Object(this._autoCompleteList)._dataProvider as IDataProvider;
               if(d != null)
               {
                  this._autoCompleteList.selectedIndex = Math.min(d.length - 1,this._autoCompleteList.selectedIndex + 1);
               }
               return;
            }
            if(details.code == Keyboard.ENTER)
            {
               d = Object(this._autoCompleteList)._dataProvider as IDataProvider;
               if(d != null)
               {
                  text = d.requestItemAt(this._autoCompleteList.selectedIndex)["label"];
                  dispatchEvent(new Event(Event.CHANGE));
                  return;
               }
            }
         }
         if(details.code == Keyboard.ENTER)
         {
            trace(" enter pressed - dispatching InputBoxEvent");
            dispatchEvent(new InputBoxEvent(InputBoxEvent.TEXT_SUBMITTED));
            sfButtonEvent = new ButtonEvent(ButtonEvent.CLICK,true,false,mouseIdx,btnIdx,false);
            dispatchEvent(sfButtonEvent);
         }
         else if(details.code == Keyboard.TAB)
         {
            trace(" tab pressed - dispatching InputBoxEvent");
            dispatchEvent(new InputBoxEvent(InputBoxEvent.TAB_PRESSED));
            sfButtonEvent2 = new ButtonEvent(ButtonEvent.CLICK,true,false,mouseIdx,btnIdx,false);
            dispatchEvent(sfButtonEvent2);
         }
         
         trace("handleInput code = " + details.code + " this = " + this.name + " stage.focus = " + stage.focus + " getFocus = " + FocusHandler.getInstance().getFocus(0));
         super.handleInput(event);
      }
      
      override protected function configUI() : §void§
      {
         super.configUI();
         this.findAutoCompleteList();
      }
      
      public function get autoCompleteList() : Object
      {
         return this._autoCompleteListValue;
      }
      
      public function set autoCompleteList(value:Object) : §void§
      {
         this._autoCompleteListValue = value;
      }
      
      protected function findAutoCompleteList() : *
      {
         var acList:ScrollingList = null;
         if(this._autoCompleteListValue is String)
         {
            if(parent != null)
            {
               this._autoCompleteList = parent.getChildByName(this._autoCompleteListValue.toString()) as ScrollingList;
            }
         }
      }
   }
}
