package scaleform.clik.utils
{
   import flash.utils.Dictionary;
   
   public class WeakReference extends Object
   {
      
      public function WeakReference(obj:Object)
      {
         super();
         this._dictionary = new Dictionary(true);
         this._dictionary[obj] = 1;
      }
      
      protected var _dictionary:Dictionary;
      
      public function get value() : Object
      {
         var dvalue:Object = null;
         for(dvalue in this._dictionary)
         {
            return dvalue;
         }
         return null;
      }
   }
}
