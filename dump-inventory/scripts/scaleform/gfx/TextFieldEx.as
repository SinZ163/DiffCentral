package scaleform.gfx
{
   import flash.text.TextField;
   import flash.display.BitmapData;
   
   public final class TextFieldEx extends InteractiveObjectEx
   {
      
      public function TextFieldEx()
      {
         super();
      }
      
      public static const VALIGN_NONE:String = "none";
      
      public static const VALIGN_TOP:String = "top";
      
      public static const VALIGN_CENTER:String = "center";
      
      public static const VALIGN_BOTTOM:String = "bottom";
      
      public static const TEXTAUTOSZ_NONE:String = "none";
      
      public static const TEXTAUTOSZ_SHRINK:String = "shrink";
      
      public static const TEXTAUTOSZ_FIT:String = "fit";
      
      public static function appendHtml(textField:TextField, newHtml:String) : §void§
      {
      }
      
      public static function setIMEEnabled(textField:TextField, isEnabled:Boolean) : §void§
      {
      }
      
      public static function setVerticalAlign(textField:TextField, valign:String) : §void§
      {
      }
      
      public static function getVerticalAlign(textField:TextField) : String
      {
         return "none";
      }
      
      public static function setTextAutoSize(textField:TextField, autoSz:String) : §void§
      {
      }
      
      public static function getTextAutoSize(textField:TextField) : String
      {
         return "none";
      }
      
      public static function setImageSubstitutions(textField:TextField, substInfo:Object) : §void§
      {
      }
      
      public static function updateImageSubstitution(textField:TextField, id:String, image:BitmapData) : §void§
      {
      }
      
      public static function setNoTranslate(textField:TextField, noTranslate:Boolean) : §void§
      {
      }
      
      public static function getNoTranslate(textField:TextField) : Boolean
      {
         return false;
      }
   }
}
